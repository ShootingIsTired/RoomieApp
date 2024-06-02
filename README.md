# RoomieApp
# Welcome to RoomieApp 👋
[![Documentation](https://img.shields.io/badge/documentation-yes-brightgreen.svg)](https://reurl.cc/EjYEZR)

> Roomie 是專為同住者設計的 App，旨在提升居住品質。同住者們可以透過建立 Room 來一同管理同住事宜，App 提供事件提醒和互助、家事分工、共享行程及狀態、匿名聊天室等功能。通過顯示同住者生日、建立住宿公約、提醒每日行程、協助家事分配，讓室友間的互動更加和諧，居住環境更加舒適。

### ✨ [Demo Video](https://reurl.cc/mMzEv7)
### ✨ [Introduction Documentation](https://drive.google.com/file/d/1naASfpKSqLARGcWLwZSepyMqwOWqP8po/view)
## Author

👤 **資管三 B10705022 謝宛軒、B10705026 黃如珩、B10705035 許毓庭、B10705037 關凱欣、B10705039 松浦明日香**

## Environment
- Frontend：SwiftUI
- Backend：Firebase
- iPhone 15 Pro
  
## File Structure

- **README.md**: Provides setup instructions and information about the project.
- **RoomieApp.xcodeproj**: Defines the project's dependencies and other metadata.
- **RoomieApp**:
  - **RoomieApp.entitlements**
  - **GoogleService-Info.plist**
  - **Info.plist**: File that use to connect firebase
  - **AuthViewModel.swift**: All the related functions.
  - **Chat.swift**: Allow members to chat anonymously.
  - **Chores.swift**: Allow members to view undone chores, modify the status and add new chores
  - **ContentView.swift**: Root of the App
  - **Home.swift**: Can display all the tasks in the future and allow users to modified.
  - **MenuBar.swift**: Allow members to log out and show all the related pages.
  - **Package.swift**
  - **Profile.swift**: Allow members to view and modify household rules, household member information and their account information.
  - **RoomieAppApp.swift**
  - **Schedule.swift**: Allow members to view all roomates' schedule and modify their own schedule.
  - **Todo.swift**: Struct of all the entities.
- **Assets.xcassets**: Asset catalog for storing image assets used in the app.
- **Elements**: Contains various UI elements that used throughout different pages in the app.
  - **AddChore.swift**
  - **AddTask.swift**
  - **ChooseDate.swift**
  - **ChooseFrequency.swift**
  - **ChooseTime.swift**
  - **EditChore.swift**
  - **EditTask.swift**
  - **SelectPerson.swift**
- **Intro pages**: Contains introductory pages for first-time users.
  - **Create Room.swift**: Allow members to create a new room.
  - **Get Room.swift**: Allow members to choose if they want to create or join a new room.
  - **Join Room.swift**: Allow members to join an existing room.
  - **Login.swift** Allow members to login
  - **Register.swift**: Allow members to  create account
- **Preview Content**: Contains content used for previewing the app in Xcode.
- **Text**: Contains text files related to the project.

## Build Setup (Local)
- `git clone https://github.com/ShootingIsTired/RoomieApp.git`
- open the `RoomieApp` file with Xcode and run
