//
//  SwitchTableViewCellDelegate.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-16.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {

    func didUpdateSwitchState(switchTableViewCell: SwitchTableViewCell, state: Bool)
    
}
