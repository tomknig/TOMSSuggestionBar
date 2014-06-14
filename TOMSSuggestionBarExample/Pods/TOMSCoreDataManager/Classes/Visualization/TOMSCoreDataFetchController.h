//
//  TOMSCoreDataFetchController.h
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class TOMSCoreDataTableViewController;
@class TOMSCoreDataCollectionViewController;

@interface TOMSCoreDataFetchController : NSObject

@property (atomic, strong) NSPredicate *predicate;
@property (atomic, strong) NSArray *sortDescriptors;
@property (readonly, atomic, strong) NSString *modelName;

@property (nonatomic) UITableViewRowAnimation tableViewRowAnimation;

- (void)setPredicate:(NSPredicate *)aPredicate sortDescriptors:(NSArray *)sortDescriptors;

- (id)initWithTableViewController:(TOMSCoreDataTableViewController *)tableViewController;
- (id)initWithCollectionViewController:(TOMSCoreDataCollectionViewController *)collectionViewController;
- (void)viewDidAppear;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSections;

@end
