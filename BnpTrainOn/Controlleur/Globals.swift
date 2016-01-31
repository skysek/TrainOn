//
//  Globals.swift
//  BnpTrainOn
//
//  Created by Resulis MAC 1 on 31/01/2016.
//  Copyright © 2016 Resulis MAC 1. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Globals {
    
    class func viderTablesGestionSesssion  () {
        
        viderTable("TMPSESSIONCONTACT")
        viderTable("TMPSESSIONMODULE")
        viderTable("TMPSESSION")
    
    }
    
    class func viderTable(nomTable: String) -> Bool {
        
        var res = false
        
        
        let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        let managedContext = appliDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: nomTable)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            /*
            try psc.executeRequest(deleteRequestTmpSesCon, withContext: managedContextTmpSesCon)
            */
            try managedContext.executeRequest(deleteRequest)
            try managedContext.save()
            print("Purge de la table  \(nomTable) : réussie")
            res = true
        } catch {
            print("Erreur lors de la purge de la table \(nomTable)")
        }
        
        
        return res
    }
    
    
}