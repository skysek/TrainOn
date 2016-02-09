//
//  DetailEntrepriseViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 04/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class DetailEntrepriseViewController: UIViewController {

    @IBOutlet var entrepriseLabel: UILabel!
    @IBOutlet var prenomLabel: UILabel!
    @IBOutlet var nomLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var telephoneEntLabel: UILabel!
    @IBOutlet var adresseEntLabel: UILabel!
    
    var entID = Int()
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        
        //Table ENTREPRISE
        let managedContextEnt = appliDelegate.managedObjectContext
        let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
        
        do {
            let predicate = NSPredicate(format: "ent_id = %@", entID as NSNumber)
            fetchRequestEnt.predicate = predicate
            //print(predicate)
            let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
            //print(fetchResults)
            for entreprise in fetchResults! {
                entrepriseLabel.text = entreprise.ent_nom
                telephoneEntLabel.text = entreprise.ent_telephone
                adresseEntLabel.text = entreprise.ent_adresse
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }
        
        //Table COLLABORATEUR
        let managedContextCol = appliDelegate.managedObjectContext
        let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
        
        do {
            let predicate = NSPredicate(format: "ent_id = %@", entID as NSNumber)
            fetchRequestCol.predicate = predicate
            let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
            
            for collaborateur in fetchResults! {
                if collaborateur.col_est_responsable == 1 {
                    prenomLabel.text = collaborateur.col_prenom
                    nomLabel.text = collaborateur.col_nom
                    emailLabel.text = collaborateur.col_mail
                } else {
                    prenomLabel.text = nil
                    nomLabel.text = nil
                    emailLabel.text = nil
                }
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }
        
        super.viewDidLoad()
    }
    
}
