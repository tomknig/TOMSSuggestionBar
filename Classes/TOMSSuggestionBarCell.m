//
//  TOMSSuggestionBarCell.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSSuggestionBarCell.h"
#import "TOMSSuggestionBar.h"
#import "TOMSSuggestionBarController.h"

@implementation TOMSSuggestionBarCell

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self designatedInitialization];
    }
    return self;
}

- (void)designatedInitialization
{
    self.textLabel = [[TOMSMorphingLabel alloc] initWithFrame:self.bounds];
    self.textLabel.textColor = self.tintColor;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.userInteractionEnabled = NO;
    
    [self addSubview:self.textLabel];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(touchedUpInside)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSuggestionBarController:(TOMSSuggestionBarController *)suggestionBarController
{
    _suggestionBarController = suggestionBarController;
    
    self.backgroundColor = self.suggestionBarController.suggestionBar.tileColor;
    self.tintColor = self.suggestionBarController.suggestionBar.textColor;
    self.textLabel.textColor = self.suggestionBarController.suggestionBar.textColor;
    self.textLabel.font = self.suggestionBarController.suggestionBar.font;
}

#pragma mark - Delegation

- (void)touchedUpInside
{
    [self.suggestionBarController didSelectSuggestionAtIndexPath:self.indexPath];
}

@end
