//
//  ShopyUITests.swift
//  ShopyUITests
//
//  Created by Philippe H. Regenass on 31.03.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import XCTest

class ShopyUITests: XCTestCase {
    
    let app = XCUIApplication()

    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func clearBasket() {
        app.tabBars.buttons["Basket"].tap()
        app.navigationBars["Basket"].buttons["Empty"].tap()
        let tablesBasket = app.tables
        let count = tablesBasket.cells.count
        XCTAssert(count == 0)
        app.tabBars.buttons["Shop"].tap()
    }
    
    func testCheckProductCount() {
        clearBasket()
        let tablesQuery = app.tables
        let count = tablesQuery.cells.count
        XCTAssert(count == 4)
    }
    
    func testAddTwoMilkToBasket() {
        clearBasket()
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Milk").buttons["+"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Milk").buttons["+"].tap()
        app.tabBars.buttons["Basket"].tap()
        let count = tablesQuery.cells.count
        XCTAssert(count == 1)
    }
    
    func testBasketTotalPriceInUSD() {
        clearBasket()
        let tablesShop = app.tables
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Milk").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Beans").buttons["+"].tap()
        
        
        
        app.tabBars.buttons["Basket"].tap()
        app.navigationBars["Basket"].buttons["Checkout"].tap()
        
        
        let table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        table.swipeUp()
        
        
        XCTAssert(XCUIApplication().staticTexts["Total Price: USD 6.23"].exists)
        XCUIApplication().toolbars.buttons["Order Now"].tap()
        
        app.navigationBars["Shop"].tap()
        app.navigationBars["Basket"].tap()
        testIsBasketClear()
    }
    
    func testBasketTotalPriceInEUR() {
        clearBasket()
        let tablesShop = app.tables
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Milk").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Beans").buttons["+"].tap()
        
        app.tabBars.buttons["Basket"].tap()
        app.navigationBars["Basket"].buttons["Checkout"].tap()
        
//        app.
//        SYCheckoutTableViewController
        
        let table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        table.swipeUp()
        
        
        XCTAssert(XCUIApplication().staticTexts["Total Price: EUR 6.23"].exists)
        XCUIApplication().toolbars.buttons["Order Now"].tap()
        let tablesBasket = app.tables
        let count = tablesBasket.cells.count
        XCTAssert(count == 0)
    }
    
    func testIsBasketClear() {
        clearBasket()
        app.tabBars.buttons["Basket"].tap()
        let tablesBasket = app.tables
        let count = tablesBasket.cells.count
        XCTAssert(count == 0)
    }
 
    
    
}
