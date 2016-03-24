//
//  OpenPayRestApi.swift
//  MenuDeslizante
//
//  Created by JUAN CARLOS LOPEZ A on 23/03/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//

import Foundation
import Parse

class OpenPayRestApi{
    
    //OpenPay variables
    static let  MERCHANT_ID:String =  "mom7qomx3rv93zcwv2vk"
    static let  API_KEY:String = "pk_f492b71637e247e4b5a314a1f9366ec9"
    
    static let SUSCRIPCION_ID = "pzxtp8o88pipie9tfmps"

    static let NUMERO_DIAS = 30
    
    
    
    
    internal static  func consultarPagoReailzadoenTienda(clientId: String!, chargeId:String, callBack: (Bool, String) -> Void ){
    
        let headers = [
        "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
        "cache-control": "no-cache",
        "postman-token": "8f142621-8f8b-ba37-351f-808dd9336947"
        ]
    
        let requestString =  "https://sandbox-api.openpay.mx/v1/"+MERCHANT_ID+"/customers/"+clientId+"/charges/"+chargeId+""
        let request = NSMutableURLRequest(URL: NSURL(string:requestString)!,
        cachePolicy: .UseProtocolCachePolicy,
        timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
    
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
            callBack(false, (error?.description)!)
        } else {
        let httpResponse = response as? NSHTTPURLResponse

            do {
                let respuesta = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]

                let error = (respuesta["error_code"])
                
                var resultado = ""
                if error != nil{
                    resultado = String(error as! NSNumber)
                }
                if resultado.isEmpty{
                    resultado = respuesta["status"] as! String!
                    print(httpResponse)
                    if resultado == "completed"{
                        self.consultarSuscripcion(clientId, callBack: { (resultado) -> Void in
                            if resultado == "1005" ||  resultado == "deleted"{
                        
                                let query = PFQuery(className:"Clientes")
                                query.whereKey("clientID", equalTo: clientId)
                                query.findObjectsInBackgroundWithBlock({ (clientes: [PFObject]?, error: NSError?) -> Void in
                                    if error != nil {
                                        print(error)
                                    } else if let _ = clientes as [PFObject]? {
                                            for cliente in clientes! {
                                                cliente["Suscrito"] = true
                                            
                                                let today = NSDate()
                                                let caducidad = NSCalendar.currentCalendar().dateByAddingUnit(
                                                    .Day,
                                                    value: NUMERO_DIAS,
                                                    toDate: today,
                                                    options: NSCalendarOptions(rawValue: 0))
                                            
                                                let dateFormater : NSDateFormatter = NSDateFormatter()
                                                dateFormater.dateFormat = "yyyy-MM-dd"
                                            
                                                cliente["Caducidad"] = dateFormater.stringFromDate(caducidad!)
                                                cliente["codigobarras"] = ""
                                                cliente["referenciaentienda"] = ""
                                                
                                                cliente.saveInBackground()
                                                callBack(true, resultado)
                                            break
                                        }
                                    }
                                })
                            }
                        })
                        
                        
                    }
                    else{
                        //  in_progress
                        callBack(false, resultado)
                    }
                }else{
            
                    callBack(false, resultado)
                }
                
                // use anyObj here
            } catch {
                callBack(false, "json error: \(error)")
            }
       
        }
           
            
        })
    
        dataTask.resume()
            
        
    }
    
    internal static  func consultarSuscripcion(clientId: String!, callBack: (String) -> Void ){
    
        let headers = [
            "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
            "cache-control": "no-cache",
            "postman-token": "9381cac4-e0cc-9770-eff8-163964830867"
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox-api.openpay.mx/v1/"+MERCHANT_ID+"/customers/"+clientId+"/subscriptions/"+SUSCRIPCION_ID+"")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                callBack((error?.description)!)
            } else {

                
                do {
                    let respuesta = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                    

                    let error = (respuesta["error_code"])
                    
                    var resultado = ""
                    if error != nil{
                        resultado = String(error as! NSNumber)
                    }
                    
                    if resultado.isEmpty{
                        resultado = respuesta["status"] as! String!
                    }
                    
                    callBack(resultado)
                } catch {
                    callBack( "json error: \(error)")
                }

            }
        })
        
        dataTask.resume()
    
    }
    
}