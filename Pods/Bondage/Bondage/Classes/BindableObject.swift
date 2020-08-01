//
//  BindableObject.swift
//  PayTalkClient
//
//  Created by dyanko.yovchev on 2/22/17.
//  Copyright © 2017 dyanko.yovchev. All rights reserved.
//

import Foundation

public class BindableObject<T>: Bindable {
    /// The type of the closure which the Bindable operates on
    public typealias Closure = (T?) -> Void
    
    /// The value/acutal data/ wrapped by the Bindable
    public var value: T? {
        didSet {
            executeClosures(newValue: value)
        }
    }
    
    private var closures: [Closure] = []
    
    /// The initializer of Bindable instance
    ///
    /// - Parameter value: a default value of the template type if needed or nil
    public init(_ value: T?) {
        self.value = value
    }
    
    /// Appends a closure to be executed on every value change. Can be called multiple times 
    /// appending multiple closures all of which would be executed on value change
    ///
    /// - Parameter closure: the closer to be operated on
    public func bind(closure: Closure?) {
        if let closure = closure {
            self.closures.append(closure)
        }
    }
    
    /// Same as bind() but also executes the passed closure immediately
    ///
    /// - Parameter closure: the closer to be operated on
    public func bindAndFire(closure: Closure?) {
        if let closure = closure {
            self.closures.append(closure)
        }
        closure?(value)
    }
    
    /// Same as bind() but also executes all of the currently bound closures plus the new one immediately
    ///
    /// - Parameter closure: the closer to be operated on
    public func bindAndFireAll(closure: Closure?) {
        if let closure = closure {
            self.closures.append(closure)
        }
        executeClosures(newValue: value)
    }
    
    /// Fires all closures currently bounded, passing them the current value
    public func fireAll() {
        executeClosures(newValue: value)
    }
    
    func executeClosures(newValue: T?) {
        closures.forEach { $0(newValue) }
    }
}
