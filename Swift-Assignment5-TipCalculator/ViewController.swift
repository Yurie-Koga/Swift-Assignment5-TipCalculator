//
//  ViewController.swift
//  Swift-Assignment5-TipCalculator
//
//  Created by Uji Saori on 2021-01-07.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var autoCalculation: UISwitch!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tipAmount: UILabel!
    @IBOutlet var billAmount: UITextField!
    @IBOutlet var tipPercentageSlider: UISlider!
    @IBOutlet var calculateBtn: UIButton!
    @IBOutlet var tipPercentage: UITextField!
    
    let defaultBillAmt = "Bill Amount"
    let defaultTextFieldUIColor = UIColor.darkGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        registerForKeyboardNotification()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(gestureRecognizer)

    }
    
    func initUI() {
        billAmount.text = defaultBillAmt
        billAmount.textColor = defaultTextFieldUIColor
        tipPercentageSlider.value = 50
        tipPercentage.textColor = defaultTextFieldUIColor
        updatePercentage()
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    fileprivate func registerForKeyboardNotification() {
        // 1. I want to listen to the keyboard showing / hiding
        //    - "hey iOS, tell(notify) me when keyboard shows / hides"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        // 2. When notified, I want to ask iOS the size(height) of the keyboard
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }

        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.size.height

        // 3. Tell scrollview to scroll up (height)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }

    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        // 2. When notified, I want to ask iOS the size(height) of the keyboard
        // 3. Tell scrollview to scroll down (height)
        let insets = UIEdgeInsets.zero
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }

    @IBAction func clickedCalculate(_ sender: Any) {
        if isValidInput() {
            calculateTip()
        }
    }
    
    func isValidInput() -> Bool {
        guard let billAmount = billAmount?.text else {
            return false
        }
        guard billAmount.lowercased() != defaultBillAmt.lowercased() else {
            // no input
            return false
        }
        guard (Double(billAmount) != nil) else {
            // invalid input
            return false
        }
        
        return true
    }
    
    func calculateTip() {
        if let billAmount = billAmount.text {
            if billAmount.lowercased() != defaultBillAmt.lowercased() {
                let tipAmountD: Double = Double(billAmount)! * Double(Int(tipPercentageSlider.value)) / 100
                tipAmount.text = "$" + String(format: "%.2f", tipAmountD)
            }
        }
    }
    
    @IBAction func changedSlider(_ sender: Any) {
        updatePercentage()
        checkAutoCalculation()
    }
    
    func updatePercentage() {
        tipPercentage.text = String(Int(tipPercentageSlider.value)) + "%"
    }
    @IBAction func inputBillAmtDidBegin(_ sender: Any) {
        if let billAmtText = billAmount.text {
            if billAmtText == defaultBillAmt {
                billAmount.text = ""
                billAmount.textColor = .black
            } else {
//                billAmount.text = ""
                billAmount.textColor = .black
            }
        }
    }
    @IBAction func inputBillAmtDidEnd(_ sender: Any) {
        if let billAmtText = billAmount.text {
            if billAmtText.isEmpty {
                billAmount.text = defaultBillAmt
                billAmount.textColor = defaultTextFieldUIColor
            } else {
                checkAutoCalculation()
            }
        }
    }
    @IBAction func inputTipPercentageDidBegin(_ sender: Any) {
        tipPercentage.text = String(Int(tipPercentageSlider.value))
        tipPercentage.textColor = .black
    }
    @IBAction func inputTipPercentageDidEnd(_ sender: Any) {
        if let tipPercent = tipPercentage.text {
            if Int(tipPercent) ?? 0 > 100 {
                tipPercentage.text = "100"
            }
        }
        
        tipPercentageSlider.value = Float(tipPercentage.text!)!
        tipPercentage.text = tipPercentage.text! + "%"
        checkAutoCalculation()
    }
    
    func checkAutoCalculation() {
        if autoCalculation.isOn {
            calculateTip()
        }
    }
}
