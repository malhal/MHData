//
//  NSPersistentStoreCoordinator+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSPersistentStoreCoordinator (MH)

// returns a shared instance of a coordinator using the MH_defaultManagedObjectModel and MH_defaultSQLiteStoreURL.
+ (NSPersistentStoreCoordinator*)MH_defaultCoordinatorWithError:(NSError**)error;

// returns a new instance of a coordinator using the MH_defaultManagedObjectModel and MH_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)MH_coordinator;

// returns a new instance of a coordinator using the supplied model and MH_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)MH_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model;

// convenience for creating a coordinator with a sqlite store already added.
+ (NSPersistentStoreCoordinator*)MH_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL*)storeURL error:(NSError**)error;

// Adds a sqlite store at the url with default options.
- (NSPersistentStore*)MH_addStoreWithURL:(NSURL*)storeURL error:(NSError**)error;

// Returns a URL path within Application Support/Executable Name/Bundle ID.sqlite creating directories as necessary.
+ (NSURL *)MH_defaultStoreURLWithError:(NSError**)error;

// Returns the Bundle ID.sqlite
+ (NSString*)MH_defaultStoreFilename;

// Returns the path to Application Support/Executable Name creating directories as necessary.
+ (NSURL *)MH_applicationSupportDirectoryWithError:(NSError**)error;

@end

NS_ASSUME_NONNULL_END