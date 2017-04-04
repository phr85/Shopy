//
//  ShopyUITests.swift
//  ShopyUITests
//
//  Created by Philippe H. Regenass on 31.03.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import XCTest

class ShopyUITests: XCTestCase {
    
    // MARK: - Properties
    
    let app = XCUIApplication()
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test Cases
    
    func testProductLoadingFromJSON() {
        // Check if product loading from JSON works
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
        
        // Add some products to basket
        let tablesShop = app.tables
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Milk").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Beans").buttons["+"].tap()
        app.tabBars.buttons["Basket"].tap()
        
        // Open Checkout
        app.navigationBars["Basket"].buttons["Checkout"].tap()
        
        // Scroll Table -> Trigger again TableView datasource
        let table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        table.swipeUp()
        
        // Check Totalprice
        XCTAssert(XCUIApplication().staticTexts["Total Price: USD 6.23"].exists)
        
        // Order Products
        XCUIApplication().toolbars.buttons["Order Now"].tap()
        
        // Check if basket empty…
        app.tabBars.buttons["Shop"].tap()
        app.tabBars.buttons["Basket"].tap()
        isBasketClear()
    }

    func testOrderViewWithTotalPriceInEUR() {
        clearBasket()
        
        // Add some products to basket
        let tablesShop = app.tables
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Eggs").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Milk").buttons["+"].tap()
        tablesShop.cells.containing(.staticText, identifier:"Beans").buttons["+"].tap()
        app.tabBars.buttons["Basket"].tap()
        
        // Open Checkout
        app.navigationBars["Basket"].buttons["Checkout"].tap()
        
        // Change currency to EUR
        app.navigationBars["Review"].buttons["Change Currency"].tap()
        let usdPickerWheel = app.pickerWheels["USD"]
        usdPickerWheel.adjust(toPickerWheelValue: "EUR")
        app.buttons["Apply"].tap()

        // Waste some time
        let table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        table.swipeUp()
        
        // Check if Total Price label changed
        let totalPricePredicate = NSPredicate(format: "label BEGINSWITH 'Total Price: EUR 5.'")
        let totalPriceLabel = app.staticTexts.element(matching: totalPricePredicate)
        XCTAssert(totalPriceLabel.exists)
        
        XCUIApplication().toolbars.buttons["Order Now"].tap()
        let tablesBasket = app.tables
        let count = tablesBasket.cells.count
        XCTAssert(count == 0)
    }
    
    // MARK: - Helpers
    
    func clearBasket() {
        app.tabBars.buttons["Basket"].tap()
        app.navigationBars["Basket"].buttons["Empty"].tap()
        let tablesBasket = app.tables
        let count = tablesBasket.cells.count
        XCTAssert(count == 0)
        app.tabBars.buttons["Shop"].tap()
    }
    
    func isBasketClear() {
        clearBasket()
        app.tabBars.buttons["Basket"].tap()
        let tablesBasket = app.tables
        let count = tablesBasket.cells.count
        XCTAssert(count == 0)
    }
    
}


