// FetchThrowingSubscription.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2023 Andrew Roan

import CoreData
import Foundation

/// Subscription provider that sends updates when a fetch request changes
final class FetchThrowingSubscription<Model: UnmanagedModel>: ThrowingSubscription<
    [Model],
    Model.ManagedModel,
    Model.ManagedModel
> {
    override func fetch() {
        frc.managedObjectContext.perform { [weak self, frc, request] in
            guard frc.fetchedObjects != nil else {
                self?.start()
                return
            }

            do {
                let result = try frc.managedObjectContext.fetch(request)
                try self?.send(result.map(Model.init(managed:)))
            } catch let error as CocoaError {
                self?.fail(.cocoa(error))
                return
            } catch {
                self?.fail(.unknown(error as NSError))
                return
            }
        }
    }
}