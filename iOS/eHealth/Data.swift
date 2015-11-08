//
//  Data.swift
//  eHealth
//
//  Created by Stefan Iarca on 11/7/15.
//  Copyright © 2015 Stefan Iarca. All rights reserved.
//

import UIKit

class Data: NSObject {

    var stringValue:String! = "";
    var numericValue:Double{
        set
        {
            self.numericValue = Double(stringValue)! //Error
        }
        get {
            if Double(stringValue) == nil {
                return 0.0
            }
            return Double(stringValue)! //Error
        }
    }
    var timeStamp:String! = "1/1/1";
}
