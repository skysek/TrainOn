//
//  SESSIONCOLLABORATEUR+CoreDataProperties.swift
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

extension SESSIONCOLLABORATEUR {

    @NSManaged var col_id: NSNumber?
    @NSManaged var ses_id: NSNumber?
    @NSManaged var prog_id:NSNumber?
    @NSManaged var pre_id: NSNumber?

}
