//
//  ViewController.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 14/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "ViewController.h"
#import <TOMSCoreDataManager/TOMSCoreDataManager.h>
#import <TOMSSuggestionBar/TOMSSuggestionBar.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TOMSSuggestionBar *suggestionBar = [[TOMSSuggestionBar alloc] init];
    [suggestionBar subscribeTextInputView:self.textField
           toSuggestionsForAttributeNamed:@"name"
                            ofEntityNamed:@"Person"
                             inModelNamed:@"Model"];
}

@end
