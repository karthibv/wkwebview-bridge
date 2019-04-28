//
//  Currencies.swift
//  wkwebview_js
//
//  Created by Karthik on 28/4/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

class Currencies: NativeWebBridgePlugin {

    //API for currency List
    func fetchCurrencyLists(){
        
        let request = NSMutableURLRequest(url : NSURL(string : "https://openexchangerates.org/api/currencies.json")! as URL, cachePolicy :.useProtocolCachePolicy, timeoutInterval : 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask (with : request as URLRequest , completionHandler : {data,response,error -> Void in
            if(error != nil){
                print(error!)
                self.errorCallback(errorMessage: error as! String)
            }else{
                _ = response as? HTTPURLResponse
                let theString = String(data: data!, encoding: .utf8)
                print(theString!)
                let dic = NSMutableDictionary()
                dic["response"]=theString?.urlPercentEncoded(withAllowedCharacters: .urlQueryAllowed, encoding: .utf8)
                DispatchQueue.main.async {
                    self.callback(values: dic)
                }
            }
        })
        dataTask.resume()
        
    }

}

extension String {
    
    // Url percent encoding according to RFC3986 specifications
    // https://tools.ietf.org/html/rfc3986#section-2.1
    func urlPercentEncoded(withAllowedCharacters allowedCharacters:
        CharacterSet, encoding: String.Encoding) -> String {
        var returnStr = ""
        
        // Compute each char seperatly
        for char in self {
            let charStr = String(char)
            let charScalar = charStr.unicodeScalars[charStr.unicodeScalars.startIndex]
            if allowedCharacters.contains(charScalar) == false,
                let bytesOfChar = charStr.data(using: encoding) {
                // Get the hexStr of every notAllowed-char-byte and put a % infront of it, append the result to the returnString
                for byte in bytesOfChar {
                    returnStr += "%" + String(format: "%02hhX", byte as CVarArg)
                }
            } else {
                returnStr += charStr
            }
        }
        
        return returnStr
    }
    
}
