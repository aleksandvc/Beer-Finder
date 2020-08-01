//
//  Bindable.swift
//  Pods
//
//  Created by Dyanko Yovchev on 5/28/17.
//
//

/// Indicates that all implementing classes can be bound with a closure to be executed on value change
public protocol Bindable {
    
    /// The type of the closure which the Bindable operates on
    ///
    /// - Parameter closure: the block to be executed on value change
    associatedtype Closure
    
    /// Appends a closure to be executed on every value change. Can be called multiple times appending multiple closures all of which would be executed on value change
    ///
    /// - Parameter closure: the closer to be operated on
    func bind(closure: Closure?)
    
    /// Same as bind() but also executes the passed closure immediately
    ///
    /// - Parameter closure: the closer to be operated on
    func bindAndFire(closure: Closure?)
    
    /// Same as bind() but also executes all of the currently bound closures plus the new one immediately
    ///
    /// - Parameter closure: the closer to be operated on
    func bindAndFireAll(closure: Closure?)
    
    /// Fires all closures currently bounded, passing them the current value
    func fireAll()
}
