//
//  FocusedValues.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/18.
//


import Foundation
import SwiftUI

struct SaveActionKey: FocusedValueKey {
    typealias Value = () -> Void
}

struct LoadActionKey: FocusedValueKey {
    typealias Value = () -> Void
}

struct GoTitleActionKey: FocusedValueKey {
    typealias Value = () -> Void
}

extension FocusedValues {
    var saveAction: (() -> Void)? {
        get { self[SaveActionKey.self] }
        set { self[SaveActionKey.self] = newValue }
    }
    
    var loadAction: (() -> Void)? {
        get { self[LoadActionKey.self] }
        set { self[LoadActionKey.self] = newValue }
    }
    
    var goTitleAction: (() -> Void)? {
        get { self[GoTitleActionKey.self] }
        set { self[GoTitleActionKey.self] = newValue }
    }
}
