//
//  TOMSSuggestionBarView.m
//  Pods
//
//  Created by Tom König on 15/06/14.
//
//

#import "TOMSSuggestionBarView.h"
#import "TOMSSuggestionBarController.h"
#import "TOMSSuggestionBarLayout.h"
#import "TOMSSuggestionBarCell.h"
#import "TOMSSuggestionBar.h"

@implementation TOMSSuggestionBarView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
     numberOfSuggestionFields:(NSInteger)numberOfSuggestionFields
{
    TOMSSuggestionBarLayout *suggestionBarLayout = [[TOMSSuggestionBarLayout alloc] initWithFrame:frame
                                                                         numberOfSuggestionFields:numberOfSuggestionFields];
    self = [super initWithFrame:frame collectionViewLayout:suggestionBarLayout];
    if (self) {
        self.numberOfSuggestionFields = numberOfSuggestionFields;
        
        [self registerCellClasses];
        self.suggestionBarController = [[TOMSSuggestionBarController alloc] initWithSuggestionBarView:self];
        self.delegate = self.suggestionBarController;
    }
    return self;
}

- (void)registerCellClasses
{
    static NSString * const cellIdentifier = @"kTOMSSuggestionBarCell";
    for (int i = 0; i < self.numberOfSuggestionFields; ++i) {
        [self registerClass:[TOMSSuggestionBarCell class] forCellWithReuseIdentifier:[cellIdentifier stringByAppendingFormat:@"_%d", i]];
    }
}

@end
