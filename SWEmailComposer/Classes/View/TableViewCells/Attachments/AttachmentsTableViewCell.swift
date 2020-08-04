//
//  AttachmentsTableViewCell.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-15.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

#if canImport(UIKit)

import UIKit

class AttachmentsTableViewCell: UITableViewCell {

    fileprivate let attachmentLabel: UILabel
    fileprivate let fileExtensionLabel: UILabel
    fileprivate let attachmentIcon: UIImageView

    var attachmentName: String? {
        didSet {
            attachmentLabel.text = attachmentName
            let attachmentNameComponents = attachmentName?.components(separatedBy: ".")
            if let fileExtension = attachmentNameComponents?.last?.uppercased() {
                fileExtensionLabel.text = fileExtension
            } else {
                fileExtensionLabel.text = ""
            }
        }
    }
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        self.attachmentLabel = UILabel()
        self.fileExtensionLabel = UILabel()
        self.attachmentIcon = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
}

extension AttachmentsTableViewCell {
    
    fileprivate func setup() {
        self.selectionStyle = .none
        self.preservesSuperviewLayoutMargins = true
        
        self.setupLabel()
        self.setupIcon()
        self.setupFileExtensionLabel()
        self.setupConstraints()
    }
    
    fileprivate func setupLabel() {
        self.attachmentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.attachmentLabel.textAlignment = .center
        self.attachmentLabel.textColor = UIColor.gray
        self.attachmentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.addSubview(self.attachmentLabel)
    }
    
    fileprivate func setupIcon() {
        self.attachmentIcon.translatesAutoresizingMaskIntoConstraints = false
        let podBundle = Bundle(for: AttachmentsTableViewCell.classForCoder())
        if let bundleUrl = podBundle.url(forResource: "SWEmailComposer", withExtension: "bundle") {
            let bundle = Bundle(url: bundleUrl)
            self.attachmentIcon.image = UIImage(named: "attachmentIcon", in: bundle , compatibleWith: nil)
        }
        self.attachmentIcon.tintColor = UIColor.gray
        self.attachmentIcon.contentMode = .scaleAspectFit
        self.addSubview(self.attachmentIcon)
    }
    
    fileprivate func setupFileExtensionLabel() {
        self.fileExtensionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.fileExtensionLabel.textColor = self.fileExtensionLabel.tintColor
        self.fileExtensionLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.addSubview(self.fileExtensionLabel)
    }
    
    fileprivate func setupConstraints() {
        let views = [
            "label": self.attachmentLabel,
            "icon": self.attachmentIcon
        ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[icon]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[icon(50)]-[label]-|", options: [], metrics: nil, views: views))
        
        self.addConstraint(NSLayoutConstraint(item: self.fileExtensionLabel, attribute: .centerX, relatedBy: .equal, toItem: self.attachmentIcon, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.fileExtensionLabel, attribute: .centerY, relatedBy: .equal, toItem: self.attachmentIcon, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

#endif
