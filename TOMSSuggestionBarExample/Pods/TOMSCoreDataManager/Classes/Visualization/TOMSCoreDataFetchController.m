//
//  TOMSCoreDataFetchController.m
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataManager.h"
#import "TOMSCoreDataFetchController.h"
#import "TOMSCoreDataTableViewController.h"
#import "TOMSCoreDataCollectionViewController.h"

@interface TOMSCoreDataFetchController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) TOMSCoreDataTableViewController *tableViewController;
@property (nonatomic, weak) TOMSCoreDataCollectionViewController *collectionViewController;

@property (nonatomic, strong) NSPredicate *defaultPredicate;
@property (nonatomic, strong) NSArray *defaultSortDescriptors;
@property (nonatomic, strong) NSBlockOperation *collectionViewBlockOperation;

@property (nonatomic, getter = isTableViewUpdateBegan) BOOL tableViewUpdateBegan;
@property (nonatomic, getter = isTableViewSectionChanged) BOOL tableViewChangedSections;
@property (nonatomic, getter = isCollectionViewReloadable) BOOL collectionViewShouldReload;
@property (nonatomic, getter = isDataFetchedOnAppearance) BOOL dataFetchedOnAppearance;

@end

@implementation TOMSCoreDataFetchController
@synthesize sortDescriptors = _sortDescriptors;
@synthesize predicate = _predicate;
@synthesize modelName = _modelName;

#pragma mark - Initialization

- (id)initWithTableViewController:(TOMSCoreDataTableViewController *)tableViewController
{
    self = [super init];
    if (self) {
        self.tableViewController = tableViewController;
    }
    return self;
}

- (id)initWithCollectionViewController:(TOMSCoreDataCollectionViewController *)collectionViewController
{
    self = [super init];
    if (self) {
        self.collectionViewController = collectionViewController;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidAppear
{
    if (!self.isDataFetchedOnAppearance) {
        self.dataFetchedOnAppearance = YES;
        [self performFetchRequest];
    }
}

#pragma mark - Fetching

- (void)setPredicate:(NSPredicate *)aPredicate
{
    @synchronized (self) {
        _predicate = aPredicate;
        [self performFetchRequest];
    }
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors
{
    @synchronized (self) {
        _sortDescriptors = sortDescriptors;
        [self performFetchRequest];
    }
}

- (void)setPredicate:(NSPredicate *)aPredicate sortDescriptors:(NSArray *)sortDescriptors
{
    @synchronized (self) {
        _predicate = aPredicate;
        _sortDescriptors = sortDescriptors;
        [self performFetchRequest];
    }
}

- (BOOL)performFetchRequest
{
    NSError *error;
    BOOL success = NO;
    
    if (self.fetchedResultsController) {
        self.fetchedResultsController.fetchRequest.predicate = self.predicate;
        self.fetchedResultsController.fetchRequest.sortDescriptors = self.sortDescriptors;
        
        success = [self.fetchedResultsController performFetch:&error];
    }
    
    if (success) {
        [self reloadData];
    }
    
    return success;
}

- (void)reloadData
{
    if (self.tableViewController) {
        [self.tableViewController.tableView reloadData];
    } else if (self.collectionViewController) {
        [self.collectionViewController.collectionView reloadData];
    }
}

#pragma mark - Getters

- (UITableViewRowAnimation)tableViewRowAnimation
{
    if (!_tableViewRowAnimation) {
        _tableViewRowAnimation = UITableViewRowAnimationAutomatic;
    }
    return _tableViewRowAnimation;
}

- (NSArray *)sortDescriptors
{
    @synchronized (self) {
        if (!_sortDescriptors) {
            return [self defaultSortDescriptors];
        }
        return _sortDescriptors;
    }
}

- (NSPredicate *)predicate
{
    @synchronized (self) {
        if (!_predicate) {
            return [self defaultPredicate];
        }
        return _predicate;
    }
}

- (NSString *)modelName
{
    @synchronized (self) {
        if (!_modelName) {
            if (self.tableViewController) {
                _modelName = [self.tableViewController modelName];
            } else if (self.collectionViewController) {
                _modelName = [self.collectionViewController modelName];
            }
        }
        return _modelName;
    }
}

- (NSArray *)defaultSortDescriptors
{
    @synchronized (self) {
        if (!_defaultSortDescriptors) {
            if (self.tableViewController) {
                _defaultSortDescriptors = [self.tableViewController defaultSortDescriptors];
            } else if (self.collectionViewController) {
                _defaultSortDescriptors = [self.collectionViewController defaultSortDescriptors];
            }
        }
        return _defaultSortDescriptors;
    }
}

- (NSPredicate *)defaultPredicate
{
    @synchronized (self) {
        if (!_defaultPredicate) {
            if (self.tableViewController) {
                _defaultPredicate = [self.tableViewController defaultPredicate];
            } else if (self.collectionViewController) {
                _defaultPredicate = [self.collectionViewController defaultPredicate];
            }
        }
        return _defaultPredicate;
    }
}

- (NSString *)entityName
{
    if (self.tableViewController) {
        return [self.tableViewController entityName];
    } else if (self.collectionViewController) {
        return [self.collectionViewController entityName];
    }
    return nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Updating

- (NSManagedObjectContext *)managedObjectContext
{
    if (self.tableViewController) {
        return self.tableViewController.managedObjectContext;
    } else if (self.collectionViewController) {
        return self.collectionViewController.managedObjectContext;
    }
    return nil;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController || ![_fetchedResultsController.fetchRequest.entityName isEqualToString:[self entityName]]) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName]
                                                  inManagedObjectContext:context];
        
        fetchRequest.entity = entity;
        fetchRequest.sortDescriptors = self.sortDescriptors;
        fetchRequest.predicate = self.predicate;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

#pragma mark - DataSource

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSections
{
    return [[self.fetchedResultsController sections] count];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.tableViewController) {
        [self.tableViewController.tableView beginUpdates];
        self.tableViewUpdateBegan = YES;
    } else if (self.collectionViewController) {
        self.collectionViewShouldReload = NO;
        self.collectionViewBlockOperation = [[NSBlockOperation alloc] init];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.tableViewController) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableViewController.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                                  withRowAnimation:self.tableViewRowAnimation];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableViewController.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                                  withRowAnimation:self.tableViewRowAnimation];
            case NSFetchedResultsChangeUpdate:
            case NSFetchedResultsChangeMove:
                break;
        }
        self.tableViewChangedSections = YES;
    } else if (self.collectionViewController) {
        __weak UICollectionView *collectionView = self.collectionViewController.collectionView;
        switch (type) {
            case NSFetchedResultsChangeInsert: {
                [self.collectionViewBlockOperation addExecutionBlock:^{
                    [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                }];
                break;
            }
            case NSFetchedResultsChangeDelete: {
                [self.collectionViewBlockOperation addExecutionBlock:^{
                    [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                }];
                break;
            }
            case NSFetchedResultsChangeUpdate: {
                [self.collectionViewBlockOperation addExecutionBlock:^{
                    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                }];
                break;
            }
            case NSFetchedResultsChangeMove:
            default:
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.tableViewController) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableViewController.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                                          withRowAnimation:self.tableViewRowAnimation];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableViewController.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                          withRowAnimation:self.tableViewRowAnimation];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath]
                                                          withRowAnimation:self.tableViewRowAnimation];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableViewController.tableView moveRowAtIndexPath:indexPath
                                                           toIndexPath:newIndexPath];
                break;
        }
    } else if (self.collectionViewController) {
        __weak UICollectionView *collectionView = self.collectionViewController.collectionView;
        switch (type) {
            case NSFetchedResultsChangeInsert: {
                if ([self.collectionViewController.collectionView numberOfSections] > 0) {
                    if ([self.collectionViewController.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                        self.collectionViewShouldReload = YES;
                    } else {
                        [self.collectionViewBlockOperation addExecutionBlock:^{
                            [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                        }];
                    }
                } else {
                    self.collectionViewShouldReload = YES;
                }
                break;
            }
            case NSFetchedResultsChangeDelete: {
                if ([self.collectionViewController.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                    self.collectionViewShouldReload = YES;
                } else {
                    [self.collectionViewBlockOperation addExecutionBlock:^{
                        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    }];
                }
                break;
            }
            case NSFetchedResultsChangeUpdate: {
                [self.collectionViewBlockOperation addExecutionBlock:^{
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
                break;
            }
            case NSFetchedResultsChangeMove: {
                [self.collectionViewBlockOperation addExecutionBlock:^{
                    [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                }];
                break;
            }
            default:
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.tableViewController) {
        [self didChangeContentInTableView];
    } else if (self.collectionViewController) {
        [self didChangeContentInCollectionView];
    }
}

- (void)didChangeContentInTableView
{
    if (self.isTableViewUpdateBegan) {
        [self.tableViewController.tableView endUpdates];
    }
    
    if (self.isTableViewSectionChanged) {
        NSRange sectionRange = NSMakeRange(0, (NSUInteger)self.tableViewController.tableView.numberOfSections);
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:sectionRange];
        [self.tableViewController.tableView reloadSections:sections
                                          withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didChangeContentInCollectionView
{
    if (self.isCollectionViewReloadable) {
        [self.collectionViewController.collectionView reloadData];
    } else {
        [self.collectionViewController.collectionView performBatchUpdates:^{
            [self.collectionViewBlockOperation start];
        } completion:nil];
    }
}

@end
