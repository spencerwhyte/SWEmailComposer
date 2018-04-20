//
//  EmailAddressTableViewCellDelegate.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-14.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

protocol EmailAddressTableViewCellDelegate: class {
    
    func didUpdateEmailAddresses(emailAddressTableViewCell: EmailAddressTableViewCell, emailAddresses: String)
    func willReturn(emailAddressTableViewCell: EmailAddressTableViewCell)
}
