# RoomieApp
# Welcome to RoomieApp 👋
[![Documentation](https://img.shields.io/badge/documentation-yes-brightgreen.svg)](https://reurl.cc/EjYEZR)

> Roomie 是專為同住者設計的App，旨在提升居住品質。它提供宿舍Profile、事件提醒和互助、家事分工、共享行程及狀態、匿名聊天室等功能。通過顯示室友生日、宿舍公約、提醒每日行程、協助家事分配，讓室友間的互動更加和諧，居住環境更加舒適。

### ✨ [Demo](https://reurl.cc/mMzEv7)
### [Introduction Documentation](https://drive.google.com/file/d/1naASfpKSqLARGcWLwZSepyMqwOWqP8po/view)
## Author

👤 **資管三 B10705022 謝宛軒、B10705026 黃如珩、B10705035 許毓庭、B10705037 關凱欣、B10705039 松浦明日香**

## File Structure

- **README.md**: Provides setup instructions and information about the project.
- **RoomieApp.xcodeproj**: Defines the project's dependencies and other metadata.
- **RoomieApp**:
  - **RoomieApp.entitlements**
  - **GoogleService-Info.plist**
  - **Info.plist**
  - **AuthViewModel.swift**
  - **Chat.swift**
  - **Chores.swift**
  - **ContentView.swift**
  - **Home.swift**: Can display all the tasks in the future
  - **MenuBar.swift**: Allow members to log out and show all the related pages.
  - **Package.swift**
  - **Profile.swift**
  - **RoomieAppApp.swift**
  - **Schedule.swift**
  - **Todo.swift**
- **Assets.xcassets**: Asset catalog for storing image assets used in the app.
- **Elements**: Contains various UI elements used throughout the app.
  - **AddChore.swift**
  - **AddTask.swift**
  - **ChooseDate.swift**
  - **ChooseFrequency.swift**
  - **ChooseTime.swift**
  - **EditChore.swift**
  - **EditTask.swift**
  - **SelectPerson.swift**
- **Intro pages**: Contains introductory pages for first-time users.
  - **Create Room.swift**: Create a room for new user.
  - **Get Room.swift**: User c
  - **Join Room.swift**: Allow members to join an existing room.
  - **Login.swift**
  - **Member.swift**
  - **Register.swift**: Allow members to  create account
- **Preview Content**: Contains content used for previewing the app in Xcode.
- **Text**: Contains text files related to the project.
- **ViewModels**: Contains view model files used in the MVVM architecture.
  - **ViewCurrentUser.swift**
  - **ViewMembers.swift**
  - **ViewRooms.swift**
