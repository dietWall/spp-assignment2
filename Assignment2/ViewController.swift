//
//  ViewController.swift
//  Assignment2
//
//  Created by admin on 19.04.19.
//  Copyright © 2019 TH Rosenheim. All rights reserved.
//

import UIKit

class VATRatesTab: UIViewController {

    var rates : [SingleRate] = Array<SingleRate>()
    
    
    func setData(data: Array<SingleRate>) -> Void
    {
        print("VC: data set : ")
        print(data)
        rates = data
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Networking.shared.requestVAT(completion: setData)
    }


}

