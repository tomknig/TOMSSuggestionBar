//
//  NSManagedObject+TOMSHelper.h
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (TOMSHelper)

+ (instancetype)toms_objectForUniqueIdentifier:(NSString *)uniqueIdentifier
                                     inContext:(NSManagedObjectContext *)context;

+ (instancetype)toms_newObjectFromDictionary:(NSDictionary *)dictionary
                                   inContext:(NSManagedObjectContext *)context;

+ (instancetype)toms_newObjectFromDictionary:(NSDictionary *)dictionary
                                   inContext:(NSManagedObjectContext *)context
                             autoSaveContext:(BOOL)autoSave;

+ (NSArray *)toms_objectsForPredicate:(NSPredicate *)predicate
                      sortDescriptors:(NSArray *)sortDescriptors
                            inContext:(NSManagedObjectContext *)context;

+ (NSArray *)toms_objectsForPredicate:(NSPredicate *)predicate
                            inContext:(NSManagedObjectContext *)context;

//The following may be overridden
+ (NSString *)toms_uniqueIdentifier;

+ (BOOL)toms_shouldAutoGenerateGloballyUniqueIdentifiers;

@end
