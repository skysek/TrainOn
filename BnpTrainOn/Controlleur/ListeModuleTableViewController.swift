//
//  ListeModuleTableViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 24/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class ListeModuleTableViewController: UITableViewController {

    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var catID = NSNumber()
    var modid = NSNumber()
    var tabModules = [MODULE]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Table MODULE
        let managedContextMod = appliDelegate.managedObjectContext
        let fetchRequestMod = NSFetchRequest(entityName: "MODULE")
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "mod_id", ascending: true)
            let sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "cat_id = %@", catID)
            fetchRequestMod.predicate = predicate
            fetchRequestMod.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
            
            tabModules.removeAll()
            
            for module in fetchResults! {
                
                tabModules.append(module)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationItem.backBarButtonItem?.title = "Back"
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

    /*override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 46
    }*/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = 0
        
        //Table MODULE
        let managedContextMod = appliDelegate.managedObjectContext
        let fetchRequestMod = NSFetchRequest(entityName: "MODULE")
        
        let predicate = NSPredicate(format: "cat_id = %@", catID)
        fetchRequestMod.predicate = predicate
        
        do {
            let fetchResults = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
            
            for _ in fetchResults! {
                count++
            }
        } catch {
            print("Erreur lors de la récupération des données de la table LOGIN")
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moduleCell", forIndexPath: indexPath) as! CellModuleTableViewCell
    
        cell.textLabel?.text = tabModules[indexPath.row].mod_nom
        cell.btnDetailModule.tag = tabModules[indexPath.row].mod_id as! Int
    
        return cell
    }
    
    @IBAction func detailModule(sender: UIButton) {
        modid = sender.tag
        performSegueWithIdentifier("showDetailModule", sender: self)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailModule" {
            let detailModuleViewController = segue.destinationViewController as! DetailModuleViewController
            detailModuleViewController.modID = modid as NSNumber
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

}
