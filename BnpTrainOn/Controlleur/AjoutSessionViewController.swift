//
//  AjoutSessionViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 09/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class AjoutSessionViewController: UIViewController {

    @IBOutlet var formationLabel: UILabel!
    @IBOutlet var entreprisePicker: UIPickerView!
    @IBOutlet var contactSelecLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var heureDebPicker: UIDatePicker!
    @IBOutlet var heureFinPicker: UIDatePicker!
    
    @IBOutlet var btbChoixModules: UIButton!
    
    //Variables hérités lors de changement d'écran
    var moduleID = NSNumber()
    var contactID = NSNumber()
    var sessionID = NSNumber()
    
    var tabEntreprises = [ENTREPRISE]()
    var tabEntreprisesName = [String]()
    var moduleEnCour = [MODULE]()
    
    var isCreation = 1
    var origine = "module" // ou "contact" ou "calendrier"
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("isCreation = " + String(isCreation))
        prepareTableTmp()
        if isCreation == 1 {
            //btbChoixModules.hidden = true
            
            //Table ENTREPRISE
            let managedContextEnt = appliDelegate.managedObjectContext
            let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
            
            do {
                let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                
                tabEntreprises.removeAll()
                tabEntreprisesName.removeAll()
                
                for entreprise in fetchResults! {
                    tabEntreprises.append(entreprise)
                    tabEntreprisesName.append(entreprise.ent_nom!)
                }
            } catch {
                print("Erreur lors de la récupération des données de la table ENTREPRISE")
            }
            
            //if moduleID != 0 {
            if origine == "module" {
                //Table MODULE
                let managedContextMod = appliDelegate.managedObjectContext
                let fetchRequestMod = NSFetchRequest(entityName: "MODULE")
                
                do {
                    let predicate = NSPredicate(format: "mod_id = %@", moduleID)
                    fetchRequestMod.predicate = predicate
                    let fetchResults = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
                    
                    moduleEnCour.removeAll()
                    
                    for module in fetchResults! {
                        moduleEnCour.append(module)
                    }
                    //Table TMPSESSIONMODULE
                    let managedContextTmpSesMod = appliDelegate.managedObjectContext
                    
                    let entityDescriptionTmpSesMod = NSEntityDescription.entityForName("TMPSESSIONMODULE", inManagedObjectContext: managedContextTmpSesMod)
                    let tmpSessionMod = TMPSESSIONMODULE(entity: entityDescriptionTmpSesMod!, insertIntoManagedObjectContext: managedContextTmpSesMod)
                    tmpSessionMod.mod_id = moduleID
                    do {
                        try managedContextTmpSesMod.save()
                    } catch {
                        print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONMODULE")
                    }
                    
                }
                catch {
                    print("Erreur lors de la récupération des données de la table MODULE")
                }
  
            }
            //if contactID != 0 {
            if origine == "contact" {
                do {
                    //Table SESSIONCOLLABORATEUR
                    let managedContextCol = appliDelegate.managedObjectContext
                    let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")

                    let managedContextEnt = appliDelegate.managedObjectContext
                    let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
                    
                    let predicate = NSPredicate(format: "col_id = %@", contactID)
                    fetchRequestCol.predicate = predicate
                    let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                    
                    for collaborateur in fetchResults! {
                        do {
                            let predicate = NSPredicate(format: "ent_id = %@", collaborateur.ent_id!)
                            fetchRequestEnt.predicate = predicate
                            let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                            
                            tabEntreprises.removeAll()
                            tabEntreprisesName.removeAll()
                            
                            for entreprise in fetchResults! {
                                tabEntreprises.append(entreprise)
                                tabEntreprisesName.append(entreprise.ent_nom!)
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
            if origine == "calendrier" {
                Globals.viderTablesGestionSesssion()
            }

            
            //formationLabel.text = moduleEnCour[0].mod_nom
            contactSelecLabel.text = "0 contact sélectionné"
        } else {
            if origine == "calendrier" {
                Globals.viderTablesGestionSesssion()
            }
            
            //Table SESSION
            let managedContextSes = appliDelegate.managedObjectContext
            let fetchRequestSes = NSFetchRequest(entityName: "SESSION")
            
            //Table SESSIONMODULE
            let managedContextSesMod = appliDelegate.managedObjectContext
            let fetchRequestSesMod = NSFetchRequest(entityName: "SESSIONMODULE")
            
            //Table SESSIONCOLLABORATEUR
            let managedContextSesCol = appliDelegate.managedObjectContext
            let fetchRequestSesCol = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
            
            //Table TMPSESSIONCONTACT
            let managedContextTmpSesCon = appliDelegate.managedObjectContext
            let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
            
            //Table TMPSESSIONMODULE
            let managedContextTmpSesMod = appliDelegate.managedObjectContext
            let fetchRequestTmpSesMod = NSFetchRequest(entityName: "TMPSESSIONMODULE")
            
            //Table MODULE
            let managedContextMod = appliDelegate.managedObjectContext
            let fetchRequestMod = NSFetchRequest(entityName: "MODULE")
            
            //Table COLLABORATEUR
            let managedContextCol = appliDelegate.managedObjectContext
            let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
            
            //Récupération du module
            do {
                let predicate = NSPredicate(format: "ses_id = %@", sessionID)
                fetchRequestSesMod.predicate = predicate
                let fetchResults = try managedContextSesMod.executeFetchRequest(fetchRequestSesMod) as? [SESSIONMODULE]
                
                for tmpmodule in fetchResults! {
                    do {
                        /*
                        let predicate = NSPredicate(format: "mod_id = %@", tmpmodule.mod_id!)
                        fetchRequestMod.predicate = predicate
                        let fetchResults = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
                        
                        for module in fetchResults! {
                            formationLabel.text = module.mod_nom
                        }
                        */
                        let entityDescriptionTmpSesMod = NSEntityDescription.entityForName("TMPSESSIONMODULE", inManagedObjectContext: managedContextTmpSesMod)
                        let tmpSessionMod = TMPSESSIONMODULE(entity: entityDescriptionTmpSesMod!, insertIntoManagedObjectContext: managedContextTmpSesMod)
                        tmpSessionMod.mod_id = tmpmodule.mod_id!
                        do {
                            try managedContextTmpSesMod.save()
                        } catch {
                            print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONMODULE")
                        }
                        

                    }
                    catch {
                        print("Erreur lors de la récupération des données de la table MODULE")
                    }
                }
            }
            catch {
                print("Erreur lors de la récupération des données de la table MODULE")
            }
            
            //Table ENTREPRISE
            let managedContextEnt = appliDelegate.managedObjectContext
            let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
            
            //Récupération de l'entreprise
            do {
                let predicate = NSPredicate(format: "ses_id = %@", sessionID)
                fetchRequestSesCol.predicate = predicate
                let fetchResults = try managedContextSesCol.executeFetchRequest(fetchRequestSesCol) as? [SESSIONCOLLABORATEUR]
                
                for tmpcontact in fetchResults! {
                    do {
                        let predicate = NSPredicate(format: "col_id = %@", tmpcontact.col_id!)
                        fetchRequestCol.predicate = predicate
                        let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                        
                        for collaborateur in fetchResults! {
                            do {
                                let predicate = NSPredicate(format: "ent_id = %@", collaborateur.ent_id!)
                                fetchRequestEnt.predicate = predicate
                                let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                                
                                tabEntreprises.removeAll()
                                tabEntreprisesName.removeAll()
                                
                                for entreprise in fetchResults! {
                                    tabEntreprises.append(entreprise)
                                    tabEntreprisesName.append(entreprise.ent_nom!)
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
            }
            catch {
                print("Erreur lors de la récupération des données de la table MODULE")
            }
            
            //Récupération des contacts
            do {
                let predicate = NSPredicate(format: "ses_id = %@", sessionID)
                fetchRequestSesCol.predicate = predicate
                let fetchResults = try managedContextSesCol.executeFetchRequest(fetchRequestSesCol) as? [SESSIONCOLLABORATEUR]
                
                for tmpcontact in fetchResults! {
                    do {
                        /*
                        let predicate = NSPredicate(format: "col_id = %@", tmpcontact.col_id!)
                        fetchRequestCol.predicate = predicate
                        let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                        */
                        
                            let entityDescriptionTmpSesCon = NSEntityDescription.entityForName("TMPSESSIONCONTACT", inManagedObjectContext: managedContextTmpSesCon)
                            let tmpSessionCol = TMPSESSIONCONTACT(entity: entityDescriptionTmpSesCon!, insertIntoManagedObjectContext: managedContextTmpSesCon)
                            tmpSessionCol.col_id = tmpcontact.col_id!
                            do {
                                try managedContextTmpSesCon.save()
                            } catch {
                                print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONCONTACT")
                            }
                            
                    }
                    catch {
                        print("Erreur lors de la récupération des données de la table COLLABORATEUR")
                    }
                }
            }
            catch {
                print("Erreur lors de la récupération des données de la table MODULE")
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let dateFormatterHeure = NSDateFormatter()
            dateFormatterHeure.dateFormat = "HH:mm"
            
            //Récupération des dates et heures
            do {
                let predicate = NSPredicate(format: "ses_id = %@", sessionID)
                fetchRequestSes.predicate = predicate
                let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
                
                for session in fetchResults! {
                    let dateChange = dateFormatter.dateFromString(session.ses_date! )
                    print(session.ses_date! )
                    print(dateChange)
                    print(session.ses_heure_deb!)
                    print(dateFormatterHeure.dateFromString(session.ses_heure_deb!))
                    let heureDebChange = dateFormatterHeure.dateFromString(session.ses_heure_deb!)
                    let heureFinChange = dateFormatterHeure.dateFromString(session.ses_heure_fin!)
                    datePicker.date = dateChange!
                    
                    heureDebPicker.date = heureDebChange!
                    heureFinPicker.date = heureFinChange!
                }
            }
            catch {
                print("Erreur lors de la récupération des données de la table MODULE")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        var compteurContacts = 0
        var compteurModules = 0
        
        //Table TMPSESSIONCONTACT
        let managedContextTmpSesCon = appliDelegate.managedObjectContext
        let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        
        do {
            let fetchedEntities = try managedContextTmpSesCon.executeFetchRequest(fetchRequestTmpSesCon) as! [TMPSESSIONCONTACT]
            
            for _ in fetchedEntities {
                compteurContacts++
            }
            
            if compteurContacts > 1 {
                contactSelecLabel.text = String(compteurContacts) + " " + NSLocalizedString("contacts sélectionnés" , comment: "pour afficher un nombre de selection")
            } else {
                contactSelecLabel.text = String(compteurContacts) + " " + NSLocalizedString("contact sélectionné" , comment: "pour afficher un nombre de selection")
            }
        } catch {
            print("Erreur vérification dans la table temporaire de contact")
        }
        
        //Table TMPSESSIONMODULE
        let managedContextTmpSesMod = appliDelegate.managedObjectContext
        let fetchRequestTmpSesMod = NSFetchRequest(entityName: "TMPSESSIONMODULE")
        
        do {
            let fetchedEntities = try managedContextTmpSesMod.executeFetchRequest(fetchRequestTmpSesMod) as! [TMPSESSIONMODULE]
            
            for _ in fetchedEntities {
                compteurModules++
            }
            
            if compteurModules > 1 {
                formationLabel.text = String(compteurModules) +  " " + NSLocalizedString("modules sélectionnés" , comment: "pour afficher un nombre de selection")
            } else {
                formationLabel.text = String(compteurModules) + NSLocalizedString("module sélectionné" , comment: "pour afficher un nombre de selection")
            }
        } catch {
            print("Erreur vérification dans la table temporaire des modules")
        }

    }

    //Permet de gérer le Picker contenant la liste des entreprises
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tabEntreprisesName.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return tabEntreprisesName[row]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ajoutContact(sender: AnyObject) {
        self.performSegueWithIdentifier("showSelectionContacts", sender: self)
    }
    
    @IBAction func validerAjoutSession(sender: AnyObject) {
        //Liste des tables temporaires
        //Table TMPSESSIONCONTACT
        let managedContextTmpSesCon = appliDelegate.managedObjectContext
        let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        //let countTmpSesCon = managedContextTmpSesCon.countForFetchRequest(fetchRequestTmpSesCon, error: nil)
        
        //Table TMPSESSIONMODULE
        let managedContextTmpSesMod = appliDelegate.managedObjectContext
        let fetchRequestTmpSesMod = NSFetchRequest(entityName: "TMPSESSIONMODULE")
        //let countTmpSesMod = managedContextTmpSesMod.countForFetchRequest(fetchRequestTmpSesMod, error: nil)
        
        //Liste des tables où les données de la session seront stockées
        //Table SESSION
        var managedContextSes = appliDelegate.managedObjectContext
        var fetchRequestSes = NSFetchRequest(entityName: "SESSION")
        let countSes = managedContextSes.countForFetchRequest(fetchRequestSes, error: nil)
        
        //Table SESSIONCOLLABORATEUR
        var managedContextSesCol = appliDelegate.managedObjectContext
        var fetchRequestSesCol = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
        
        //Table SESSIONMODULE
        var managedContextSesMod = appliDelegate.managedObjectContext
        var fetchRequestSesMod = NSFetchRequest(entityName: "SESSIONMODULE")
        
        //Pour afficher sous format de string la date
        let dateFormatter = NSDateFormatter()
        //dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+1")
        //dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        print (strDate)
        
        //Pour afficher sous format de string les heures de début et de fin
        let dateFormatterHeureDeb = NSDateFormatter()
        //dateFormatterHeureDeb.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatterHeureDeb.dateFormat = "HH:mm"
        //dateFormatterHeureDeb.timeZone = NSTimeZone(abbreviation: "GMT+1")
        let strDateHeureDeb = dateFormatterHeureDeb.stringFromDate(heureDebPicker.date)
        
        let dateFormatterHeureFin = NSDateFormatter()
        //dateFormatterHeureFin.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatterHeureFin.dateFormat = "HH:mm"
        //dateFormatterHeureDeb.timeZone = NSTimeZone(abbreviation: "GMT+1")
        let strDateHeureFin = dateFormatterHeureFin.stringFromDate(heureFinPicker.date)
        
        var session: SESSION
        var sesID = 0
        if isCreation == 1 {
            //ID de la session
            sesID = countSes+1
            
            //Enregistrement dans la table session
            let entityDescriptionSes = NSEntityDescription.entityForName("SESSION", inManagedObjectContext: managedContextSes)
            session = SESSION(entity: entityDescriptionSes!, insertIntoManagedObjectContext: managedContextSes)
            session.ses_id = sesID
            session.ses_nom = tabEntreprises[entreprisePicker.selectedRowInComponent(0)].ent_nom! + " - " + formationLabel.text!
            session.ses_detail = ""
            session.ses_date = strDate
            session.ses_heure_deb = strDateHeureDeb
            session.ses_heure_fin = strDateHeureFin
            
            
        } else {
            do {
                sesID = Int(sessionID)
                let predicate = NSPredicate(format: "ses_id = %@", sessionID as NSNumber)
                fetchRequestSes.predicate = predicate
                
                let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
                session = fetchResults![0]
                session.ses_id = sesID
                session.ses_nom = tabEntreprises[entreprisePicker.selectedRowInComponent(0)].ent_nom! + " - " + formationLabel.text!
                session.ses_detail = ""
                session.ses_date = strDate
                session.ses_heure_deb = strDateHeureDeb
                session.ses_heure_fin = strDateHeureFin
                
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table SESSION")
            }
            
        }
        


        do {
            try managedContextSes.save()
        } catch {
            print("Impossible de sauvegarder l'ajout dans la table SESSION")
        }
        
        
        //Enregistrement dans la table session/module
        
        
        
        do {
            // suppression des anciens
            let predicate = NSPredicate(format: "ses_id == \(sesID)")
            
            let fetchRequest = NSFetchRequest(entityName: "SESSIONMODULE")
            fetchRequest.predicate = predicate
            let fetchedEntities = try managedContextSesMod.executeFetchRequest(fetchRequest) as! [SESSIONMODULE]
            for entity in fetchedEntities {
                managedContextSesMod.deleteObject(entity)
            }
            try managedContextSesMod.save()
            
            // insertion des nouveaux
            let fetchResults = try managedContextTmpSesMod.executeFetchRequest(fetchRequestTmpSesMod) as? [TMPSESSIONMODULE]
            
            for tmpsessionmodule in fetchResults! {
                let entityDescriptionSesMod = NSEntityDescription.entityForName("SESSIONMODULE", inManagedObjectContext: managedContextSesMod)
                let sessionmodule = SESSIONMODULE(entity: entityDescriptionSesMod!, insertIntoManagedObjectContext: managedContextSesMod)
                
                sessionmodule.ses_id = sesID
                sessionmodule.mod_id = tmpsessionmodule.mod_id
                do {
                    try managedContextSesMod.save()
                } catch {
                    print("Impossible de sauvegarder l'ajout dans la table SESSIONMODULE")
                }
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPSESSIONMODULE")
        }
        

        
        //Enregistrement dans la table session/contact
        do {
            // suppression des anciens
            let predicate = NSPredicate(format: "ses_id == \(sesID)")
            
            let fetchRequest = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
            fetchRequest.predicate = predicate
            let fetchedEntities = try managedContextSesCol.executeFetchRequest(fetchRequest) as! [SESSIONCOLLABORATEUR]
            for entity in fetchedEntities {
                managedContextSesCol.deleteObject(entity)
            }
            try managedContextSesCol.save()
            
            // insertion des nouveaux
            let fetchResults = try managedContextTmpSesCon.executeFetchRequest(fetchRequestTmpSesCon) as? [TMPSESSIONCONTACT]
            
            for tmpsessioncontact in fetchResults! {
                let entityDescriptionSesCol = NSEntityDescription.entityForName("SESSIONCOLLABORATEUR", inManagedObjectContext: managedContextSesCol)
                let sessioncollaborateur = SESSIONCOLLABORATEUR(entity: entityDescriptionSesCol!, insertIntoManagedObjectContext: managedContextSesCol)
                
                sessioncollaborateur.ses_id = sesID
                sessioncollaborateur.col_id = tmpsessioncontact.col_id
                do {
                    try managedContextSesCol.save()
                } catch {
                    print("Impossible de sauvegarder l'ajout dans la table SESSIONCOLLABORATEUR")
                }
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPSESSIONCONTACT")
        }
        
 
        
        //Table SESSION
        managedContextSes = appliDelegate.managedObjectContext
        fetchRequestSes = NSFetchRequest(entityName: "SESSION")
        
        //Table SESSIONCOLLABORATEUR
        managedContextSesCol = appliDelegate.managedObjectContext
        fetchRequestSesCol = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
        
        //Table SESSIONMODULE
        managedContextSesMod = appliDelegate.managedObjectContext
        fetchRequestSesMod = NSFetchRequest(entityName: "SESSIONMODULE")
        
        //Table MODULES
        let managedContextMod = appliDelegate.managedObjectContext
        var fetchRequestMod = NSFetchRequest(entityName: "MODULE")
        
        //Table COLLABORATEUR
        let managedContextCol = appliDelegate.managedObjectContext
        var fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
        
        //Table ENTREPRISE
        let managedContextEnt = appliDelegate.managedObjectContext
        var fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
        
        //Variables servant a créer le JSON de retour
        var JSONObjectCol = [String : AnyObject]()
        var jsonTestCol = [Dictionary<String, AnyObject>]()
        
        var JSONObjectColResp = [String : AnyObject]()
        var jsonTestColResp = [Dictionary<String, AnyObject>]()
        
        var JSONObjectMod = [String : AnyObject]()
        var jsonTestMod = [Dictionary<String, AnyObject>]()
        
        var JSONObjectEnt = [String : AnyObject]()
        var jsonTestEnt = [Dictionary<String, AnyObject>]()
        
        var JSONObjectSes = [String : AnyObject]()
        
        var numEntreprise = NSNumber()
        
        //On parcoure les différentes structures de l'auto-évaluation pour alimenter le JSON de retour
        
        //Partie auto-évaluation
        do {
            let predicate = NSPredicate(format: "ses_id = %@", sesID as NSNumber)
            fetchRequestSes.predicate = predicate
            let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
            
            //Partie macro-compétences
            for session in fetchResults! {
                fetchRequestSesMod = NSFetchRequest(entityName: "SESSIONMODULE")
                
                do {
                    let predicate = NSPredicate(format: "ses_id = %@", session.ses_id!)
                    fetchRequestSesMod.predicate = predicate
                    let fetchResults = try managedContextSesMod.executeFetchRequest(fetchRequestSesMod) as? [SESSIONMODULE]
                    
                    jsonTestMod.removeAll()
                    
                    for sessionmodule in fetchResults! {
                        
                        //Partie Modules
                        
                        fetchRequestMod = NSFetchRequest(entityName: "MODULE")
                        do {
                            let predicate = NSPredicate(format: "mod_id = %@", sessionmodule.mod_id!)
                            fetchRequestMod.predicate = predicate
                            let fetchResults = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
                            
                            for module in fetchResults! {
                                //Enregistrement de la question dans le JSON
                                JSONObjectMod["id"] = module.mod_id
                                JSONObjectMod["name"] = module.mod_nom
                                
                                jsonTestMod.append(JSONObjectMod)
                            }
                        } catch {
                            print("Requête échouée(Récupération données MODULES pour JSON)")
                        }
                    }
                } catch {
                    print("Requête échouée(Récupération données SESSIONMODULE  pour JSON)")
                }
                
                fetchRequestSesCol = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
                
                jsonTestCol.removeAll()
                
                do {
                    let predicate = NSPredicate(format: "ses_id = %@", session.ses_id!)
                    fetchRequestSesCol.predicate = predicate
                    let fetchResults = try managedContextSesCol.executeFetchRequest(fetchRequestSesCol) as? [SESSIONCOLLABORATEUR]
                    
                    for sessioncollaborateur in fetchResults! {
                        
                        //Partie Collaborateur
                        
                        fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
                        do {
                            let predicate = NSPredicate(format: "col_id = %@", sessioncollaborateur.col_id!)
                            fetchRequestCol.predicate = predicate
                            let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                            
                            for collaborateur in fetchResults! {
                                
                                jsonTestEnt.removeAll()
                                
                                fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
                                do {
                                    let predicate = NSPredicate(format: "ent_id = %@", collaborateur.ent_id!)
                                    fetchRequestEnt.predicate = predicate
                                    let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
                                    
                                    for entreprise in fetchResults! {
                                        //Enregistrement de la question dans le JSON
                                        JSONObjectEnt["id"] = entreprise.ent_id
                                        JSONObjectEnt["name"] = entreprise.ent_nom
                                        numEntreprise = entreprise.ent_id!
                                        
                                        jsonTestEnt.append(JSONObjectEnt)
                                    }
                                } catch {
                                    print("Requête échouée(Récupération données ENTREPRISE pour JSON)")
                                }
                                
                                //Enregistrement du collaborateur dans le JSON
                                JSONObjectCol["id"] = collaborateur.col_id
                                JSONObjectCol["name"] = collaborateur.col_nom
                                JSONObjectCol["email"] = collaborateur.col_mail
                                
                                jsonTestCol.append(JSONObjectCol)
                            }
                        } catch {
                            print("Requête échouée(Récupération données COLLABORATEUR pour JSON)")
                        }
                    }
                } catch {
                    print("Requête échouée(Récupération données SESSIONCOLLABORATEUR  pour JSON)")
                }
                
                jsonTestColResp.removeAll()
                
                fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
                do {
                    let predicate = NSPredicate(format: "ent_id = %@", numEntreprise)
                    fetchRequestCol.predicate = predicate
                    let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
                    
                    for col in fetchResults! {
                        if col.col_est_responsable == 1 {
                            JSONObjectColResp["id"] = col.col_id
                            JSONObjectColResp["name"] = col.col_nom
                            JSONObjectColResp["email"] = col.col_mail
                            
                            jsonTestColResp.append(JSONObjectColResp)
                        }
                    }
                } catch {
                    print("Requête échouée(Récupération données ENTREPRISE pour JSON)")
                }
                //Partie contact responsable
                
                
                //Enregistrement de quizz dans le JSON
                JSONObjectSes["id"] = session.ses_id
                JSONObjectSes["isCreation"] = isCreation
                JSONObjectSes["company"] = jsonTestEnt
                JSONObjectSes["date"] = session.ses_date
                JSONObjectSes["tStart"] = session.ses_heure_deb
                JSONObjectSes["tEnd"] = session.ses_heure_fin
                JSONObjectSes["modules"] = jsonTestMod
                JSONObjectSes["participants"] = jsonTestCol
                JSONObjectSes["contact"] = jsonTestColResp
            }
        } catch {
            print("Requête échouée(Récupération données SESSION)")
        }
        
        //print(JSONObjectSes)
        
        //print(NSJSONSerialization.isValidJSONObject(JSONObjectSes))
        
        if Reachability.isConnectedToNetwork() == true {
            
            //Si le JSON a envoyé est conforme, on lance la requête post avec ce dernier
            if NSJSONSerialization.isValidJSONObject(JSONObjectSes) {
                let request: NSMutableURLRequest = NSMutableURLRequest()
                let url = "http://pp2.cetelem.gr.sam.cx/DiagVendor/session/eyJsb2dpbiIgOiAiVGhpZXJyeS5FeW1hcmQiICwgICJwYXNzIiA6ICIifQ==/donnee"
                
                request.URL = NSURL(string: url)
                request.HTTPMethod = "POST"
                request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(JSONObjectSes, options:  NSJSONWritingOptions(rawValue:0))
                } catch {
                    print("Serialization du JSON échoué")
                }
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {(response, data, error) -> Void in
                    if error != nil {
                        print("Erreur lors de l'envoi du JSON")
                    } else {
                        print(response)
                        print(data)
                    }
                }
            } else {
                print("JSON de retour non conforme")
            }
        }
        
        if isCreation == 1 {
            
            isCreation = 0 // on passe (ou reste) en modification
            sessionID = sesID
            
            let alert = UIAlertView(title: NSLocalizedString("Ajout réussi" , comment: "message alerte"), message: "La session a bien été ajoutée.", delegate: nil, cancelButtonTitle: "OK")
            
            alert.show()
        } else {
            let alert = UIAlertView(title: NSLocalizedString("Modification réussie" , comment: "message alerte"), message: NSLocalizedString("La session a bien été modifiée." , comment: "message alerte"), delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
        /*do {
            let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
        
            for session in fetchResults! {
                print(session.ses_nom)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
        }*/
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSelectionContacts" {
            
            let selectionContactsTableViewController = segue.destinationViewController as! SelectionContactsTableViewController
            selectionContactsTableViewController.entID = tabEntreprises[entreprisePicker.selectedRowInComponent(0)].ent_id as! Int
        }
    }
    
    func prepareTableTmp() {
        /*
        //Table TMPSESSIONCONTACT
        let managedContextSesCol = appliDelegate.managedObjectContext
        let fetchRequestSesCol = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        
        var deleteRequestTmp = NSBatchDeleteRequest(fetchRequest: fetchRequestSesCol)
        do {
            //try psc.executeRequest(deleteRequestTmpMois, withContext: managedContextTmpMois)
            try managedContextSesCol.executeRequest(deleteRequestTmp)
            try managedContextSesCol.save()
        } catch {
            print("Erreur lors de la purge de la table TMPSESSIONCONTACT")
        }
        */
        //Table TMPSESSIONMODULE
        let managedContextSesMod = appliDelegate.managedObjectContext
        let fetchRequestSesMod = NSFetchRequest(entityName: "TMPSESSIONMODULE")
        

        
        let deleteRequestTmp = NSBatchDeleteRequest(fetchRequest: fetchRequestSesMod)
        do {
            //try psc.executeRequest(deleteRequestTmpAnnee, withContext: managedContextTmpAnnee)
            try managedContextSesMod.executeRequest(deleteRequestTmp)
            try managedContextSesMod.save()
        } catch {
            print("Erreur lors de la purge de la table TMPSESSIONMODULE")
        }
    }

}
