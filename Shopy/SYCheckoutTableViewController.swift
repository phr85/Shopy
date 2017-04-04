//
//  SYCheckoutTableViewController.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 01.04.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit
import CoreData
import DATAStack
import DATASource
import SwiftyJSON

class SYCheckoutTableViewController: UIViewController {

    // MARK: - Properties
    
    let dataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack
    let pickerViewDataSourceAndDelegate: UIPickerViewDelegate = PickerDataSourceAndDelegate()
    var selectedCurrency = "USD"
    var exchangeRate: Float = 1.0
    var totalPrice: Float = 0.0
    
    // MARK: -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupBasketTableViewCell()
        setupTableView()
        setupTotalPriceLabel()
    }
    
    private func setupBasketTableViewCell() {
        tableView.register(UINib(nibName: "SYBasketTableViewCell", bundle: nil),
                           forCellReuseIdentifier: SYShopTableViewCell.reuseIdentifier)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self.dataSource
    }
    
    private func setupTotalPriceLabel() {
        self.totalPrice = 0
        let request:NSFetchRequest<SMBasketArticle> = NSFetchRequest(entityName: "SMBasketArticle")
        let results = try! self.dataStack.viewContext.fetch(request)
        
        for item:SMBasketArticle in results {
            let convertedPrice: Float =
                SYHelpers.totalItemPrice(item.value(forKey: "price") as! Float,
                                         numberOfItems: item.value(forKey: "itemCount") as! Int,
                                         exchangeRate: self.exchangeRate)
            self.totalPrice += convertedPrice
        }
        
        self.totalPriceLabel.text = String(format: "Total Price: %@ %.2f", self.selectedCurrency, self.totalPrice)
    }
    
    // MARK: - Actions

    @IBAction func closeSheet(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeCurrency(sender: UIBarButtonItem) {
        let sheetController = self.currencyPicker()
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func orderNow(sender: UIBarButtonItem) {
        self.dataStack.performInNewBackgroundContext { backgroundContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SMBasketArticle")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try backgroundContext.execute(batchDeleteRequest)
            } catch {
            }
            try! backgroundContext.save()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func currencyPicker() -> ActionSheetController {
        let pickerView = UIPickerView(frame: CGRect.zero)
        pickerView.tag = 1
        pickerView.delegate = self.pickerViewDataSourceAndDelegate
        let okAction = ActionSheetControllerAction(style: .Done, title: "Apply", dismissesActionController: true) {
            controller in
            let dataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack
            dataStack.performInNewBackgroundContext { backgroundContext in
                self.selectedCurrency = self.pickerViewDataSourceAndDelegate.pickerView!(
                    pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!
                self.exchangeRate = self.getExchangeRate()
                DispatchQueue.main.async {
                    self.reloadData()
                }
            }
        }
        let cancelAction = ActionSheetControllerAction(
            style: .Cancel,
            title: "Cancel",
            dismissesActionController: true,
            handler: nil)
        let sheetController = ActionSheetController(
            title: "Select your Currency",
            message: "",
            cancelAction: cancelAction,
            okAction: okAction)
        sheetController.disableBlurEffects = false
        sheetController.contentView = pickerView
        return sheetController
    }
    
    private func getExchangeRate() -> Float {
        // TODO: Create pro account for HTTPS access ;-)
        let urlString = "http://apilayer.net/api/live?access_key=5e5eee34674eea997c910f445b014faa&format=1&source=USD&currencies=" + self.selectedCurrency
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url, options: []) {
                let json = JSON(data: data)
                let jsonQuotes = json["quotes"]
                if let ex = jsonQuotes["USD" + self.selectedCurrency].float {
                    return ex
                }
            }
        }
        self.selectedCurrency = "USD"
        return 1.0
    }
    
    private func reloadData() {
        self.dataSource.fetch()
        self.tableView.reloadData()
        self.setupTotalPriceLabel()
    }
    
    // MARK: - Table view data source / DATASource
    
    lazy var dataSource: DATASource = {
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SMBasketArticle")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let dataSource = DATASource(tableView: self.tableView, cellIdentifier: SYShopTableViewCell.reuseIdentifier,
                                    fetchRequest: request, mainContext: self.dataStack.mainContext,
                                    configuration: { cell, item, indexPath in
                                        cell.textLabel?.text = item.value(forKey: "title") as? String
                                        cell.detailTextLabel?.text = item.value(forKey: "title") as? String
                                        var convertedPrice: Float =
                                            SYHelpers.totalItemPrice(item.value(forKey: "price") as! Float,
                                                                numberOfItems: item.value(forKey: "itemCount") as! Int,
                                                                exchangeRate: self.exchangeRate)
                                        cell.detailTextLabel?.text =
                                            String(format: "%@ %.2f for %i Items",
                                                   self.selectedCurrency,
                                                   convertedPrice,
                                                   (item.value(forKey: "itemCount") as? Int)!)
        })
        return dataSource
    }()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}

class PickerDataSourceAndDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // TODO: Put values into JSON file...
        switch row {
        case 0:
            return NSLocalizedString("USD", comment: "")
        case 1:
            return NSLocalizedString("EUR", comment: "")
        case 2:
            return NSLocalizedString("CHF", comment: "")
        case 3:
            return NSLocalizedString("GBP", comment: "")
        case 4:
            return NSLocalizedString("BOB", comment: "")
        default:
            return ""
        }
    }
}
