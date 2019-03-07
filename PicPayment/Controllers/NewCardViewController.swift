//
//  NewCardViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 06/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit

class NewCardViewController: UIViewController {

    @IBOutlet weak var cardNumberText: UITextField!
    @IBOutlet weak var nameHolderText: UITextField!
    @IBOutlet weak var expireDateText: UITextField!
    @IBOutlet weak var cvvText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(named: "GreenPic")
        titleLabel.text = "Save Card"
        
    }
    
    
    override func viewDidLayoutSubviews() {
       setupCustomTextField()
    }
    
    func setupCustomTextField() {
        let lineColor = UIColor(named: "GrayPic")!
        
        cardNumberText.setBottomLine(borderColor: lineColor)
        cardNumberText.setPlaceholder(text: "Card Number", textColor: UIColor(named: "GrayPic")!)
        
        nameHolderText.setBottomLine(borderColor: lineColor)
        nameHolderText.setPlaceholder(text: "Name Holder", textColor:UIColor(named: "GrayPic")!)

        expireDateText.setBottomLine(borderColor: lineColor)
        expireDateText.setPlaceholder(text: "Expire Date", textColor: UIColor(named: "GrayPic")!)
        
        cvvText.setBottomLine(borderColor: lineColor)
        cvvText.setPlaceholder(text: "CVV", textColor:UIColor(named: "GrayPic")!)
        cvvText.delegate = self
    }
    
    
    @IBAction func saveNewCard(_ sender: UIButton) {
    
        verifyTextFieldValues()
        
    }
    
    func verifyTextFieldValues() {
        
        guard let card = cardNumberText.text, let name = nameHolderText.text, let expire = expireDateText.text, let cvv = cvvText.text else { return }
        
        if (card.isEmpty || name.isEmpty || expire.isEmpty || cvv.isEmpty) {
            
            showAlert("Error", message: "Please fill all fields.")
    
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
   
        if let date2 = formatter.date(from: expire){
            let components = Calendar.current.dateComponents([.month], from: date, to: date2)
            
            if components.month! < 0 {
                showAlert("Error", message: "Please enter a valid date.")
            }
            
        } else {
            showAlert("Error", message: "Please enter a valid date.")

        }

    }
    
}

extension NewCardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 4
    }
    
}

