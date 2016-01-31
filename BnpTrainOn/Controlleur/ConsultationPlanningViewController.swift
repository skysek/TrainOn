//
//  ConsultationPlanningViewController.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 15/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit
import CoreData

class ConsultationPlanningViewController: UIViewController {
    
    //1ère ligne calendrier
    @IBOutlet var CollectionButton1: [UIButton]!
    
    //2ème ligne calendrier
    @IBOutlet var CollectionButton2: [UIButton]!
    
    //3ème ligne calendrier
    @IBOutlet var CollectionButton3: [UIButton]!
    
    //4ème ligne calendrier
    @IBOutlet var CollectionButton4: [UIButton]!
    
    //5ème ligne calendrier
    @IBOutlet var CollectionButton5: [UIButton]!
    
    //6ème ligne calendrier
    @IBOutlet var CollectionButton6: [UIButton]!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewInScrollView: UIView!
    @IBOutlet var moisLabel: UILabel!
    @IBOutlet var anneeLabel: UILabel!
    
    var sesID = NSNumber()
    var jourEncour = 1

    var createSession = 0
    
    var CollectionButtonMois = [UIButton]()
    
    var tabLabel = [UILabel]()
    var tabButton = [UIButton]()
    var tabImgView = [UIImageView]()
    
    var database = [NSManagedObject]()
    let appliDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        
        //Réinitialisation de la base pour le mois en cour et l'année en cour
        //Table TMPMOISENCOUR
        var managedContextTmpMois = appliDelegate.managedObjectContext
        var fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        var managedContextTmpAnnee = appliDelegate.managedObjectContext
        var fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        //let psc = self.appliDelegate.persistentStoreCoordinator
        
        let deleteRequestTmpMois = NSBatchDeleteRequest(fetchRequest: fetchRequestTmpMois)
        do {
            //try psc.executeRequest(deleteRequestTmpMois, withContext: managedContextTmpMois)
            try managedContextTmpMois.executeRequest(deleteRequestTmpMois)
            try managedContextTmpMois.save()
        } catch {
            print("Erreur lors de la purge de la table TMPMOISENCOUR")
        }
        
        let deleteRequestTmpAnnee = NSBatchDeleteRequest(fetchRequest: fetchRequestTmpAnnee)
        do {
            //try psc.executeRequest(deleteRequestTmpAnnee, withContext: managedContextTmpAnnee)
            try managedContextTmpAnnee.executeRequest(deleteRequestTmpAnnee)
            try managedContextTmpAnnee.save()
        } catch {
            print("Erreur lors de la purge de la table TMPANNEENCOUR")
        }
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationItem.backBarButtonItem?.title = "Back"
        
        super.viewDidLoad()

        CollectionButtonMois.removeAll()
        
        let dateFormatterYear = NSDateFormatter()
        let dateFormatterYearShort = NSDateFormatter()
        let dateFormatterMonth = NSDateFormatter()
        let dateFormatterDay = NSDateFormatter()
        let date = NSDate()
        dateFormatterYear.dateFormat = "yyyy"
        dateFormatterYearShort.dateFormat = "yy"
        dateFormatterMonth.dateFormat = "MM"
        dateFormatterDay.dateFormat = "dd"
        let calendar = NSCalendar.currentCalendar()
        var compteurDeJours = 0
        
        //Récupère le premier jour du mois
        let components = calendar.components([.Year, .Month], fromDate: date)
        let startOfMonth = calendar.dateFromComponents(components)!
        //print(dateFormatter.stringFromDate(startOfMonth))
        
        //Lecture de la base
        //firstSaturdayMarch2015DateComponents.year = anneeBase -1
        //firstSaturdayMarch2015DateComponents.month = moisBase -1
        
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: startOfMonth, options: [])!
        let nbDay = Int(dateFormatterDay.stringFromDate(endOfMonth))!
        //print(dateFormatter.stringFromDate(endOfMonth))
        
        //Récupére le "weekday" (le 1 jour du mois)
        let firstSaturdayMarch2015DateComponents = NSDateComponents()
        firstSaturdayMarch2015DateComponents.year = Int(dateFormatterYear.stringFromDate(startOfMonth))!
        firstSaturdayMarch2015DateComponents.month = Int(dateFormatterMonth.stringFromDate(startOfMonth))!
        
        anneeLabel.text = dateFormatterYear.stringFromDate(startOfMonth)
        changeNameMonth(Int(dateFormatterMonth.stringFromDate(startOfMonth))!)
        
        //firstSaturdayMarch2015DateComponents.year = 2015
        //firstSaturdayMarch2015DateComponents.month = 08
        
        let firstSaturdayMarch2015Date = calendar.dateFromComponents(firstSaturdayMarch2015DateComponents)!
        let componentsTest = calendar.components([.Weekday], fromDate: firstSaturdayMarch2015Date)
        //print(componentsTest.weekday)
        
        //Stockage du mois et de l'année en cour
        //Table TMPMOISENCOUR
        managedContextTmpMois = appliDelegate.managedObjectContext
        fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        managedContextTmpAnnee = appliDelegate.managedObjectContext
        fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        //Enregistrement dans les tables TMPMOISENCOUR et TMPANNEENCOUR
        let entityDescriptionTmpMois = NSEntityDescription.entityForName("TMPMOISENCOUR", inManagedObjectContext: managedContextTmpMois)
        let tmpmoisencour = TMPMOISENCOUR(entity: entityDescriptionTmpMois!, insertIntoManagedObjectContext: managedContextTmpMois)
        
        tmpmoisencour.value_mois = Int(dateFormatterMonth.stringFromDate(startOfMonth))!
        
        do {
            try managedContextTmpMois.save()
        } catch {
            print("Échec de la sauvegarde de la table TMPMOISENCOUR")
        }
        
        let entityDescriptionTmpAnnee = NSEntityDescription.entityForName("TMPANNEENCOUR", inManagedObjectContext: managedContextTmpAnnee)
        let tmpanneeencour = TMPANNEENCOUR(entity: entityDescriptionTmpAnnee!, insertIntoManagedObjectContext: managedContextTmpAnnee)
        
        tmpanneeencour.value_annee = Int(dateFormatterYear.stringFromDate(startOfMonth))!
        
        do {
            try managedContextTmpAnnee.save()
        } catch {
            print("Échec de la sauvegarde de la table TMPANNEENCOUR")
        }
        
        
        if componentsTest.weekday <= 6 && componentsTest.weekday != 1 {
            for var i=0; i<CollectionButton6.count; i++ {
                CollectionButton6[i].hidden = true
            }
        } else {
            for var i=0; i<CollectionButton6.count; i++ {
                CollectionButton6[i].hidden = false
            }
        }
        
        switch componentsTest.weekday {
        //Jour de départ : Dimanche
        case 1:
            for var i=0; i<CollectionButton1.count-1; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=6;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                compteurDeJours++
                CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton5[i])
            }
            
            for var i=0;i<CollectionButton6.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton6[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton6[i])
                } else {
                    CollectionButton6[i].hidden = true
                }
            }
        //Jour de départ : Lundi
        case 2:
            for var i=0;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
        //Jour de départ : Mardi
        case 3:
            CollectionButton1[0].hidden = true
            
            for var i=1;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
        //Jour de départ : Mercredi
        case 4:
            for var i=0; i<CollectionButton1.count-5; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=2;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
        //Jour de départ : Jeudi
        case 5:
            for var i=0; i<CollectionButton1.count-4; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=3;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
        //Jour de départ : Vendredi
        case 6:
            for var i=0; i<CollectionButton1.count-3; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=4;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            
        //Jour de départ : Samedi
        case 7:
            for var i=0; i<CollectionButton1.count-2; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=5;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                compteurDeJours++
                CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton5[i])
            }
            
            for var i=0;i<CollectionButton6.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton6[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton6[i])
                } else {
                    CollectionButton6[i].hidden = true
                }
            }
        default :
            print("Défaut")
        }
        
        for var i=0;i<CollectionButtonMois.count; i++ {
            CollectionButtonMois[i].tag = i+1
            CollectionButtonMois[i].addTarget(self, action: "showSession:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        changeColorButton()
        
    }
    
    //Fonction permettant de changer la couleur des boutons si ils ont des sessions
    func changeColorButton() {
        var moisEnCour = String()
        var anneeEnCour = String()
        
        //Récupération du mois et de l'année en cour dans des variables locales
        //Table TMPMOISENCOUR
        let managedContextTmpMois = appliDelegate.managedObjectContext
        let fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        let managedContextTmpAnnee = appliDelegate.managedObjectContext
        let fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        do {
            let fetchResults = try managedContextTmpMois.executeFetchRequest(fetchRequestTmpMois) as? [TMPMOISENCOUR]
            
            for entity in fetchResults! {
                moisEnCour = String(entity.value_mois as! Int)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPMOISENCOUR")
        }
        
        do {
            let fetchResults = try managedContextTmpAnnee.executeFetchRequest(fetchRequestTmpAnnee) as? [TMPANNEENCOUR]
            
            for entity in fetchResults! {
                anneeEnCour = String(entity.value_annee as! Int)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPMOISENCOUR")
        }
        
        //Affichage des sessions si il y a des sessions au jour convenu et mise à jour de la couleur
        //Table SESSION
        let managedContextSes = appliDelegate.managedObjectContext
        let fetchRequestSes = NSFetchRequest(entityName: "SESSION")
        //let countSes = managedContextSes.countForFetchRequest(fetchRequestSes, error: nil)

        
        do {
            let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
            
            for entity in fetchResults! {
                // la date dans la sseion est enregistré au format MM/DD/YY
                //print(entity.ses_date)
                //print("0" + String(CollectionButtonMois[i].tag) + "/" + moisEnCour + "/" + anneeEnCour)
                let sesDate = entity.ses_date
                var arDateSession = sesDate?.componentsSeparatedByString("/")
                
                print("===========================================")
                print(entity)
                print("===========================================")
                print(arDateSession)
                //print([Int(arDateSession![0]),CollectionButtonMois[i].tag])
                print([Int(arDateSession![1]),Int(moisEnCour)])
                print([Int(arDateSession![2]),Int(anneeEnCour)])
                
                
                
                if  ( Int(arDateSession![1]) == Int(moisEnCour))
                    && ( Int(arDateSession![2]) == Int(anneeEnCour)) {
                        let i = Int(arDateSession![0])!-1
                        CollectionButtonMois[i].setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                        print("-> ok")
                }
                /*
                if entity.ses_date! == "0" + String(CollectionButtonMois[i].tag) + "/" + moisEnCour + "/" + anneeEnCour {
                CollectionButtonMois[i].setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                }
                */
            }
        } catch {
            print("Erreur lors de la récupération des données de la table SESSION")
        }

        
        /* // ancien code Killian remplacé par le code ci dessus
        for var i=0; i<CollectionButtonMois.count; i++ {
            if CollectionButtonMois[i].tag <= 9 {
                do {
                    let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
                    
                    for entity in fetchResults! {
                        // la date dans la sseion est enregistré au format MM/DD/YY
                        //print(entity.ses_date)
                        //print("0" + String(CollectionButtonMois[i].tag) + "/" + moisEnCour + "/" + anneeEnCour)
                        let sesDate = entity.ses_date
                        var arDateSession = sesDate?.componentsSeparatedByString("/")
                        //print(arDateSession)
                        print([Int(arDateSession![0]),CollectionButtonMois[i].tag])
                        print([Int(arDateSession![1]),Int(moisEnCour)])
                        print([Int(arDateSession![2]),Int(anneeEnCour)])
                        print("===========================================")
                        //let sesMois:Int? = Int(arDateSession![0])
                        
                        if  ( Int(arDateSession![0]) == CollectionButtonMois[i].tag)
                                && ( Int(arDateSession![1]) == Int(moisEnCour))
                                && ( Int(arDateSession![2]) == Int(anneeEnCour)) {
                            CollectionButtonMois[i].setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                        }
                        /*
                        if entity.ses_date! == "0" + String(CollectionButtonMois[i].tag) + "/" + moisEnCour + "/" + anneeEnCour {
                            CollectionButtonMois[i].setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                        }
                        */
                    }
                } catch {
                    print("Erreur lors de la récupération des données de la table SESSION")
                }
            } else {
                do {
                    let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
                    
                    for entity in fetchResults! {
                        //print(entity.ses_date)
                        //print(String(CollectionButtonMois[i].tag) + "/" + moisEnCour + "/" + anneeEnCour)
                        if entity.ses_date! == String(CollectionButtonMois[i].tag) + "/" + moisEnCour + "/" + anneeEnCour {
                            CollectionButtonMois[i].setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                        }
                    }
                } catch {
                    print("Erreur lors de la récupération des données de la table SESSION")
                }
            }
        }
        */
    }

    //Fonction permettant d'afficher les différentes session dans la scrollView
    func showSession(sender: UIButton) {
        
        var firstPassage = 1
        scrollView.contentSize.height = 0
        
        //Variables permettant de définir le positionement des labels/boutons/image pour l'affichage d'une session
        let posXPictoPuceViolet = CGFloat(43)
        var posYPictoPuceViolet = CGFloat(27)
        let posXBoutonNomSession = CGFloat(200)
        var posYBoutonNomSession = CGFloat(32)
        let posXPictoHorloge = CGFloat(70)
        var posYPictoHorloge = CGFloat(53)
        let posXLabelHeureDebut = CGFloat(120)
        var posYLabelHeureDebut = CGFloat(61)
        let posXLabelSeparationHeure = CGFloat(160)
        var posYLabelSeparationHeure = CGFloat(60)
        let posXLabelHeureFin = CGFloat(203)
        var posYLabelHeureFin = CGFloat(61)
        
        var moisEnCour = String()
        var anneeEnCour = String()
        
        //On cache les éléments précédents
        for var i=0; i<tabButton.count; i++ {
            tabButton[i].hidden = true
        }
        for var i=0; i<tabLabel.count; i++ {
            tabLabel[i].hidden = true
        }
        for var i=0; i<tabImgView.count; i++ {
            tabImgView[i].hidden = true
        }
        
        //On les supprime des tableaux courants
        tabButton.removeAll()
        tabImgView.removeAll()
        tabLabel.removeAll()
        
        jourEncour = sender.tag
        
        print(jourEncour)
        
        //Récupération du mois et de l'année en cour dans des variables locales
        //Table TMPMOISENCOUR
        let managedContextTmpMois = appliDelegate.managedObjectContext
        let fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        let managedContextTmpAnnee = appliDelegate.managedObjectContext
        let fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        do {
            let fetchResults = try managedContextTmpMois.executeFetchRequest(fetchRequestTmpMois) as? [TMPMOISENCOUR]
            
            for entity in fetchResults! {
                moisEnCour = String(entity.value_mois!)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPMOISENCOUR")
        }
        
        do {
            let fetchResults = try managedContextTmpAnnee.executeFetchRequest(fetchRequestTmpAnnee) as? [TMPANNEENCOUR]
            
            for entity in fetchResults! {
                anneeEnCour = String(entity.value_annee!)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPMOISENCOUR")
        }
        
        //Affichage des sessions si il y a des sessions au jour convenu et mise à jour de la couleur
        //Table SESSION
        let managedContextSes = appliDelegate.managedObjectContext
        let fetchRequestSes = NSFetchRequest(entityName: "SESSION")
        //let countSes = managedContextSes.countForFetchRequest(fetchRequestSes, error: nil)
        
            do {
                let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
                
                for session in fetchResults! {
                    let sesDate = session.ses_date
                    var arDateSession = sesDate?.componentsSeparatedByString("/")
                    
                    //if session.ses_date! == "0" + String(sender.tag) + "/" + moisEnCour + "/" + anneeEnCour
                    if  ( Int(arDateSession![0]) == sender.tag)
                        && ( Int(arDateSession![1]) == Int(moisEnCour))
                        && ( Int(arDateSession![2]) == Int(anneeEnCour)){
                            
                        let image = UIImage(named: "liste_puce.png")
                        let imageView = UIImageView(image: image!)
                        imageView.frame = CGRect(x: posXPictoPuceViolet, y: posYPictoPuceViolet, width: 10, height: 10)
                        imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        viewInScrollView.addSubview(imageView)
                        tabImgView.append(imageView)
                        
                        let buttonNomSession = UIButton(frame: CGRectMake(0, 0, 262, 22))
                        buttonNomSession.setTitle(session.ses_nom, forState: UIControlState.Normal)
                        buttonNomSession.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                        buttonNomSession.titleLabel!.font =  UIFont(name: "BNPPSANS-Regular", size: 16)
                        buttonNomSession.center = CGPointMake(posXBoutonNomSession, posYBoutonNomSession)
                        buttonNomSession.tag = Int(session.ses_id!)
                        buttonNomSession.addTarget(self, action: "clickButtonDetailSession:", forControlEvents: UIControlEvents.TouchUpInside)
                        buttonNomSession.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
                        buttonNomSession.enabled = true
                        viewInScrollView.addSubview(buttonNomSession)
                        tabButton.append(buttonNomSession)
                        
                        let image2 = UIImage(named: "liste_icon-time.png")
                        let imageView2 = UIImageView(image: image2!)
                        imageView2.frame = CGRect(x: posXPictoHorloge, y: posYPictoHorloge, width: 16, height: 16)
                        imageView2.contentMode = UIViewContentMode.ScaleAspectFit
                        viewInScrollView.addSubview(imageView2)
                        tabImgView.append(imageView2)
                        
                        let labelHeureDeb = UILabel(frame: CGRectMake(0, 0, 50, 21))
                        labelHeureDeb.text = session.ses_heure_deb
                        labelHeureDeb.textColor = UIColor.blackColor()
                        labelHeureDeb.font = UIFont(name: labelHeureDeb.font.fontName, size: 12)
                        labelHeureDeb.center = CGPointMake(posXLabelHeureDebut, posYLabelHeureDebut)
                        viewInScrollView.addSubview(labelHeureDeb)
                        tabLabel.append(labelHeureDeb)
                        
                        let labelHeureSepar = UILabel(frame: CGRectMake(0, 0, 9, 21))
                        labelHeureSepar.text = "-"
                        labelHeureSepar.textColor = UIColor.blackColor()
                        labelHeureSepar.font = UIFont(name: labelHeureSepar.font.fontName, size: 12)
                        labelHeureSepar.center = CGPointMake(posXLabelSeparationHeure, posYLabelSeparationHeure)
                        viewInScrollView.addSubview(labelHeureSepar)
                        tabLabel.append(labelHeureSepar)
                        
                        let labelHeureFin = UILabel(frame: CGRectMake(0, 0, 56, 21))
                        labelHeureFin.text = session.ses_heure_fin
                        labelHeureFin.textColor = UIColor.blackColor()
                        labelHeureFin.font = UIFont(name: labelHeureFin.font.fontName, size: 12)
                        labelHeureFin.center = CGPointMake(posXLabelHeureFin, posYLabelHeureFin)
                        viewInScrollView.addSubview(labelHeureFin)
                        tabLabel.append(labelHeureFin)
                        
                        posYPictoPuceViolet += CGFloat(59)
                        posYBoutonNomSession += CGFloat(59)
                        posYPictoHorloge += CGFloat(59)
                        posYLabelHeureDebut += CGFloat(59)
                        posYLabelSeparationHeure += CGFloat(59)
                        posYLabelHeureFin += CGFloat(59)
                        
                        if (firstPassage == 1) {
                            scrollView.contentSize.height += CGFloat(90)
                            firstPassage++
                        } else {
                          scrollView.contentSize.height += CGFloat(59)
                        }
                    }
                }
            } catch {
                print("Erreur lors de la récupération des données de la table SESSION")
            }
        
        
        
        //print(sender.tag)
    }
    /* killian
    func showSession(sender: UIButton) {
        
        var firstPassage = 1
        scrollView.contentSize.height = 0
        
        //Variables permettant de définir le positionement des labels/boutons/image pour l'affichage d'une session
        let posXPictoPuceViolet = CGFloat(43)
        var posYPictoPuceViolet = CGFloat(27)
        let posXBoutonNomSession = CGFloat(200)
        var posYBoutonNomSession = CGFloat(32)
        let posXPictoHorloge = CGFloat(70)
        var posYPictoHorloge = CGFloat(53)
        let posXLabelHeureDebut = CGFloat(120)
        var posYLabelHeureDebut = CGFloat(61)
        let posXLabelSeparationHeure = CGFloat(160)
        var posYLabelSeparationHeure = CGFloat(60)
        let posXLabelHeureFin = CGFloat(203)
        var posYLabelHeureFin = CGFloat(61)
        
        var moisEnCour = String()
        var anneeEnCour = String()
        
        //On cache les éléments précédents
        for var i=0; i<tabButton.count; i++ {
            tabButton[i].hidden = true
        }
        for var i=0; i<tabLabel.count; i++ {
            tabLabel[i].hidden = true
        }
        for var i=0; i<tabImgView.count; i++ {
            tabImgView[i].hidden = true
        }
        
        //On les supprime des tableaux courants
        tabButton.removeAll()
        tabImgView.removeAll()
        tabLabel.removeAll()
        
        //Récupération du mois et de l'année en cour dans des variables locales
        //Table TMPMOISENCOUR
        let managedContextTmpMois = appliDelegate.managedObjectContext
        let fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        let managedContextTmpAnnee = appliDelegate.managedObjectContext
        let fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        do {
            let fetchResults = try managedContextTmpMois.executeFetchRequest(fetchRequestTmpMois) as? [TMPMOISENCOUR]
            
            for entity in fetchResults! {
                moisEnCour = String(entity.value_mois!)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPMOISENCOUR")
        }
        
        do {
            let fetchResults = try managedContextTmpAnnee.executeFetchRequest(fetchRequestTmpAnnee) as? [TMPANNEENCOUR]
            
            for entity in fetchResults! {
                anneeEnCour = String(entity.value_annee!)
            }
        } catch {
            print("Erreur lors de la récupération des données de la table TMPMOISENCOUR")
        }
        
        //Affichage des sessions si il y a des sessions au jour convenu et mise à jour de la couleur
        //Table SESSION
        let managedContextSes = appliDelegate.managedObjectContext
        let fetchRequestSes = NSFetchRequest(entityName: "SESSION")
        //let countSes = managedContextSes.countForFetchRequest(fetchRequestSes, error: nil)
        
        if sender.tag <= 9 {
            do {
                let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
                
                for session in fetchResults! {
                    if session.ses_date! == "0" + String(sender.tag) + "/" + moisEnCour + "/" + anneeEnCour {
                        let image = UIImage(named: "liste_puce.png")
                        let imageView = UIImageView(image: image!)
                        imageView.frame = CGRect(x: posXPictoPuceViolet, y: posYPictoPuceViolet, width: 10, height: 10)
                        imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        viewInScrollView.addSubview(imageView)
                        tabImgView.append(imageView)
                        
                        let buttonNomSession = UIButton(frame: CGRectMake(0, 0, 262, 22))
                        buttonNomSession.setTitle(session.ses_nom, forState: UIControlState.Normal)
                        buttonNomSession.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                        buttonNomSession.titleLabel!.font =  UIFont(name: "BNPPSANS-Regular", size: 16)
                        buttonNomSession.center = CGPointMake(posXBoutonNomSession, posYBoutonNomSession)
                        buttonNomSession.tag = Int(session.ses_id!)
                        buttonNomSession.addTarget(self, action: "clickButtonDetailSession:", forControlEvents: UIControlEvents.TouchUpInside)
                        buttonNomSession.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
                        buttonNomSession.enabled = true
                        viewInScrollView.addSubview(buttonNomSession)
                        tabButton.append(buttonNomSession)
                        
                        let image2 = UIImage(named: "liste_icon-time.png")
                        let imageView2 = UIImageView(image: image2!)
                        imageView2.frame = CGRect(x: posXPictoHorloge, y: posYPictoHorloge, width: 16, height: 16)
                        imageView2.contentMode = UIViewContentMode.ScaleAspectFit
                        viewInScrollView.addSubview(imageView2)
                        tabImgView.append(imageView2)
                        
                        let labelHeureDeb = UILabel(frame: CGRectMake(0, 0, 50, 21))
                        labelHeureDeb.text = session.ses_heure_deb
                        labelHeureDeb.textColor = UIColor.blackColor()
                        labelHeureDeb.font = UIFont(name: labelHeureDeb.font.fontName, size: 12)
                        labelHeureDeb.center = CGPointMake(posXLabelHeureDebut, posYLabelHeureDebut)
                        viewInScrollView.addSubview(labelHeureDeb)
                        tabLabel.append(labelHeureDeb)
                        
                        let labelHeureSepar = UILabel(frame: CGRectMake(0, 0, 9, 21))
                        labelHeureSepar.text = "-"
                        labelHeureSepar.textColor = UIColor.blackColor()
                        labelHeureSepar.font = UIFont(name: labelHeureSepar.font.fontName, size: 12)
                        labelHeureSepar.center = CGPointMake(posXLabelSeparationHeure, posYLabelSeparationHeure)
                        viewInScrollView.addSubview(labelHeureSepar)
                        tabLabel.append(labelHeureSepar)
                        
                        let labelHeureFin = UILabel(frame: CGRectMake(0, 0, 56, 21))
                        labelHeureFin.text = session.ses_heure_fin
                        labelHeureFin.textColor = UIColor.blackColor()
                        labelHeureFin.font = UIFont(name: labelHeureFin.font.fontName, size: 12)
                        labelHeureFin.center = CGPointMake(posXLabelHeureFin, posYLabelHeureFin)
                        viewInScrollView.addSubview(labelHeureFin)
                        tabLabel.append(labelHeureFin)
                        
                        posYPictoPuceViolet += CGFloat(59)
                        posYBoutonNomSession += CGFloat(59)
                        posYPictoHorloge += CGFloat(59)
                        posYLabelHeureDebut += CGFloat(59)
                        posYLabelSeparationHeure += CGFloat(59)
                        posYLabelHeureFin += CGFloat(59)
                        
                        if (firstPassage == 1) {
                            scrollView.contentSize.height += CGFloat(90)
                            firstPassage++
                        } else {
                            scrollView.contentSize.height += CGFloat(59)
                        }
                    }
                }
            } catch {
                print("Erreur lors de la récupération des données de la table SESSION")
            }
        } else{
            do {
                let fetchResults = try managedContextSes.executeFetchRequest(fetchRequestSes) as? [SESSION]
                for session in fetchResults! {
                    if session.ses_date! == String(sender.tag) + "/" + moisEnCour + "/" + anneeEnCour {
                        let image = UIImage(named: "liste_puce.png")
                        let imageView = UIImageView(image: image!)
                        imageView.frame = CGRect(x: posXPictoPuceViolet, y: posYPictoPuceViolet, width: 10, height: 10)
                        imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        viewInScrollView.addSubview(imageView)
                        tabImgView.append(imageView)
                        
                        let buttonNomSession = UIButton(frame: CGRectMake(0, 0, 262, 22))
                        buttonNomSession.setTitle(session.ses_nom, forState: UIControlState.Normal)
                        buttonNomSession.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                        buttonNomSession.titleLabel!.font =  UIFont(name: "BNPPSANS-Regular", size: 16)
                        buttonNomSession.center = CGPointMake(posXBoutonNomSession, posYBoutonNomSession)
                        buttonNomSession.tag = Int(session.ses_id!)
                        buttonNomSession.addTarget(self, action: "clickButtonDetailSession:", forControlEvents: UIControlEvents.TouchUpInside)
                        buttonNomSession.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
                        buttonNomSession.enabled = true
                        viewInScrollView.addSubview(buttonNomSession)
                        tabButton.append(buttonNomSession)
                        
                        let image2 = UIImage(named: "liste_icon-time.png")
                        let imageView2 = UIImageView(image: image2!)
                        imageView2.frame = CGRect(x: posXPictoHorloge, y: posYPictoHorloge, width: 16, height: 16)
                        imageView2.contentMode = UIViewContentMode.ScaleAspectFit
                        viewInScrollView.addSubview(imageView2)
                        tabImgView.append(imageView2)
                        
                        //print(session.ses_heure_deb)
                        
                        let labelHeureDeb = UILabel(frame: CGRectMake(0, 0, 50, 21))
                        labelHeureDeb.text = session.ses_heure_deb
                        labelHeureDeb.textColor = UIColor.blackColor()
                        labelHeureDeb.font = UIFont(name: labelHeureDeb.font.fontName, size: 12)
                        labelHeureDeb.center = CGPointMake(posXLabelHeureDebut, posYLabelHeureDebut)
                        viewInScrollView.addSubview(labelHeureDeb)
                        tabLabel.append(labelHeureDeb)
                        
                        let labelHeureSepar = UILabel(frame: CGRectMake(0, 0, 9, 21))
                        labelHeureSepar.text = "-"
                        labelHeureSepar.textColor = UIColor.blackColor()
                        labelHeureSepar.font = UIFont(name: labelHeureSepar.font.fontName, size: 12)
                        labelHeureSepar.center = CGPointMake(posXLabelSeparationHeure, posYLabelSeparationHeure)
                        viewInScrollView.addSubview(labelHeureSepar)
                        tabLabel.append(labelHeureSepar)
                        
                        let labelHeureFin = UILabel(frame: CGRectMake(0, 0, 56, 21))
                        labelHeureFin.text = session.ses_heure_fin
                        labelHeureFin.textColor = UIColor.blackColor()
                        labelHeureFin.font = UIFont(name: labelHeureFin.font.fontName, size: 12)
                        labelHeureFin.center = CGPointMake(posXLabelHeureFin, posYLabelHeureFin)
                        viewInScrollView.addSubview(labelHeureFin)
                        tabLabel.append(labelHeureFin)
                        
                        posYPictoPuceViolet += CGFloat(59)
                        posYBoutonNomSession += CGFloat(59)
                        posYPictoHorloge += CGFloat(59)
                        posYLabelHeureDebut += CGFloat(59)
                        posYLabelSeparationHeure += CGFloat(59)
                        posYLabelHeureFin += CGFloat(59)
                        
                        if (firstPassage == 1) {
                            scrollView.contentSize.height += CGFloat(90)
                            firstPassage++
                        } else {
                            scrollView.contentSize.height += CGFloat(59)
                        }
                    }
                }
            } catch {
                print("Erreur lors de la récupération des données de la table SESSION")
            }
        }
        
        //print(sender.tag)
    }
    

    */
    
    
    
    @IBAction func showNextMonth(sender: AnyObject) {
        var currentYear = Int()
        var currentMonth = Int()
        
        for var i=0; i<CollectionButtonMois.count; i++ {
            CollectionButtonMois[i].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        
        //Table TMPMOISENCOUR
        var managedContextTmpMois = appliDelegate.managedObjectContext
        var fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        var managedContextTmpAnnee = appliDelegate.managedObjectContext
        var fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        //Récupération du mois et de l'année précédent
        do {
            let fetchResults = try managedContextTmpMois.executeFetchRequest(fetchRequestTmpMois) as? [TMPMOISENCOUR]
            
            for tmpmois in fetchResults! {
                currentMonth = tmpmois.value_mois as! Int
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }
        do {
            let fetchResults = try managedContextTmpAnnee.executeFetchRequest(fetchRequestTmpAnnee) as? [TMPANNEENCOUR]
            
            for tmpannee in fetchResults! {
                currentYear = tmpannee.value_annee as! Int
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }
        
        //Si le mois en cour est Janvier, on change l'année. Sinon on fait juste le mois en cour -1
        if currentMonth == 12 {
            currentMonth = 01
            currentYear++
        } else {
            currentMonth++
        }
        
        //On enregistre les nouvelles valeurs dans les tables TMPMOISENCOUR et TMPANNEENCOUR
        //Table TMPMOISENCOUR
        managedContextTmpMois = appliDelegate.managedObjectContext
        fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        managedContextTmpAnnee = appliDelegate.managedObjectContext
        fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        do {
            if let fetchResults = try managedContextTmpMois.executeFetchRequest(fetchRequestTmpMois) as? [TMPMOISENCOUR] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue(currentMonth, forKey: "value_mois")
                    
                    try managedContextTmpMois.save()
                }
            }
        } catch {
            print("Erreur lors de la sauvegarde des nouvelles données sur la table TMPMOISENCOUR")
        }
        
        do {
            if let fetchResults = try managedContextTmpAnnee.executeFetchRequest(fetchRequestTmpAnnee) as? [TMPANNEENCOUR] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue(currentYear, forKey: "value_annee")
                    
                    try managedContextTmpAnnee.save()
                }
            }
        } catch {
            print("Erreur lors de la sauvegarde des nouvelles données sur la table TMPANNEENCOUR")
        }
        
        updateCalendar(currentMonth, year: currentYear)
    }
    
    @IBAction func showPreviousMonth(sender: AnyObject) {
        var currentYear = Int()
        var currentMonth = Int()
        
        for var i=0; i<CollectionButtonMois.count; i++ {
            CollectionButtonMois[i].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        
        //Table TMPMOISENCOUR
        var managedContextTmpMois = appliDelegate.managedObjectContext
        var fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        var managedContextTmpAnnee = appliDelegate.managedObjectContext
        var fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        //Récupération du mois et de l'année précédent
        do {
            let fetchResults = try managedContextTmpMois.executeFetchRequest(fetchRequestTmpMois) as? [TMPMOISENCOUR]
            
            for tmpmois in fetchResults! {
                currentMonth = tmpmois.value_mois as! Int
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }
        do {
            let fetchResults = try managedContextTmpAnnee.executeFetchRequest(fetchRequestTmpAnnee) as? [TMPANNEENCOUR]
            
            for tmpannee in fetchResults! {
                currentYear = tmpannee.value_annee as! Int
            }
        } catch {
            print("Erreur lors de la récupération des données de la table MODULE")
        }
        
        //Si le mois en cour est Janvier, on change l'année. Sinon on fait juste le mois en cour -1
        if currentMonth == 01 {
            currentMonth = 12
            currentYear--
        } else {
            currentMonth--
        }
        
        //On enregistre les nouvelles valeurs dans les tables TMPMOISENCOUR et TMPANNEENCOUR
        //Table TMPMOISENCOUR
        managedContextTmpMois = appliDelegate.managedObjectContext
        fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        managedContextTmpAnnee = appliDelegate.managedObjectContext
        fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        do {
            if let fetchResults = try managedContextTmpMois.executeFetchRequest(fetchRequestTmpMois) as? [TMPMOISENCOUR] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue(currentMonth, forKey: "value_mois")
                    
                    try managedContextTmpMois.save()
                }
            }
        } catch {
            print("Erreur lors de la sauvegarde des nouvelles données sur la table TMPMOISENCOUR")
        }
        
        do {
            if let fetchResults = try managedContextTmpAnnee.executeFetchRequest(fetchRequestTmpAnnee) as? [TMPANNEENCOUR] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue(currentYear, forKey: "value_annee")
                    
                    try managedContextTmpAnnee.save()
                }
            }
        } catch {
            print("Erreur lors de la sauvegarde des nouvelles données sur la table TMPANNEENCOUR")
        }
        
        updateCalendar(currentMonth, year: currentYear)
    }
    
    func clickButtonDetailSession(sender: UIButton){
        sesID = sender.tag
        self.performSegueWithIdentifier("showModifSession", sender: self)
    }
    
    func changeNameMonth(currentMonth: Int){
        switch currentMonth {
        case 1:
            moisLabel.text = NSLocalizedString("Janvier", comment: "mois calendrier")
        case 2:
            moisLabel.text =  NSLocalizedString("Février", comment: "mois calendrier")
        case 3:
            moisLabel.text =  NSLocalizedString("Mars", comment: "mois calendrier")
        case 4:
            moisLabel.text =  NSLocalizedString("Avril", comment: "mois calendrier")
        case 5:
            moisLabel.text =  NSLocalizedString("Mai", comment: "mois calendrier")
        case 6:
            moisLabel.text =  NSLocalizedString("Juin", comment: "mois calendrier")
        case 7:
            moisLabel.text =  NSLocalizedString("Juillet", comment: "mois calendrier")
        case 8:
            moisLabel.text =  NSLocalizedString("Aout", comment: "mois calendrier")
        case 9:
            moisLabel.text =  NSLocalizedString("Septembre", comment: "mois calendrier")
        case 10:
            moisLabel.text =  NSLocalizedString("Octobre", comment: "mois calendrier")
        case 11:
            moisLabel.text =  NSLocalizedString("Novembre", comment: "mois calendrier")
        case 12:
            moisLabel.text =  NSLocalizedString("Décembre", comment: "mois calendrier")
        default:
            print("Défault")
        }
    }
    
    func updateCalendar(month: Int, year: Int){
        //Table TMPMOISENCOUR
        var managedContextTmpMois = appliDelegate.managedObjectContext
        var fetchRequestTmpMois = NSFetchRequest(entityName: "TMPMOISENCOUR")
        
        //Table TMPANNEENCOUR
        var managedContextTmpAnnee = appliDelegate.managedObjectContext
        var fetchRequestTmpAnnee = NSFetchRequest(entityName: "TMPANNEENCOUR")
        
        CollectionButtonMois.removeAll()
        
        let dateFormatterYear = NSDateFormatter()
        let dateFormatterYearShort = NSDateFormatter()
        let dateFormatterMonth = NSDateFormatter()
        let dateFormatterDay = NSDateFormatter()
        dateFormatterYear.dateFormat = "yyyy"
        dateFormatterYearShort.dateFormat = "yy"
        dateFormatterMonth.dateFormat = "MM"
        dateFormatterDay.dateFormat = "dd"
        let calendar = NSCalendar.currentCalendar()
        var compteurDeJours = 0
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateChange = dateFormatter.dateFromString("01/" + String(month) + "/" + String(year))
        
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: dateChange!, options: [])!
        let nbDay = Int(dateFormatterDay.stringFromDate(endOfMonth))!
        //print(nbDay)
        //print(dateFormatter.stringFromDate(endOfMonth))
        
        //Récupére le "weekday" (le 1 jour du mois)
        let dateForWeekDayComponents = NSDateComponents()
        dateForWeekDayComponents.year = year
        dateForWeekDayComponents.month = month
        
        anneeLabel.text = String(year)
        changeNameMonth(month)
        
        //firstSaturdayMarch2015DateComponents.year = 2015
        //firstSaturdayMarch2015DateComponents.month = 08
        
        let dateForWeekDay = calendar.dateFromComponents(dateForWeekDayComponents)!
        let componentsTest = calendar.components([.Weekday], fromDate: dateForWeekDay)
        //print(componentsTest.weekday)
        
        //Affichage des boutons cachés avant
        for var i=0; i<CollectionButton1.count; i++ {
            CollectionButton1[i].hidden = false
        }
        for var i=0; i<CollectionButton5.count; i++ {
            CollectionButton5[i].hidden = false
        }
        for var i=0; i<CollectionButton6.count; i++ {
            CollectionButton6[i].hidden = false
        }
        
        if componentsTest.weekday <= 6 && componentsTest.weekday != 1 {
            for var i=0; i<CollectionButton6.count; i++ {
                CollectionButton6[i].hidden = true
            }
        } else {
            for var i=0; i<CollectionButton6.count; i++ {
                CollectionButton6[i].hidden = false
            }
        }
        
        switch componentsTest.weekday {
            //Jour de départ : Dimanche
        case 1:
            for var i=0; i<CollectionButton1.count-1; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=6;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            
            for var i=0;i<CollectionButton6.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton6[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton6[i])
                } else {
                    CollectionButton6[i].hidden = true
                }
            }
            //Jour de départ : Lundi
        case 2:
            for var i=0;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            //Jour de départ : Mardi
        case 3:
            CollectionButton1[0].hidden = true
            
            for var i=1;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            //Jour de départ : Mercredi
        case 4:
            for var i=0; i<CollectionButton1.count-5; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=2;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            //Jour de départ : Jeudi
        case 5:
            for var i=0; i<CollectionButton1.count-4; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=3;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            //Jour de départ : Vendredi
        case 6:
            for var i=0; i<CollectionButton1.count-3; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=4;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            
            //Jour de départ : Samedi
        case 7:
            for var i=0; i<CollectionButton1.count-2; i++ {
                CollectionButton1[i].hidden = true
            }
            
            for var i=5;i<CollectionButton1.count;i++ {
                compteurDeJours++
                CollectionButton1[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton1[i])
            }
            
            for var i=0;i<CollectionButton2.count;i++ {
                compteurDeJours++
                CollectionButton2[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton2[i])
            }
            
            for var i=0;i<CollectionButton3.count;i++ {
                compteurDeJours++
                CollectionButton3[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton3[i])
            }
            
            for var i=0;i<CollectionButton4.count;i++ {
                compteurDeJours++
                CollectionButton4[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                CollectionButtonMois.append(CollectionButton4[i])
            }
            
            for var i=0;i<CollectionButton5.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton5[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton5[i])
                } else {
                    CollectionButton5[i].hidden = true
                }
            }
            
            for var i=0;i<CollectionButton6.count;i++ {
                if compteurDeJours < nbDay {
                    compteurDeJours++
                    CollectionButton6[i].setTitle(String(compteurDeJours), forState: UIControlState.Normal)
                    CollectionButtonMois.append(CollectionButton6[i])
                } else {
                    CollectionButton6[i].hidden = true
                }
            }
        default :
            print("Défaut")
        }
        
        for var i=0;i<CollectionButtonMois.count; i++ {
            CollectionButtonMois[i].tag = i+1
            CollectionButtonMois[i].addTarget(self, action: "showSession:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        changeColorButton()
    }
    
    @IBAction func creationSession(sender: AnyObject) {
        createSession = 1
        performSegueWithIdentifier("showModifSession", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showModifSession" {
            let ajoutSessionViewController = segue.destinationViewController as! AjoutSessionViewController
            if createSession == 1 {
                ajoutSessionViewController.isCreation = 1
                ajoutSessionViewController.origine = "calendrier"
                ajoutSessionViewController.moduleID = 0
                ajoutSessionViewController.contactID = 0
                createSession = 0
            } else {
                ajoutSessionViewController.isCreation = 0
                ajoutSessionViewController.sessionID = sesID
                ajoutSessionViewController.origine = "calendrier"
                
            }
        }
    }


}
