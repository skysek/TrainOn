//
//  MODULE+CoreDataProperties.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 04/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MODULE {

    @NSManaged var cat_id: NSNumber?
    @NSManaged var mod_detail: String?
    @NSManaged var mod_id: NSNumber?
    @NSManaged var mod_nom: String?

}
