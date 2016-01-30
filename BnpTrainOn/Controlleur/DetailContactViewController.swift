//
//  DetailContactViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 30/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class DetailContactViewController: UIViewController {
    
    @IBOutlet var prenomLabel: UILabel!
    @IBOutlet var nomLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var fonctionLabel: UILabel!
    @IBOutlet var telephoneLabel: UILabel!
    @IBOutlet var entrepriseLabel: UILabel!
    
    var colID = Int()
    var tagInterne = Int()
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Table COLLABORATEUR
        let managedContextCol = appliDelegate.managedObjectContext
        let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
        
        do {
            let predicate = NSPredicate(format: "col_id = %@", colID as NSNumber)
            fetchRequestCol.predicate = predicate
            let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
            
            for module in fetchResults! {
                prenomLabel.text = module.col_prenom
                nomLabel.text = module.col_nom
                emailLabel.text = module.col_mail
                fonctionLabel.text = module.col_fonction
                telephoneLabel.text = module.col_telephone
                tagInterne = module.ent_id as! Int
                
                //Table ENTREPRISE
                let managedContextEnt = appliDelegate.managedObjectContext
                let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
                
                do {
                    let predicate = NSPredicate(format: "ent_id = %@", module.ent_id!)
                    fetchRequestEnt.predicate = predicate
                    let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                    
                    for entreprise in fetchResults! {
                        entrepriseLabel.text = entreprise.ent_nom
                    }
                } catch {
                    print("Erreur lors de la récupération des données de la table MODULE")
                }
            }
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func detailEnt(sender: AnyObject) {
        self.performSegueWithIdentifier("showDetailEntreprise", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailEntreprise" {
            let detailEntrepriseViewController = segue.destinationViewController as! DetailEntrepriseViewController
            detailEntrepriseViewController.entID = tagInterne
        }
        if segue.identifier == "showModifContact" {
            let modifContact = segue.destinationViewController as! AjoutContactViewController
            modifContact.colID = colID
            modifContact.isCreation = 0
            
        }
        if segue.identifier == "showAddSessionFromContact" {
            //Table TMPSESSIONCONTACT
            let managedContextTmpSesCon = appliDelegate.managedObjectContext
            let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
            //Table TMPSESSIONMODULE
            let managedContextTmpSesMod = appliDelegate.managedObjectContext
            let fetchRequestTmpSesMod = NSFetchRequest(entityName: "TMPSESSIONMODULE")
            //Table TMPSESSION
            let managedContextTmpSes = appliDelegate.managedObjectContext
            let fetchRequestTmpSes = NSFetchRequest(entityName: "TMPSESSION")
            
            //On purge les tables temporaires
            //let psc = self.appliDelegate.persistentStoreCoordinator
            let deleteRequestTmpSesCon = NSBatchDeleteRequest(fetchRequest: fetchRequestTmpSesCon)
            do {
                /*
                try psc.executeRequest(deleteRequestTmpSesCon, withContext: managedContextTmpSesCon)
                */
                try managedContextTmpSesCon.executeRequest(deleteRequestTmpSesCon)
                try managedContextTmpSesCon.save()
                print("Purge de la table TMPSESSIONCONTACT : réussie")
            } catch {
                print("Erreur lors de la purge de la table TMPSESSIONCONTACT")
            }
            
            let deleteRequestTmpSesMod = NSBatchDeleteRequest(fetchRequest: fetchRequestTmpSesMod)
            do {
                /*
                try psc.executeRequest(deleteRequestTmpSesMod, withContext: managedContextTmpSesMod)
                */
                try managedContextTmpSesMod.executeRequest(deleteRequestTmpSesMod)
                try managedContextTmpSesMod.save()
            } catch {
                print("Erreur lors de la purge de la table TMPSESSIONMODULE")
            }
            
            let deleteRequestTmpSes = NSBatchDeleteRequest(fetchRequest: fetchRequestTmpSes)
            do {
                /*
                try psc.executeRequest(deleteRequestTmpSes, withContext: managedContextTmpSes)
                */
                try managedContextTmpSes.executeRequest(deleteRequestTmpSes)
                try managedContextTmpSes.save()
            } catch {
                print("Erreur lors de la purge de la table TMPSESSION")
            }
            
            
                
                let entityDescriptionTmpSesCon = NSEntityDescription.entityForName("TMPSESSIONCONTACT", inManagedObjectContext: managedContextTmpSesCon)
                let tmpsessioncon = TMPSESSIONCONTACT(entity: entityDescriptionTmpSesCon!, insertIntoManagedObjectContext: managedContextTmpSesCon)
                
                tmpsessioncon.col_id = colID
            do {
                try managedContextTmpSesCon.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table SESSION")
            }
            
            let ajoutSessionViewController = segue.destinationViewController as! AjoutSessionViewController
            ajoutSessionViewController.moduleID = 0
            ajoutSessionViewController.contactID = colID
            ajoutSessionViewController.isCreation = 1
        }

        //
    }

}
