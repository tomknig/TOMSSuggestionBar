//
//  TOMSCoreDataManager.m
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataManager.h"

@interface TOMSCoreDataManager ()
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSString *dataModelName;
@property (strong, nonatomic) NSURL *modelURL;
@property (strong, nonatomic) NSURL *storeURL;
@end

@implementation TOMSCoreDataManager

#pragma mark - initialization

- (id)init
{
    return nil;
}

- (id)initWithModelName:(NSString *)dataModelName
{
    self = [super init];
    if (self) {
        self.dataModelName = dataModelName;
    }
    return self;
}

#pragma mark - singleton

static NSMutableDictionary *_sharedManagers = nil;

+ (instancetype)managerForModelName:(NSString *)dataModelName
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManagers = [[NSMutableDictionary alloc] init];
    });
    
    id sharedManager = [_sharedManagers objectForKey:dataModelName];
    if (!sharedManager) {
        @synchronized (_sharedManagers) {
            [_sharedManagers setObject:[[TOMSCoreDataManager alloc] initWithModelName:dataModelName] forKey:dataModelName];
            sharedManager = [_sharedManagers objectForKey:dataModelName];
        }
    }
    
    return sharedManager;
}

+ (instancetype)managerForModelName:(NSString *)dataModelName withBackingRESTClientClass:(Class)RestClientClass
{
    TOMSCoreDataManager *sharedManager = [TOMSCoreDataManager managerForModelName:dataModelName];

    if (!sharedManager.client) {
        sharedManager.client = [RestClientClass new];
    }
    
    return sharedManager;
}

+ (instancetype)managerForContext:(NSManagedObjectContext *)context
{
    if (_sharedManagers) {
        for (TOMSCoreDataManager *manager in [_sharedManagers allValues]) {
            if (manager.managedObjectContext == context) {
                return manager;
            }
        }
    }
    return nil;
}

#pragma mark - Lazy Getters

- (NSURL *)modelURL
{
    if (!_modelURL) {
        _modelURL = [[NSBundle mainBundle] URLForResource:self.dataModelName withExtension:@"momd"];
    }
    return _modelURL;
}

- (NSURL *)storeURL
{
    if (!_storeURL) {
        _storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.dataModelName]];
    }
    return _storeURL;
}

#pragma mark - Persist

+ (void)saveContext:(NSManagedObjectContext *)context
{
    [[self managerForContext:context] saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // TODO: schedule the changes to be saved at a later time
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        if (self.persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        __block NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSURL *storeURL = [self storeURL];
        NSDictionary *options = @{
                                  NSInferMappingModelAutomaticallyOption : @(YES),
                                  NSMigratePersistentStoresAutomaticallyOption: @(YES)
                                  };
        
        if (self.client) {
            TOMSCoreDataIncrementalStore *incrementalStore =
            (TOMSCoreDataIncrementalStore*)[_persistentStoreCoordinator addPersistentStoreWithType:[TOMSCoreDataIncrementalStore type]
                                                                                     configuration:nil
                                                                                               URL:nil
                                                                                           options:nil
                                                                                             error:nil];
            
            incrementalStore.client = self.client;
        }
        
        BOOL (^addPersistentStoreCoordinator)() = ^BOOL{
            return !![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil
                                                                         URL:storeURL
                                                                     options:options
                                                                       error:&error];
        };
        
        if (!addPersistentStoreCoordinator()) {
            [[NSFileManager defaultManager] removeItemAtURL:storeURL
                                                      error:nil];
            if (!addPersistentStoreCoordinator()) {
                // TODO: do further error handling
                abort();
            }
        }
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
