//
//  WorkResults.swift
//  ASyncTesting
//
//  Created by Steve Wainwright on 02/04/2024.
//

import SwiftUI

struct ASyncMessagesView: View {
    @State var messages: [MessageItem] = []
    let worker = Worker()
    
    var body: some View {
        
        List(messages) { message in
            Text(message.text)
        }
        .task {
            await loadMessages()
        }
    }
    
    func loadMessages() async {
        await worker.messages()
        self.messages = await worker.texts ?? []
    }
}
