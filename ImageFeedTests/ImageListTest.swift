//
//  ImageListTest.swift
//  ImageFeedTests
//
//  Created by Александр Косолапов on 13/5/25.
//

import XCTest
@testable import ImageFeed

final class ImageListTest: XCTestCase {
    
    func testViewDidLoadCallsPresenter() {
        let presenterSpy = ImagesListPresenterSpy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось загрузить ImagesListViewController из storyboard")
            return
        }
        sut.configureWithPresenter(presenterSpy)
        
        _ = sut.view  // запускаем viewDidLoad
        
        XCTAssertTrue(presenterSpy.viewDidLoadCalled, "viewDidLoad() у presenter должен быть вызван при загрузке view")
    }
    
    func testTableViewNumberOfRowsReturnsPhotosCount() {
        // arrange
        let presenterSpy = ImagesListPresenterSpy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось загрузить ImagesListViewController из storyboard")
            return
        }
        sut.configureWithPresenter(presenterSpy)
        _ = sut.view
        
        let tableView = sut.tableView
        let rows = tableView?.dataSource?.tableView(tableView!, numberOfRowsInSection: 0)
        
        XCTAssertEqual(rows, presenterSpy.photosCount, "Количество строк должно совпадать с presenter.photosCount")
    }
    func testCellForRowCallsPresenterPhotoAt() {
        // arrange
        let presenterSpy = ImagesListPresenterSpy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось загрузить ImagesListViewController из storyboard")
            return
        }
        sut.configureWithPresenter(presenterSpy)
        _ = sut.view
        
        // act
        let indexPath = IndexPath(row: 0, section: 0)
        _ = sut.tableView(sut.tableView, cellForRowAt: indexPath)
        
        // assert
        XCTAssertEqual(presenterSpy.lastRequestedPhotoIndex, indexPath, "photo(at:) должен быть вызван с корректным IndexPath")
    }
    
    func testWillDisplayCellCallsPresenter() {
        // arrange
        let presenterSpy = ImagesListPresenterSpy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось загрузить ImagesListViewController из storyboard")
            return
        }
        sut.configureWithPresenter(presenterSpy)
        _ = sut.view
        
        let indexPath = IndexPath(row: 0, section: 0)
        let dummyCell = UITableViewCell()
        
        // act
        sut.tableView(sut.tableView, willDisplay: dummyCell, forRowAt: indexPath)
        
        // assert
        XCTAssertEqual(presenterSpy.willDisplayCellCalledIndexPath, indexPath, "willDisplayCell(at:) должен быть вызван с корректным IndexPath")
    }
}
