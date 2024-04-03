//
//  Worker.swift
//  ASyncTesting
//
//  Created by Steve Wainwright on 30/03/2024.
//

import Foundation

struct MessageItem: Decodable, Identifiable, Equatable, Sendable {
    let id: Int
    let text: String
}

struct Work: Sendable {}


struct Calculator: Sendable {
    
    func calculateEndIndex(_ start: Int) async -> Int {
        var count: Int = 0
        var index = start
        while count < 10000 {
            index += 1
            count += 1
        }
        return index
    }
    
}

actor Worker {
    var work: Task<[MessageItem], Never>?
    var result: Work?
    
    var texts: [MessageItem]?
    
    enum TaskStorage {
        @TaskLocal static var name: String?
    }
    
    enum TaskSteps {
        case first(Int)
        case second(String)
    }

    deinit {
        assert(work != nil)
        // even though the task is still retained,
        // once it completes it no longer causes a reference cycle with the actor
        print("deinit actor")
    }


    func messages() async {
        work = Task {
            print("start task work")
            var texts: [MessageItem] = []
            texts.append(MessageItem(id: 0, text: "start task work"))
            try? await Task.sleep(for: .seconds(3))
            self.result = Work() // we captured self
            print("completed task work")
            texts.append(MessageItem(id: 1, text: "completed task work"))
        
            // but as the task completes, this reference is released
            // we keep a strong reference to the task
       
            await TaskStorage.$name.withValue("my-task") {
                let t1 = Task<String, Never> {
                    print("unstructured:", TaskStorage.name ?? "n/a")
                    return "unstructured:" + (TaskStorage.name ?? "n/a")
                }
                
                let t2 = Task<String, Never>.detached {
                    print("detached:", TaskStorage.name ?? "n/a")
                    return "detached:" + (TaskStorage.name ?? "n/a")
                }
                
                /// runs in parallel
                let parallel = await [t1.value, t2.value]
                texts.append(MessageItem(id: 2, text: parallel[0]))
                texts.append(MessageItem(id: 3, text: parallel[1]))
            }
        
//        Task(priority: .background) {
                let t3 = Task<String, Never>.detached {
                    withUnsafeCurrentTask { task in
                        print(task?.isCancelled ?? false)
                        print(task?.priority == nil)
                    }
                    let x = await self.calculateFirstNumber()
                    print("The meaning of life is:", x)
                    return "The meaning of life is: \(x)"
                }
    
            texts.append(MessageItem(id: 4, text: await t3.value))
//            }
        
//            var calculators: [Calculator] = []
//            for i in 0..<11 {
//                calculators.append(Calculator(index: i))
//            }
            
            
            let indices = await withTaskGroup(of: Int.self, returning: [Int].self) { taskGroup in
                for i in 0..<11 {
                    //var calculator = Calculator()
                    taskGroup.addTask { await Calculator().calculateEndIndex(i) }
                }
                var indices: [Int] = []
                for await result in taskGroup {
                    indices.append(result)
                }
                return indices
            }
            print(indices)
            texts.append(MessageItem(id: 5, text: "\(indices)"))
    
            await withTaskGroup(of: TaskSteps.self) { group in
                group.addTask {
                    .first(await self.calculateNumber())
                }
                group.addTask {
                    .second(await self.calculateString())
                }
                
                var result: String = ""
                for await res in group {
                    switch res {
                    case .first(let value):
                        result = result + String(value)
                    case .second(let value):
                        result = value + result
                    }
                }
                print(result)
                texts.append(MessageItem(id: 6, text: result))
            }
            
            return texts
        }
        self.texts = await work?.value
    }
    
    func calculateFirstNumber() async -> Int {
        await withCheckedContinuation { c in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                c.resume(with: .success(42))
            }
        }
    }
    
    func calculateNumber() async -> Int {
        await withCheckedContinuation { c in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                c.resume(with: .success(42))
            }
        }
    }

    func calculateString() async -> String {
        await withCheckedContinuation { c in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                c.resume(with: .success("The meaning of life is: "))
            }
        }
    }
}

