//
//  EmailConfig.swift
//  MailComposer
//
//  Created by Spencer Whyte on 2016-09-28.
//  Copyright © 2016 Spencer Whyte. All rights reserved.
//

public struct EmailConfig {

    public init() {
        
    }
    
    public var toEmail: String?
    public var fromEmail: String?
    public var subject: String?
    public var body: String?
    public var attachmentName: String?
    public var isSendToCompanyEnabled: Bool?
    public var allowMultipleEmails: Bool?
}
