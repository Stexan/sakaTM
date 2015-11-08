//
//  GoogleAPIHandler.swift
//  Food&Fuel Finder
//
//  Created by DMTC on 9/14/15.
//  Copyright © 2015 DMTC. All rights reserved.
//


//Login si register POST
//http://bogdanstanga.com/hacktm/v1/register
//http://bogdanstanga.com/hacktm/v1/login
//http://bogdanstanga.com/hacktm/v1/indices
//http://bogdanstanga.com/hacktm/v1/indice/%/values
//http://bogdanstanga.com/hacktm/v1/indice/1/add

import UIKit
import CoreLocation

protocol APIDelegate : NSObjectProtocol{
    func handlerDidGetResults(results:Array<AnyObject>?);
    func handlerDidFailWithError(error:NSError?,description:String?);
}

class GoogleAPIHandler: NSObject {
    let APIKey:String = "AIzaSyCBFhw1uo-RM5_aMEkrPYmWuXXVIGwL9Yw";
    
    var delegate: APIDelegate?;
    

    private func executeLocationQuery(withURL queryURL:NSURL,bodyString:String?,respSelector:Selector){
        let request:NSMutableURLRequest = NSMutableURLRequest.init(URL: queryURL);
        let session = NSURLSession.sharedSession();

        if bodyString != nil{
            request.HTTPMethod = "POST";
            let body:NSData! = bodyString!.dataUsingEncoding(NSUTF8StringEncoding);
            request.HTTPBody = body;
            if bodyString?.containsString("value=") == true {
                request.setValue((NSUserDefaults.standardUserDefaults().objectForKey("key") as! String), forHTTPHeaderField: "Api");
            }
        }else{
            request.HTTPMethod = "GET";
            request.setValue((NSUserDefaults.standardUserDefaults().objectForKey("key") as! String), forHTTPHeaderField: "Api");
        }
        print(request);
        print(request.HTTPMethod);
        print(request.HTTPBody);
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: {(data, response, error) -> Void in
                
                if error != nil{
                    print("\(error)");
                    self.delegate?.handlerDidFailWithError(error!,description: nil);
                }
                
                //assert(data != nil, "RESPONSE DATA IS NIL");
                if data != nil{
                    
                    do{
                        if let responseDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                            
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSelector(respSelector, withObject: responseDict);
                                print(responseDict);
                            });
                            
                            
                        }else{
                            let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    } catch let parseError{
                        print(parseError);
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }
                
                print("Response: \(response)")
            }
        )
        
        task.resume()
    }
    
    internal func register(username:String,password:String,email:String){
        executeLocationQuery(withURL: NSURL.init(string: "http://bogdanstanga.com/hacktm/v1/register")!, bodyString: "name=" + username + "&password=" + password + "&email=" + email, respSelector: Selector("parseRegisterResponse:"));
    }
    
    internal func login(email:String,password:String){
        executeLocationQuery(withURL: NSURL.init(string: "http://bogdanstanga.com/hacktm/v1/login")!, bodyString: "password=" + password + "&email=" + email, respSelector: Selector("parseLoginResponse:"));
    }
    
    internal func getIndices(){
        executeLocationQuery(withURL: NSURL.init(string: "http://bogdanstanga.com/hacktm/v1/indices")!, bodyString: nil, respSelector: Selector("parseCategoryResponse:"));
    }
    
    
    
    internal func getAllDataForCategory(categoryID:String){
        executeLocationQuery(withURL: NSURL.init(string: "http://bogdanstanga.com/hacktm/v1/indice/" + categoryID + "/values")!, bodyString: nil, respSelector: Selector("parseAllIndicesResponse:"));
    }
    
    internal func postDataForCategory(categoryID:String,value:String){
        executeLocationQuery(withURL: NSURL.init(string: "http://bogdanstanga.com/hacktm/v1/indice/" + categoryID + "/add")!, bodyString: "value=" + value, respSelector: Selector("parseAllIndicesResponse:"));
    }
    
    
    func parseLoginResponse(jsonResponse:NSDictionary){
        let errorKey:Bool = jsonResponse.objectForKey("error") as! Bool;
        if errorKey == true {
            delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let user = jsonResponse.objectForKey("user") as! NSDictionary;
            let key = user.objectForKey("api_key")
            NSUserDefaults.standardUserDefaults().setObject(key, forKey: "key");
            delegate?.handlerDidGetResults(nil);
        }
        
    }
    
    func parseRegisterResponse(jsonResponse:NSDictionary){
        let errorKey:Bool = jsonResponse.objectForKey("error") as! Bool;
        if errorKey == true {
            delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let user = jsonResponse.objectForKey("user") as! NSDictionary;
            let key = user.objectForKey("api_key")
             NSUserDefaults.standardUserDefaults().setObject(key, forKey: "key");
            delegate?.handlerDidGetResults(nil);
        }
       
    }
    
    func parseAllIndicesResponse(jsonResponse:NSDictionary){
        print(jsonResponse);
        let errorKey:Bool = jsonResponse.objectForKey("error") as! Bool;
        if errorKey == true {
            delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let valuesArray = jsonResponse.objectForKey("values") as! Array<NSDictionary>;
            var dataArray = Array<Data>();
            for dict in valuesArray{
                let entry = Data();
                entry.stringValue = dict.objectForKey("value") as! String;
                entry.timeStamp = dict.objectForKey("timestamp") as! String;
                dataArray.append(entry);
            }
            print(dataArray);
            delegate?.handlerDidGetResults(dataArray);
        }
    }
    
    func parseCategoryResponse(jsonResponse:NSDictionary){
        
        let indicesArray = jsonResponse.objectForKey("indices") as! Array<NSDictionary>;
        
        var categoryArray = Array<Category>();
        
        for dict in indicesArray {
            let categ = Category();
            
            let maxStr = dict.objectForKey("max_value") as! String;
            let minStr = dict.objectForKey("min_value") as! String
            
            var components = maxStr.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            var part = components.joinWithSeparator("");
            let maxVal = Int(part)
            
            components = minStr.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            part = components.joinWithSeparator("");
            let minVal = Int(part)
            
            categ.minValue = minVal
            categ.maxValue = maxVal
            categ.name = dict.objectForKey("name") as? String
            categ.measurement = minStr.stringByReplacingOccurrencesOfString(part, withString: "", options:NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start: minStr.startIndex, end: minStr.endIndex))
            categ.id = dict.objectForKey("id") as? Int
            categoryArray.append(categ);
        }
        
        delegate?.handlerDidGetResults(categoryArray)
    }
}
