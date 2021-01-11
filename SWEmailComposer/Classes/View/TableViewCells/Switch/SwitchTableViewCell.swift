//
//  SwitchTableViewCell.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-16.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

#if canImport(UIKit)

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    private let switchView = UISwitch()
    
    var switchState: Bool {
        get {
            return switchView.isOn
        }
        set(newSwitchState) {
            switchView.isOn = newSwitchState
        }
    }
    
    weak var switchTableViewCellDelegate: SwitchTableViewCellDelegate?
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
    
    @objc func switchChanged() {
        switchTableViewCellDelegate?.didUpdateSwitchState(switchTableViewCell: self, state: switchView.isOn)
    }
}

extension SwitchTableViewCell {
    
    private func setup() {
        selectionStyle = .none
        textLabel?.textColor = UIColor.lightGray
        
        setupSwitch()
    }
    
    private func setupSwitch() {
        accessoryView = switchView
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
}

#endif
