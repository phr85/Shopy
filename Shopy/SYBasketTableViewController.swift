//
//  SYBasketTableViewController.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 31.03.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit
import CoreData
import DATAStack
import DATASource

class SYBasketTableViewController: UITableViewController {

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
        setupBasketTableViewCell()
        setupTableView()
    }
    
    private func setupBasketTableViewCell() {
        tableView.register(UINib(nibName: "SYBasketTableViewCell", bundle: nil),
                           forCellReuseIdentifier: SYShopTableViewCell.reuseIdentifier)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func emptyBasket(sender: UIBarButtonItem) {
        self.dataStack.performInNewBackgroundContext { backgroundContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SMBasketArticle")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try backgroundContext.execute(batchDeleteRequest)
            } catch {
            }
            try! backgroundContext.save()
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    // MARK: - Helpers

    private func reloadData() {
        self.dataSource.fetch()
        self.tableView.reloadData()
        appDelegate.updateBasketBadge()
    }
    
    // MARK: - Table view data source / DATASource
    
    lazy var dataSource: DATASource = {
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SMBasketArticle")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let dataSource = DATASource(tableView: self.tableView, cellIdentifier: SYShopTableViewCell.reuseIdentifier,
                                    fetchRequest: request, mainContext: self.dataStack.mainContext,
                                    configuration: { cell, item, indexPath in
            let basketItem: SMBasketArticle = item as! SMBasketArticle
            cell.textLabel?.text = basketItem.title
            var totalItemPrice: Float =
                SYHelpers.totalItemPrice(item.value(forKey: "price") as! Float,
                                         numberOfItems: item.value(forKey: "itemCount") as! Int,
                                         exchangeRate: 1.0)
            cell.detailTextLabel?.text =
                String(format: "USD %.2f for %i %@s",
                       totalItemPrice,
                       basketItem.itemCount,
                       basketItem.unit!)
        })
        
        return dataSource
    }()
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}



