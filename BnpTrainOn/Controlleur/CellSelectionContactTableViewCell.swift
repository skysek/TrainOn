//
//  CellSelectionContactTableViewCell.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 09/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class CellSelectionContactTableViewCell: UITableViewCell {
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var entrepriseNameLabel: UILabel!
    var idCollaborateur = NSNumber()
    var idSession = NSNumber()
    var idPresence = NSNumber()
    
    var tabPresences = [SESSIONCOLLABORATEUR]()
    
    
    var checkbox = Checkbox(frame: CGRectMake(315, 13, 28, 20), title: "checkbox", selected: false)
    
    func changeTarget() {
        checkbox.addTarget(self, action: #selector(CellSelectionContactTableViewCell.saveStateCheckbox(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func changeStateCheckbox() {
        //Table TMPSESSIONCONTACT
        let managedContextTmpSesCon = appliDelegate.managedObjectContext
        //let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        
        let predicate = NSPredicate(format: "col_id = %@", idCollaborateur)
        
        let fetchRequest = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try managedContextTmpSesCon.executeFetchRequest(fetchRequest) as! [TMPSESSIONCONTACT]
            for _ in fetchedEntities {
                checkbox.selected = true
                
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
        let managedContextSesCol = appliDelegate.managedObjectContext
        let entityDescriptionSesCol = NSEntityDescription.entityForName("SESSIONCOLLABORATEUR", inManagedObjectContext: managedContextSesCol)
        let contact = SESSIONCOLLABORATEUR(entity: entityDescriptionSesCol!, insertIntoManagedObjectContext: managedContextSesCol)

        //Table TMPSESSIONCONTACT
        let managedContextTmpSesCon = appliDelegate.managedObjectContext
        //let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        
        if checkbox.selected {
            
            contact.ses_id = idSession
            contact.prog_id = 1
            contact.col_id = idCollaborateur
            do {
                try managedContextSesCol.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table SESSIONCOLLABORATEUR")
            }

            
            
            let entityDescriptionTmpSesCon = NSEntityDescription.entityForName("TMPSESSIONCONTACT", inManagedObjectContext: managedContextTmpSesCon)
            let tmpsessioncontact = TMPSESSIONCONTACT(entity: entityDescriptionTmpSesCon!, insertIntoManagedObjectContext: managedContextTmpSesCon)
            
            tmpsessioncontact.col_id = idCollaborateur
            do {
                try managedContextTmpSesCon.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONCONTACT")
            }
            
            
        } else {
            let predicate2 = NSPredicate(format: "col_id = %@", idCollaborateur)
            
            let fetchRequest2 = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
            fetchRequest2.predicate = predicate2
            
            do {
                let fetchedEntities = try managedContextTmpSesCon.executeFetchRequest(fetchRequest2) as! [SESSIONCOLLABORATEUR]
                if let entityToDelete = fetchedEntities.first {
                    managedContextTmpSesCon.deleteObject(entityToDelete)
                }
            } catch {
                // Do something in response to error condition
            }
            contact.ses_id = idSession
            contact.prog_id = 0
            contact.col_id = idCollaborateur
            
            do {
                try managedContextSesCol.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table SESSIONCOLLABORATEUR")
            }
            
            let predicate = NSPredicate(format: "col_id = %@", idCollaborateur)
            
            let fetchRequest = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
            fetchRequest.predicate = predicate
            
            do {
                let fetchedEntities = try managedContextTmpSesCon.executeFetchRequest(fetchRequest) as! [TMPSESSIONCONTACT]
                if let entityToDelete = fetchedEntities.first {
                    managedContextTmpSesCon.deleteObject(entityToDelete)
                }
            } catch {
                // Do something in response to error condition
            }
            
            do {
                try managedContextTmpSesCon.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONCONTACT")
            }
        }
    
        print("prog_id = \(contact.prog_id)")
        print("contact : \(contact)")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
