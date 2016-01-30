//
//  ENTREPRISE+CoreDataProperties.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 07/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ENTREPRISE {

    @NSManaged var ent_adresse: String?
    @NSManaged var ent_id: NSNumber?
    @NSManaged var ent_nom: String?
    @NSManaged var ent_telephone: String?

}
