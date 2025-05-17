//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Александр Косолапов on 13/5/25.
//

@testable import ImageFeed
import XCTest
import Foundation

final class ProfileTests: XCTestCase {
    func testViewControllerCallsPresenterViewDidLoad() {
     
        let presenterSpy = ProfilePresenterSpy()
        let sut = ProfileViewController()
        sut.configure(presenter: presenterSpy)

        _ = sut.view
   
        XCTAssertTrue(presenterSpy.viewDidLoadCalled, "viewDidLoad() у presenter должен быть вызван")
    }
    

    func testConfigureSetsPresenterAndView() {
      
        let presenterSpy = ProfilePresenterSpy()
        let sut = ProfileViewController()

        sut.configure(presenter: presenterSpy)

        XCTAssertTrue(presenterSpy.view === sut, "View у presenter должна указывать на ViewController после configure()")
    }
    
    func testPresenterSetsProfileData_onViewDidLoad() {
        let viewSpy = ProfileViewSpy()
        let presenter = ProfilePresenterWithFakeData()
        presenter.view = viewSpy

        presenter.viewDidLoad()

        XCTAssertEqual(viewSpy.receivedName, "Имя")
        XCTAssertEqual(viewSpy.receivedLogin, "@login")
        XCTAssertEqual(viewSpy.receivedBio, "Описание профиля")
    }
}


