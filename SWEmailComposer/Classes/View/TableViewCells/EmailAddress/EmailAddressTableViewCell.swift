//
//  EmailAddressTableViewCell.swift
//  MailComposer
//
//  Created by Spencer Whyte on 2016-09-28.
//  Copyright © 2016 Spencer Whyte. All rights reserved.
//

import UIKit

class EmailAddressTableViewCell: UITableViewCell {

    fileprivate var emailTextField: UITextField
    fileprivate var emailLabel: UILabel
    
    weak var emailAddressTableViewCellDelegate: EmailAddressTableViewCellDelegate?
    var emails: NSAttributedString? {
        get {
            return emailTextField.attributedText
        }
        set(newEmails) {
            let cursorPosition = emailTextField.selectedTextRange
            emailTextField.attributedText = newEmails
            emailTextField.selectedTextRange = cursorPosition
        }
    }
    var label: String? {
        get {
            return emailLabel.text
        }
        set(newLabel) {
            emailLabel.text = newLabel
        }
    }
    var readonly: Bool = false {
        didSet {
            if readonly {
                self.emailTextField.textColor = UIColor.lightGray
                self.emailTextField.isUserInteractionEnabled = false
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.emailTextField = UITextField()
        self.emailLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
    
    func makeEmailAddressFirstResponder() {
        self.emailTextField.becomeFirstResponder()
    }
    
    @objc func emailTextChanged(){
        let emailAddresses = self.emailTextField.text ?? ""
        self.emailAddressTableViewCellDelegate?.didUpdateEmailAddresses(emailAddressTableViewCell: self, emailAddresses: emailAddresses)
    }
    
}

extension EmailAddressTableViewCell {
    
    fileprivate func setup() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = true
        setupTextView()
        setupLabel()
        setupConstraints()
    }
    
    fileprivate func setupLabel() {
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailLabel.textColor = UIColor.lightGray
        self.addSubview(self.emailLabel)
    }
    
    fileprivate func setupTextView() {
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextField.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        self.emailTextField.delegate = self
        self.emailTextField.keyboardType = .emailAddress
        self.addSubview(self.emailTextField)
    }
    
    fileprivate func setupConstraints() {
        let views = [
            "label": self.emailLabel,
            "textField": self.emailTextField
        ]
        self.emailLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.emailLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.emailTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.addConstraint(NSLayoutConstraint(item: self.emailLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.emailTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[label]-[textField]", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label(>=49)]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField(>=49)]|", options: [], metrics: nil, views: views))
    }
}

extension EmailAddressTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailAddressTableViewCellDelegate?.willReturn(emailAddressTableViewCell: self)
        return false
    }
    
}
