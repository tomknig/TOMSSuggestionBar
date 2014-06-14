//
//  TOMSCoreDataIncrementalStore.m
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataIncrementalStore.h"

@implementation TOMSCoreDataIncrementalStore

+ (void)initialize
{
    [NSPersistentStoreCoordinator registerStoreClass:self
                                        forStoreType:[self type]];
}

+ (NSString *)type
{
    return NSStringFromClass(self);
}

- (id<AFIncrementalStoreHTTPClient>)HTTPClient
{
    return self.client;
}

@end
