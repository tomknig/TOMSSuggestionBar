//
//  TOMSSuggestionBarView.h
//  Pods
//
//  Created by Tom König on 15/06/14.
//
//

#import <UIKit/UIKit.h>

#define kTOMSSuggestionCellPadding 2.f

@class TOMSSuggestionBarController;

@interface TOMSSuggestionBarView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame
     numberOfSuggestionFields:(NSInteger)numberOfSuggestionFields;

@property (nonatomic, strong) TOMSSuggestionBarController *suggestionBarController;
@property (nonatomic, assign) NSInteger numberOfSuggestionFields;
@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *modelName;

@end
