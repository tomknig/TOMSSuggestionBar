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

/**
 Returns a `NSString` that is a substring of the overall textInput. It represents the substring that is relevant for fetching instances from CoreData for suggestions.
 
 @param suggestionBar The suggestionBar that is displaying the contents.
 @param textInput The whole text within the suggestionBars subscribed textInput.
 @param caretLocation The location of the caret.
 */
- (NSString *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
    relevantContextForInput:(NSString *)textInput
              caretLocation:(NSInteger)caretLocation;

/**
 Returns a `NSPredicate` to define a fetch request for a specific context.
 
 @param suggestionBar The suggestionBar that is displaying the contents.
 @param context The currently relevant textsnipped that should be used in the predicate.
 @param attributeName The name of the attribute that values are displayed of.
 */
- (NSPredicate *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
           predicateForContext:(NSString *)context
                 attributeName:(NSString *)attributeName;

/**
 Returns a `NSArray` of `NSSortDescriptor` to specify the order in which fetched instances are displayed.
 
 @param suggestionBar The suggestionBar that is displaying the contents.
 @param attributeName The name of the attribute that values are displayed of.
 */
- (NSArray *)suggestionBar:(TOMSSuggestionBar *)suggestionBar
sortDescriptorsForAttributeName:(NSString *)attributeName;

@end
