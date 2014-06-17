//
//  ViewController.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 14/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "BaseViewController.h"
#import <TOMSCoreDataManager/TOMSCoreDataManager.h>
#import <TOMSSuggestionBar/TOMSSuggestionBar.h>

@interface BaseViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation BaseViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TOMSSuggestionBar *suggestionBar = [[TOMSSuggestionBar alloc] init];
    [suggestionBar subscribeTextInputView:self.textField
           toSuggestionsForAttributeNamed:@"name"
                            ofEntityNamed:@"Person"
                             inModelNamed:@"Model"];
    
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
