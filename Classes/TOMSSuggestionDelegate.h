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

- (void)suggestionBar:(TOMSSuggestionBar *)suggestionBar
  didSelectSuggestion:(NSString *)suggestion
     associatedObject:(NSManagedObject *)associatedObject;

@end
