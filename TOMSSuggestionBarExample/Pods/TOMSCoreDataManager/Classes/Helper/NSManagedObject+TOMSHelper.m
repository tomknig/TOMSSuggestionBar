//
//  NSManagedObject+TOMSHelper.m
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <objc/runtime.h>
#import "NSManagedObject+TOMSHelper.h"
#import "TOMSCoreDataManager.h"
#import "TOMSIDGenerator.h"

@implementation NSManagedObject (TOMSHelper)

+ (NSString *)toms_uniqueIdentifier
{
    return @"objectId";
}

+ (BOOL)toms_shouldAutoGenerateGloballyUniqueIdentifiers
{
    return YES;
}

+ (instancetype)toms_objectForUniqueIdentifier:(NSString *)uniqueIdentifier
                                inContext:(NSManagedObjectContext *)context
{
    return [self toms_objectForAttribute:[self toms_uniqueIdentifier]
                           matchingValue:uniqueIdentifier
                               inContext:context];
}

+ (instancetype)toms_newObjectFromDictionary:(NSDictionary *)dictionary
                                   inContext:(NSManagedObjectContext *)context
{
    return [self toms_newObjectFromDictionary:dictionary
                                    inContext:context
                              autoSaveContext:YES];
}

+ (instancetype)toms_newObjectFromDictionary:(NSDictionary *)dictionary
                              inContext:(NSManagedObjectContext *)context
                        autoSaveContext:(BOOL)autoSave;
{
    if (!dictionary) {
        return nil;
    }
    
    NSString *uniqueIdentifierKey = [self toms_uniqueIdentifier];
    
    NSMutableDictionary *mutableInfo = [dictionary mutableCopy];
    
    if ([self toms_shouldAutoGenerateGloballyUniqueIdentifiers]) {
        if (!dictionary[uniqueIdentifierKey]) {
            NSString *objectId = [TOMSIDGenerator uniqueIdentifier];
            [mutableInfo setObject:objectId forKey:uniqueIdentifierKey];
        } else {
            @throw [NSException exceptionWithName:@"TOMSAutogeneratableIdentifierException"
                                           reason:[NSString stringWithFormat:@"`%@` is configured to auto generate unique Identifiers but there was a custom unique identifier of `%@` specified. This is an internal inconsistency and can be fixed by either setting `shouldAutoGenerateGloballyUniqueIdentifiers` to NO or removing the custom unique identifier from the passed dictionary.", NSStringFromClass([self class]), uniqueIdentifierKey]
                                         userInfo:dictionary];
        }
    }
    
    id object = nil;
    
    if (dictionary[uniqueIdentifierKey]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ = %@", uniqueIdentifierKey, [mutableInfo[uniqueIdentifierKey] description]];
        NSArray *matches = [self toms_objectsForPredicate:predicate
                                                inContext:context];
        
        if (!matches || ([matches count] >= 1)) {
            @throw [NSException exceptionWithName:@"TOMSFetchException"
                                           reason:[NSString stringWithFormat:@"Could not insert object for dictionary `%@`. The unique identifier was either not new or there was an error executing the fetch for it. Maybe its unique identifier is not as unique as it should be?", dictionary]
                                         userInfo:dictionary];
        } else {
            object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectContext:context];
        }
    } else {
        object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                               inManagedObjectContext:context];
    }
    
    
    for (NSString *key in mutableInfo) {
        Class propertyClass = [object toms_classOfPropertyNamed:key
                                                inObjectOfClass:[self class]];
        
        if ([[mutableInfo[key] class] isSubclassOfClass:propertyClass]) {
            [object setValue:mutableInfo[key] forKey:key];
        } else {
            @throw [NSException exceptionWithName:@"TOMSPropertyTypeMismatchException"
                                           reason:[NSString stringWithFormat:@"Could not insert value `%@` to property of class `%@`. Its type does not match class in Dictionary `%@`.", key, propertyClass, [mutableInfo[key] class]]
                                         userInfo:dictionary];
        }
    }
    
    if (autoSave) {
        [TOMSCoreDataManager saveContext:context];
    }

    return object;

}

+ (NSArray *)toms_objectsForPredicate:(NSPredicate *)predicate
                      sortDescriptors:(NSArray *)sortDescriptors
                            inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    fetchRequest.returnsObjectsAsFaults = NO;
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        @throw [NSException exceptionWithName:@"TOMSFetchException"
                                       reason:[NSString stringWithFormat:@"Could get objects for predicate `%@`. Error: `%@`.", predicate, error]
                                     userInfo:nil];
    }
    
    return result;
}

+ (NSArray *)toms_objectsForPredicate:(NSPredicate *)predicate
                       inContext:(NSManagedObjectContext *)context
{
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]];
    return [self toms_objectsForPredicate:predicate
                          sortDescriptors:sortDescriptors
                                inContext:context];
}

#pragma mark - private helper methods

+ (instancetype)toms_objectForAttribute:(NSString *)attribute
                          matchingValue:(NSString *)value
                              inContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ = %@", attribute, [value description]];
    NSArray *matches = [self toms_objectsForPredicate:predicate
                                            inContext:context];
    
    if ([matches count] == 1) {
        return [matches lastObject];
    }
    
    return nil;
}

- (Class)toms_classOfPropertyNamed:(NSString*)propertyName
                   inObjectOfClass:(Class)class
{
    Class propertyClass = nil;
    NSString *className = NSStringFromClass(class);
    objc_property_t property = class_getProperty(NSClassFromString(className), [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    
    if (splitPropertyAttributes.count > 0) {
        // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    
    return propertyClass;
}

@end
