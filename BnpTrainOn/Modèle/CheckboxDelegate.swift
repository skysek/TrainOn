//
//  CheckboxDelegate.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 02/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import Foundation

protocol CheckboxDelegate {
    func didSelectCheckbox(state: Bool, identifier: Int, title: String);
}