//
//  DialogBoxHelper.swift
//  My_Pk_Et_Moi
//
//  Created by Elyes DOUDECH on 17/03/2018.
//  Copyright © 2018 Elyes DOUDECH. All rights reserved.
//
//This class will give an alert methodes for errors and messages

import Foundation
import UIKit

class DialogBoxHelper
{
    
    /// Show an alert dialog bow woth two message
    ///
    /// - Parameters:
    ///   - title: title of dialog box seen as main message
    ///   - msg: additional message used to describe context or additional information
    class func alert(view: UIViewController, withTitle title: String, andMessage msg: String = "")
    {
        let alert = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok",
                                         style: .default)
        
        alert.addAction(cancelAction)
        view.present(alert, animated: true)
    }
    
    /// show an alert to inform about an error
    ///
    /// - Parameters:
    ///   - error: error we want information about
    class func alert(view: UIViewController, error : NSError)
    {
        self.alert(view: view, withTitle: "\(error)", andMessage: "\(error.userInfo)")
    }
    
}
