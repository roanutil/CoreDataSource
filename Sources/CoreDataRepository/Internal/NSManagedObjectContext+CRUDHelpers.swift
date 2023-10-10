// NSManagedObjectContext+CRUDHelpers.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2023 Andrew Roan

import CoreData
import Foundation

extension NSManagedObjectContext {
    /// Helper function for getting the ``NSManagedObjectID`` from an ``URL``
    func objectId(from url: URL) -> Result<NSManagedObjectID, CoreDataError> {
        guard let objectId = persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else {
            return .failure(CoreDataError.failedToGetObjectIdFromUrl(url))
        }
        return .success(objectId)
    }

    /// Helper function for checking that a managed object is not deleted in the store
    func notDeletedObject(for id: NSManagedObjectID) throws -> NSManagedObject {
        let object: NSManagedObject = try existingObject(with: id)
        guard !object.isDeleted else {
            throw CoreDataError.fetchedObjectIsFlaggedAsDeleted
        }
        return object
    }
}
