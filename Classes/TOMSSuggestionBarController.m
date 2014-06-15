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

#pragma mark - Suggesting

- (void)suggestableTextDidChange:(NSString *)context
{
    self.coreDataFetchController.predicate = [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@", [self attributeName], [NSString stringWithFormat:@"*%@*", context]];
}

#pragma mark - Bridged Getters

- (NSInteger)numberOfSuggestionFields
{
    return((TOMSSuggestionBarView *)self.collectionView).numberOfSuggestionFields;
}

- (NSString *)attributeName
{
    return((TOMSSuggestionBarView *)self.collectionView).attributeName;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfSuggestionFields = [self numberOfSuggestionFields];
    CGFloat width = (self.collectionView.frame.size.width - (numberOfSuggestionFields - 1) * kTOMSSuggestionCellPadding) / (CGFloat)numberOfSuggestionFields;
    CGFloat height = self.collectionView.frame.size.height;
    
    if (numberOfSuggestionFields % 2 == 0) {
        return CGSizeMake(floorf(width), height);
    } else {
        CGFloat maxWidth = floorf(width * 1.02532);
        if (indexPath.row == floorf(numberOfSuggestionFields / 2)) {
            return CGSizeMake(maxWidth, height);
        } else {
            width = (self.collectionView.frame.size.width - (numberOfSuggestionFields - 1) * kTOMSSuggestionCellPadding - maxWidth) / (CGFloat)(numberOfSuggestionFields - 1);
            return CGSizeMake(floorf(width), height);
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfSuggestionFields];
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
    return [NSPredicate predicateWithFormat:@"%@.length > 0", [self attributeName]];
}

- (NSArray *)defaultSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:[self attributeName] ascending:YES]];
}

- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    TOMSSuggestionBarCell *suggestionBarCell = (TOMSSuggestionBarCell *)cell;
    NSString *text;
    
    @try {
        NSManagedObject *object = [self.coreDataFetchController objectAtIndexPath:indexPath];
        if (object) {
            text = [object valueForKeyPath:[self attributeName]];
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
