//
//  SubjectTableViewCellDelegate.swift
//  EmailComposer
//
//  Created by Spencer Whyte on 2018-04-14.
//  Copyright © 2018 WorldReach Software. All rights reserved.
//

#if canImport(UIKit)

protocol SubjectTableViewCellDelegate: class {
    
    func didUpdateSubject(subjectTableViewCell: SubjectTableViewCell, subject: String)
    func willReturn(subjectTableViewCell: SubjectTableViewCell)
}

#endif
