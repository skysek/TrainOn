//
//  ListeContactViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 27/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class ListeContactViewController: UITableViewController {

    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tabEntreprise = [ENTREPRISE]()
    var tabCollaborateur = [COLLABORATEUR]()
    var tagInterne = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table ENTREPRISE
        let managedContextEnt = appliDelegate.managedObjectContext
        let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
        
        //Table COLLABORATEUR
        let managedContextCol = appliDelegate.managedObjectContext
        let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "ent_id", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestEnt.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
            
            tabEntreprise.removeAll()
            
            for entreprise in fetchResults! {
                
                tabEntreprise.append(entreprise)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table ENTREPRISE")
        }
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "ent_id", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestCol.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
            
            tabCollaborateur.removeAll()
            
            for collaborateur in fetchResults! {
                
                tabCollaborateur.append(collaborateur)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
        }
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = NSLocalizedString("Clients", comment: "clients")
        
        //Table ENTREPRISE
        let managedContextEnt = appliDelegate.managedObjectContext
        let fetchRequestEnt = NSFetchRequest(entityName: "ENTREPRISE")
        
        //Table COLLABORATEUR
        let managedContextCol = appliDelegate.managedObjectContext
        let fetchRequestCol = NSFetchRequest(entityName: "COLLABORATEUR")
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "ent_id", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestEnt.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextEnt.executeFetchRequest(fetchRequestEnt) as? [ENTREPRISE]
            
            tabEntreprise.removeAll()
            
            for entreprise in fetchResults! {
                
                tabEntreprise.append(entreprise)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table ENTREPRISE")
        }
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "ent_id", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestCol.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextCol.executeFetchRequest(fetchRequestCol) as? [COLLABORATEUR]
            
            tabCollaborateur.removeAll()
            
            for collaborateur in fetchResults! {
                
                tabCollaborateur.append(collaborateur)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table COLLABORATEUR")
        }
        
        self.tableView.reloadData()
        
        //super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabCollaborateur.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! CellContactTableViewCell

        cell.contactName.text = tabCollaborateur[indexPath.row].col_nom
        cell.button.tag = tabCollaborateur[indexPath.row].col_id as! Int
        cell.button.addTarget(self, action: #selector(ListeContactViewController.clickButtonDetail(_:)), forControlEvents: .TouchUpInside)
        
        cell.button2.tag = tabCollaborateur[indexPath.row].col_id as! Int
        cell.button2.addTarget(self, action: #selector(ListeContactViewController.clickButtonDetail(_:)), forControlEvents: .TouchUpInside)
        
        for i in 0 ..< tabEntreprise.count {
            if tabEntreprise[i].ent_id == tabCollaborateur[indexPath.row].ent_id {
                
                cell.entrepriseName.text = tabEntreprise[i].ent_nom
            }
        }

        return cell
    }
    
    func clickButtonDetail(sender: UIButton){
        self.tagInterne = sender.tag
        self.performSegueWithIdentifier("showDetailContact", sender: self)
    }
    
    @IBAction func addContact(sender: AnyObject) {
        self.performSegueWithIdentifier("showAjoutContact", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailContact" {
            let detailContactViewController = segue.destinationViewController as! DetailContactViewController
            detailContactViewController.colID = sender!.tagInterne
        }
    }

}
