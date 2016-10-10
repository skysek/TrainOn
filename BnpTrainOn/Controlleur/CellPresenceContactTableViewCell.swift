//
//  CellPresenceContactTableViewCell.swift
//  BnpTrainOn
//
//  Created by Resulis MAC 1 on 21/07/2016.
//  Copyright © 2016 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class CellPresenceContactTableViewCell: UITableViewCell, UINavigationControllerDelegate {

    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var entrepriseNameLabel: UILabel!
    var idCollaborateur : NSNumber = 0
    var idSession = NSNumber()
    var preID: NSNumber = 0
    
    var checkbox = Checkbox(frame: CGRectMake(315, 13, 28, 20), title: "checkbox", selected: false)
    
    func changeTarget() {
        checkbox.addTarget(self, action: #selector(CellPresenceContactTableViewCell.saveStateCheckbox(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func changeStateCheckbox() {
        //Table SESSIONCOLLABORATEUR
        let managedContextSesCol = appliDelegate.managedObjectContext
        //let fetchRequestTmpSesCon = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
        
        let predicate = NSPredicate(format: "col_id = %@", idCollaborateur)
        let sortDescriptor = NSSortDescriptor(key: "ses_id", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        let fetchRequest = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            var fetchedEntities = try managedContextSesCol.executeFetchRequest(fetchRequest) as! [SESSIONCOLLABORATEUR]
            fetchedEntities = fetchedEntities.sort({ $0.col_id!.compare($1.col_id!) == .OrderedAscending })
            for contact in fetchedEntities {
                if contact.ses_id == idSession{
                    if contact.pre_id == 1{
                        checkbox.selected = true
                    }else{
                        checkbox.selected = false
                    }
                    print("Contact : \(contact)")
                }
            }
        } catch {
            // Do something in response to error condition
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func saveStateCheckbox(sender:UIButton){
        //Table SESSIONCOLLABORATEUR
        let managedContextSesCon = appliDelegate.managedObjectContext
        let entityDescriptionSesCon = NSEntityDescription.entityForName("SESSIONCOLLABORATEUR", inManagedObjectContext: managedContextSesCon)
        let sessioncontact = SESSIONCOLLABORATEUR(entity: entityDescriptionSesCon!, insertIntoManagedObjectContext: managedContextSesCon)
        
        sessioncontact.ses_id = idSession
        sessioncontact.col_id = idCollaborateur
        sessioncontact.prog_id = 1
        
        if checkbox.selected {
            sessioncontact.pre_id = 1
            do {
                try managedContextSesCon.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table SESSIONCOLLABORATEUR")
            }
            
        } else {
            sessioncontact.pre_id = 0
            do {
                try managedContextSesCon.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table SESSIONCOLLABORATEUR")
            }
        }
        
        print("Session = \(sessioncontact)")
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
            // Here you pass the data back to your original view controller
    }
    
}
