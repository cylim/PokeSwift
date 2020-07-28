//
//  ViewController.swift
//  testProject
//
//  Created by Chee Yeong Lim on 7/28/20.
//  Copyright © 2020 Chee Yeong Lim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        submitButton.alpha = 0
        submitButton.isEnabled = false
        
        nameTextField.delegate = self
    }
    
    @IBAction func onTextChange(_ sender: Any) {
        
        if let field = (sender as! UITextField).text {
            name = field
            
            if(field.count > 0) {
                UIView.animate(withDuration: 0.5) {
                    self.submitButton.alpha = 1
                    self.submitButton.isEnabled = true
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.submitButton.alpha = 0
                    self.submitButton.isEnabled = false
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToCatViewSegue") {
            UserDefaults.standard.set(nameTextField.text!, forKey: "name")
//            let destination = segue.destination as! CatViewController
//            destination.name = nameTextField.text!
            
        }
    }
}

