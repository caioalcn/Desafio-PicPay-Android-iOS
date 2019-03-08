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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        amountText.becomeFirstResponder()
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
