//
//  ViewController.swift
//  SWEmailComposer
//
//  Created by Spencer Whyte on 04/18/2018.
//  Copyright (c) 2018 Spencer Whyte. All rights reserved.
//

import UIKit
import SWEmailComposer

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var emailConfig = EmailConfig()
        emailConfig.fromEmail = "spencerwhyte@gmail.com"
        emailConfig.subject = "Your estimate from Toolbelt Test"
        emailConfig.body = "Thank you for your business"
        
        let composer = MailComposerTableViewController(emailConfig: emailConfig, delegate: self)
        let navigationController = UINavigationController(rootViewController: composer)
        self.present(navigationController, animated: true)
    }
    
}

extension ViewController: MailComposerTableViewControllerDelegate {
    
    func didFinishComposingEmail(emailComposer: MailComposerTableViewController, emailConfig: EmailConfig) {
        print("didFinishComposingEmail(..)")
        print(emailConfig)
    }
    
    func didCancelComposingEmail(emailComposer: MailComposerTableViewController) {
        print("didCancelComposingEmail(..)")
    }
}
