//
//  AmountViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 07/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit

class AmountViewController: UIViewController {

    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var cardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        amountText.delegate = self
        amountText.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        amountText.becomeFirstResponder()

    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyFormatting() {
            if amountString.isEmpty {
                textField.text = "0,00"
            } else {
                textField.text = amountString
            }
        }
    }

    @IBAction func editCard(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
}



extension AmountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 7
    }
}
