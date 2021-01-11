//
//  SubjectTableViewCell.swift
//  MailComposer
//
//  Created by Spencer Whyte on 2016-09-28.
//  Copyright © 2016 Spencer Whyte. All rights reserved.
//

#if canImport(UIKit)

import UIKit

class SubjectTableViewCell: UITableViewCell {

    var subjectTextView: UITextView

    weak var emailSubjectTableViewCellDelegate: SubjectTableViewCellDelegate?

    private var subjectLabel: UILabel

    override init(style: CellStyle, reuseIdentifier: String?) {
        subjectTextView = UITextView()
        subjectLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
}

extension SubjectTableViewCell {
    
    private func setup() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = true
        contentView.autoresizingMask = [.flexibleHeight]
        
        setupTextView()
        setupLabel()
        setupConstraints()
    }
    
    private func setupTextView() {
        subjectTextView.delegate = self
        subjectTextView.translatesAutoresizingMaskIntoConstraints = false
        subjectTextView.isScrollEnabled = false
        subjectTextView.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(subjectTextView)
    }
    
    private func setupLabel() {
        subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        subjectLabel.textColor = UIColor.lightGray
        subjectLabel.text = "Subject:"
        contentView.addSubview(subjectLabel)
    }
    
    private func setupConstraints() {
        let views = [
            "label": subjectLabel,
            "textView": subjectTextView
        ]
        subjectLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        subjectLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        subjectTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[label]-[textView]", options: [], metrics: nil, views: views))
        
        addConstraint(NSLayoutConstraint(item: subjectLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subjectTextView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label(>=49)]", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(6)-[textView]-(6)-|", options: [], metrics: nil, views: views))
    }
}

extension SubjectTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let subject = subjectTextView.text ?? ""
        emailSubjectTableViewCellDelegate?.didUpdateSubject(subjectTableViewCell: self, subject: subject)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            emailSubjectTableViewCellDelegate?.willReturn(subjectTableViewCell: self)
            return false
        }
        return true
    }
    
}

#endif
