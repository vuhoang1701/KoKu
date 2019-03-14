//
//  ActivityViewController.swift
//  Koku
//
//  Created by HoangVu on 3/13/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrayTransactions: [ActivityTableViewCellContent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableView.automaticDimension
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadData()
        }
       
    
        // Register to receive notification to reload
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name(rawValue: "reloadActivityList"), object: nil)
       
    }
    

    //Load data transactions of user
    func loadData()
    {
        NetworkManager.getListTransactions(success: { (arrayOfDictionary) in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM, yyyy HH:mm a"
            
            
            let sortedArray = arrayOfDictionary.sorted(by: {
                Date.dateFromISOString(string:($0["sendTime"] as! String))!.compare(Date.dateFromISOString(string:($1["sendTime"] as! String))!) == .orderedDescending
                
            })
            self.arrayTransactions.removeAll()
            for i in 0...sortedArray.count-1
            {
                let dataTransaction = sortedArray[i]
                if let fromCurrency = dataTransaction["fromCurrency"] as? String ,let fromAmount = dataTransaction["fromAmount"] as? String ,let toCurrency = dataTransaction["toCurrency"] as? String ,let toAmount = dataTransaction["toAmount"] as? String ,let exchangeRate = dataTransaction["exchangeRate"] as? String ,let fee = dataTransaction["fee"] as? String ,let totalAmount = dataTransaction["totalAmount"] as? String ,let customerName = dataTransaction["customerName"] as? String ,let customerNumber = dataTransaction["customerNumber"] as? String, let bankName = dataTransaction["bankName"] as? String, let status = dataTransaction["status"] as? String,let senderId = dataTransaction["senderId"] as? String
                {
                    let transactionItem = TransactionModel(id: dataTransaction["id"] as? Int, fromcurrency: fromCurrency, fromamount: fromAmount.floatValue, tocurrency: toCurrency, toamount: toAmount.floatValue, exchangerate: exchangeRate.floatValue, fee: fee.floatValue, totalamount: totalAmount.floatValue, customername: customerName, customernumber: customerNumber, bankname: bankName, status: status, senderid: Int(senderId)!, sendtime: dataTransaction["sendTime"] as? String, receivedtime: dataTransaction["receivedTime"] as? String)
                    let contentTransactionCell = ActivityTableViewCellContent(datamodel: transactionItem)
                    self.arrayTransactions.append(contentTransactionCell)
                  
                   
                }
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
           print(error)
        }
    }
    
    // handle notification
    @objc func reloadTableView(_ notification: NSNotification) {
        loadData()
    }

}




// PRAGMA MARK: - TableView delegate and datasource
extension ActivityViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  arrayTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: String(describing: ActivityTableViewCell.self), for: indexPath) as! ActivityTableViewCell
        cell.set(content: arrayTransactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditTransactionView", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? EditTransactionViewController
        {
        let index = tableView.indexPathForSelectedRow?.row
            let transactionModel = arrayTransactions[index!].dataModel
            destinationController.transaction = transactionModel
        }
    }
    
}
