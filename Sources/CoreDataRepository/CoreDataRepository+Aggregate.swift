// CoreDataRepository+Aggregate.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2023 Andrew Roan

import Combine
import CoreData

extension CoreDataRepository {
    enum AggregateFunction: String {
        case count
        case sum
        case average
        case min
        case max
    }

    static func aggregate<Value: Numeric>(
        context: NSManagedObjectContext,
        request: NSFetchRequest<NSDictionary>
    ) throws -> Value {
        let result = try context.fetch(request)
        guard let value: Value = result.asAggregateValue() else {
            throw CoreDataRepositoryError.fetchedObjectFailedToCastToExpectedType
        }
        return value
    }

    private static func send<Value>(
        function: AggregateFunction,
        context: NSManagedObjectContext,
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil
    ) async -> Result<Value, CoreDataRepositoryError> where Value: Numeric {
        guard entityDesc == attributeDesc.entity else {
            return .failure(.propertyDoesNotMatchEntity)
        }
        return await context.performInScratchPad { scratchPad in
            let request = try NSFetchRequest<NSDictionary>.request(
                function: function,
                predicate: predicate,
                entityDesc: entityDesc,
                attributeDesc: attributeDesc,
                groupBy: groupBy
            )
            do {
                let value: Value = try Self.aggregate(context: scratchPad, request: request)
                return value
            } catch let error as CocoaError {
                throw CoreDataRepositoryError.coreData(error)
            } catch {
                throw CoreDataRepositoryError.unknown(error as NSError)
            }
        }
    }

    public func count<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        as _: Value.Type
    ) async -> Result<Value, CoreDataRepositoryError> {
        await context.performInScratchPad { scratchPad in
            do {
                let request = try NSFetchRequest<NSDictionary>
                    .countRequest(predicate: predicate, entityDesc: entityDesc)
                let count = try scratchPad.count(for: request)
                return Value(exactly: count) ?? Value.zero
            } catch let error as CocoaError {
                throw CoreDataRepositoryError.coreData(error)
            } catch {
                throw CoreDataRepositoryError.unknown(error as NSError)
            }
        }
    }

    public func countSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        as _: Value.Type
    ) -> AsyncStream<Result<Value, CoreDataRepositoryError>> {
        CountSubscription(
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc
        ).stream()
    }

    public func countThrowingSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        as _: Value.Type
    ) -> AsyncThrowingStream<Value, Error> {
        CountSubscription(
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc
        ).throwingStream()
    }

    public func sum<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) async -> Result<Value, CoreDataRepositoryError> {
        await Self.send(
            function: .sum,
            context: context,
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        )
    }

    public func sumSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncStream<Result<Value, CoreDataRepositoryError>> {
        AggregateSubscription(
            function: .sum,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).stream()
    }

    public func sumThrowingSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncThrowingStream<Value, Error> {
        AggregateSubscription(
            function: .sum,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).throwingStream()
    }

    public func average<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) async -> Result<Value, CoreDataRepositoryError> {
        await Self.send(
            function: .average,
            context: context,
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        )
    }

    public func averageSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncStream<Result<Value, CoreDataRepositoryError>> {
        AggregateSubscription(
            function: .average,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).stream()
    }

    public func averageThrowingSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncThrowingStream<Value, Error> {
        AggregateSubscription(
            function: .average,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).throwingStream()
    }

    public func min<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) async -> Result<Value, CoreDataRepositoryError> {
        await Self.send(
            function: .min,
            context: context,
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        )
    }

    public func minSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncStream<Result<Value, CoreDataRepositoryError>> {
        AggregateSubscription(
            function: .min,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).stream()
    }

    public func minThrowingSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncThrowingStream<Value, Error> {
        AggregateSubscription(
            function: .min,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).throwingStream()
    }

    public func max<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) async -> Result<Value, CoreDataRepositoryError> {
        await Self.send(
            function: .max,
            context: context,
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        )
    }

    public func maxSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncStream<Result<Value, CoreDataRepositoryError>> {
        AggregateSubscription(
            function: .max,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).stream()
    }

    public func maxThrowingSubscription<Value: Numeric>(
        predicate: NSPredicate,
        entityDesc: NSEntityDescription,
        attributeDesc: NSAttributeDescription,
        groupBy: NSAttributeDescription? = nil,
        as _: Value.Type
    ) -> AsyncThrowingStream<Value, Error> {
        AggregateSubscription(
            function: .max,
            context: context.childContext(),
            predicate: predicate,
            entityDesc: entityDesc,
            attributeDesc: attributeDesc,
            groupBy: groupBy
        ).throwingStream()
    }
}
