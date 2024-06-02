import XCTest
import SwiftUI
import ViewInspector
@testable import RoomieApp

// Extend the view to be inspected by ViewInspector
extension MenuBar: Inspectable {}

@MainActor
final class MenuBarTests: XCTestCase {

    func testInitialSelectedPage() throws {
        let authViewModel = AuthViewModel()
        let menuBarView = MenuBar(selectedPage: .constant("Home"))
            .environmentObject(authViewModel)
        let menuBar = try menuBarView.inspect().view(MenuBar.self)
        
        XCTAssertEqual(try menuBar.actualView().selectedPage, "Home")
    }

    func testProfileButtonTap() throws {
        let authViewModel = AuthViewModel()
        let selectedPage = Binding<String?>(wrappedValue: "Home")
        let menuBarView = MenuBar(selectedPage: selectedPage)
            .environmentObject(authViewModel)
        let menuBar = try menuBarView.inspect().view(MenuBar.self)
        
        try menuBar.find(button: "PROFILE").tap()
        XCTAssertEqual(selectedPage.wrappedValue, "Profile")
    }

    func testHomeButtonTap() throws {
        let authViewModel = AuthViewModel()
        let selectedPage = Binding<String?>(wrappedValue: "Profile")
        let menuBarView = MenuBar(selectedPage: selectedPage)
            .environmentObject(authViewModel)
        let menuBar = try menuBarView.inspect().view(MenuBar.self)
        
        try menuBar.find(button: "HOME").tap()
        XCTAssertEqual(selectedPage.wrappedValue, "Home")
    }

    func testChoresButtonTap() throws {
        let authViewModel = AuthViewModel()
        let selectedPage = Binding<String?>(wrappedValue: "Home")
        let menuBarView = MenuBar(selectedPage: selectedPage)
            .environmentObject(authViewModel)
        let menuBar = try menuBarView.inspect().view(MenuBar.self)
        
        try menuBar.find(button: "CHORES").tap()
        XCTAssertEqual(selectedPage.wrappedValue, "Chores")
    }

    func testScheduleButtonTap() throws {
        let authViewModel = AuthViewModel()
        let selectedPage = Binding<String?>(wrappedValue: "Home")
        let menuBarView = MenuBar(selectedPage: selectedPage)
            .environmentObject(authViewModel)
        let menuBar = try menuBarView.inspect().view(MenuBar.self)
        
        try menuBar.find(button: "SCHEDULE").tap()
        XCTAssertEqual(selectedPage.wrappedValue, "Schedule")
    }

    func testChatButtonTap() throws {
        let authViewModel = AuthViewModel()
        let selectedPage = Binding<String?>(wrappedValue: "Home")
        let menuBarView = MenuBar(selectedPage: selectedPage)
            .environmentObject(authViewModel)
        let menuBar = try menuBarView.inspect().view(MenuBar.self)
        
        try menuBar.find(button: "CHAT").tap()
        XCTAssertEqual(selectedPage.wrappedValue, "Chat")
    }
}
