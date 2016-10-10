//
//  PresenceContactsTableViewController.swift
//  BnpTrainOn
//
//  Created by Resulis MAC 1 on 27/05/2016.
//  Copyright © 2016 Resulis MAC 1. All rights reserved.
//

//
//  SelectionContactsTableViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 09/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class PresenceContactsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var entID = Int()
    var sesID = NSNumber()
    var colID = NSNumber()
    var preID = NSNumber()
    var arrayPresences = [NSNumber]()
    
    var tabCol = [COLLABORATEUR]()
    var tabEnt = [ENTREPRISE]()
    var tabCheckBox = [Checkbox]()
    
    var tabColGeneral = [COLLABORATEUR]()
    
    var tabSesCol = [SESSIONCOLLABORATEUR]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        tabCheckBox.removeAll()
        arrayPresences.removeAll()
        tabSesCol.removeAll()
        
        //Table COLLABORATEUR
        let managedContextCol = appliDelegate.managedObjectContext
        let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
        
        do {
            let predicate = NSPredicate(format: "ent_id = %@", entID as NSNumber)
            fetchRequestCol.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "col_nom", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestCol.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
            
            
            
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
        }
        
        //Table SESSIONCOLLABORATEUR
        let managedContextSesCol = appliDelegate.managedObjectContext
        let fetchRequestSesCol = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
        
        do {
            let predicate = NSPredicate(format: "ses_id = %@", sesID as NSNumber)
            fetchRequestSesCol.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "col_id", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestSesCol.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextSesCol.executeFetchRequest(fetchRequestSesCol) as? [SESSIONCOLLABORATEUR]
            
            for sescol in fetchResults!{
                if (sescol.prog_id == 1){
                    tabSesCol.append(sescol)
                    print("sescol : \(sescol)")
                }
            }
            
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
        }
        
        //Table ENTREPRISE
        let managedContextEnt = appliDelegate.managedObjectContext
        let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
        
        do {
            let predicate = NSPredicate(format: "ent_id = %@", entID as NSNumber)
            fetchRequestEnt.predicate = predicate
            let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
            
            tabEnt.removeAll()
            
            for entreprise in fetchResults! {
                tabEnt.append(entreprise)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
        }
        
        print("PROGRAMMÉS : \(tabSesCol)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Liste de présences"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabColGeneral.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellContact", forIndexPath: indexPath) as! CellPresenceContactTableViewCell
        let checkbox1 = Checkbox(frame: CGRectMake(0, 13, 28, 20), title: "checkbox1", selected: false)

        
        checkbox1.tag = tabColGeneral[indexPath.row].col_id as! Int
        
        cell.contactNameLabel.text = tabColGeneral[indexPath.row].col_nom! +  " " + tabColGeneral[indexPath.row].col_prenom!
        cell.entrepriseNameLabel.text = tabEnt[0].ent_nom
        cell.idCollaborateur = tabColGeneral[indexPath.row].col_id!
        
        cell.checkbox = checkbox1
        cell.idSession = sesID
        cell.changeTarget()
        cell.changeStateCheckbox()
        
        if cell.checkbox.selected{
            
            preID = 1
            
        }else{
            
            preID = 0
        }
        arrayPresences.append(preID)
        
        print("sesID : \(sesID)")
        print("preID : \(preID)")
        print("Les présents : \(arrayPresences)")
        cell.addSubview(checkbox1)
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        tabCheckBox.removeAll()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //Table SESSIONCOLLABORATEUR
        let managedContextTmpSesCon = appliDelegate.managedObjectContext
        let fetchRequestSesCon = NSFetchRequest(entityName: "SESSIONCOLLABORATEUR")
        
        do {
            let fetchResults = try managedContextTmpSesCon.executeFetchRequest(fetchRequestSesCon) as? [SESSIONCOLLABORATEUR]
            
            for sessioncontact in fetchResults! {
                print("\(sessioncontact.col_id) : \(sessioncontact.pre_id)")
            }
        } catch {
            print("Erreur lors de la récupération des données de la table SESSIONCOLLABORATEUR")
        }
    }
    
   
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AjoutSessionViewController {
            
            controller.arrayPresences = arrayPresences   // Here you pass the data back to your original view controller
        }
    }
   
    
}

