//
//  VatRatesViewController.swift
//  Assignment2
//
//  Created by admin on 23.04.19.
//  Copyright © 2019 TH Rosenheim. All rights reserved.
//

import UIKit

class VatRatesViewController: UITableViewController {
   
    var rates = [SingleRate](){
        didSet{
            getImages()
        }
    }
    
    var flags = [String:UIImage]()
    
    
    func getImages(){
        //Images holen
        for rate in rates{
            Networking.shared.requestFlag(country_code: rate.country_code, completion: { img in
                //Array befüllen aus der main queue
                DispatchQueue.main.async { [weak self] in
                    self?.flags[rate.country_code] = img
                    //erst wenn alle Flaggen da sind
                    if (self?.flags.count == self?.rates.count)
                    {
                        //daten Nachladen
                        self?.reload()
                    }
                }
            })
        }
    }
    
    
    func setData(data: Array<SingleRate>) -> Void
    {
        rates = data
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Networking.shared.requestVAT(completion: setData)
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Beim ersten Durchlauf werden erstmal nur die Namen gesetzt
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = rates[indexPath.row].name
        
        //Später ist dieses Array auch befüllt und die Flaggen werden auch angezeigt
        if flags[rates[indexPath.row].country_code] != nil{
            cell.imageView?.image = flags[rates[indexPath.row].country_code]
        }
        return cell
    }
    
    func reload(){
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
 

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        if segue.identifier == "TouchedSomeField"{
                if let dest = segue.destination.children[0] as? CalculatorViewController{
                    if let def=sender as? UITableViewCell{
                        let rate = rates.filter( {$0.name == def.textLabel?.text})[0]
                        dest.rates = rate
                        dest.flagPicture = flags[rate.country_code]
                    }
            }else{
                print("segue:dest \(segue.destination)")
            }
        }
        
    }
    
}
