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
    
    fileprivate let switchView: UISwitch
    
    var switchState: Bool {
        get {
            return switchView.isOn
        }
        set(newSwitchState) {
            self.switchView.isOn = newSwitchState
        }
    }
    
    weak var switchTableViewCellDelegate: SwitchTableViewCellDelegate?
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        self.switchView = UISwitch()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not intended to be inited with aDecoder")
    }
    
    @objc func switchChanged() {
        self.switchTableViewCellDelegate?.didUpdateSwitchState(switchTableViewCell: self, state: self.switchView.isOn)
    }
}

extension SwitchTableViewCell {
    
    fileprivate func setup() {
        self.selectionStyle = .none
        self.textLabel?.textColor = UIColor.lightGray
        
        self.setupSwitch()
    }
    
    fileprivate func setupSwitch() {
        self.accessoryView = self.switchView
        self.switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
}

#endif
