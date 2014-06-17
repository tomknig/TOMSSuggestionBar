//
//  UIControl+TOMSSuggestionBar.m
//  Pods
//
//  Created by Tom König on 17/06/14.
//
//

#import "UIControl+TOMSSuggestionBar.h"
#import <objc/runtime.h>

@implementation UIControl (TOMSSuggestionBar)

#pragma mark - Property extension

NSString const *toms_key = @"TOMSSuggestionBarCategoryKey";

- (void)setToms_suggestionBar:(TOMSSuggestionBar *)toms_suggestionBar
{
    objc_setAssociatedObject(self, &toms_key, toms_suggestionBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TOMSSuggestionBar *)toms_suggestionBar
{
    return objc_getAssociatedObject(self, &toms_key);
}

@end
