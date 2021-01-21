//
//  EmailAddressTableViewCell.swift
//  MailComposer
//
//  Created by Spencer Whyte on 2016-09-28.
//  Copyright © 2016 Spencer Whyte. All rights reserved.
//

#if canImport(UIKit)

import UIKit

class EmailAddressTableViewCell: UITableViewCell {

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
                emailTextField.textColor = UIColor.lightGray
                emailTextField.isUserInteractionEnabled = false
            }
        }
    }

    private let emailTextField = UITextField()
    private let emailLabel = UILabel()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
    
    func makeEmailAddressFirstResponder() {
        emailTextField.becomeFirstResponder()
    }
    
    @objc func emailTextChanged(){
        let emailAddresses = emailTextField.text ?? ""
        emailAddressTableViewCellDelegate?.didUpdateEmailAddresses(emailAddressTableViewCell: self, emailAddresses: emailAddresses)
    }
    
}

extension EmailAddressTableViewCell {
    
    private func setup() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = true
        contentView.autoresizingMask = [.flexibleHeight]

        setupTextView()
        setupLabel()
        setupConstraints()
    }
    
    private func setupLabel() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textColor = UIColor.lightGray
        contentView.addSubview(emailLabel)
    }
    
    private func setupTextView() {
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        contentView.addSubview(emailTextField)
    }
    
    private func setupConstraints() {
        let views = [
            "label": emailLabel,
            "textField": emailTextField
        ]
        emailLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        emailLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        emailTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.addConstraint(NSLayoutConstraint(item: emailLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: emailTextField, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[label]-[textField]", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label(>=49)]|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField(>=49)]|", options: [], metrics: nil, views: views))
    }
}

extension EmailAddressTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailAddressTableViewCellDelegate?.willReturn(emailAddressTableViewCell: self)
        return false
    }
    
}

#endif
