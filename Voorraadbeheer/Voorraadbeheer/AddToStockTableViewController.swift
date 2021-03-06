//
//  AddToStockTableViewController.swift
//  Voorraadbeheer
//
//  Created by Wytze Dijkstra on 26/01/2019.
//  Copyright © 2019 Wytze Dijkstra. All rights reserved.
//

import UIKit

class AddToStockTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    //outlets and actions
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var quantityTypeTextfield: UITextField!
    @IBOutlet weak var quantityTextfield: UITextField!
    @IBAction func quantityStepper(_ sender: UIStepper) {
        quantityTextfield.text = String(Double(sender.value))
    }
    @IBOutlet weak var quantityStepperOutlet: UIStepper!
    @IBOutlet weak var notificationQuantityTextfield: UITextField!
    
    @IBAction func notificationQuantityStepper(_ sender: UIStepper) {
        notificationQuantityTextfield.text = String(Double(sender.value))
    }
    @IBOutlet weak var notificationQuantityStepperOutlet: UIStepper!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityTypeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var notificationQuantityLabel: UILabel!
    
    @IBAction func productNameTextfieldEditingDidBegin(_ sender: UITextField) {
        productNameLabel.isHidden = false
    }
    
    @IBAction func quantityTypeTextfieldEditingDidBegin(_ sender: UITextField) {
        quantityTypeLabel.isHidden = false
    }
    @IBAction func quantityTextfieldEditingDidBegin(_ sender: UITextField) {
        quantityLabel.isHidden = false
    }
    
    @IBAction func notificationQuantityTextfieldEditingDidBegin(_ sender: UITextField) {
        notificationQuantityLabel.isHidden = false
    }
    
    @IBAction func notificationQuantityTextfieldEditingDidEnd(_ sender: UITextField) {
        notificationQuantityStepperOutlet.value = Double(notificationQuantityTextfield.text!)!
    }
    
    @IBAction func quantityTextfieldEditingDidEnd(_ sender: UITextField) {
        quantityStepperOutlet.value = Double(quantityTextfield.text!)!
    }
    @IBOutlet weak var notesTextfield: UITextField!
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        // when a needed textfield isn't filled in -> give an alert
        if productNameTextfield.text?.isEmpty ?? true || quantityTextfield.text?.isEmpty ?? true || quantityTypeTextfield.text?.isEmpty ?? true || notificationQuantityTextfield.text?.isEmpty ?? true {
            let erroralert = UIAlertController(title: "There was a problem", message: "Alle velden behalve de notities moeten worden ingevuld!" , preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            erroralert.addAction(okButton)
            self.present(erroralert, animated: true, completion: nil)
            //if quantitytextfields are filled in with letters -> give alert
        } else if Double(quantityTextfield.text!) == nil || Double(notificationQuantityTextfield.text!) == nil {
            let erroralert = UIAlertController(title: "There was a problem", message: "Vul alstublieft een getal in, inclusief decimalen!" , preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            erroralert.addAction(okButton)
            self.present(erroralert, animated: true, completion: nil)
            //if the textfields are changed when it's added earlier --> change in rester
        } else if isnewproduct == false {
            let doublequantity = Double(quantityTextfield.text!)
            let doublenotificationquantity = Double(notificationQuantityTextfield.text!)
            changeProduct(id: productid!, user: loginuser!, productname: productNameTextfield.text!, selectedCategory: quantityTypeTextfield.text!, quantity: doublequantity!, notificationQuantity: doublenotificationquantity!, notes: notesTextfield.text!)
            performSegue(withIdentifier: "saveUnwind", sender: self)
            // add new product
        } else {
            let doublequantity = Double(quantityTextfield.text!)
            let doublenotificationquantity = Double(notificationQuantityTextfield.text!)
            addProduct(user: loginuser!, productname: productNameTextfield.text!, selectedCategory: quantityTypeTextfield.text!, quantity: doublequantity!, notificationQuantity: doublenotificationquantity!, notes: notesTextfield.text!)
            performSegue(withIdentifier: "saveUnwind", sender: self)
        }
        
    }
    //variables
    let quantities = ["liters", "stuks", "gram", "kilogram", "flessen"] // options for picker
    var product : products?
    var loginuser : String?
    var selectedQuantity: String?
    var productid : Int?
    var isnewproduct : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createQuantityPicker()
        hideKeyboardWhenTappedAround()
        
        if let product = product { // if an existing product is tapped, show the details
            productNameTextfield.text = product.title
            quantityTypeTextfield.text = product.quantity_type
            quantityTextfield.text = product.quantity
            notificationQuantityTextfield.text = product.notification_quantity
            productid = product.id
            quantityStepperOutlet.value = Double(quantityTextfield.text!)!
            notificationQuantityStepperOutlet.value = Double(notificationQuantityTextfield.text!)!
        } else { //if the add new product "+" button is tapped, hide labels for layout
            quantityLabel.isHidden = true
            productNameLabel.isHidden = true
            quantityTypeLabel.isHidden = true
            notificationQuantityLabel.isHidden = true
            
        }
        // set title
        if isnewproduct! {
            self.title = "Product toevoegen"
            
        } else {
            self.title = productNameTextfield.text!
        }
        
    }
    
    //set statusbar to white text
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //create Picker when quantitytype is touched
    func createQuantityPicker() {
        let quantityPicker = UIPickerView()
        quantityPicker.delegate = self
        quantityTypeTextfield.inputView = quantityPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quantities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedQuantity = quantities[row]
        quantityTypeTextfield.text = selectedQuantity
    }
    
    //add a new product
    func addProduct (user: String, productname : String, selectedCategory : String, quantity: Double, notificationQuantity: Double, notes: String) {
        let url = URL(string: "https://ide50-wytzz.legacy.cs50.io:8080/\(user)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var scarceproduct : String
        //checks if product is scarce, adds string so scopebar can be made
        if notificationQuantity >= quantity {
            scarceproduct = "Schaars"
        } else {
            scarceproduct = "Niet schaars"
        }
        let postString = "title=\(productname)&quantity_type=\(selectedCategory)&quantity=\(quantity)&notification_quantity=\(notificationQuantity)&notes=\(notes)&scarce_product=\(scarceproduct)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        }
        task.resume()
    }
    //change a product
    func changeProduct (id: Int, user: String, productname : String, selectedCategory : String, quantity: Double, notificationQuantity: Double, notes: String) {
        let url = URL(string: "https://ide50-wytzz.legacy.cs50.io:8080/\(user)/\(id)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        var scarceproduct : String
        //checks if product is scarce, adds string so scopebar can be made
        if notificationQuantity >= quantity {
            scarceproduct = "Schaars"
        } else {
            scarceproduct = "Niet schaars"
        }
        let postString = "title=\(productname)&quantity_type=\(selectedCategory)&quantity=\(quantity)&notification_quantity=\(notificationQuantity)&notes=\(notes)&scarce_product=\(scarceproduct)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        }
        task.resume()
    }
}

// when tapped around pickerkeyboard add selected pickercategory
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
