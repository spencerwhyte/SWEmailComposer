//
//  ReusableCell.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-03-31.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

#if canImport(UIKit)

import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableCell { }

extension ReusableCell where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
}

extension UICollectionViewCell: ReusableCell { }

extension ReusableCell where Self: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

#endif
