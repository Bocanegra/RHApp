//
//  LASimpleCoreDataStack.h
//
//  Created by Luis Ángel García Muñoz on 7/3/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface LASimpleCoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

+ (NSString *)persistentStoreCoordinatorErrorNotificationName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                          databaseFilename:(NSString *)aDBName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                               databaseURL:(NSURL *)aDBURL;

- (id)initWithModelName:(NSString *)aModelName databaseURL:(NSURL *)aDBURL;

- (void)zapAllData;

- (void)saveWithErrorBlock:(void(^)(NSError *error))errorBlock;
- (NSArray *)executeRequest:(NSFetchRequest *)request
                  withError:(void(^)(NSError *error))errorBlock;
@end
