//
//  TOMSSuggestionBarCell.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSSuggestionBarCell.h"
#import "TOMSSuggestionBar.h"

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
    self.backgroundColor = [TOMSSuggestionBar defaultTileColor];
    self.tintColor = [TOMSSuggestionBar defaultTextColor];
    
    self.textLabel = [[TOMSMorphingLabel alloc] initWithFrame:self.bounds];
    self.textLabel.font = [TOMSSuggestionBar defaultFont];
    self.textLabel.textColor = self.tintColor;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.textLabel];
    
    [self test];
}

- (void)test
{
    self.textLabel.text = @"Swift";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.textLabel.text = @"Swiftilicious";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.textLabel.text = @"delicious";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self test];
            });
        });
    });
}

@end
