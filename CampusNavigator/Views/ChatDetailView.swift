//
//  ChatDetailView.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-27.
//

import SwiftUI

// MARK: - Components
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 2) {
                Text(message.content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        message.isFromCurrentUser ?
                        Color.blue :
                        Color(UIColor.systemGray5)
                    )
                    .foregroundColor(
                        message.isFromCurrentUser ?
                        Color.white :
                        Color.primary
                    )
                    .cornerRadius(16)
                
                Text(formatMessageTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
            }
            
            if !message.isFromCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MessageInputField: View {
    @Binding var messageText: String
    var onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            TextField("Enter your message here", text: $messageText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)
            
            Button(action: onSend) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(messageText.isEmpty ? Color.gray : Color.blue)
                    .clipShape(Circle())
            }
            .disabled(messageText.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
    }
}

// MARK: - Main Chat Detail View
struct ChatDetailView: View {
    let recipient: String
    @State private var messageText = ""
    @State private var messages: [Message] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header to match design
            HStack {
                Button(action: {
                    // Use presentation mode to go back to ChatView
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(recipient)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Empty view to balance the layout
                Image(systemName: "chevron.left")
                    .font(.system(size: 16))
                    .foregroundColor(.clear)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            // Chat message list
            if messages.isEmpty {
                Spacer()
                Text("No messages yet")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            // Message input field
            MessageInputField(messageText: $messageText, onSend: sendMessage)
                .padding(.bottom, 8)  // Extra padding for the home indicator area
        }
        .navigationBarHidden(true)
        .onAppear {
            // Load sample messages for preview
            loadSampleMessages()
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let newMessage = Message(
            content: messageText,
            timestamp: Date(),
            isFromCurrentUser: true
        )
        
        messages.append(newMessage)
        messageText = ""
        
        // Simulate a response after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let response = Message(
                content: "This is a sample response",
                timestamp: Date(),
                isFromCurrentUser: false
            )
            messages.append(response)
        }
    }
    
    private func loadSampleMessages() {
        // Add some sample messages for preview purposes
        let sampleMessages = [
            Message(
                content: "Hi there! How's your day going?",
                timestamp: Date().addingTimeInterval(-3600),
                isFromCurrentUser: false
            ),
            Message(
                content: "Pretty good, thanks for asking! Just working on this iOS project.",
                timestamp: Date().addingTimeInterval(-3500),
                isFromCurrentUser: true
            ),
            Message(
                content: "That sounds interesting. What are you building?",
                timestamp: Date().addingTimeInterval(-3400),
                isFromCurrentUser: false
            )
        ]
        
        self.messages = sampleMessages
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView(recipient: "Alice Smith")
            .preferredColorScheme(.light)
        
        ChatDetailView(recipient: "Alice Smith")
            .preferredColorScheme(.dark)
    }
}
