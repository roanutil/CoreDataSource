// ManagedIdReferencable.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData

/// Protocol for types that store an `NSManagedObjectID` to relate it to an instance of `NSManagedObject`
public protocol ManagedIdReferencable {
    /// Unique `CoreData` managed identifier that relates this instance to its corresponding `NSManagedObject`
    ///
    /// A `nil` value should mean that this instance has not been saved in the repository
    var managedId: NSManagedObjectID? { get set }
}
