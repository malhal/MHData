//
//  CoreData+MH.h
//  MHData
//
//  Created by Malcolm Hall on 20/06/2009.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

// It should be possible to use different instances with the same filename on different threads. The instances will share the same persistant coordinator.

// Errors from things not found in the bundle throw exceptions. Runtime errors are returned as errors.

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectContext(MH)
    
// returns a main queue context using the default persistent store coordinator.
// exceptions if fails to create the store.
+(instancetype)mh_defaultContext;

// Creates a new managed object context associated with a private queue.
// Designed to work on a context that already has an SQLite store added because it creates a new coordinator with the same URL.
-(NSManagedObjectContext *)mh_createPrivateQueueContextWithError:(NSError **)error;

// creates a child context with the same concurrency type.
-(NSManagedObjectContext*)mh_createChildContext;

//exceptions if entity does not exist
-(NSManagedObject*)mh_insertNewObjectForEntityName:(NSString*)name;

-(NSEntityDescription*)mh_entityDescriptionForName:(NSString*)name;

- (NSArray*)mh_fetchObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

- (id)mh_fetchObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

// dictionary of keys and values that an and predicate will be used. Include NSNull for null values in the query.
- (NSManagedObject*)mh_fetchObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error;

// If there was an error fetching the error is set and nil is returned. If in an insert is required an object will always be returned with no error.
- (NSManagedObject*)mh_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error;

- (BOOL)mh_save:(NSError**)error rollbackOnError:(BOOL)rollbackOnError;

// function is one of the predefined NSExpression functions, e.g. max: sum: etc. Returns nil if there is no value.
- (id)mh_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

@end

@interface NSPersistentStoreCoordinator (MH)

// returns a shared instance of a coordinator using the mh_defaultManagedObjectModel and mh_defaultSQLiteStoreURL.
+ (NSPersistentStoreCoordinator*)mh_defaultCoordinatorWithError:(NSError**)error;

// returns a new instance of a coordinator using the mh_defaultManagedObjectModel and mh_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mh_coordinator;

// returns a new instance of a coordinator using the supplied model and mh_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mh_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model;

// convenience for creating a coordinator with a sqlite store already added.
+ (NSPersistentStoreCoordinator*)mh_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL*)storeURL error:(NSError**)error;

// Adds a sqlite store at the url with default options.
- (NSPersistentStore*)mh_addStoreWithURL:(NSURL*)storeURL error:(NSError**)error;

// Returns a URL path within Application Support/Executable Name/Bundle ID.sqlite creating directories as necessary.
+ (NSURL *)mh_defaultStoreURLWithError:(NSError**)error;

// Returns the Bundle ID.sqlite
+ (NSString*)mh_defaultStoreFilename;

// Returns the path to Application Support/Executable Name creating directories as necessary.
+ (NSURL *)mh_applicationSupportDirectoryWithError:(NSError**)error;

@end

@interface NSManagedObjectModel (MH)

// merged model of all models in bundle.
#define MH_defaultModel MHDATA_ADD_PREFIX(MH_defaultModel)
+ (NSManagedObjectModel*)MH_defaultModel;

// Easily load a model from a model file and caches it. Do not include any file extension.
+ (NSManagedObjectModel*)mh_modelNamed:(NSString*)name;

-(NSEntityDescription*)mh_entityNamed:(NSString*)entityName;

@end

@interface NSEntityDescription (MH)

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mh_toManyRelationshipsByName;

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mh_toOneRelationshipsByName;

// test
- (NSArray<NSRelationshipDescription *> *)relationshipsWithManagedObjectClass:(Class)managedObjectClass;

// convenience for getting only relations that have toMany true.
//-(NSArray*)mh_toManyRelations;

//-(NSSet*)mh_toManyRelationNames;

//-(NSArray*)mh_toOneRelations;

// e.g. if this entity is FruitType it would return fruitTypes. It lowercases first letter and appends an 's'.
- (NSString*)mh_propertyNameForToManyRelation;

- (NSArray*)mh_transientProperties;

@end

@interface NSManagedObject (KeyedSubscript)

// getter
- (id)objectForKeyedSubscript:(NSString*)key;

// setter
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

@end

//@interface NSRelationshipDescription (MH)
//
//-(BOOL)isInverseOfRelation:(NSRelationshipDescription*)relation;
//
//@end

NS_ASSUME_NONNULL_END
