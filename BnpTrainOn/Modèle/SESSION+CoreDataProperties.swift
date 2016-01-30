//
//  SESSION+CoreDataProperties.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 08/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SESSION {

    @NSManaged var ses_date: String?
    @NSManaged var ses_detail: String?
    @NSManaged var ses_heure_deb: String?
    @NSManaged var ses_id: NSNumber?
    @NSManaged var ses_nom: String?
    @NSManaged var ses_heure_fin: String?

}
