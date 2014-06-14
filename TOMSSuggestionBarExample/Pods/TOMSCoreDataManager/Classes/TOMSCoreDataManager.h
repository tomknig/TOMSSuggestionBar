//
//  TOMSCoreDataManager.h
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TOMSCoreDataIncrementalStore.h"
#import "NSManagedObject+TOMSHelper.h"
#import "TOMSCoreDataCollectionViewController.h"
#import "TOMSCoreDataTableViewController.h"

@interface TOMSCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) AFRESTClient<AFIncrementalStoreHTTPClient> *client;

+ (instancetype)managerForModelName:(NSString *)dataModelName;
+ (instancetype)managerForModelName:(NSString *)dataModelName withBackingRESTClientClass:(Class)RestClientClass;

+ (instancetype)managerForContext:(NSManagedObjectContext *)context;
+ (void)saveContext:(NSManagedObjectContext *)context;
- (void)saveContext;

@end
