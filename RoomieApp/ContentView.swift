//
//  ContentView.swift
//  RoomieApp
//
//  Created by Yuting Hsu on 2024/4/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var selectedPage: String?
    var body: some View {
        Group{
            if !viewModel.IsLoggedIn {
                // 1. 還沒登入
                LoginView(selectedPage: $selectedPage)
            } else if !viewModel.userHasRoom {
                // 2. 登入但沒有房間
                GetRoomView()
            } else {
                // 3. 登入且有房間
                MenuBarView()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Root"
        var body: some View {
            ContentView(selectedPage: $selectedPage)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
