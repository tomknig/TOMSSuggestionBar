//
//  TOMSSuggestionDataSource.h
//  Pods
//
//  Created by Tom König on 17/06/14.
//
//

#import <Foundation/Foundation.h>

@class TOMSSuggestionBar;

@protocol TOMSSuggestionDataSource <NSObject>

@optional

- (NSString *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
    relevantContextForInput:(NSString *)textInput
              caretLocation:(NSInteger)caretLocation;

- (NSPredicate *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
           predicateForContext:(NSString *)context
                 attributeName:(NSString *)attributeName;

- (NSArray *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
sortDescriptorsForAttributeName:(NSString *)attributeName;

@end
