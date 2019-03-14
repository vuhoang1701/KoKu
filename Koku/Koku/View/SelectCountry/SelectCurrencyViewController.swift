//
//  SelectCurrencyViewController.swift
//  Koku
//
//  Created by HoangVu on 3/14/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit

class SelectCurrencyViewController: UIViewController {
    
    var searchController: UISearchController!
    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var currencies:[CurrencyModel] = UserSetting.sharedInstance.listCurrenciesModel
    var filteredCurrencies:[CurrencyModel] = []
    var selectedCurrencies:[String:CurrencyModel] = [:]
    var fromCurrencyId: String?
    var toCurrencyId: String?
    var isSelectFromCurrency = false
    var returnSelectedCurrencyModel: ((CurrencyModel) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.dataSource = self
        tableView.delegate = self
        currencies.sort(by: {$0.id < $1.id})
        if(isSelectFromCurrency)
        {
            //Remove selected ToCurrency from list
            let selectedToCurency = currencies.filter{
                currency in
                return (currency.id == toCurrencyId)
                }.first
            let indexToRemove = currencies.firstIndex(of: selectedToCurency!)
            currencies.remove(at: indexToRemove!)
            
            //Set current selected FromCurrency (To display checkmark)
            let selectedCurency = currencies.filter{
                currency in
                return (currency.id == fromCurrencyId)
            }.first
            selectedCurrencies = [selectedCurency!.id: selectedCurency] as! [String : CurrencyModel]
            
            
            
        }
        else
        {
            //Remove selected FromCurrency from list
            let selectedFromCurency = currencies.filter{
                currency in
                return (currency.id == fromCurrencyId)
                }.first
            let indexToRemove = currencies.firstIndex(of: selectedFromCurency!)
            currencies.remove(at: indexToRemove!)
            
             //Set current selected ToCurrency (To display checkmark)
            let selectedCurency = currencies.filter{
                currency in
                return (currency.id == toCurrencyId)
                }.first
            selectedCurrencies = [selectedCurency!.id: selectedCurency] as! [String : CurrencyModel]
            
           
        }
       
    }
    
    
    func addSearchBar()
    {
        //Set up Seach Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        searchController.searchBar.setShowsCancelButton(false, animated: false)
        searchController.searchBar.tintColor = UIColor.white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        //Set place holder
        for subview in searchController.searchBar.subviews
        {
            for textInput in subview.subviews
            {
                if textInput is UITextField
                {
                    let textInput = textInput as! UITextField
                    textInput.placeholder = "Search"
                    
                }
            }
            
        }
        
    }

    func hideRightButtons()
    {
        navigationItem.rightBarButtonItem = nil;
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
  

}

extension SelectCurrencyViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate
{
    
    // PRAGMA MARK: - UISearchBarDelegate
    func filterContentForSearchText(_ searchText: String) {
        self.filteredCurrencies = currencies.filter{ currency in
            let stringMatch = currency.currencyName.lowercased().range(of: searchText.lowercased())
            let stringMatch2 = currency.id.lowercased().range(of: searchText.lowercased())
            return (stringMatch != nil || stringMatch2 != nil)
        }
        self.tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
    }
    

    
    
    //PRAGMA MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //PRAGMA MARK: - search event Method
    func searchCurrency(_ sender:UIButton){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = self.searchController.searchBar
            self.searchController.searchBar.alpha = 1
            self.searchController.searchBar.becomeFirstResponder()
            self.searchController.searchBar.text = ""
        })
    }
    


}


//PRAGMA MARK: - TableView Methods
extension SelectCurrencyViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredCurrencies.count
        }
        return self.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        
        let currency:CurrencyModel
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = self.filteredCurrencies[(indexPath as NSIndexPath).row]
        } else {
            currency = self.currencies[(indexPath as NSIndexPath).row]
        }
        cell.accessoryType = .none
        if selectedCurrencies.count > 0 {
            let selected = selectedCurrencies[currency.id]
            if selected != nil {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.tintColor = UIColor.colorWithHexString(hexString: "59E3FF")
        cell.set(currency: currency)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency: CurrencyModel
        
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = self.filteredCurrencies[(indexPath as NSIndexPath).row]
            selectCurrency(tableView, indexPath, currency)
            dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            currency = self.currencies[(indexPath as NSIndexPath).row]
            selectCurrency(tableView, indexPath, currency)
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
        returnSelectedCurrencyModel!(currency)
        
    }
    
    func selectCurrency(_ tableView: UITableView, _ indexPath: IndexPath, _ currency: CurrencyModel){
        
        for lastId in selectedCurrencies.keys {
            selectedCurrencies[lastId] = nil
            tableView.reloadData()
        }
        
        
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                selectedCurrencies[currency.id] = currency
            } else {
                cell.accessoryType = .none
                selectedCurrencies.removeValue(forKey: currency.id)
            }
        }
    }
    
}



