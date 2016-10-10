//
//  ModulesTableViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 09/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

let cellID = "cell"

class CategorieModulesTableViewController: UITableViewController, UISearchBarDelegate{

    //Variables faisant le lien avec le CoreData
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    private var tabCategories = [CATEGORIE]()
    private var tabModules = [MODULE]()
    var filteredTabCategories = [CATEGORIE]()
    var searchActive = false
    
    var catId = Int()
    var catNom = String()
    
    
    override func viewDidLoad() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationItem.backBarButtonItem?.title = "Back"
        
        //Table CATEGORIE
        let managedContextCat = appliDelegate.managedObjectContext
        let fetchRequestCat = NSFetchRequest(entityName: "CATEGORIE")
        
        //Table MODULE
        let managedContextMod = appliDelegate.managedObjectContext
        let fetchRequestMod = NSFetchRequest(entityName: "MODULE")
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "cat_order", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestCat.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextCat.executeFetchRequest(fetchRequestCat) as? [CATEGORIE]
            
            tabCategories.removeAll()
            
            for categorie in fetchResults! {
                tabCategories.append(categorie)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table LOGIN")
        }
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "cat_id", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestMod.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
            
            tabModules.removeAll()
            
            for module in fetchResults! {
                
                tabModules.append(module)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.title = NSLocalizedString("Modules", comment: "modules")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabCategories.count
    }
    
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 46
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! CellCategorieModuleController
        
        if(searchActive){
            cell.titleLabel.text = filteredTabCategories[indexPath.row].cat_nom
            cell.button.tag = filteredTabCategories[indexPath.row].cat_id as! Int
        } else {
            cell.titleLabel.text = tabCategories[indexPath.row].cat_nom
            cell.button.tag = tabCategories[indexPath.row].cat_id as! Int
        }
        
        return cell
    }
    
    @IBAction func dtlModule(sender: AnyObject) {
        catId = sender.tag
        performSegueWithIdentifier("showListeModule", sender: self)
    }
    @IBAction func detailModule(sender: AnyObject) {
        catId = sender.tag
        performSegueWithIdentifier("showListeModule", sender: self)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredTabCategories = tabCategories.filter({ (text) -> Bool in
            let tmp: NSString = text.cat_nom!
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredTabCategories.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showListeModule" {
            let listeModuleController = segue.destinationViewController as! ListeModuleTableViewController
            listeModuleController.catID = catId as NSNumber
            listeModuleController.catNOM = catNom as String
        }
    }
    

}
