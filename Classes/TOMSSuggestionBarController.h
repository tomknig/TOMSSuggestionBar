//
//  TOMSSuggestionBarController.h
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataCollectionViewController.h"

@class TOMSSuggestionBarView;

@interface TOMSSuggestionBarController : TOMSCoreDataCollectionViewController

- (instancetype)initWithSuggestionBarView:(TOMSSuggestionBarView *)suggestionBarView;

- (void)suggestableTextDidChange:(NSString *)context;

@end
