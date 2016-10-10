//
//  DetailModuleViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 26/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class DetailModuleViewController: UIViewController {

    var modID = NSNumber()
    var moduleEnCour = [MODULE]()
    
    @IBOutlet var webView: UIWebView!
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table MODULE
        let managedContextMod = appliDelegate.managedObjectContext
        let fetchRequestMod = NSFetchRequest(entityName: "MODULE")
        
        do {
            let predicate = NSPredicate(format: "mod_id = %@", modID)
            fetchRequestMod.predicate = predicate
            let fetchResults = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
            
            moduleEnCour.removeAll()
            
            for module in fetchResults! {
                
                let decodedData = NSData(base64EncodedString: module.mod_detail!, options:NSDataBase64DecodingOptions(rawValue: 0))
                let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
                
                //print()
                
                //let imageArray = NSBundle.mainBundle().URLsForResourcesWithExtension("png", subdirectory: "images") as! [NSURL]
                
                let path = NSBundle.mainBundle().URLForResource("duree_icon_diapo", withExtension: "png")
                print(path)
                //let baseURL:NSURL=NSURL(fileURLWithPath: path as String)
                let htmlString:String! = decodedString as! String
                webView.loadHTMLString(htmlString, baseURL: path)
                
                //webView.loadHTMLString(decodedString as! String, baseURL: nil)
                
                moduleEnCour.append(module)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addSessionFromModuleFormation(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showAddSessionFromModule", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddSessionFromModule" {
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
            
            let countTmpSesMod = try! managedContextTmpSesMod.countForFetchRequest(fetchRequestTmpSesMod)
            
            if countTmpSesMod == 0 {
                    
                let entityDescriptionTmpSesMod = NSEntityDescription.entityForName("TMPSESSIONMODULE", inManagedObjectContext: managedContextTmpSesMod)
                let tmpsessionmodule = TMPSESSIONMODULE(entity: entityDescriptionTmpSesMod!, insertIntoManagedObjectContext: managedContextTmpSesMod)
                
                tmpsessionmodule.mod_id = modID
            }
            
            let ajoutSessionViewController = segue.destinationViewController as! AjoutSessionViewController
            ajoutSessionViewController.moduleID = modID
            ajoutSessionViewController.contactID = 0
            ajoutSessionViewController.isCreation = 1
        }
    }
    

}
