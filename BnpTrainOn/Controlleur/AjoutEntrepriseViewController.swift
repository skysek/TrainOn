//
//  AjoutEntrepriseViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 11/01/2016.
//  Copyright © 2016 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData


class AjoutEntrepriseViewController: UIViewController {

    @IBOutlet var fldEntreprise: UITextField!
    @IBOutlet var fldTelephone: UITextField!
    @IBOutlet var fldAdresse: UITextView!
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tabEntreprises = [String]()
    
    
    var isCreation = 1
    var entID = Int() // si modification
    
    override func viewDidLoad() {
        
        
        if isCreation == 1 {
            //Table ENTREPRISE
            let managedContextEnt = appliDelegate.managedObjectContext
            let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
            
            do {
                let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                
                tabEntreprises.removeAll()
                
                for entreprise in fetchResults! {
                    tabEntreprises.append(entreprise.ent_nom!)
                }
            } catch {
                print("Erreur lors de la récupération des données de la table ENTREPRISE")
            }
            
        } else { // modification

        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func validerAjoutEntreprise(sender: AnyObject) {
        if self.fldEntreprise != nil && self.fldTelephone != nil {
            let managedContextCol = appliDelegate.managedObjectContext
            if isCreation == 1 {
                //Table ENTREPRISE
                let managedContextEnt = appliDelegate.managedObjectContext
                let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
                
                do {
                    let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                    
                    tabEntreprises.removeAll()
                    
                    for entreprise in fetchResults! {
                        tabEntreprises.append(entreprise.ent_nom!)
                    }
                } catch {
                    print("Erreur lors de la récupération des données de la table ENTREPRISE")
                }
                
                //Table ENTREPRISE
                do {
                    let entityDescriptionEnt = NSEntityDescription.entityForName("ENTREPRISE",  inManagedObjectContext: managedContextEnt)
                let entreprise = ENTREPRISE(entity: entityDescriptionEnt!, insertIntoManagedObjectContext: managedContextEnt)
                
                    entreprise.ent_id = tabEntreprises.count+1
                    entreprise.ent_nom = fldEntreprise.text
                    entreprise.ent_telephone = fldTelephone.text
                    entreprise.ent_adresse = fldAdresse.text
                try managedContextEnt.save()
                } catch {
                    print("Erreur lors de la récupération des données de la table ENTREPRISE")
                }
                
                let alert = UIAlertView(title: "Ajout réussi", message: "L'entreprise a bien été ajouté.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
            } else {
                //Table COLLABORATEUR
                let managedContextEnt = appliDelegate.managedObjectContext
                let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
                do {
                    
                    let predicate = NSPredicate(format: "ent_id = \(entID)")
                    fetchRequestEnt.predicate = predicate
                    let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                    
                    if fetchResults!.count > 0 {
                        let entite=fetchResults![0]
                        entite.ent_nom = fldEntreprise.text
                        entite.ent_telephone = fldTelephone.text
                        entite.ent_adresse = fldAdresse.text
                        
                        
                    }
                    try managedContextEnt.save()
                } catch {
                    print("Erreur lors de la récupération des données de la table ENTREPRISE")
                }
                
                
            }
            
            
            
        } else {
            let alert = UIAlertView(title: "Validation échouée", message: "Veuillez saisir les différents champs", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
