//
//  TOMSSuggestionBarLayout.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSSuggestionBarLayout.h"
#import "TOMSSuggestionBarView.h"

@implementation TOMSSuggestionBarLayout

- (instancetype)initWithFrame:(CGRect)frame
     numberOfSuggestionFields:(NSInteger)numberOfSuggestionFields
{
    self = [super init];
    if (self) {
        CGFloat width = (frame.size.width - (numberOfSuggestionFields - 1) * kTOMSSuggestionCellPadding) / (CGFloat)numberOfSuggestionFields;
        self.itemSize = CGSizeMake(width, frame.size.height);
        self.minimumInteritemSpacing = kTOMSSuggestionCellPadding;
    }
    return self;
}

@end
