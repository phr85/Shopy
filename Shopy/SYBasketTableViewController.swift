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
    
    // MARK: - Initialization

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    }
    
    // MARK: - Actions
    
    @IBAction func emptyBasket(sender: UIBarButtonItem) {
        self.dataStack.performInNewBackgroundContext { backgroundContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SMArticle")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try backgroundContext.execute(batchDeleteRequest)
            } catch {
            }
            try! backgroundContext.save()
            DispatchQueue.main.async {
                self.dataSource.fetch()
            }
        }
    }
    
    // MARK: - Table view data source / DATASource
    
    lazy var dataSource: DATASource = {
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SMArticle")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let dataSource = DATASource(tableView: self.tableView, cellIdentifier: SYShopTableViewCell.reuseIdentifier,
                                    fetchRequest: request, mainContext: self.dataStack.mainContext,
                                    configuration: { cell, item, indexPath in
            cell.textLabel?.text = item.value(forKey: "title") as? String
            cell.detailTextLabel?.text = item.value(forKey: "title") as? String
                                        cell.detailTextLabel?.text =
                                            String(format: "$ %@ for %.0f Items",
                                                   (item.value(forKey: "price") as? String)!,
                                                   (item.value(forKey: "itemCount") as? Double)!)
        })
        
        return dataSource
    }()
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}



