// UnmanagedModel.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreData
import Foundation

/// Protocol for a value type that corresponds to an ``NSManagedObject`` subclass
public typealias UnmanagedModel = ReadableUnmanagedModel & WritableUnmanagedModel
