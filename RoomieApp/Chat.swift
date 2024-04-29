import SwiftUI

// Define a struct to model individual chat messages
struct ChatMessage: Identifiable, Equatable {
    let id: UUID = UUID() // Unique identifier for each message
    let content: String // The text content of the message
    let isCurrentUser: Bool // To differentiate between the current user and others
}

struct ChatRoomView: View {
    @Binding var selectedPage: String?
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [] // The array that simulates a database
    @State private var showMenuBar = false // State to manage the visibility of the menu
    var body: some View {
        ZStack(alignment: .leading){
            Chat
                .contentShape(Rectangle())
                .onTapGesture{
                    if showMenuBar{
                        showMenuBar = false
                    }
                }
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
        }
    }

    var Chat: some View {
        VStack(spacing: 0) {
            // Header at the top
            HStack {
                // Toggle button for the menu
                Button(action: {
                        // Toggle the visibility of the menu
                        withAnimation {
                            showMenuBar.toggle()
                        }
                    }) {
                    Image("menu")
                    .frame(width: 38, height: 38)}
                Spacer()
                Text("CHAT")
                    .font(.custom("Krona One", size: 20))
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
                Spacer()
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 2)

            // Chat content goes here
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            // Align messages to leading or trailing side based on the sender
                            HStack {
                                if message.isCurrentUser {
                                    Spacer()
                                    Text(message.content)
                                        .padding(10)
                                        .background(Color.blue)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                } else {
                                    Text(message.content)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: messages) {
                    if let lastMessage = messages.last {
                        scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }

            // Text field at the bottom
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .frame(height: 70)
            .background(Color.white)
            .shadow(radius: 2)
        }
        .edgesIgnoringSafeArea(.bottom) // Allow the text field to be at the bottom edge
    }

    func sendMessage() {
        // Avoid sending empty messages
        if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newMessage = ChatMessage(content: messageText, isCurrentUser: true)
            messages.append(newMessage) // Append the new message to the messages array
            messageText = "" // Clear the text field
        }
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Chat"

        var body: some View {
            ChatRoomView(selectedPage: $selectedPage)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
