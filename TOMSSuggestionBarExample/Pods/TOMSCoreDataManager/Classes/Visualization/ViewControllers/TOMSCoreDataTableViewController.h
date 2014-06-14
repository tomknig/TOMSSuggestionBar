//
//  TOMSCoreDataTableViewController.h
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 09/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOMSCoreDataViewDataSource.h"

@interface TOMSCoreDataTableViewController : UITableViewController <TOMSCoreDataViewDataSource>

@property (readonly) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

@end
