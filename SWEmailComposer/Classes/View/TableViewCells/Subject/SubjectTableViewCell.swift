//
//  SubjectTableViewCell.swift
//  MailComposer
//
//  Created by Spencer Whyte on 2016-09-28.
//  Copyright © 2016 Spencer Whyte. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    var subjectTextView: UITextView
    fileprivate var subjectLabel: UILabel
    weak var emailSubjectTableViewCellDelegate: SubjectTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.subjectTextView = UITextView()
        self.subjectLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
}

extension SubjectTableViewCell {
    
    fileprivate func setup() {
        self.selectionStyle = .none
        self.preservesSuperviewLayoutMargins = true
        
        self.setupTextView()
        self.setupLabel()
        self.setupConstraints()
    }
    
    fileprivate func setupTextView() {
        self.subjectTextView.delegate = self
        self.subjectTextView.translatesAutoresizingMaskIntoConstraints = false
        self.subjectTextView.isScrollEnabled = false
        self.subjectTextView.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(self.subjectTextView)
    }
    
    fileprivate func setupLabel() {
        self.subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subjectLabel.textColor = UIColor.lightGray
        self.subjectLabel.text = "Subject:"
        self.addSubview(self.subjectLabel)
    }
    
    fileprivate func setupConstraints() {
        let views = [
            "label": self.subjectLabel,
            "textView": self.subjectTextView
        ]
        self.subjectLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.subjectLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        self.subjectTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[label]-[textView]", options: [], metrics: nil, views: views))
        
        self.addConstraint(NSLayoutConstraint(item: self.subjectLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.subjectTextView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label(>=49)]", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(6)-[textView]-(6)-|", options: [], metrics: nil, views: views))
    }
}

extension SubjectTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let subject = self.subjectTextView.text ?? ""
        self.emailSubjectTableViewCellDelegate?.didUpdateSubject(subjectTableViewCell: self, subject: subject)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.emailSubjectTableViewCellDelegate?.willReturn(subjectTableViewCell: self)
            return false
        }
        return true
    }
    
}
