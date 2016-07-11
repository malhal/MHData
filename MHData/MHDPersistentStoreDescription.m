//
//  MHDPersistentStoreDescription.m
//  MHData
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDPersistentStoreDescription.h"

//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000

@implementation MHDPersistentStoreDescription{
    NSMutableDictionary<NSString *, NSObject *> *_options;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
+(BOOL)classAvailable{
    // if the class exists and we linked against the SDK it became available in.
    NSString* sdkName = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"DTSDKName"];
    NSString* sdkVersion = [sdkName stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    return sdkVersion.integerValue >= 10;
}

+(id)alloc{
    if([self classAvailable]){
        return [NSPersistentStoreDescription alloc];
    }
    return [super alloc];
}
#endif

+ (instancetype)persistentStoreDescriptionWithURL:(NSURL *)URL{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if([self classAvailable]){
        return [NSPersistentStoreDescription persistentStoreDescriptionWithURL:URL];
    }
    #endif
    return [[self alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _options = [NSMutableDictionary dictionaryWithObjectsAndKeys:@YES, NSInferMappingModelAutomaticallyOption,
                           @YES, NSMigratePersistentStoresAutomaticallyOption,
                           nil];
        self.type = NSSQLiteStoreType;
        self.URL = URL;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithURL:[NSURL fileURLWithPath:@"/dev/null"]];
}

- (void)setOption:(NSObject *)option forKey:(NSString *)key{
    _options[key] = option;
}

- (void)setValue:(nullable NSObject *)value forPragmaNamed:(NSString *)name{
    
}

@end

//#endif