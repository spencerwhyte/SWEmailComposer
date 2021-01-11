//
//  MailComposerTableViewController.swift
//  MailComposer
//
//  Created by Spencer Whyte on 2016-09-28.
//  Copyright © 2016 Spencer Whyte. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class MailComposerTableViewController: UITableViewController, UITextViewDelegate {

    private weak var mailComposerTableViewControllerDelegate: MailComposerTableViewControllerDelegate?

    private let mailComposerModel: MailComposerModel

    private let toEmailAddressIndexPath = IndexPath(row: 0, section: 0)
    private let switchIndexPath = IndexPath(row: 1, section: 0)
    private let fromEmailAddressIndexPath = IndexPath(row: 2, section: 0)
    private let subjectIndexPath = IndexPath(row: 3, section: 0)
    private let bodyIndexPath = IndexPath(row: 4, section: 0)
    private let attachmentsIndexPath = IndexPath(row: 5, section: 0)

    public init(emailConfig: EmailConfig, delegate: MailComposerTableViewControllerDelegate){
        mailComposerTableViewControllerDelegate = delegate
        let emailValidator = DefaultEmailValidator()
        mailComposerModel = MailComposerModel(emailConfig: emailConfig, emailValidator: emailValidator)
        super.init(style: .plain)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not meant to be used with init(coder...)")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mailComposerModel.emailConfig.toEmail?.isEmpty != false {
            toEmailAddressTableViewCell()?.makeEmailAddressFirstResponder()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateNavigationTitle()
        didChangeModel()
    }
    
    @objc func done(){
        dismiss(animated: true) {
            self.mailComposerTableViewControllerDelegate?.didFinishComposingEmail(emailComposer: self, emailConfig: self.mailComposerModel.emailConfig)
        }
    }
    
    @objc func cancel(){
        dismiss(animated: true) {
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
            cell.emails = attributedStringForEmails(emailAddresses: mailComposerModel.emailConfig.toEmail)
            cell.readonly = false
            cell.emailAddressTableViewCellDelegate = self
            return cell
        }else if indexPath == switchIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.textLabel?.text = "Send copy to company email"
            cell.switchState = (mailComposerModel.emailConfig.isSendToCompanyEnabled == true)
            cell.switchTableViewCellDelegate = self
            return cell
        } else if indexPath == fromEmailAddressIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailAddressTableViewCell.reuseIdentifier, for: indexPath) as! EmailAddressTableViewCell
            cell.label = "From:"
            cell.emails = attributedStringForEmails(emailAddresses: mailComposerModel.emailConfig.fromEmail)
            cell.readonly = true
            cell.emailAddressTableViewCellDelegate = self
            return cell
        }else if indexPath == subjectIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.reuseIdentifier, for: indexPath) as! SubjectTableViewCell
            cell.subjectTextView.text = mailComposerModel.emailConfig.subject
            cell.emailSubjectTableViewCellDelegate = self
            return cell
        }else if indexPath == bodyIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: BodyTableViewCell.reuseIdentifier, for: indexPath) as! BodyTableViewCell
            cell.bodyTableViewCellDelegate = self
            cell.bodyText = mailComposerModel.emailConfig.body ?? ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentsTableViewCell.reuseIdentifier, for: indexPath) as! AttachmentsTableViewCell
            cell.attachmentName = mailComposerModel.emailConfig.attachmentName
            return cell
        }
    }
}

extension MailComposerTableViewController {
    
    private func setupTableView() {
        tableView.register(EmailAddressTableViewCell.self, forCellReuseIdentifier: EmailAddressTableViewCell.reuseIdentifier)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
        tableView.register(SubjectTableViewCell.self, forCellReuseIdentifier: SubjectTableViewCell.reuseIdentifier)
        tableView.register(BodyTableViewCell.self, forCellReuseIdentifier: BodyTableViewCell.reuseIdentifier)
        tableView.register(AttachmentsTableViewCell.self, forCellReuseIdentifier: AttachmentsTableViewCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func updateNavigationTitle() {
        if mailComposerModel.emailConfig.subject?.isEmpty == false {
            navigationItem.title = mailComposerModel.emailConfig.subject
        } else {
            navigationItem.title = "New Message"
        }
    }
    
    private func toEmailAddressTableViewCell() -> EmailAddressTableViewCell? {
        return tableView.cellForRow(at: toEmailAddressIndexPath) as? EmailAddressTableViewCell
    }
    
    private func fromEmailAddressTableViewCell() -> EmailAddressTableViewCell? {
        return tableView.cellForRow(at: fromEmailAddressIndexPath) as? EmailAddressTableViewCell
    }
    
    private func subjectTableViewCell() -> SubjectTableViewCell? {
        return tableView.cellForRow(at: subjectIndexPath) as? SubjectTableViewCell
    }
    
    private func bodyTableViewCell() -> BodyTableViewCell? {
        return tableView.cellForRow(at: bodyIndexPath) as? BodyTableViewCell
    }
    
    private func didChangeModel() {
        let toEmailIsEffectivelyEmpty: Bool = (mailComposerModel.emailConfig.toEmail?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty != false)
        let isCompositionValid = (mailComposerModel.extractToEmails().count > 0 || (toEmailIsEffectivelyEmpty && mailComposerModel.emailConfig.isSendToCompanyEnabled == true)) && mailComposerModel.isSubjectValid()
        navigationItem.rightBarButtonItem?.isEnabled = isCompositionValid
    }
    
    private func updateCellSize() {
        DispatchQueue.main.async { // HACK TO HANDLE AN IOS BUG: http://danspinosa.com/post/121100186427/apple-cmon-with-the-docs
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    private func attributedStringForEmails(emailAddresses: String?) -> NSAttributedString {
        guard let emailAddresses = emailAddresses else {
            return NSAttributedString()
        }
        let attributedEmailsString = NSMutableAttributedString(string: emailAddresses)
        let ranges = mailComposerModel.extractEmails(email: emailAddresses)
        for range in ranges {
            attributedEmailsString.addAttribute(NSAttributedString.Key.foregroundColor, value: view.tintColor, range: range)
        }
        return attributedEmailsString
    }
}

extension MailComposerTableViewController: BodyTableViewCellDelegate {
    
    func shouldUpdateCellSize(bodyTableViewCell: BodyTableViewCell) {
        updateCellSize()
    }
    
    func didUpdateBodyText(bodyTableViewCell: BodyTableViewCell, text: String) {
        mailComposerModel.emailConfig.body = text
        didChangeModel()
    }
}

extension MailComposerTableViewController: EmailAddressTableViewCellDelegate {
    
    func didUpdateEmailAddresses(emailAddressTableViewCell: EmailAddressTableViewCell, emailAddresses: String) {
        if emailAddressTableViewCell === toEmailAddressTableViewCell() {
            mailComposerModel.emailConfig.toEmail = emailAddresses
            emailAddressTableViewCell.emails = attributedStringForEmails(emailAddresses: emailAddresses)
        } else if emailAddressTableViewCell === fromEmailAddressTableViewCell() {
            mailComposerModel.emailConfig.fromEmail = emailAddresses
        }
        didChangeModel()
    }
    
    func willReturn(emailAddressTableViewCell: EmailAddressTableViewCell) {
        if emailAddressTableViewCell === toEmailAddressTableViewCell() {
            subjectTableViewCell()?.subjectTextView.becomeFirstResponder()
        }
    }
}

extension MailComposerTableViewController: SubjectTableViewCellDelegate {
    
    func didUpdateSubject(subjectTableViewCell: SubjectTableViewCell, subject: String) {
        mailComposerModel.emailConfig.subject = subject
        updateNavigationTitle()
        didChangeModel()
        updateCellSize()
    }
    
    func willReturn(subjectTableViewCell: SubjectTableViewCell) {
        bodyTableViewCell()?.textView.becomeFirstResponder()
    }
}

extension MailComposerTableViewController: SwitchTableViewCellDelegate {
    
    func didUpdateSwitchState(switchTableViewCell: SwitchTableViewCell, state: Bool) {
        mailComposerModel.emailConfig.isSendToCompanyEnabled = state
        didChangeModel()
    }
}

#endif
