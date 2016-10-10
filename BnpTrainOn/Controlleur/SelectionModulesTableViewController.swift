//
//  TableViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 06/01/2016.
//  Copyright © 2016 Resulis MAC 1. All rights reserved.
//

import UIKit



import UIKit
import CoreData



class SelectionModulesTableViewController: UITableViewController {

    //Variables faisant le lien avec le CoreData
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    private var tabCategories = [CATEGORIE]()
    private var tabModules = [[MODULE]]()
    private var tmpModules = [MODULE]()
    private var tmpModIdSelected = [Int]()
    var filteredTabCategories = [CATEGORIE]()
    var searchActive = false
    
    var catId = Int()
    
    override func viewDidLoad() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationItem.backBarButtonItem?.title = "Back"
        
        //Table CATEGORIE
        let managedContextCat = appliDelegate.managedObjectContext
        let fetchRequestCat = NSFetchRequest(entityName: "CATEGORIE")
        
        //Table MODULE
        let managedContextSesMod = appliDelegate.managedObjectContext
        let fetchRequestSesMod = NSFetchRequest(entityName: "TMPSESSIONMODULE")
        
        do {
        let fetchResults = try managedContextSesMod.executeFetchRequest(fetchRequestSesMod)as?[TMPSESSIONMODULE]
        
        for tmpmodule in fetchResults! {
            tmpModIdSelected.append(Int(tmpmodule.mod_id!))
        }
        } catch {
            print("Erreur lors de la récupération des données de la table LOGIN")
        }
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "cat_order", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequestCat.sortDescriptors = sortDescriptors
            let fetchResults = try managedContextCat.executeFetchRequest(fetchRequestCat) as? [CATEGORIE]
            let managedContextMod = appliDelegate.managedObjectContext
            let fetchRequestMod = NSFetchRequest(entityName: "MODULE")

            tabCategories.removeAll()
            
            for categorie in fetchResults! {
                tabCategories.append(categorie)
                
                //Table MODULE
                
                let predicate = NSPredicate(format: "cat_id = %@", categorie.cat_id!)
                fetchRequestMod.predicate = predicate
                
                do {
                    let fetchResultsModules = try managedContextMod.executeFetchRequest(fetchRequestMod) as? [MODULE]
                    tmpModules.removeAll()
                    for module in fetchResultsModules! {
                        tmpModules.append(module)
                    }
                    tabModules.append(tmpModules)
                    
                } catch {
                    print("Erreur lors de la récupération des données de la table LOGIN")
                }
                
                
            }
        } catch {
            print("Erreur lors de la récupération des données de la table CATEGORIE")
        }
        
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tabCategories.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabModules[section].count
    }
    /*
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 46
    }
    */
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tabCategories[section].cat_nom
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view:UIView,forSection  section: Int) {
        
        view.backgroundColor = UIColor(red: 147,green: 189, blue: 14, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: "BNPPSans", size: 16)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("cellModule") as! CellCategorieModuleController
        let cell = tableView.dequeueReusableCellWithIdentifier("cellModule", forIndexPath: indexPath)
       
        cell.textLabel?.text = tabModules[indexPath.section][indexPath.row].mod_nom!
        cell.textLabel?.font = UIFont(name: "BNPPSans", size: 12)
        cell.tintColor = UIColor(red: 3/255, green: 143/255, blue: 94/255, alpha: 1)

        print("compare : \(Int(tabModules[indexPath.section][indexPath.row].mod_id!))")
        if tmpModIdSelected.contains(Int(tabModules[indexPath.section][indexPath.row].mod_id!)){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        print("indexPath : \(indexPath)")
        var selected = false
        if cell!.selected
        {
            cell!.selected = false
            if cell!.accessoryType == UITableViewCellAccessoryType.None
            {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                print("id: \(tmpModIdSelected)")
                selected = true
                saveState(indexPath.section, row: indexPath.row, selected: selected )
            }
            else if  tmpModIdSelected.count > 0
            {
                cell!.accessoryType = UITableViewCellAccessoryType.None
                selected = false
                saveState(indexPath.section, row: indexPath.row, selected: selected )
            }
            
        }
        
    }
    
 
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showListeModule" {
            let listeModuleController = segue.destinationViewController as! ListeModuleTableViewController
            listeModuleController.catID = catId as NSNumber
        }
    }
    func saveState(section: Int,row: Int,selected: Bool){
        
        let managedContextTmpSes = appliDelegate.managedObjectContext
        if selected {
            let entityDescriptionTmpSes = NSEntityDescription.entityForName("TMPSESSIONMODULE", inManagedObjectContext: managedContextTmpSes)
            let tmpsession = TMPSESSIONMODULE(entity: entityDescriptionTmpSes!, insertIntoManagedObjectContext: managedContextTmpSes)
            
            tmpsession.mod_id = tabModules[section][row].mod_id
            
            do {
                try managedContextTmpSes.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONMODULE")
            }
            tmpModIdSelected.append(Int(tabModules[section][row].mod_id!))
        } else {
            let predicate = NSPredicate(format: "mod_id = %@", tabModules[section][row].mod_id!)
            
            let fetchRequest = NSFetchRequest(entityName: "TMPSESSIONMODULE")
            fetchRequest.predicate = predicate
            
            do {
                let fetchedEntities = try managedContextTmpSes.executeFetchRequest(fetchRequest) as! [TMPSESSIONMODULE]
                if let entityToDelete = fetchedEntities.first {
                    managedContextTmpSes.deleteObject(entityToDelete)
                }
            } catch {
                // Do something in response to error condition
            }
            
            do {
                try managedContextTmpSes.save()
            } catch {
                print("Impossible de sauvegarder l'ajout dans la table TMPSESSIONMODULE")
            }
            
            let index = tmpModIdSelected.indexOf(Int(tabModules[section][row].mod_id!))
            tmpModIdSelected.removeAtIndex(index!)
        }
        
        //Table TMPSESSIONMODULE
        
        let fetchRequestTmpSesMod = NSFetchRequest(entityName: "TMPSESSIONMODULE")
        
        do {
            let fetchedEntities = try managedContextTmpSes.executeFetchRequest(fetchRequestTmpSesMod) as! [TMPSESSIONMODULE]
            print("module")
            for module in fetchedEntities {
                print(module.mod_id)
            }
            
            
        } catch {
            print("Erreur vérification dans la table temporaire des modules")
        }
        
     }
    
}
