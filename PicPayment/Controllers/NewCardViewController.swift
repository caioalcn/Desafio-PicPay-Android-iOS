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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.init(red: 91/255, green: 195/255, blue: 120/255, alpha: 1)
        navigationItem.title = "Save Card"
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
       setupCustomTextField()
    }
    
    func setupCustomTextField() {
        let lineColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        
        cardNumberText.setBottomLine(borderColor: lineColor)
        cardNumberText.setPlaceholder(text: "Card Number", textColor: UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))
        
        nameHolderText.setBottomLine(borderColor: lineColor)
        nameHolderText.setPlaceholder(text: "Name Holder", textColor: UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))

        expireDateText.setBottomLine(borderColor: lineColor)
        expireDateText.setPlaceholder(text: "Expire Date", textColor: UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))
        
        cvvText.setBottomLine(borderColor: lineColor)
        cvvText.setPlaceholder(text: "CVV", textColor: UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))
    
    }
    
    
    @IBAction func saveNewCard(_ sender: UIButton) {
    
        
    
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
