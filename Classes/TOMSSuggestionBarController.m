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
#import "TOMSSuggestionBar.h"

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
    if (self.suggestionBar.dataSource && [self.suggestionBar.dataSource respondsToSelector:@selector(suggestionBar:predicateForContext:attributeName:)]) {
        self.coreDataFetchController.predicate = [self.suggestionBar.dataSource suggestionBar:self.suggestionBar
                                                                          predicateForContext:context
                                                                                attributeName:[self attributeName]];
    } else {
        self.coreDataFetchController.predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", [self attributeName], context];
    }
}

- (NSManagedObject *)objectForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfSuggestionFields = [self numberOfSuggestionFields];
    if (numberOfSuggestionFields % 2 == 0) {
        return [self.coreDataFetchController objectAtIndexPath:indexPath];
    } else {
        NSManagedObject *object;
        
        @try {
            NSInteger row = (indexPath.row - floorf(numberOfSuggestionFields / 2.f)) * 2;
            if (row < 0) {
                row = -row - 1;
            }
            NSIndexPath *recalculatedIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
            object = [self.coreDataFetchController objectAtIndexPath:recalculatedIndexPath];
        }
        @catch (NSException *exception) {
            object = nil;
        }
        
        return object;
    }
}

- (void)didSelectSuggestionAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self objectForIndexPath:indexPath];
    if (object) {
        NSString *suggestion = [object valueForKeyPath:[self attributeName]];
        
        if (self.suggestionBar.delegate && [self.suggestionBar.delegate respondsToSelector:@selector(suggestionBar:didSelectSuggestion:associatedObject:)]) {
            [self.suggestionBar.delegate suggestionBar:self.suggestionBar
                                   didSelectSuggestion:suggestion
                                      associatedObject:object];
        } else {
            NSString *replacement = [suggestion stringByAppendingString:@" "];
            NSRange contextRange = [self.suggestionBar rangeOfRelevantContext];
            UITextPosition *beginning = self.suggestionBar.textInputView.beginningOfDocument;
            UITextPosition *start = [self.suggestionBar.textInputView positionFromPosition:beginning
                                                                                    offset:contextRange.location];
            UITextPosition *end = [self.suggestionBar.textInputView positionFromPosition:start
                                                                                  offset:contextRange.length];
            UITextRange *replacementRange = [self.suggestionBar.textInputView textRangeFromPosition:start
                                                                                         toPosition:end];
            
            [self.suggestionBar.textInputView replaceRange:replacementRange
                                                  withText:replacement];
        }
    }
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
    return [cellIdentifier stringByAppendingFormat:@"_%i", indexPath.row];
}

- (NSPredicate *)defaultPredicate
{
    if (self.suggestionBar.dataSource && [self.suggestionBar.dataSource respondsToSelector:@selector(suggestionBar:predicateForContext:attributeName:)]) {
        return [self.suggestionBar.dataSource suggestionBar:self.suggestionBar
                                        predicateForContext:@""
                                              attributeName:[self attributeName]];
    } else {
        return [NSPredicate predicateWithFormat:@"%@.length > 0", [self attributeName]];
    }
}

- (NSArray *)defaultSortDescriptors
{
    if (self.suggestionBar.dataSource && [self.suggestionBar.dataSource respondsToSelector:@selector(suggestionBar:sortDescriptorsForAttributeName:)]) {
        return [self.suggestionBar.dataSource suggestionBar:self.suggestionBar
                            sortDescriptorsForAttributeName:[self attributeName]];
    } else {
        return @[[NSSortDescriptor sortDescriptorWithKey:[self attributeName] ascending:YES]];
    }
}

- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    TOMSSuggestionBarCell *suggestionBarCell = (TOMSSuggestionBarCell *)cell;
    
    suggestionBarCell.indexPath = indexPath;
    suggestionBarCell.suggestionBarController = self;
    
    NSString *text;
    @try {
        NSManagedObject *object = [self objectForIndexPath:indexPath];
        if (object) {
            text = [object valueForKeyPath:[self attributeName]];
        } else {
            @throw [NSException exceptionWithName:@"TOMSObjectNotFoundException"
                                           reason:@"Did not fetch enaugh data to fill all of the cells."
                                         userInfo:nil];
        }
    }
    @catch (NSException *exception) {
        text = @"";
    }
    
    suggestionBarCell.textLabel.text = text;
}

@end
