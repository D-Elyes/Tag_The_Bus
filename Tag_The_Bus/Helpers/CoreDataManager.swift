//
//  CoreDataManager.swift
//  Tag_The_Bus
//
//  Created by Elyes DOUDECH on 15/04/2018.
//  Copyright © 2018 Elyes DOUDECH. All rights reserved.
//
//This class will give the contexte 

import Foundation


import CoreData
import UIKit

class CoreDataManager
{
    //context manager
    static let context : NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            exit(EXIT_FAILURE)
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    
    @discardableResult
    
    /// save all data
    ///
    /// - Returns: NSError or nil if save succeed
    class func save() -> NSError?
    {
        //try to save
        do{
            try CoreDataManager.context.save()
            return nil;
        }
        catch let error as NSError{
            return error
        }
    }
}
