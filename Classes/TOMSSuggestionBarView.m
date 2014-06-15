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

@interface TOMSSuggestionBarView ()
@property (nonatomic, strong) TOMSSuggestionBarController *suggestionBarController;//TODO: does it have to be strong?
@end

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
        
        [self registerClass:[TOMSSuggestionBarCell class] forCellWithReuseIdentifier:@"kTOMSSuggestionBarCell"];
        self.suggestionBarController = [[TOMSSuggestionBarController alloc] initWithSuggestionBarView:self];
        self.backgroundColor = [TOMSSuggestionBar defaultBackgroundColor];
    }
    return self;
}

@end
