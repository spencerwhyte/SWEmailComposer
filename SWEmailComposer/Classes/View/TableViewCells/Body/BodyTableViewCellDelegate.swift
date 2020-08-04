//
//  BodyTableViewCellDelegate.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-07.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

#if canImport(UIKit)

import UIKit

protocol BodyTableViewCellDelegate: class {

    func shouldUpdateCellSize(bodyTableViewCell: BodyTableViewCell)
    func didUpdateBodyText(bodyTableViewCell: BodyTableViewCell, text: String)
    
}

#endif
