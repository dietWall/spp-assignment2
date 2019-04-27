//
//  CalculatorViewController.swift
//  Assignment2
//
//  Created by admin on 24.04.19.
//  Copyright © 2019 TH Rosenheim. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController{

    
    @IBOutlet var inputLabel: UITextField!
    
    @IBOutlet var flagImg: UIImageView!
    
    @IBOutlet var outPutLabel: UILabel!
    
    var rates : SingleRate? = nil
    
    var flagPicture : UIImage? = nil
    
    @IBAction func editChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if let text = sender.attributedText{
            print(text.string)
            if let amount = Double(text.string){
                print(amount)
                let vatAmount = calculateVatRate(input: amount)
                outPutLabel.text = getOutputText(amount: amount, vatAmount: vatAmount)
            }
            else{
                outPutLabel.text = getOutputText(amount: 0.00, vatAmount: 0.00)
            }
        }
        
    }
    
    private func calculateVatRate(input: Double) -> Double{
        return input * (rates?.periods[0].rates.standard ?? 0.00)/100.00;
    }
    
    private func getOutputText(amount: Double, vatAmount: Double) -> String{
        let first = String(format: "%.2f", amount)
        let second = String(format: "%.2f", vatAmount)
        let result = first + "€" + " + " +  second + "€"
        return result
    }
    
    
    //Setup self:
    override func viewDidLoad() {
        super.viewDidLoad()
        flagImg.image = flagPicture
        navigationItem.title = rates?.name
    }
    


    //Exit from View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print("prepare for return segue")
    }
    
}
