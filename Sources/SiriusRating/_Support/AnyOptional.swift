//
//  AnyOptional.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 08/09/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

// We use this protocol to determine if a generic type is nil, e.g. `let genericType = genericType as? OptionalProtocol, genericType.isNil()`.
// We cannot define a generic type to be nillable. We only use this protocol inside our `@propertyWrapper`'s to enable nillable default values.
protocol AnyOptional {
    /// Determines if `self` is nil.
    ///
    /// - returns: `self == nil`.
    func isNil() -> Bool
}

extension Optional: AnyOptional {
    /// Determines if `self` is nil.
    ///
    /// - returns: `self == nil`.
    func isNil() -> Bool {
        return self == nil
    }
}
