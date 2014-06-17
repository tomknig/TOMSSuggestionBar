# TOMSCoreDataManager
Comfortable persistency with CoreData integrated views plus support for an optional RESTful backend.
TOMSCoreDataManager provides handy superclasses for your custom TableViewController or CollectionViewController implementation as well as an useful ManagedObject extension.

## Installation with CocoaPods

TOMSCoreDataManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

#### Podfile

```ruby
platform :ios, '7.0'
pod "TOMSCoreDataManager", "~> 0.1.0"
```

#### Xcode Project .pch file

You could import the project in a precompiled header file of your project to make all the components of TOMSCoreDataManager accessible throughout your project.

```objective-c
#import <TOMSCoreDataManager/TOMSCoreDataManager.h>
```

## Usage

1. Create a new Xcode project and don't let Xcode include the CoreData code.
2. Install TOMSCoreDataManager as explained above.
3. Introduce your custom .xcdatamodel
4. Create a subclass of either TOMSCoreData..ViewController
5. Adopt the DataSource as described in the following:

### TableViewController and CollectionViewController

`TOMSCoreDataTableViewController` and `TOMSCoreDataCollectionViewController` provide a great point for your implementations to be subclasses of.
Simply inherit from the appropriate superclass and implement the following DataSource methods:
(The succeeding examples assume that there is a Model.xcdatamodel, which defines an entity `Person` with two attributes `objectId` and `name`)

```objective-c
/**
The modelName specifies the name of the model, that contains the displayed entities.
*/
- (NSString *)modelName
{
    return @"Model";//without .xcdatamodel extension
}

/**
The entityName specifies the entities that should be displayed by the table (or collection) view.
Usually those entityNames are the class names of the generated NSManagedObject subclasses.
*/
- (NSString *)entityName
{
    return @"Person";
}

/**
The cellIdentifierForItemAtIndexPath specifies the cell identifier for one specific indexPath.
This can be used to work with your custom styled cells from the interface builder.
*/
- (NSString *)cellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"Cell";
    return cellIdentifier;
}

/**
Provide a defaultPredicate to specify which data should be fetched if there is no custom or predicate present at a time.
*/
- (NSPredicate *)defaultPredicate
{
    return [NSPredicate predicateWithFormat:@"name.length > 0"];
}

/**
Provide defaultSortDescriptors to specify in which order data should be presented by default.
*/
- (NSArray *)defaultSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
}

/**
configureCell:forIndexPath: is getting called by the superclass while setting a cell up.
Use this method as entry point to configure the contents of a cell at a specific indexPath.
*/
- (void)configureCell:(id)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = (UITableViewCell *)cell;
    NSManagedObject *object = [self.coreDataFetchController objectAtIndexPath:indexPath];

    if ([object isKindOfClass:[Person class]]) {
        Person *person = (Person *)object;
        tableViewCell.textLabel.text = person.name;
        tableViewCell.detailTextLabel.text = person.objectId;
    }
}
```

---

### FetchController

The `coreDataFetchController` is a private property of both of the preceding ViewControllers.
It can be used to easily influence and update the visible set of Data.
To do so you can set the `predicate`, the `sortDescriptors` or both at the same time.
Doing so is simple, since they are properties of the `coreDataFetchController` and can be accessed through dot syntax.

##### setPredicate:

Setting the predicate will perform a fetch request to the database under the hood.
The present table- or collectionView will automatically and autonomously update its content.

```objective-c
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Steve"]
self.coreDataResultsController.predicate = predicate;
```

##### setSortDescriptors:

Setting the sortDescriptors will reorder the table- or collectionViews displayed data appropriately.

```objective-c
NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]
self.coreDataResultsController.sortDescriptors = sortDescriptors;
```

##### setPredicate:sortDescriptors:

Since setting the `predicate` or the `sortDescriptors` does immediately take effect, there is the following helper method to set both at the same time.

```objective-c
[self.coreDataResultsController setPredicate:predicate sortDescriptors:sortDescriptors];
```

---

### NSManagedObject+TOMSHelpers

This category provides some helpful methods.
It is particularly useful to import `NSManagedObject+TOMSHelpers.h` in your custom `NSManagedObject` subclasses.
This category enables you to call the following helpers on your custom models.

```objective-c
/**
Finds and returns an object for the given unique identifier in a context.
*/
+ (instancetype)toms_objectForUniqueIdentifier:(NSString *)uniqueIdentifier
                                     inContext:(NSManagedObjectContext *)context;

/**
Creates an object for the given associative dictionary.
The dictionaries keys should match the entities property names.
The context is saved automatically after inserting the object.
*/
+ (instancetype)toms_newObjectFromDictionary:(NSDictionary *)dictionary
                                   inContext:(NSManagedObjectContext *)context;

/**
Creates an object for the given associative dictionary.
The dictionaries keys should match the entities property names.
The context is saved automatically after inserting the object if specified.
*/
+ (instancetype)toms_newObjectFromDictionary:(NSDictionary *)dictionary
                                   inContext:(NSManagedObjectContext *)context
                             autoSaveContext:(BOOL)autoSave;

/**
Returns an array of instances that match the predicate, sorted by the sort descriptors.
*/
+ (NSArray *)toms_objectsForPredicate:(NSPredicate *)predicate
                      sortDescriptors:(NSArray *)sortDescriptors
                            inContext:(NSManagedObjectContext *)context;

/**
Returns an array of instances that match the predicate.
*/
+ (NSArray *)toms_objectsForPredicate:(NSPredicate *)predicate
                            inContext:(NSManagedObjectContext *)context;
```

Note that within a `TOMSCoreData{Table, Collection}ViewController` the appropriate `context` can be easily accessed by their `managedObjectContext` property.
Unique identifiers are automatically generated for all objects that are created via the `TOMSHelpers` category.

```objective-c
Person *steve = [Person toms_newObjectFromDictionary:@{
                                                      @"name" : @"Steve"
                                                      }
                                           inContext:self.managedObjectContext];
```

TOMSCoreDataManager assumes all entities to have an attribute of name `objectId` to represent the unique identifier.
However if you either want to specify another attribute name for the unique identifier or you don't want the objects to be uniquely identifiable you can implement one of the following methods within your NSManagedObject subclass.

```objective-c
#pragma mark - optional implementation
/**
The returned string has to match an attribute of the entity. This will be assumed to be the objects unique identifier.
*/
+ (NSString *)toms_uniqueIdentifier
{
  return @"uniqueIdentifier";
}

/**
If you return NO, there will be no unique identifiers generated for this particular entity.
*/
+ (BOOL)toms_shouldAutoGenerateGloballyUniqueIdentifiers
{
  return NO;
}
```

---

### AFRestClient

In order to synchronize the local database with a restful webservice, you can implement an optional DataSource method to specify your subclassed AFRestClient.
To do so you can simply add `backingRESTClientClass` to your `TOMSCoreData{Table, Collection}ViewController.m` and return the class of you implementation.

```objective-c
- (Class)backingRESTClientClass
{
    return [YourRestClient class];
}
```

Since the CoreData stack initializes its own instance of `YourRestClient`, it is important for you to override the simple `init` method and within it initialize itself by calling supers `initWithBaseURL`.
An initializer could look like the following:
```objective-c
- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://yourapp.herokuapp.com"]];

    if (self) {
      [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
      [self setDefaultHeader:@"Accept" value:@"application/json"];
    }

    return self;
}
```

Implementing the rest of the client can be easily done, following the guide on the [AFIncrementalStore](https://github.com/AFNetworking/AFIncrementalStore#mapping-core-data-to-http) project page.

## Dependencies

TOMSCoreDataManager depends on [AFIncrementalStore](https://github.com/AFNetworking/AFIncrementalStore) by [Mattt Thompson](https://github.com/mattt/). Thanks for that!

## Author

[Tom König](http://github.com/TomKnig) [@TomKnig](https://twitter.com/TomKnig)

## License

TOMSCoreDataManager is available under the MIT license. See the LICENSE file for more info.
