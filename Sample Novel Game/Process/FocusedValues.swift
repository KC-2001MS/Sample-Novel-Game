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

struct BackwardActionKey: FocusedValueKey {
    typealias Value = () -> Void
}

struct AutoPlayActionKey: FocusedValueKey {
    typealias Value = () -> Void
}

struct ForwardActionKey: FocusedValueKey {
    typealias Value = () -> Void
}

struct WaitingTimeKey: FocusedValueKey {
    typealias Value = Binding<Double>
}

struct HelpActionKey: FocusedValueKey {
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
    
    var backwardAction: (() -> Void)? {
        get { self[BackwardActionKey.self] }
        set { self[BackwardActionKey.self] = newValue }
    }
    
    var autoPlayAction: (() -> Void)? {
        get { self[AutoPlayActionKey.self] }
        set { self[AutoPlayActionKey.self] = newValue }
    }
    
    var forwardAction: (() -> Void)? {
        get { self[ForwardActionKey.self] }
        set { self[ForwardActionKey.self] = newValue }
    }
    
    var waitingTime: Binding<Double>? {
        get { self[WaitingTimeKey.self] }
        set { self[WaitingTimeKey.self] = newValue }
    }
    
    var helpAction: (() -> Void)? {
        get { self[HelpActionKey.self] }
        set { self[HelpActionKey.self] = newValue }
    }
}
