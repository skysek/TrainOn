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
    
    var checkbox = Checkbox(frame: CGRectMake(315, 13, 28, 20), title: "checkbox", selected: false)
    
    func changeTarget() {
        checkbox.addTarget(self, action: "saveStateCheckbox:", forControlEvents: UIControlEvents.TouchUpInside)
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
        //Table TMPSESSIONCONTACT
        let managedContextTmpSesCon = appliDelegate.managedObjectContext
        //let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        
        if checkbox.selected {
            let entityDescriptionTmpSesCon = NSEntityDescription.entityForName("TMPSESSIONCONTACT", inManagedObjectContext: managedContextTmpSesCon)
            let tmpsessioncontact = TMPSESSIONCONTACT(entity: entityDescriptionTmpSesCon!, insertIntoManagedObjectContext: managedContextTmpSesCon)
            
            tmpsessioncontact.col_id = idCollaborateur
            
            do {
                try managedContextTmpSesCon.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONCONTACT")
            }
        } else {
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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
