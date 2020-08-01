//
//  UpdatableArray.swift
//  PayTalkClient
//
//  Created by dyanko.yovchev on 2/22/17.
//  Copyright © 2017 dyanko.yovchev. All rights reserved.
//

/// Class conforming Bindable protocol that can hold Arrays just like BindableArray and 
/// trggers closure executon only when new data is introduced to the value array, just like UpdatableObject.
/// Example: If the instance.value == [1, 2, 3] and you invoke instance.value = [1, 2, 3] 
/// or instance.append(newValues: [1, 2, 3]) no closure execution would be triggered as opposed to BindableArray instance.
public class UpdatableArray<T: Equatable>: BindableArray<T> {
    
    /// The closure which the Bindable operates on
    public typealias Closure = ([T]) -> Void
    
    fileprivate var closures: [Closure] = []
    fileprivate var shouldUpdate: Bool = false
    
    /// The value/actual data/ wrapped by the Bindable
    override public var value: [T] {
        willSet {
            shouldUpdate = newValue != value
        }
        didSet {
            executeClosures(newValue: value)
        }
    }
    
    override func executeClosures(newValue: [T]) {
        if shouldUpdate {
            shouldUpdate = false
            closures.forEach { $0(newValue) }
        }
    }
}
