// NSManagedObjectModel+Constants.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData

extension NSManagedObjectModel {
    package static let model_UuidId: NSManagedObjectModel = {
        let model = NSManagedObjectModel()
        model.entities = [ManagedModel_UuidId.entity()]
        return model
    }()

    package static let model_IntId: NSManagedObjectModel = {
        let model = NSManagedObjectModel()
        model.entities = [ManagedModel_IntId.entity()]
        return model
    }()
}
