//
//  Optionable+Rx.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

internal protocol Optionable {
    
    associatedtype WrappedType
    
    func unwrap() -> WrappedType
    func isEmpty() -> Bool
}

// MARK: - Helpers to check for values
extension Optional: Optionable {
    
    internal typealias WrappedType = Wrapped
    
    /// DONT NOT USE BY ITSELF, Force unwraps the contained value and returns it. Will crash if there's no value stored.
    ///
    /// - Returns: Value
    internal func unwrap() -> WrappedType {
        // Before using this method i filter out nil values
        guard let value = self else { fatalError("Nil value found while unwrapping, this method only intended for internal use") }
        
        return value
    }
    
    /// Returns `true if the Optional element is `nil`; if it does not contain a value
    ///
    /// - Returns: result
    internal func isEmpty() -> Bool {
        return self == nil
    }
}

// MARK: - Helper to unwrap values in observable
internal extension ObservableType where E: Optionable {
    
    // MARK:
    // MARK: Unwrap
    
    /// Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
    ///
    /// - Returns: An observable sequence of non-optional elements
    internal func unwrap() -> Observable<E.WrappedType> {
        return self
            .filter { !$0.isEmpty() }
            .map { $0.unwrap() }
    }
}

internal protocol OptionalType {
    
    associatedtype Wrapped
    
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
   
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    internal var value: Wrapped? {
        return self
    }
}

internal extension ObservableType where E: OptionalType {
    /// Unwraps and filters out `nil` elements.
    ///
    /// - Returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
    internal func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            
            return Observable<E.Wrapped>.just(value)
        }
    }
}
