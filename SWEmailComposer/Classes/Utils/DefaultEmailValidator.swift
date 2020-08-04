//
//  DefaultEmailValidator.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-15.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

import Foundation

class DefaultEmailValidator: EmailValidator {
    

    func extractEmails(email: String) -> [NSRange] {
        guard !email.lowercased().contains("mailto:") else { return [] }
        guard let emailDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return [] }
        let matches = emailDetector.matches(in: email, options: [], range: NSRange(location: 0, length: email.count))
        var ranges = [NSRange]()
        for match in matches {
            if match.url?.scheme == "mailto" {
                ranges.append(match.range)
            }
        }
        return ranges
    }
}
