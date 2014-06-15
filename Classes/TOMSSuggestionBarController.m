//
//  TOMSSuggestionBarController.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSSuggestionBarController.h"
#import "TOMSSuggestionBarView.h"
#import "TOMSSuggestionBarCell.h"

@implementation TOMSSuggestionBarController

#pragma mark - Initialization

- (instancetype)initWithSuggestionBarView:(TOMSSuggestionBarView *)suggestionBarView
{
    self = [super init];
    if (self) {
        CGRect suggestionBarViewFrame = suggestionBarView.frame;
        self.collectionView = suggestionBarView;
        self.collectionView.frame = suggestionBarViewFrame;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return ((TOMSSuggestionBarView *)self.collectionView).numberOfSuggestionFields;
}

#pragma mark - TOMSCoreDataManagerDataSource

- (NSString *)modelName
{
    return ((TOMSSuggestionBarView *)self.collectionView).modelName;
}

- (NSString *)entityName
{
    return ((TOMSSuggestionBarView *)self.collectionView).entityName;
}

- (NSString *)cellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"kTOMSSuggestionBarCell";
    return cellIdentifier;
}

- (NSPredicate *)defaultPredicate
{
    return [NSPredicate predicateWithFormat:@"%@.length > 0", ((TOMSSuggestionBarView *)self.collectionView).attributeName];
}

- (NSArray *)defaultSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:((TOMSSuggestionBarView *)self.collectionView).attributeName ascending:YES]];
}

- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    TOMSSuggestionBarCell *suggestionBarCell = (TOMSSuggestionBarCell *)cell;
    NSString *text;
    
    @try {
        NSManagedObject *object = [self.coreDataFetchController objectAtIndexPath:indexPath];
        if (object) {
            text = [object valueForKeyPath:((TOMSSuggestionBarView *)self.collectionView).attributeName];
        } else {
            @throw [NSException exceptionWithName:@"TOMSObjectNotFoundException" reason:@"Did not fetch enaugh data to fill all of the cells." userInfo:nil];
        }
    }
    @catch (NSException *exception) {
        text = @"";
    }
    
    suggestionBarCell.textLabel.text = text;
}

@end
