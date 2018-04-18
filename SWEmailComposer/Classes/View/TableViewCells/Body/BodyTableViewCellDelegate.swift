//
//  BodyTableViewCellDelegate.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-07.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

import UIKit

protocol BodyTableViewCellDelegate: class {

    func shouldUpdateCellSize(bodyTableViewCell: BodyTableViewCell)
    func didUpdateBodyText(bodyTableViewCell: BodyTableViewCell, text: String)
    
}
