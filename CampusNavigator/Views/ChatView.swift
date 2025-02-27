import SwiftUI

// MARK: - Models
struct Chat: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let timestamp: String
    let isGroup: Bool
    var avatar: String? // Optional avatar image name
}

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let timestamp: Date
    let isFromCurrentUser: Bool
}

// MARK: - Components
struct AvatarView: View {
    let isGroup: Bool
    let avatarName: String?
    
    var body: some View {
        if let avatarName = avatarName, !avatarName.isEmpty {
            Image(avatarName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } else {
            Image(systemName: isGroup ? "person.2.fill" : "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(isGroup ? 4 : 0)
                .frame(width: 40, height: 40)
                .foregroundColor(isGroup ? .mint : .gray)
                .background(isGroup ? Color.gray.opacity(0.2) : Color.clear)
                .clipShape(Circle())
        }
    }
}

struct ChatRow: View {
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 16) {
            AvatarView(isGroup: chat.isGroup, avatarName: chat.avatar)
            
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
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(chat.timestamp)
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                /*Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.7))*/
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Main Chats List View
struct ChatView: View {
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    let individualChats = [
        Chat(name: "John Doe", lastMessage: "Did you finish iOS assignment?", timestamp: "10:30 AM", isGroup: false),
        Chat(name: "Alice Smith", lastMessage: "Did you finish iOS assignment?", timestamp: "10:30 AM", isGroup: false, avatar: nil)
    ]
    
    let groupChats = [
        Chat(name: "iOS Dev Group", lastMessage: "New resources added!!", timestamp: "Yesterday", isGroup: true),
        Chat(name: "Alice Smith", lastMessage: "Exam schedule updated", timestamp: "2h ago", isGroup: true)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header to match design
            HStack {
                Button(action: {
                    // Use presentation mode to go back to HomeView
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Home")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.mint)
                }
                
                Spacer()
                
                Text("Chats")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    // Handle new chat action
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20))
                        .foregroundColor(.mint)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            
            List {
                Section(header: Text("INDIVIDUAL CHATS")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)) {
                        ForEach(individualChats) { chat in
                            NavigationLink(destination: ChatDetailView(recipient: chat.name)) {
                                ChatRow(chat: chat)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                
                Section(header: Text("GROUP CHATS")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)) {
                        ForEach(groupChats) { chat in
                            NavigationLink(destination: ChatDetailView(recipient: chat.name)) {
                                ChatRow(chat: chat)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarHidden(true)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .preferredColorScheme(.light)
        
        ChatView()
            .preferredColorScheme(.dark)
    }
}
