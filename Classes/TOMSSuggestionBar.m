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
@property (nonatomic, assign) NSRange relevantContextRange;
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
        numberOfSuggestionFields = MAX(1, numberOfSuggestionFields);
        self.suggestionBarView = [[TOMSSuggestionBarView alloc] initWithFrame:[TOMSSuggestionBar suggestionBarFrame]
                                                     numberOfSuggestionFields:numberOfSuggestionFields];
        [self designatedInitialization];
    }
    return self;
}

- (void)designatedInitialization
{
    self.suggestionBarView.suggestionBarController.suggestionBar = self;
    self.relevantContextRange = NSMakeRange(0, 0);
}

#pragma mark - Suggestion setup

- (BOOL)subscribeTextInputView:(UIControl<UITextInput> *)textInputView
toSuggestionsForAttributeNamed:(NSString *)attributeName
                 ofEntityNamed:(NSString *)entityName
                  inModelNamed:(NSString *)modelName
{
    if ([textInputView respondsToSelector:@selector(setInputAccessoryView:)]) {
        textInputView.autocorrectionType = UITextAutocorrectionTypeNo;
        textInputView.toms_suggestionBar = self;
        
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
    NSString *relevantContext;
    UITextPosition *caretPosition = textInputView.selectedTextRange.start;

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(suggestionBar:relevantContextForInput:caretLocation:)]) {
        UITextRange *inputRange = [textInputView textRangeFromPosition:textInputView.beginningOfDocument
                                                            toPosition:textInputView.endOfDocument];
        NSString *inputText = [textInputView textInRange:inputRange];
        
        relevantContext = [self.dataSource suggestionBar:self
                                 relevantContextForInput:inputText
                                           caretLocation:[textInputView offsetFromPosition:textInputView.beginningOfDocument
                                                                                toPosition:caretPosition]];
        self.relevantContextRange = [inputText rangeOfString:relevantContext];
    } else {
        UITextRange *inputRange = [textInputView textRangeFromPosition:textInputView.beginningOfDocument
                                                            toPosition:caretPosition];
        
        NSString *inputText = [textInputView textInRange:inputRange];
        NSRange lastWordRange = [inputText rangeOfString:@" "
                                                 options:NSBackwardsSearch];
        
        if (lastWordRange.location == NSNotFound) {
            relevantContext = inputText;
            self.relevantContextRange = NSMakeRange(0, inputText.length);
        } else {
            NSInteger location = lastWordRange.location + 1;
            relevantContext = [inputText substringFromIndex:location];
            self.relevantContextRange = NSMakeRange(location, inputText.length - location);
        }
    }
    
    [self.suggestionBarView.suggestionBarController suggestableTextDidChange:relevantContext];
}

- (NSRange)rangeOfRelevantContext
{
    return self.relevantContextRange;
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
