//
//  TOMSSuggestionBarController.h
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSCoreDataCollectionViewController.h"

@class TOMSSuggestionBarView;
@class TOMSSuggestionBar;

@interface TOMSSuggestionBarController : TOMSCoreDataCollectionViewController

- (instancetype)initWithSuggestionBarView:(TOMSSuggestionBarView *)suggestionBarView;

- (void)suggestableTextDidChange:(NSString *)context;

- (void)didSelectSuggestionAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) TOMSSuggestionBar *suggestionBar;

@end
