//
//  Network.swift
//  Assignment2
//
//  Created by admin on 19.04.19.
//  Copyright © 2019 TH Rosenheim. All rights reserved.
//

import Foundation
import UIKit


struct rates : Codable{
    let standard : Double
}


struct periods : Codable{
    let rates : rates
}

struct SingleRate : Codable{
    let name : String
    let country_code : String
    let periods :  [periods]

}

struct Rates : Codable{
    let rates   : [SingleRate]
}



class Networking {
 
    typealias rateCompletionHandler = (Array<SingleRate>) -> Void
    typealias flagCompletionHandler = (UIImage)->Void

    static let shared = Networking()            //Singleton Class
    
    private init(){}                            //nichts zu tun, nur private 
    
    //Dekodiert Data und gibt ein Array von SingleRates zurück
    //Falls Daten nicht dekodierbar => Leeres Array von Singlerates
    private func decode(data: Data) -> Array<SingleRate> {
        print("Dekodiere:")
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Rates.self, from: data)
            return response.rates
        } catch let e as DecodingError {
            print("DecodingError: \(e)")
        } catch {
            print("Other error: \(error)")
        }
        return Array<SingleRate>()
    }
    
    
    
    func requestFlag(country_code: String, completion: @escaping flagCompletionHandler){
        let prefix = "https://www.countryflags.io/"
        let suffix = "/flat/64.png"
        
        if let url = URL(string: prefix + country_code + suffix){
            
        print("Fetching Flag Image from : " + (url.absoluteString))

        let flagSession = URLSession(configuration: .default)

        flagSession.dataTask(with: url, completionHandler: { data, response, error in

            if let response = response as? HTTPURLResponse,
                response.statusCode == 200{
                if(data != nil){
                    //data wurde geprüft => data!
                    if let img = UIImage(data: data!){
                       completion(img)
                    }
                }
            }
        }).resume()
       }
    }
    
    //Für ein Array von Country Codes gibt die Funktion die zugehörigen Flaggen zurück
    func requestFlags(country_codes: [String], completion : ([String:UIImage])->Void){
        var result = [String:UIImage]()
        
        for x in country_codes{
            requestFlag(country_code: x, completion: { (img) in
                result[x] = img
                })
        }
    }
    


    func requestVAT(completion: @escaping rateCompletionHandler){
        
        let url = URL(string: "https://jsonvat.com/")
        
        let defaultsession = URLSession(configuration: .default)

        defaultsession.dataTask(with: url!, completionHandler: { data, response, error in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 200{
                if(data != nil){
                    completion(self.decode(data: data!))
                }
                else{
                    print("data: nil")
                }
            }
        }).resume()
        
    }
}
