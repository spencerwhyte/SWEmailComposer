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

    private let attachmentLabel = UILabel()
    private let fileExtensionLabel = UILabel()
    private let attachmentIcon = UIImageView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
}

extension AttachmentsTableViewCell {
    
    private func setup() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = true
        contentView.autoresizingMask = [.flexibleHeight]
        
        setupLabel()
        setupIcon()
        setupFileExtensionLabel()
        setupConstraints()
    }
    
    private func setupLabel() {
        attachmentLabel.translatesAutoresizingMaskIntoConstraints = false
        attachmentLabel.textAlignment = .center
        attachmentLabel.textColor = UIColor.gray
        attachmentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(attachmentLabel)
    }
    
    private func setupIcon() {
        attachmentIcon.translatesAutoresizingMaskIntoConstraints = false
        //attachmentIcon.image = UIImage(named: "attachmentIcon", in: Bundle.module, compatibleWith: nil)
        attachmentIcon.tintColor = UIColor.gray
        attachmentIcon.contentMode = .scaleAspectFit
        contentView.addSubview(attachmentIcon)
    }
    
    private func setupFileExtensionLabel() {
        fileExtensionLabel.translatesAutoresizingMaskIntoConstraints = false
        fileExtensionLabel.textColor = fileExtensionLabel.tintColor
        fileExtensionLabel.font = UIFont.boldSystemFont(ofSize: 12)
        contentView.addSubview(fileExtensionLabel)
    }
    
    private func setupConstraints() {
        contentView.addConstraints([
            attachmentIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            attachmentIcon.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            attachmentIcon.heightAnchor.constraint(equalToConstant: 50),
            attachmentLabel.topAnchor.constraint(equalToSystemSpacingBelow: attachmentIcon.bottomAnchor, multiplier: 1.0),
            attachmentLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            attachmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attachmentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fileExtensionLabel.centerXAnchor.constraint(equalTo: attachmentIcon.centerXAnchor),
            fileExtensionLabel.centerYAnchor.constraint(equalTo: attachmentIcon.centerYAnchor)
        ])
    }
}

#endif
