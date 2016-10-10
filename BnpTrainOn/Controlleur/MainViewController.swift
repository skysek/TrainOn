//
//  ViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 23/10/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class MainViewController: UIViewController {
    
    //Variables faisant le lien avec le CoreData
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet var gestionClients: UIButton!
    @IBOutlet var calendrier: UIButton!
    @IBOutlet var moduleFormation: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    //ID de la personne connecté
    var loginPersonneConnectée = String()
    var passwordPersonneConnectée = String()
    
    override func viewDidLoad() {
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0/250, green: 150/250, blue: 94/250, alpha: 1.00)
        self.scrollView.contentSize = CGSizeMake(320,530)
        
        //On récupère en local les variables
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        loginPersonneConnectée = prefs.stringForKey("USERNAME")!
        passwordPersonneConnectée = prefs.stringForKey("PASSWORD")!
        
        gestionClients.titleLabel?.textAlignment = NSTextAlignment.Center
        calendrier.titleLabel?.textAlignment = NSTextAlignment.Center
        moduleFormation.titleLabel?.textAlignment = NSTextAlignment.Center
        
        //Insertion de données de test dans la table
        //Table ENTREPRISE
        let managedContextEnt = appliDelegate.managedObjectContext
        let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
        let countEnt = try! managedContextEnt.countForFetchRequest(fetchRequestEnt)
        
        //Table COLLABORATEUR
        let managedContextCol = appliDelegate.managedObjectContext
        let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
        let countCol = try! managedContextCol.countForFetchRequest(fetchRequestCol)
        
        //Table MODULE
        let managedContextMod = appliDelegate.managedObjectContext
        let fetchRequestMod = NSFetchRequest(entityName: "MODULE")
        let countMod = try! managedContextMod.countForFetchRequest(fetchRequestMod)
        
        //Table CATEGORIE
        let managedContextCat = appliDelegate.managedObjectContext
        let fetchRequestCat = NSFetchRequest(entityName: "CATEGORIE")
        let countCat = try! managedContextCat.countForFetchRequest(fetchRequestCat)
        
        //Table SESSION
        let managedContextSes = appliDelegate.managedObjectContext
        let fetchRequestSes = NSFetchRequest(entityName: "SESSION")
        let countSes = try! managedContextSes.countForFetchRequest(fetchRequestSes)
        
        //Table SESSIONCOLLABORATEUR
        let managedContextSesCol = appliDelegate.managedObjectContext
        let fetchRequestSesCol = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
        let countSesCol = try! managedContextSesCol.countForFetchRequest(fetchRequestSesCol)
        
        //Table SESSIONMODULE
        let managedContextSesMod = appliDelegate.managedObjectContext
        let fetchRequestSesMod = NSFetchRequest(entityName: "SESSIONMODULE")
        let countSesMod = try! managedContextSesMod.countForFetchRequest(fetchRequestSesMod)
        
        if countEnt == 0 {
            for i in 0 ..< 3 {
                
                let entityDescriptionEnt = NSEntityDescription.entityForName("ENTREPRISE", inManagedObjectContext: managedContextEnt)
                let entreprise = ENTREPRISE(entity: entityDescriptionEnt!, insertIntoManagedObjectContext: managedContextEnt)
                
                switch i {
                case 0 :
                    entreprise.ent_id = 1
                    entreprise.ent_nom = "Xerox"
                    entreprise.ent_adresse = "200 rue imaginaire"
                    entreprise.ent_telephone = "0505050404"
                case 1 :
                    entreprise.ent_id = 2
                    entreprise.ent_nom = "Canon"
                    entreprise.ent_adresse = "230 rue de Paris"
                    entreprise.ent_telephone = "0506070605"
                case 2 :
                    entreprise.ent_id = 3
                    entreprise.ent_nom = "JCB"
                    entreprise.ent_adresse = "120 avenue libératrice"
                    entreprise.ent_telephone = "0906070605"
                case 3 :
                    entreprise.ent_id = 4
                    entreprise.ent_nom = "Manitou"
                    entreprise.ent_adresse = "120 avenue Libération"
                    entreprise.ent_telephone = "0906070605"
                default :
                    print("Défault")
                }
            }
        }
        
        if countCol == 0 {
            for i in 0 ..< 3 {
                
                let entityDescriptionCol = NSEntityDescription.entityForName("COLLABORATEUR", inManagedObjectContext: managedContextCol)
                let collaborateur = COLLABORATEUR(entity: entityDescriptionCol!, insertIntoManagedObjectContext: managedContextCol)
                
                switch i {
                case 0 :
                    collaborateur.col_id = 1
                    collaborateur.col_nom = "Dupont"
                    collaborateur.col_prenom = "Martin"
                    collaborateur.col_telephone = "0606060606"
                    collaborateur.col_mail = "dupont.martine@email.com"
                    collaborateur.col_fonction = "Cadre Responsable"
                    collaborateur.ent_id = 1
                    collaborateur.col_est_responsable = 1
                case 1 :
                    collaborateur.col_id = 2
                    collaborateur.col_nom = "Killian"
                    collaborateur.col_prenom = "Perpere"
                    collaborateur.col_telephone = "0707070707"
                    collaborateur.col_mail = "perpere.killian@adressemail.com"
                    collaborateur.col_fonction = "Cadre"
                    collaborateur.ent_id = 3
                    collaborateur.col_est_responsable = 0
                case 2 :
                    collaborateur.col_id = 3
                    collaborateur.col_nom = "Gerard"
                    collaborateur.col_prenom = "Martin"
                    collaborateur.col_telephone = "0808080808"
                    collaborateur.col_mail = "gerard.martin@mail.com"
                    collaborateur.col_fonction = "Cadre Responsable"
                    collaborateur.ent_id = 2
                    collaborateur.col_est_responsable = 1
                default :
                    print("Défault")
                }
            }
        }
        
        if countSes == 0 {
            for i in 0 ..< 5 {
                
                let entityDescriptionSes = NSEntityDescription.entityForName("SESSION", inManagedObjectContext: managedContextSes)
                let session = SESSION(entity: entityDescriptionSes!, insertIntoManagedObjectContext: managedContextSes)
                
                switch i {
                case 0 :
                    session.ses_id = 1
                    session.ses_nom = "Canon - Vendre Top Full"
                    session.ses_detail = "detailSession"
                    session.ses_date = "13/12/2015"
                    session.ses_heure_deb = "11:00"
                    session.ses_heure_fin = "11:30"
                case 1 :
                    session.ses_id = 2
                    session.ses_nom = "Canon - Crédit-Bail ELS"
                    session.ses_detail = "detailSession"
                    session.ses_date = "02/12/2015"
                    session.ses_heure_deb = "11:00"
                    session.ses_heure_fin = "11:30"
                case 2 :
                    session.ses_id = 3
                    session.ses_nom = "Canon - Crédit-Bail ELS"
                    session.ses_detail = "detailSession"
                    session.ses_date = "02/12/2015"
                    session.ses_heure_deb = "11:00"
                    session.ses_heure_fin = "11:30"
                case 3 :
                    session.ses_id = 4
                    session.ses_nom = "Canon - Crédit-Bail ELS"
                    session.ses_detail = "detailSession"
                    session.ses_date = "02/12/2015"
                    session.ses_heure_deb = "11:00"
                    session.ses_heure_fin = "11:30"
                case 4 :
                    session.ses_id = 5
                    session.ses_nom = "Canon - Crédit-Bail ELS"
                    session.ses_detail = "detailSession"
                    session.ses_date = "02/12/2015"
                    session.ses_heure_deb = "11:00"
                    session.ses_heure_fin = "11:30"
                default :
                    print("Défault")
                }
            }
        }
        
        if countSesCol == 0 {
            for i in 0 ..< 5 {
                
                let entityDescriptionSesCol = NSEntityDescription.entityForName("SESSIONCOLLABORATEUR", inManagedObjectContext: managedContextSesCol)
                let sessionCol = SESSIONCOLLABORATEUR(entity: entityDescriptionSesCol!, insertIntoManagedObjectContext: managedContextSesCol)
                
                switch i {
                case 0 :
                    sessionCol.ses_id = 1
                    sessionCol.col_id = 3
                case 1 :
                    sessionCol.ses_id = 2
                    sessionCol.col_id = 3
                case 2 :
                    sessionCol.ses_id = 3
                    sessionCol.col_id = 3
                case 3 :
                    sessionCol.ses_id = 4
                    sessionCol.col_id = 3
                case 4 :
                    sessionCol.ses_id = 5
                    sessionCol.col_id = 3
                default :
                    print("Défault")
                }
            }
        }
        
        if countSesMod == 0 {
            for i in 0 ..< 5 {
                
                let entityDescriptionSesMod = NSEntityDescription.entityForName("SESSIONMODULE", inManagedObjectContext: managedContextSesMod)
                let sessionMod = SESSIONMODULE(entity: entityDescriptionSesMod!, insertIntoManagedObjectContext: managedContextSesMod)
                
                switch i {
                case 0 :
                    sessionMod.ses_id = 1
                    sessionMod.mod_id = 1
                case 1 :
                    sessionMod.ses_id = 2
                    sessionMod.mod_id = 1
                case 2 :
                    sessionMod.ses_id = 3
                    sessionMod.mod_id = 1
                case 3 :
                    sessionMod.ses_id = 4
                    sessionMod.mod_id = 1
                case 4 :
                    sessionMod.ses_id = 5
                    sessionMod.mod_id = 1
                default :
                    print("Défault")
                }
            }
        }
        
        super.viewDidLoad()
        
     /*   let eventStore = EKEventStore()
        let startDate = NSDate()
        let endDate = startDate.dateByAddingTimeInterval(60*60)
        
        if(EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized){
            eventStore.requestAccessToEntityType(.Event, completion: { granted, error in
                self.createEvent(eventStore, title: title!, startDate: startDate, endDate: endDate)
            })
            //If we get permission
            
        } else{
            //If we already have permission
            createEvent(eventStore, title: title!, startDate: startDate, endDate: endDate)
        } */
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate){
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do{
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch{
            print("Bad things happened")
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    //Différentes actions suivants les boutons qui sont appuyés
    @IBAction func goToHelp(sender: AnyObject) {
        let alert = UIAlertView(title: NSLocalizedString("Contact", comment: "Titre message alerte contact"), message: NSLocalizedString("train.on@dmf.fr",comment: "message d'alerte"), delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    @IBAction func goToCalendar2(sender: AnyObject) {
        self.performSegueWithIdentifier("showPlanning", sender: self)
    }
    @IBAction func goToCalendar(sender: AnyObject) {
        self.performSegueWithIdentifier("showPlanning", sender: self)
    }
    
    @IBAction func goToContact2(sender: AnyObject) {
        self.performSegueWithIdentifier("showContact", sender: self)
    }
    @IBAction func goToContact(sender: AnyObject) {
        self.performSegueWithIdentifier("showContact", sender: self)
    }
    @IBAction func goToModuleFormation2(sender: AnyObject) {
        self.performSegueWithIdentifier("showCategorieModuleFormation", sender: self)
    }
    @IBAction func goToModuleFormation(sender: AnyObject) {
        self.performSegueWithIdentifier("showCategorieModuleFormation", sender: self)
    }
    
    @IBAction func deconnexion(sender: AnyObject) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        NSLog("Logout SUCCESS")
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = NSLocalizedString("Train'ON", comment: "accueil")
    }
    
    @IBAction func showHTML(sender: AnyObject) {
        self.performSegueWithIdentifier("showHTML", sender: sender)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            //Redirection vers l'écran "Gérer les contacts"
        case "showContact" :
            print("")
            //Redirection vers l'écran "Gérer le planning"
        case "showPlanning" :
            print("")
            //Redirection vers l'écran "Gérer les modules de formations"
        case "showCategorieModuleFormation" :
            print("")
            //Redirection vers l'écran "Login"
        case "showLogin" :
            let loginViewController = segue.destinationViewController as! LoginViewController
            loginViewController.nomUser = loginPersonneConnectée
        default :
            print("Aucun segue trouvé", terminator: "")
        }
    }
    
}

