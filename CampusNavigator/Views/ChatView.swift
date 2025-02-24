//
//  ChatView.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-17.
//

import SwiftUI

struct Chat: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let timestamp: String
    let isGroup: Bool
}

struct ChatRow: View {
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: chat.isGroup ? "person.2.fill" : "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(chat.timestamp)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct ChatView: View {
    let individualChats = [
        Chat(name: "Jhon Doe", lastMessage: "Did you finish iOS assignment?", timestamp: "10:30 AM", isGroup: false),
        Chat(name: "Alice Smith", lastMessage: "Did you finish iOS assignment?", timestamp: "10:30 AM", isGroup: false)
    ]
    
    let groupChats = [
        Chat(name: "iOS Dev Group", lastMessage: "New resources added!!", timestamp: "Yesterday", isGroup: true),
        Chat(name: "Alice Smith", lastMessage: "Exam schedule updated", timestamp: "2h ago", isGroup: true)
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("INDIVIDUAL CHATS")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)) {
                        ForEach(individualChats) { chat in
                            ChatRow(chat: chat)
                        }
                    }
                
                Section(header: Text("GROUP CHATS")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)) {
                        ForEach(groupChats) { chat in
                            ChatRow(chat: chat)
                        }
                    }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Chats")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
