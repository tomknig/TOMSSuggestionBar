//
//  TOMSSuggestionDelegate.h
//  Pods
//
//  Created by Tom König on 17/06/14.
//
//

#import <Foundation/Foundation.h>

@class TOMSSuggestionBar;
@class NSManagedObject;

@protocol TOMSSuggestionDelegate <NSObject>

@optional

/**
 Gets called when a suggestion tile is tapped.
 
 @param suggestionBar The suggestionBar containing the tapped tile.
 @param suggestion The text on the tapped tile.
 @param associatedObject The instance fetched from CoreData that is represented by the tapped text.
 */
- (void)suggestionBar:(TOMSSuggestionBar *)suggestionBar
  didSelectSuggestion:(NSString *)suggestion
     associatedObject:(NSManagedObject *)associatedObject;

@end
