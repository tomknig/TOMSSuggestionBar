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
#import "Person.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) TOMSSuggestionBar *suggestionBar;
@end

@implementation ViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self mockSomePersons];
    
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.suggestionBar = [[TOMSSuggestionBar alloc] init];
    [self.suggestionBar subscribeTextInputView:self.textField
                toSuggestionsForAttributeNamed:@"name"
                                 ofEntityNamed:@"Person"
                                  inModelNamed:@"Model"];
}

#pragma mark - Mocks

- (NSArray *)mockedNames
{
    return @[
             @"Steve",
             @"Woz",
             @"Tom",
             @"Steven",
             @"Shalymar",
             @"Khader"
             ];
}

- (void)mockSomePersons
{
    NSManagedObjectContext *managedObjectContext = [TOMSCoreDataManager managerForModelName:@"Model"].managedObjectContext;
    
    for (NSString *name in [self mockedNames]) {
        [Person toms_newObjectFromDictionary:@{@"name": name}
                                   inContext:managedObjectContext
                             autoSaveContext:NO];
    }

}

@end
