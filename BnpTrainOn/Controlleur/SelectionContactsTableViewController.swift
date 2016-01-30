//
//  SelectionContactsTableViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 09/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class SelectionContactsTableViewController: UITableViewController {

    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var entID = Int()
    var tabCol = [COLLABORATEUR]()
    var tabEnt = [ENTREPRISE]()
    var tabCheckBox = [Checkbox]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabCheckBox.removeAll()
        
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
            
            tabCol.removeAll()
            
            for collaborateur in fetchResults! {
                tabCol.append(collaborateur)
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabCol.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellContact", forIndexPath: indexPath) as! CellSelectionContactTableViewCell
        let checkbox1 = Checkbox(frame: CGRectMake(315, 13, 28, 20), title: "checkbox1", selected: false)

        checkbox1.tag = tabCol[indexPath.row].col_id as! Int
        
        cell.contactNameLabel.text = tabCol[indexPath.row].col_nom! +  " " + tabCol[indexPath.row].col_prenom!
        cell.entrepriseNameLabel.text = tabEnt[0].ent_nom
        cell.idCollaborateur = tabCol[indexPath.row].col_id!
        cell.checkbox = checkbox1
        cell.changeTarget()
        cell.changeStateCheckbox()
        
        cell.addSubview(checkbox1)
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        tabCheckBox.removeAll()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //Table TMPSESSIONCONTACT
        let managedContextTmpSesCon = appliDelegate.managedObjectContext
        let fetchRequestTmpSesCon = NSFetchRequest(entityName: "TMPSESSIONCONTACT")
        
        do {
            let fetchResults = try managedContextTmpSesCon.executeFetchRequest(fetchRequestTmpSesCon) as? [TMPSESSIONCONTACT]
            
            for tmpsessioncontact in fetchResults! {
                //print(tmpsessioncontact.col_id)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
