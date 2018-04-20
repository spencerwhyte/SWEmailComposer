//
//  MailComposerTableViewController.swift
//  MailComposer
//
//  Created by Spencer Whyte on 2016-09-28.
//  Copyright © 2016 Spencer Whyte. All rights reserved.
//

import UIKit

public class MailComposerTableViewController: UITableViewController, UITextViewDelegate {

    fileprivate let mailComposerModel: MailComposerModel
    
    fileprivate let toEmailAddressIndexPath = IndexPath(row: 0, section: 0)
    fileprivate let switchIndexPath = IndexPath(row: 1, section: 0)
    fileprivate let fromEmailAddressIndexPath = IndexPath(row: 2, section: 0)
    fileprivate let subjectIndexPath = IndexPath(row: 3, section: 0)
    fileprivate let bodyIndexPath = IndexPath(row: 4, section: 0)
    fileprivate let attachmentsIndexPath = IndexPath(row: 5, section: 0)
    
    fileprivate weak var mailComposerTableViewControllerDelegate: MailComposerTableViewControllerDelegate?

    public init(emailConfig: EmailConfig, delegate: MailComposerTableViewControllerDelegate){
        self.mailComposerTableViewControllerDelegate = delegate
        let emailValidator = DefaultEmailValidator()
        self.mailComposerModel = MailComposerModel(emailConfig: emailConfig, emailValidator: emailValidator)
        super.init(style: .plain)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(done))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not meant to be used with init(coder...)")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.mailComposerModel.emailConfig.toEmail?.isEmpty != false {
            self.toEmailAddressTableViewCell()?.makeEmailAddressFirstResponder()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.updateNavigationTitle()
        self.didChangeModel()
    }
    
    @objc func done(){
        self.dismiss(animated: true) {
            self.mailComposerTableViewControllerDelegate?.didFinishComposingEmail(emailComposer: self, emailConfig: self.mailComposerModel.emailConfig)
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true) {
            self.mailComposerTableViewControllerDelegate?.didCancelComposingEmail(emailComposer: self)
        }
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == toEmailAddressIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailAddressTableViewCell.reuseIdentifier, for: indexPath) as! EmailAddressTableViewCell
            cell.label = "To:"
            cell.emails = attributedStringForEmails(emailAddresses: self.mailComposerModel.emailConfig.toEmail)
            cell.readonly = false
            cell.emailAddressTableViewCellDelegate = self
            return cell
        }else if indexPath == switchIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.textLabel?.text = "Send copy to company email"
            cell.switchState = (self.mailComposerModel.emailConfig.isSendToCompanyEnabled == true)
            cell.switchTableViewCellDelegate = self
            return cell
        } else if indexPath == fromEmailAddressIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailAddressTableViewCell.reuseIdentifier, for: indexPath) as! EmailAddressTableViewCell
            cell.label = "From:"
            cell.emails = attributedStringForEmails(emailAddresses: self.mailComposerModel.emailConfig.fromEmail)
            cell.readonly = true
            cell.emailAddressTableViewCellDelegate = self
            return cell
        }else if indexPath == subjectIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.reuseIdentifier, for: indexPath) as! SubjectTableViewCell
            cell.subjectTextView.text = self.mailComposerModel.emailConfig.subject
            cell.emailSubjectTableViewCellDelegate = self
            return cell
        }else if indexPath == bodyIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: BodyTableViewCell.reuseIdentifier, for: indexPath) as! BodyTableViewCell
            cell.bodyTableViewCellDelegate = self
            cell.bodyText = self.mailComposerModel.emailConfig.body ?? ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentsTableViewCell.reuseIdentifier, for: indexPath) as! AttachmentsTableViewCell
            cell.attachmentName = self.mailComposerModel.emailConfig.attachmentName
            return cell
        }
    }
}

extension MailComposerTableViewController {
    
    fileprivate func setupTableView() {
        self.tableView.register(EmailAddressTableViewCell.self, forCellReuseIdentifier: EmailAddressTableViewCell.reuseIdentifier)
        self.tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
        self.tableView.register(SubjectTableViewCell.self, forCellReuseIdentifier: SubjectTableViewCell.reuseIdentifier)
        self.tableView.register(BodyTableViewCell.self, forCellReuseIdentifier: BodyTableViewCell.reuseIdentifier)
        self.tableView.register(AttachmentsTableViewCell.self, forCellReuseIdentifier: AttachmentsTableViewCell.reuseIdentifier)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func updateNavigationTitle() {
        if self.mailComposerModel.emailConfig.subject?.isEmpty == false {
            self.navigationItem.title = self.mailComposerModel.emailConfig.subject
        } else {
            self.navigationItem.title = "New Message"
        }
    }
    
    fileprivate func toEmailAddressTableViewCell() -> EmailAddressTableViewCell? {
        return self.tableView.cellForRow(at: self.toEmailAddressIndexPath) as? EmailAddressTableViewCell
    }
    
    fileprivate func fromEmailAddressTableViewCell() -> EmailAddressTableViewCell? {
        return self.tableView.cellForRow(at: self.fromEmailAddressIndexPath) as? EmailAddressTableViewCell
    }
    
    fileprivate func subjectTableViewCell() -> SubjectTableViewCell? {
        return self.tableView.cellForRow(at: self.subjectIndexPath) as? SubjectTableViewCell
    }
    
    fileprivate func bodyTableViewCell() -> BodyTableViewCell? {
        return self.tableView.cellForRow(at: self.bodyIndexPath) as? BodyTableViewCell
    }
    
    fileprivate func didChangeModel() {
        let toEmailIsEffectivelyEmpty: Bool = (self.mailComposerModel.emailConfig.toEmail?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty != false)
        let isCompositionValid = (self.mailComposerModel.extractToEmails().count > 0 || (toEmailIsEffectivelyEmpty && self.mailComposerModel.emailConfig.isSendToCompanyEnabled == true)) && self.mailComposerModel.isSubjectValid()
        self.navigationItem.rightBarButtonItem?.isEnabled = isCompositionValid
    }
    
    fileprivate func updateCellSize() {
        DispatchQueue.main.async { // HACK TO HANDLE AN IOS BUG: http://danspinosa.com/post/121100186427/apple-cmon-with-the-docs
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    fileprivate func attributedStringForEmails(emailAddresses: String?) -> NSAttributedString {
        guard let emailAddresses = emailAddresses else {
            return NSAttributedString()
        }
        let attributedEmailsString = NSMutableAttributedString(string: emailAddresses)
        let ranges = mailComposerModel.extractEmails(email: emailAddresses)
        for range in ranges {
            attributedEmailsString.addAttribute(NSAttributedStringKey.foregroundColor, value: self.view.tintColor, range: range)
        }
        return attributedEmailsString
    }
}

extension MailComposerTableViewController: BodyTableViewCellDelegate {
    
    func shouldUpdateCellSize(bodyTableViewCell: BodyTableViewCell) {
        self.updateCellSize()
    }
    
    func didUpdateBodyText(bodyTableViewCell: BodyTableViewCell, text: String) {
        self.mailComposerModel.emailConfig.body = text
        self.didChangeModel()
    }
}

extension MailComposerTableViewController: EmailAddressTableViewCellDelegate {
    
    func didUpdateEmailAddresses(emailAddressTableViewCell: EmailAddressTableViewCell, emailAddresses: String) {
        if emailAddressTableViewCell === self.toEmailAddressTableViewCell() {
            self.mailComposerModel.emailConfig.toEmail = emailAddresses
            emailAddressTableViewCell.emails = attributedStringForEmails(emailAddresses: emailAddresses)
        } else if emailAddressTableViewCell === self.fromEmailAddressTableViewCell() {
            self.mailComposerModel.emailConfig.fromEmail = emailAddresses
        }
        self.didChangeModel()
    }
    
    func willReturn(emailAddressTableViewCell: EmailAddressTableViewCell) {
        if emailAddressTableViewCell === self.toEmailAddressTableViewCell() {
            self.subjectTableViewCell()?.subjectTextView.becomeFirstResponder()
        }
    }
}

extension MailComposerTableViewController: SubjectTableViewCellDelegate {
    
    func didUpdateSubject(subjectTableViewCell: SubjectTableViewCell, subject: String) {
        self.mailComposerModel.emailConfig.subject = subject
        self.updateNavigationTitle()
        self.didChangeModel()
        self.updateCellSize()
    }
    
    func willReturn(subjectTableViewCell: SubjectTableViewCell) {
        self.bodyTableViewCell()?.textView.becomeFirstResponder()
    }
}

extension MailComposerTableViewController: SwitchTableViewCellDelegate {
    
    func didUpdateSwitchState(switchTableViewCell: SwitchTableViewCell, state: Bool) {
        self.mailComposerModel.emailConfig.isSendToCompanyEnabled = state
        self.didChangeModel()
    }
}
