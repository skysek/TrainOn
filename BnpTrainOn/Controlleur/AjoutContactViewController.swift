//
//  AjoutContactViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 01/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class AjoutContactViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var prenomTextField: UITextField!
    @IBOutlet var nomTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var fonctionTextField: UITextField!
    @IBOutlet var telephoneTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tabEntreprises = [String]()
    var tabCol = [String]()
    
    var isCreation = 1
    var colID = Int() // si modification
    
    let checkbox1 = Checkbox(frame: CGRectMake(12, 527, 28, 20), title: "checkbox1", selected: false)

    override func viewDidLoad() {
        self.navigationController!.navigationItem.backBarButtonItem?.title = "Back"
        
        self.view.addSubview(checkbox1)
        
        self.prenomTextField.delegate = self
        self.nomTextField.delegate = self
        self.emailTextField.delegate = self
        self.fonctionTextField.delegate = self
        self.telephoneTextField.delegate = self

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
            
            //Table COLLABORATEUR
            let managedContextCol = appliDelegate.managedObjectContext
            let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
            
            do {
                let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                
                tabCol.removeAll()
                
                for collab in fetchResults! {
                    tabCol.append(collab.col_nom!)
                }
            } catch {
                print("Erreur lors de la récupération des données de la table COLLABORATEUR")
            }
            
        } else { // modification
            do {
                //Table COLLABORATEUR
                let managedContextCol = appliDelegate.managedObjectContext
                let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")

                let predicate = NSPredicate(format: "col_id = \(colID)")
                fetchRequestCol.predicate = predicate
                let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                
                if fetchResults!.count > 0 {
                    let collab=fetchResults![0]
                    prenomTextField.text = collab.col_prenom
                    nomTextField.text = collab.col_nom
                    emailTextField.text = collab.col_mail
                    fonctionTextField.text = collab.col_fonction
                    telephoneTextField.text = collab.col_telephone
                    
                    //Table ENTREPRISE
                    let managedContextEnt = appliDelegate.managedObjectContext
                    let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
                    
                    let predicate = NSPredicate(format: "ent_id = %@", collab.ent_id!)
                    fetchRequestEnt.predicate = predicate
                    do {
                        let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                        
                        tabEntreprises.removeAll()
                        
                        for entreprise in fetchResults! {
                            tabEntreprises.append(entreprise.ent_nom!)
                        }
                    } catch {
                        print("Erreur lors de la récupération des données de la table ENTREPRISE")
                    }
                    

                }
                
                
            }
            catch {
                print("Erreur lors de la récupération des données de la table MODULE")
            }
            
            
        }

        
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Fonction permettant d'ajouter un contact
    @IBAction func validerAjoutContact(sender: AnyObject) {
        if self.prenomTextField != nil && self.nomTextField != nil && self.emailTextField != nil && self.fonctionTextField != nil && self.telephoneTextField != nil{
            let managedContextCol = appliDelegate.managedObjectContext
            if isCreation == 1 {
                //Table COLLABORATEUR
                let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
                
                do {
                    let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                    
                    tabCol.removeAll()
                    
                    for entreprise in fetchResults! {
                        tabCol.append(entreprise.col_nom!)
                    }
                } catch {
                    print("Erreur lors de la récupération des données de la table COLLABORATEUR")
                }
                
                //Table ENTREPRISE
                let managedContextEnt = appliDelegate.managedObjectContext
                let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
                
                do {
                    let predicate = NSPredicate(format: "ent_nom = %@", tabEntreprises[pickerView.selectedRowInComponent(0)])
                    fetchRequestEnt.predicate = predicate
                    let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                    
                    for entreprise in fetchResults! {
                        let entityDescriptionCol = NSEntityDescription.entityForName("COLLABORATEUR", inManagedObjectContext: managedContextCol)
                        let collaborateur = COLLABORATEUR(entity: entityDescriptionCol!, insertIntoManagedObjectContext: managedContextCol)
                        
                        collaborateur.col_id = tabCol.count+1
                        collaborateur.col_nom = nomTextField.text
                        collaborateur.col_prenom = prenomTextField.text
                        collaborateur.col_telephone = telephoneTextField.text
                        collaborateur.col_mail = emailTextField.text
                        collaborateur.col_fonction = fonctionTextField.text
                        collaborateur.ent_id = entreprise.ent_id
                        if checkbox1.selected == true {
                            collaborateur.col_est_responsable = 1
                        } else {
                            collaborateur.col_est_responsable = 0
                        }
                    }
                    
                    try managedContextCol.save()
                } catch {
                    print("Erreur lors de la récupération des données de la table MODULE")
                }
                
                let alert = UIAlertView(title: "Ajout réussi", message: "Le contact a bien été ajouté.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
               
            } else {
                //Table COLLABORATEUR
                let managedContextCol = appliDelegate.managedObjectContext
                let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
                do {
                    
                    let predicate = NSPredicate(format: "col_id = \(colID)")
                    fetchRequestCol.predicate = predicate
                    let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                
                    if fetchResults!.count > 0 {
                        let collab=fetchResults![0]
                        collab.col_prenom = prenomTextField.text
                        collab.col_nom = nomTextField.text
                        collab.col_mail = emailTextField.text
                        collab.col_fonction = fonctionTextField.text
                        collab.col_telephone = telephoneTextField.text
                        if checkbox1.selected == true {
                            collab.col_est_responsable = 1
                        } else {
                            collab.col_est_responsable = 0
                        }
                    }
                    try managedContextCol.save()
                } catch {
                    print("Erreur lors de la récupération des données de la table COLLABORATEUR")
                }

                
            }
            
            
            
        } else {
            let alert = UIAlertView(title: "Validation échouée", message: "Veuillez saisir les différents champs", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    //Permet de gérer le Picker contenant la liste des entreprises
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tabEntreprises.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return tabEntreprises[row]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
