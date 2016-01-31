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
            
            Globals.viderTablesGestionSesssion()
        
            //Table TMPSESSIONCONTACT
            let managedContextTmpSesCon = appliDelegate.managedObjectContext
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
            ajoutSessionViewController.origine = "contact"

        }

        //
    }

}
