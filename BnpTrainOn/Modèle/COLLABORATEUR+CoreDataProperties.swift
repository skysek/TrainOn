//
//  COLLABORATEUR+CoreDataProperties.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 03/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension COLLABORATEUR {

    @NSManaged var col_fonction: String?
    @NSManaged var col_id: NSNumber?
    @NSManaged var col_mail: String?
    @NSManaged var col_nom: String?
    @NSManaged var col_prenom: String?
    @NSManaged var col_telephone: String?
    @NSManaged var ent_id: NSNumber?
    @NSManaged var col_est_responsable: NSNumber?

}
