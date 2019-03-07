//
//  CardsViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 03/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noCardDataView: UIView!
    @IBOutlet weak var saveCardButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.backgroundView = noCardDataView
        navigationItem.title = ""

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveCard(_ sender: UIButton) {
    }
    
}

extension CardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        
        return cell
        
    }
    
}
