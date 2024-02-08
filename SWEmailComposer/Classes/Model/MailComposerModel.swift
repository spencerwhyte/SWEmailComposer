//
//  MailComposerModel.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-14.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

import Foundation

class MailComposerModel {

    var emailConfig: EmailConfig
    let emailValidator: EmailValidator
    
    init(emailConfig: EmailConfig, emailValidator: EmailValidator) {
        self.emailConfig = emailConfig
        self.emailValidator = emailValidator
    }
    
    func extractToEmails() -> [NSRange] {
        return extractEmails(email: self.emailConfig.toEmail)
    }
    
    func isFromEmailValid() -> Bool {
        return extractEmails(email: self.emailConfig.fromEmail).count == 1
    }
    
    func isSubjectValid() -> Bool {
        return (self.emailConfig.subject?.isEmpty == false)
    }
    
    func isBodyValid() -> Bool {
        return (self.emailConfig.body?.isEmpty == false)
    }
    
    func extractEmails(email: String?) -> [NSRange] {
        guard let email = email else {
            return []
        }
        let ranges = self.emailValidator.extractEmails(email: email)
        if emailConfig.allowMultipleEmails == true {
            return ranges
        } else {
            if ranges.count == 1 && ranges.first?.length == email.trimmingCharacters(in: .whitespacesAndNewlines).count {
                return ranges
            } else {
                return []
            }
        }
    }
}

