// ManagedIdUrlReferencable.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData
import Foundation

/// Protocol for types that store a `URL` encoded `NSManagedObjectID` to relate it to an instance of `NSManagedObject`
public protocol ManagedIdUrlReferencable {
    /// Unique `CoreData` managed identifier in `URL` form that relates this instance to its corresponding
    /// `NSManagedObject`
    ///
    /// A `nil` value should mean that this instance has not been saved in the repository
    var managedIdUrl: URL? { get set }
}
