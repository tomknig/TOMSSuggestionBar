//
//  TOMSCoreDataTableViewController.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataTableViewController.h"
#import "TOMSCoreDataManager.h"

@interface TOMSCoreDataTableViewController ()
@property (readwrite, nonatomic, strong) TOMSCoreDataFetchController *coreDataFetchController;
@end

@implementation TOMSCoreDataTableViewController
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

#pragma mark - UITableViewDataSource

- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"<Implementation missing! Please implement `configureCell:forIndexPath:` in your subclass of `TOMSCoreDataTableViewController`>");
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self cellIdentifierForItemAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.coreDataFetchController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.coreDataFetchController numberOfRowsInSection:section];
}

#pragma mark - TKCoreDataViewDataSource

- (TOMSCoreDataFetchController *)coreDataFetchController
{
    @synchronized (self) {
        if (!_coreDataFetchController) {
            _coreDataFetchController = [[TOMSCoreDataFetchController alloc] initWithTableViewController:self];
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
