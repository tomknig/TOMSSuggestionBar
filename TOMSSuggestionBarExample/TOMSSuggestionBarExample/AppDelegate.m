//
//  AppDelegate.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 14/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "AppDelegate.h"
#import <TOMSCoreDataManager/TOMSCoreDataManager.h>
#import "Person.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self mockSomePersons];
    
    return YES;
}

#pragma mark - Database Mocks

- (NSArray *)mockedNames
{
    return @[
             @"Steve",
             @"Sandra",
             @"Steven",
             @"Estland",
             @"Meste",
             @"Oste"
             ];
}

- (void)mockSomePersons
{
    NSManagedObjectContext *managedObjectContext = [TOMSCoreDataManager managerForModelName:@"Model"].managedObjectContext;
    
    for (NSString *name in [self mockedNames]) {
        [Person toms_newObjectFromDictionary:@{@"name": name}
                                   inContext:managedObjectContext
                             autoSaveContext:NO];
    }
    
}

@end
