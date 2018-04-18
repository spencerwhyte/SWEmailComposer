//
//  EmailValidator.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-15.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

import UIKit

protocol EmailValidator {

    func extractEmails(email: String) -> [NSRange]
    
}
