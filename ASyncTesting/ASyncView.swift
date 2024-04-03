//
//  ASyncView.swift
//  ASyncTesting
//
//  Created by Steve Wainwright on 30/03/2024.
//

import Foundation

import SwiftUI
import AsyncView

struct CountriesView: View, Sendable {
    var body: some View {
        AsyncView(
            operation: { try await CountriesEndpoints.shared.countries() },
            content: { countries in
                List(countries) { country in
                    Text(country.name)
                }
            }
        )
    }
}

//struct ASyncMessagesView: View, Sendable {
//    @State var messages: [MessageItem] = []
//    let worker = Worker()
//    
//    var body: some View {
////        AsyncView(
////            operation: {
////                await worker.messages()
////                let texts = await worker.texts
////                self.messages = texts
////                return texts
////            },
////            content: { messages in
////                List(messages) { message in
////                    Text(message.text)
////                }
////        })
//        
//        List(messages) { message in
//            Text(message.text)
//        }
//        .task {
//            await worker.messages()
//            self.messages = await worker.texts
//        }
//    }
//}

struct Country: Identifiable, Codable, Sendable {
    var id: String
    var name: String
}

class CountriesEndpoints {
    let urlSession = URLSession.shared
    let jsonDecoder = JSONDecoder()
    
    static let shared = CountriesEndpoints()

    func countries() async throws -> [Country] {
        let url = URL(string: "https://www.ralfebert.de/examples/v3/countries.json")!
        let (data, _) = try await urlSession.data(from: url)
        return try self.jsonDecoder.decode([Country].self, from: data)
    }
}
