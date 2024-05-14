//
//  Register.swift
//  RoomieApp
//
//  Created by Ru Heng on 2024/4/29.
//

import Foundation
import SwiftUI
import SwiftData
import Firebase
import FirebaseCore
import FirebaseAuth

struct RegisterView: View {
    @Binding var selectedPage: String?
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var birthday = ""
    @State private var error: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.92), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.88, green: 0.92, blue: 0.94), location: 0.29),
                        Gradient.Stop(color: Color(red: 0.69, green: 0.81, blue: 0.94), location: 1.00)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("Roomie Icon")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fit)
                    
                    //LOGIN
                    Text("RIGISTER")
                        .font(.title)
                        .bold()
                        .frame(width: 200, height: 40)
                        .foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.38, blue: 0.56, alpha: 1)))
                    HStack {
                        VStack {
                            Text("Name:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 100, height: 45
                                )
                                .padding(.trailing, 2)
                            Text("Birthday:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 100, height: 50
                                )
                                .padding(.trailing, 2)
                            Text("Email:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 100, height: 50
                                )
                                .padding(.trailing, 2)
                            Text("Password:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 100, height: 50)
                                .padding(.trailing, 2)
                        }
                        VStack {
                            TextField("Please enter your name", text: $name)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .background {textFieldBorder}
                                .multilineTextAlignment(.center)
                            TextField("Please enter your bithday", text: $birthday)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .background {textFieldBorder}
                                .multilineTextAlignment(.center)
                            TextField("Please enter your email", text: $email)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .background {textFieldBorder}
                                .multilineTextAlignment(.center)
                            TextField("Please enter your password", text: $password)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .background {textFieldBorder}
                                .multilineTextAlignment(.center)
                        }
                        
                        
                    }

                    Button {
                        Task {
                            try await viewModel.createMember(withEmail: email, password: password, name: name, birthday: birthday)
                        }
                    } label: {
                        Text("ENTER")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 100.0, height: 42.0)
                            .background(ButtomBorder)
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                                        
                    NavigationLink {
                        LoginView(selectedPage: $selectedPage)
                            .navigationBarBackButtonHidden()
                    } label: {
                        VStack {
                            Text("LOGIN")
                                .font(.subheadline)
                                .underline()
                                .foregroundColor(.black)
                                .frame(width: 100.0, height: 42.0)
                        }
                    }
                }
                .padding()
            }
        }
        }

//    func register() {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        }
//    }
    
    var textFieldBorder: some View {
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 230, height: 42)
            .background(Color(red: 1, green: 0.87, blue: 0.44))
            .cornerRadius(15)
            .overlay(
            RoundedRectangle(cornerRadius: 15)
            .inset(by: -1)
            .stroke(Color(red: 0, green: 0.23, blue:0.44).opacity(0.8), lineWidth: 2)

            )
        
        }
    
    var ButtomBorder: some View {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.clear)
              .frame(width: 82, height: 42)
              .background(Color(red: 1, green: 0.84, blue: 0.25))
              .cornerRadius(15)
              .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .inset(by: -1)
                  .stroke(Color(red: 0.95, green: 0.75, blue: 0.09), lineWidth: 1)
              )
        }
}

extension RegisterView: AuthenticationFormProtocol {
    var formIsValid: Bool{
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && !name.isEmpty
        && !birthday.isEmpty
    }
}

struct RegisterView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Register"
        var body: some View {
            RegisterView(selectedPage: $selectedPage)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}

