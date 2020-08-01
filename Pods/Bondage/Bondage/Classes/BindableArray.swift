//
//  BindableArray.swift
//  Pods
//
//  Created by Dyanko Yovchev on 5/28/17.
//
//

/**
 Bindable array that executes the closure on every data change without checking if newly passed value is different from the already set.
 */
public class BindableArray<T>: Bindable {

    /// The value/acutal data/ wrapped by the Bindable
    public var value: [T] {
        didSet {
            executeClosures(newValue: value)
        }
    }
    
    /// The type of the closure which the Bindable operates on
    public typealias Closure = ([T]) -> Void

    fileprivate var closures: [Closure] = []
        
    /// The initializer of Bindable instance
    ///
    /// - Parameter value: a default value of the template type if needed or nil
    public init(_ value: [T]) {
        self.value = value
    }
    
    /// Binds a closure to be executed when the 'value' property of the object is changed
    ///
    /// - Parameter closure: the closure to be executed on value change
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
    
    /// Appends the new array to the old one, triggering closures execution
    ///
    /// - Parameter newValues: the array of values to be appended
    public func append(newValues: [T]) {
        var oldArr: [T] = value
        for item in newValues {
            oldArr.append(item)
        }
        value = oldArr
    }
    
    /// Fires all closures currently bounded, passing them the current value
    public func fireAll() {
        executeClosures(newValue: value)
    }
    
    func executeClosures(newValue: [T]) {
        closures.forEach { $0(newValue) }
    }
}
