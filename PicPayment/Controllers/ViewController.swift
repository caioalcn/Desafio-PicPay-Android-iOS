//
//  ViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 28/02/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        APIContacts.getContacts { (result, status) in
            switch status {
            case .success(_):
                self.showAlert("Success", message: "\(result?[0].name)")
            case .failure(let error):
                self.showAlert("Error", message: "\(error)")
            }
        }
        
        
        APIPayments.pay(cardNumber: "1111111111111111", cvv: 789, value: 79.9, expiryDate: "01/18", destinationUserId: 1002) { (result, status) in
            switch status {
            case .success(_):
                self.showAlert("Success", message: "\(result?.destinationUser?.name)")
            case .failure(let error):
                self.showAlert("Error", message: "\(error)")
            }
        }
    }


}

