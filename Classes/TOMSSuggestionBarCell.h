//
//  TOMSSuggestionBarCell.h
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TOMSMorphingLabel/TOMSMorphingLabel.h>

@class TOMSSuggestionBarController;

@interface TOMSSuggestionBarCell : UICollectionViewCell

@property (nonatomic, strong) TOMSMorphingLabel *textLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) TOMSSuggestionBarController *suggestionBarController;

@end
