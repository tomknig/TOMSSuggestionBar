//
//  TOMSSuggestionBar.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 15/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSSuggestionBar.h"
#import "TOMSSuggestionBarView.h"
#import "TOMSSuggestionBarController.h"

@interface TOMSSuggestionBar ()
@property (nonatomic, strong) TOMSSuggestionBarView *suggestionBarView;
@property (nonatomic, weak) UIControl<UITextInput> *textInputView;
@end

@implementation TOMSSuggestionBar

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.suggestionBarView = [[TOMSSuggestionBarView alloc] initWithFrame:[TOMSSuggestionBar suggestionBarFrame]
                                                     numberOfSuggestionFields:3];
        [self designatedInitialization];
    }
    return self;
}

- (instancetype)initWithNumberOfSuggestionFields:(NSInteger)numberOfSuggestionFields
{
    self = [super init];
    if (self) {
        self.suggestionBarView = [[TOMSSuggestionBarView alloc] initWithFrame:[TOMSSuggestionBar suggestionBarFrame]
                                                     numberOfSuggestionFields:numberOfSuggestionFields];
        [self designatedInitialization];
    }
    return self;
}

- (void)designatedInitialization
{

}

#pragma mark - Suggestion setup

- (BOOL)subscribeTextInputView:(UIControl<UITextInput> *)textInputView
toSuggestionsForAttributeNamed:(NSString *)attributeName
                 ofEntityNamed:(NSString *)entityName
                  inModelNamed:(NSString *)modelName
{
    if ([textInputView respondsToSelector:@selector(setInputAccessoryView:)]) {
        self.suggestionBarView.attributeName = attributeName;
        self.suggestionBarView.entityName = entityName;
        self.suggestionBarView.modelName = modelName;
        
        self.textInputView = textInputView;
        
        [self.textInputView performSelector:@selector(setInputAccessoryView:)
                                 withObject:self.suggestionBarView];
        
        [self.textInputView addTarget:self
                               action:@selector(textChanged:)
                     forControlEvents:UIControlEventEditingChanged];
        
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [self.textInputView removeTarget:self
                              action:@selector(textChanged:)
                    forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Suggesting

- (void)textChanged:(UIControl<UITextInput> *)textInputView
{
    UITextRange *wholeTextRange = [textInputView textRangeFromPosition:textInputView.beginningOfDocument
                                                            toPosition:textInputView.endOfDocument];
    NSString *wholeText = [textInputView textInRange:wholeTextRange];
    
    NSRange lastWordRange = [wholeText rangeOfString:@" "
                                             options:NSBackwardsSearch];
    
    NSString *lastWord;
    
    if (lastWordRange.location == NSNotFound) {
        lastWord = wholeText;
    } else {
        lastWord = [wholeText substringFromIndex:lastWordRange.location + 1];
    }
    
    [self.suggestionBarView.suggestionBarController suggestableTextDidChange:lastWord];
}

#pragma mark - Passing setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.suggestionBarView.backgroundColor = backgroundColor;
}

- (void)setTileColor:(UIColor *)tileColor
{
    _tileColor = tileColor;
    //TODO pass this value to all existing cells
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    //TODO pass this value to all existing cells
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    //TODO pass this value to all existing cells
}

#pragma mark - Default configuration

+ (CGRect)suggestionBarFrame
{
    return CGRectMake(0, 21, 320, 42);//TODO genrify
}

+ (UIColor *)defaultBackgroundColor
{
    return [UIColor colorWithRed:210.0/255.0 green:213.0/255.0 blue: 219.0/255.0 alpha:1];
}

+ (UIColor *)defaultTileColor
{
    return [UIColor colorWithRed:174.0/255.0 green:179.0/255.0 blue: 190.0/255.0 alpha:1];
}

+ (UIColor *)defaultTextColor
{
    return [UIColor whiteColor];
}

+ (UIFont *)defaultFont
{
    return [UIFont systemFontOfSize:16];
}

@end
