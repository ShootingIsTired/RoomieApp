import SwiftUI

struct ChatRoomView: View {
    @Binding var selectedPage: String?
    @State private var messageText = ""
    @State private var showMenuBar = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            chatContent
                .contentShape(Rectangle())
                .onTapGesture {
                    if showMenuBar {
                        showMenuBar = false
                    }
                }
            
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
        }
    }
    
    var chatContent: some View {
        VStack(spacing: 0) {
            header
            Spacer()
            messagesView
            messageInputField
        }
    }
    
    var header: some View {
        HStack {
            Button(action: {
                withAnimation {
                    showMenuBar.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
            }
            Spacer()
            Text("CHAT")
                .font(Font.custom("Noto Sans", size: 24))
                .bold()
                .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }
    
    var messagesView: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(authViewModel.currentRoom?.chatsData ?? [], id: \.id) { message in
                        chatMessageRow(message: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal)
                .onChange(of: authViewModel.currentRoom?.chatsData?.count) { _ in
                    if let lastMessage = authViewModel.currentRoom?.chatsData?.last?.id {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage, anchor: .bottom)
                        }
                    }
                }
            }
            .onAppear {
                authViewModel.fetchChats(roomID: authViewModel.currentRoom?.id ?? "")
            }
        }
    }

    var messageInputField: some View {
        HStack {
            TextField("Type a message...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 10)

            Button(action: {
                if let roomID = authViewModel.currentRoom?.id, !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    authViewModel.sendChatMessage(roomID: roomID, content: messageText)
                    messageText = ""
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 10)
        }
        .frame(height: 50)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func chatMessageRow(message: Chats) -> some View {
        HStack {
            if message.isCurrentUser ?? false {
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

struct ChatRoomView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Chat"
        @StateObject var authViewModel = AuthViewModel()

        var body: some View {
            ChatRoomView(selectedPage: $selectedPage).environmentObject(authViewModel)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
