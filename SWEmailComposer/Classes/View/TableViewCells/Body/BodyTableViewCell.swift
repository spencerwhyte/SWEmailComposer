//
//  BodyTableViewCell.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-03-31.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

import UIKit

class BodyTableViewCell: UITableViewCell {

    weak var bodyTableViewCellDelegate: BodyTableViewCellDelegate?
    fileprivate let textView: UITextView
    
    var bodyText: String {
        get {
            return self.textView.text
        }
        set(newBodyText) {
            self.textView.text = newBodyText
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.textView = UITextView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
}

extension BodyTableViewCell {
    
    fileprivate func setup() {
        self.contentView.autoresizingMask = .flexibleHeight
        self.preservesSuperviewLayoutMargins = true
        self.selectionStyle = .none
        self.setupTextView()
        self.setupConstraints()
    }
    
    fileprivate func setupTextView() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.isScrollEnabled = false
        self.textView.font = UIFont.systemFont(ofSize: 17)
        self.textView.delegate = self
        self.textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.textView.textContainer.lineFragmentPadding = 0
        
        self.addSubview(self.textView)
    }
    
    fileprivate func setupConstraints() {
        let views = [
            "textView": self.textView
        ]
        self.addConstraint(NSLayoutConstraint(item: self.textView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.textView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textView(>=120)]-|", options: [], metrics: nil, views: views))
    }
}

extension BodyTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let bodyText = self.textView.text ?? ""
        self.bodyTableViewCellDelegate?.didUpdateBodyText(bodyTableViewCell: self, text: bodyText)
        self.bodyTableViewCellDelegate?.shouldUpdateCellSize(bodyTableViewCell: self)
    }
}
