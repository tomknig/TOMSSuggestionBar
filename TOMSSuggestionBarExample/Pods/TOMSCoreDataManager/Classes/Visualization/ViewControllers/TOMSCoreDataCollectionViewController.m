//
//  TOMSCoreDataCollectionViewController.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataCollectionViewController.h"
#import "TOMSCoreDataManager.h"

@interface TOMSCoreDataCollectionViewController ()
@property (readwrite, nonatomic, strong) TOMSCoreDataFetchController *coreDataFetchController;
@end

@implementation TOMSCoreDataCollectionViewController
@synthesize coreDataFetchController = _coreDataFetchController;

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.coreDataFetchController viewDidAppear];
}

#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext
{
    return [TOMSCoreDataManager managerForModelName:self.modelName].managedObjectContext;
}

- (void)saveContext
{
    [TOMSCoreDataManager saveContext:self.managedObjectContext];
}

#pragma mark - UICollectionViewDataSource

- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"<Implementation missing! Please implement `configureCell:forIndexPath:` in your subclass of `TOMSCoreDataCollectionViewController`>");
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self cellIdentifierForItemAtIndexPath:indexPath];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.coreDataFetchController numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.coreDataFetchController numberOfRowsInSection:section];
}

#pragma mark - TKCoreDataViewDataSource

- (TOMSCoreDataFetchController *)coreDataFetchController
{
    @synchronized (self) {
        if (!_coreDataFetchController) {
            _coreDataFetchController = [[TOMSCoreDataFetchController alloc] initWithCollectionViewController:self];
        }
        return _coreDataFetchController;
    }
}

- (NSString *)modelName
{
    return nil;
}

- (NSString *)entityName
{
    return nil;
}

- (NSString *)cellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSArray *)defaultSortDescriptors
{
    return nil;
}

- (NSPredicate *)defaultPredicate
{
    return nil;
}

@end
