//
//  LOGIN+CoreDataProperties.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 23/10/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LOGIN {

    @NSManaged var log_id: NSNumber?
    @NSManaged var log_username: String?
    @NSManaged var log_password: String?
    @NSManaged var log_test: String?

}
