//
//  AlertView.swift
//  picpayment
//
//  Created by Caio Alcântara on 28/02/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertTwoOptions(_ title: String, message: String, buttonConfirm: String, buttonCancel: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: buttonConfirm, style: .default) {
            UIAlertAction in
        }
        let cancelAction = UIAlertAction(title: buttonCancel, style: .cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
