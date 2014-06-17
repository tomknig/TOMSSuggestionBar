//
//  TOMSSuggestionBar.h
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOMSSuggestionDataSource.h"
#import "TOMSSuggestionDelegate.h"
#import "UIControl+TOMSSuggestionBar.h"

@interface TOMSSuggestionBar : NSObject

- (instancetype)initWithNumberOfSuggestionFields:(NSInteger)numberOfSuggestionFields;

- (BOOL)subscribeTextInputView:(UIControl<UITextInput> *)textInputView
toSuggestionsForAttributeNamed:(NSString *)attributeName
                 ofEntityNamed:(NSString *)entityName
                  inModelNamed:(NSString *)modelName;

- (NSRange)rangeOfRelevantContext;

@property (nonatomic, weak) UIControl<UITextInput> *textInputView;
@property (nonatomic, weak) id<TOMSSuggestionDataSource> dataSource;
@property (nonatomic, weak) id<TOMSSuggestionDelegate> delegate;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *tileColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

@end
