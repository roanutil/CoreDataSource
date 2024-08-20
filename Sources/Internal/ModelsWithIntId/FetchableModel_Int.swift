// FetchableModel_Int.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2024 Andrew Roan

import CoreDataRepository
import Foundation

package struct FetchableModel_IntId: Hashable, Sendable {
    package var bool: Bool
    package var date: Date
    package var decimal: Decimal
    package var double: Double
    package var float: Float
    package var int: Int
    package var string: String
    package var uuid: UUID

    @inlinable
    package init(
        bool: Bool,
        date: Date,
        decimal: Decimal,
        double: Double,
        float: Float,
        int: Int,
        string: String,
        uuid: UUID
    ) {
        self.bool = bool
        self.date = date
        self.decimal = decimal
        self.double = double
        self.float = float
        self.int = int
        self.string = string
        self.uuid = uuid
    }
}

extension FetchableModel_IntId: FetchableUnmanagedModel {
    @inlinable
    package init(managed: ManagedModel_IntId) throws {
        self.init(
            bool: managed.bool,
            date: managed.date,
            decimal: managed.decimal as Decimal,
            double: managed.double,
            float: managed.float,
            int: managed.int,
            string: managed.string,
            uuid: managed.uuid
        )
    }
}

extension FetchableModel_IntId: WritableUnmanagedModel {
    @inlinable
    package func updating(managed: ManagedModel) throws {
        managed.bool = bool
        managed.date = date
        managed.decimal = decimal as NSDecimalNumber
        managed.double = double
        managed.float = float
        managed.id = int
        managed.int = int
        managed.string = string
        managed.uuid = uuid
    }
}

extension FetchableModel_IntId: Comparable {
    package static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.int < rhs.int
    }
}
