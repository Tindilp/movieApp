//
//  ViewController.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func verUsr(_ sender: Any) {
        
        if let value = AppDelegate.getUserDefaultArrayStringForKey("moviesStored"){
        //if let value = UserDefaults.data(forKey: "Llave"){
            
           // print(value)
        } else{
            print("error")
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        
    }
    
}

