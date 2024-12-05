// NSManagedObject+CRUDHelpers.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData
import Foundation

extension NSManagedObject {
    func asRepoManaged<T>() throws -> T where T: RepositoryManagedModel {
        guard let repoManaged = self as? T else {
            throw CoreDataRepositoryError.fetchedObjectFailedToCastToExpectedType
        }
        return repoManaged
    }
}
