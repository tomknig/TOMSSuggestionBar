//
//  TOMSCoreDataViewDataSource.h
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataFetchController.h"

@protocol TOMSCoreDataViewDataSource <NSObject>

@required

@property (readonly, nonatomic, strong) TOMSCoreDataFetchController *coreDataFetchController;

- (NSString *)modelName;

- (NSString *)entityName;

- (NSString *)cellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)defaultSortDescriptors;

- (NSPredicate *)defaultPredicate;

- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath;

@optional

- (Class)backingRESTClientClass;

@end