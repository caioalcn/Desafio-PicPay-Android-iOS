//
//  ViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 28/02/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit
import Reachability

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataReloadButton: UIButton!
    
    var contacts = [Contact]() {
        didSet {
            activityIndicator.stopAnimating()
            tableView.isScrollEnabled = true
        }
    }
    var selectedContact: Contact?
    var searchResults = [Contact]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.tintColor = UIColor(named: "GreenPic")
        navigationController?.view.backgroundColor = UIColor(named: "DarkPic")
        navigationItem.searchController = searchController
        navigationItem.title = "Contacts"
            
        searchController.searchBar.barStyle = .black
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Who you want to pay?"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
      
        tableView.backgroundView = noDataView
        tableView.isScrollEnabled = false
        
        getContacts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardsSegue"{
            
            let cardController = segue.destination as? CardsViewController
            
            cardController?.user = selectedContact
        }
    }
    
    func searchForName(for searchText: String) {
        
        searchResults = contacts.filter({ (x)  -> Bool in
            
            let match = x.name?.range(of: searchText, options: .caseInsensitive)
            return match != nil
        })
    }
    
    func setupNoDataView(text: String, isHidden: Bool) {
        noDataLabel.text = text
        noDataLabel.isHidden = isHidden
        noDataReloadButton.isHidden = isHidden
    }
    
    @IBAction func reloadData(_ sender: UIButton) {
        setupNoDataView(text: "", isHidden: true)
        getContacts()
    }

    
    func getContacts() {
        if (ReachabilityManager.shared.isConnectedToNetwork()){
            activityIndicator.startAnimating()
            APIContacts.getContacts { (result, status) in
                switch status {
                case .success(_):
                    
                    guard let c = result else { self.setupNoDataView(text: "No Data Found!", isHidden: false)
                        return }
                    
                    self.contacts = c
                    
                    self.tableView.reloadData()
                    
                case .failure(_):
                    self.activityIndicator.stopAnimating()
                    self.setupNoDataView(text: "Error Loading Data!", isHidden: false)
                    self.showAlert("Error", message: "Please check your internet connection.")
                }
            }
        } else {
            self.showAlert("Error", message: "Please check your internet connection.")
            self.setupNoDataView(text: "Error internet connection", isHidden: false)
        }
    }
    
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! ContactsCell

        let data = searchController.isActive ?
            searchResults[indexPath.row] : contacts[indexPath.row]

        cell.setupCell(contact: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedContact = contacts[indexPath.row]
        
        performSegue(withIdentifier: "cardsSegue", sender: nil)

    }
    
}

extension ContactsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty{
                searchResults = contacts
            } else {
                searchForName(for: searchText)
                tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            searchResults = contacts
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        tableView.reloadData()
    }
}
