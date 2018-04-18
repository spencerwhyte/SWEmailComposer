//
//  MailComposerTableViewControllerDelegate.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-14.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

public protocol MailComposerTableViewControllerDelegate: class {
    
    func didFinishComposingEmail(emailComposer: MailComposerTableViewController, emailConfig: EmailConfig)
    func didCancelComposingEmail(emailComposer: MailComposerTableViewController)
}
