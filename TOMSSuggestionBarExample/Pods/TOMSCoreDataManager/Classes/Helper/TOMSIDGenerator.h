//
//  TOMSIDGenerator.h
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOMSIDGenerator : NSObject

#pragma mark - Singleton
+ (instancetype)sharedInstance;

#pragma mark - ID Generation
@property (readonly, atomic, strong) NSString *UUID;
+ (NSString *)uniqueIdentifier;

@end
