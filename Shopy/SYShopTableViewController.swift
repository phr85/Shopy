//
//  SYShopTableViewController.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 31.03.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit
import CoreData
import DATAStack
import DATASource
import Sync
import SwiftyJSON
import EZLoadingActivity
import GMStepper


class SYShopTableViewController: UITableViewController {

    // MARK: - Properties
    
    let dataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupShopTableViewCell()
        setupTableView()
        setupImportData()
    }
    
    private func setupImportData() {
        EZLoadingActivity.show(NSLocalizedString("Loading Products", comment: ""), disableUI: true)
        let urlString = "https://api.treeinspired.com/shopy/index.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url, options: []) {
                let appDelegate =
                    UIApplication.shared.delegate as! AppDelegate
                let jsonRoot = JSON(data: data)
                let json = try! JSONSerialization.jsonObject(with: jsonRoot.rawData(), options: [])
                    as! [[String: Any]]
                Sync.changes(json, inEntityNamed: "SMProducts", dataStack: appDelegate.dataStack) { error in
                    if let errorDes = error?.localizedDescription {
                        print(errorDes)
                    }
                }
            }
        }
        EZLoadingActivity.hide()
    }
    
    private func setupShopTableViewCell() {
        tableView.register(UINib(nibName: "SYShopTableViewCell", bundle: nil),
                           forCellReuseIdentifier: SYShopTableViewCell.reuseIdentifier)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self.dataSource
    }
    
    // MARK: - Actions
    
    @IBAction func addProductToBasket(sender: GMStepper) {
        let stepperIndexPath = IndexPath.init(row: sender.tag, section: 0)
        let item: SMProducts = self.dataSource.object(stepperIndexPath) as! SMProducts
        self.dataStack.performInNewBackgroundContext { backgroundContext in
            let request:NSFetchRequest<SMBasketArticle> = NSFetchRequest(entityName: "SMBasketArticle")
            request.predicate = NSPredicate(format: "id ==[c] %@", item.id)
            var resultItem = try! backgroundContext.fetch(request)
            if resultItem.count > 0 {
                if (sender.value == 0) {
                    backgroundContext.delete(resultItem[0])
                } else {
                    resultItem[0].setValue(sender.value, forKey: "itemCount")
                }
            } else if(sender.value > 0) {
                let entity = NSEntityDescription.entity(forEntityName: "SMBasketArticle", in: backgroundContext)!
                let object = NSManagedObject(entity: entity, insertInto: backgroundContext)
                object.setValue(item.title, forKey: "title")
                object.setValue(item.price, forKey: "price")
                object.setValue(sender.value, forKey: "itemCount")
                object.setValue(item.unit, forKey: "unit")
                object.setValue(item.id, forKey: "id")
            }
            try! backgroundContext.save()
            DispatchQueue.main.async {
                self.appDelegate.updateBasketBadge()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func reloadData() {
        self.tableView.reloadData()
    }
    
    func stepperValueFromBasketItem(_ prodId: String) -> Double {
        let request:NSFetchRequest<SMBasketArticle> = NSFetchRequest(entityName: "SMBasketArticle")
        request.predicate = NSPredicate(format: "id ==[c] %@", prodId)
        var resultItem = try! self.dataStack.viewContext.fetch(request)
        if resultItem.count > 0 {
            let item:SMBasketArticle = resultItem[0]
            return Double(item.itemCount)
        }
        return 0
    }
    
    // MARK: - Table view data source / DATASource
    
    lazy var dataSource: DATASource = {
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SMProducts")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let dataSource = DATASource(tableView: self.tableView, cellIdentifier: SYShopTableViewCell.reuseIdentifier,
                                    fetchRequest: request, mainContext: self.dataStack.mainContext,
                                    configuration: { cell, item, indexPath in
                                        let shopCell: SYShopTableViewCell = cell as! SYShopTableViewCell
                                        let productItem: SMProducts = item as! SMProducts
                                        shopCell.stepperButton.tag = indexPath.row
                                        shopCell.stepperButton.value = self.stepperValueFromBasketItem(productItem.id)
                                        shopCell.productTitel?.text = productItem.title
                                        shopCell.priceLabel?.text =
                                            String(format: "USD %.2f per %@",
                                                   productItem.price,
                                                   productItem.unit!)
        })
        
        return dataSource
    }()
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }

}
