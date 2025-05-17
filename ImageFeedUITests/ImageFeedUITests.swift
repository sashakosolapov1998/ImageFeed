//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Александр Косолапов on 13/5/25.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5), "Кнопка 'Authenticate' не появилась")
        authButton.tap()
        
        let webView = app.webViews["authWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("login")
        webView.swipeUp()
        
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        
        passwordTextField.typeText("password")
        sleep(2)
        // из-за перекрытия на маленьких экранах
        if app.keyboards.buttons["go"].exists {
            app.keyboards.buttons["go"].tap()
        }
        sleep(5)
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(5)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        if cellToLike.buttons["like button off"].exists {
            cellToLike.buttons["like button off"].tap()
        } else if cellToLike.buttons["like button on"].exists {
            cellToLike.buttons["like button on"].tap()
        }
        
        sleep(5)
        
        let previewImage = cellToLike.images.element(boundBy: 0)
        XCTAssertTrue(previewImage.exists)
        previewImage.tap()
        
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["chevron"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
    }
    
    func testProfile() throws {
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Aleksandr Kosolapov"].exists)
        XCTAssertTrue(app.staticTexts["@sashakosolapov"].exists)
        
        app.buttons["exit_button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(5)
    }
}

