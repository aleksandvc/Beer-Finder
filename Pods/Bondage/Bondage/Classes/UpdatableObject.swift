//
//  UpdatableObject.swift
//  PayTalkClient
//
//  Created by dyanko.yovchev on 2/22/17.
//  Copyright © 2017 dyanko.yovchev. All rights reserved.
//

import Foundation

public class UpdatableObject<T: Equatable>: BindableObject<T> {
    
    private var shouldUpdate: Bool = false
    
    /// The value/acutal data/ wrapped by the Bindable
    override public var value: T? {
        willSet {
            shouldUpdate = newValue != value
        }
    }
    
    /// The initializer of Bindable instance
    ///
    /// - Parameter value: a default value of the template type if needed or nil
    override public init(_ value: T?) {
        super.init(value)
    }
    
    override func executeClosures(newValue: T?) {
        if shouldUpdate {
            shouldUpdate = false
            super.executeClosures(newValue: value)
        }
    }
}
