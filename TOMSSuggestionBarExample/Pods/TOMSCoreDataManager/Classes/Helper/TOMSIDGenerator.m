//
//  TOMSIDGenerator.m
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOMSIDGenerator.h"
#import <CommonCrypto/CommonDigest.h>

#define kTOMSUUIDKey @"de.tomknig.kTOMSUUIDKey"
#define kTOMSTimeStamp [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000]

@interface TOMSIDGenerator ()
@property (readwrite, atomic, strong) NSString *UUID;
@end

@implementation TOMSIDGenerator
@synthesize UUID = _UUID;

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static TOMSIDGenerator *_sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - ID Generation

- (NSString *)UUID
{
    @synchronized([TOMSIDGenerator sharedInstance]) {
        if (!_UUID) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            _UUID = [userDefaults objectForKey:kTOMSUUIDKey];
            
            if (!_UUID || !_UUID.length) {
                _UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                [userDefaults setObject:_UUID forKey:kTOMSUUIDKey];
            }
        }
        
        return _UUID;
    }
}

+ (NSString *)uniqueIdentifier
{
    @synchronized([TOMSIDGenerator sharedInstance]) {
        return [self sha1RepresentationOfString:[NSString stringWithFormat:@"%@%@", [TOMSIDGenerator sharedInstance].UUID, kTOMSTimeStamp]];
    }
}

#pragma mark - SHA1 Helper

+ (NSString *)sha1RepresentationOfString:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

#pragma mark - Atomic Setters

- (void)setUUID:(NSString *)UUID
{
    @synchronized([TOMSIDGenerator sharedInstance]) {
        _UUID = UUID;
    }
}

@end
