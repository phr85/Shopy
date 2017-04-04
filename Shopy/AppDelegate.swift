//
//  AppDelegate.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 31.03.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit
import CoreData
import DATAStack


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    let dataStack = DATAStack(modelName:"ShopyAppModel")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.updateBasketBadge()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    // MARK: - Helpers

    func updateBasketBadge() {
        self.dataStack.performInNewBackgroundContext { backgroundContext in
            let request:NSFetchRequest<SMBasketArticle> = NSFetchRequest(entityName: "SMBasketArticle")
            request.returnsObjectsAsFaults = false
            let results = try! backgroundContext.fetch(request)
            var totalPriceSum: Float = 0.0
            for item:SMBasketArticle in results {
                let totalPrice:Float = item.price * Float(item.itemCount)
                totalPriceSum += totalPrice
            }
            DispatchQueue.main.async {
                let tabBarController:UITabBarController = self.window?.rootViewController as! UITabBarController
                if (totalPriceSum > 0.0) {
                    tabBarController.viewControllers?[1].tabBarItem.badgeValue = String(format: "$%.2f",
                                                                                        totalPriceSum)
                } else {
                    tabBarController.viewControllers?[1].tabBarItem.badgeValue = nil
                }
                
            }
        }

    }
    
}

