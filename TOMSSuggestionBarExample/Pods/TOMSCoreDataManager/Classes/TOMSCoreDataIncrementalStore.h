//
//  TOMSCoreDataIncrementalStore.h
//  TOMSCoreDataManager
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <AFIncrementalStore/AFIncrementalStore.h>
#import "AFRESTClient.h"

@interface TOMSCoreDataIncrementalStore : AFIncrementalStore

@property (strong, nonatomic) AFRESTClient<AFIncrementalStoreHTTPClient> *client;

@end
