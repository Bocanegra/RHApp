// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Notification.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NotificationID : NSManagedObjectID {}
@end

@interface _Notification : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NotificationID *objectID;

@property (nonatomic, strong) NSDate* receivedDate;

@property (nonatomic, strong) NSString* text;

@property (nonatomic, strong, nullable) NSString* url;

@end

@interface _Notification (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveReceivedDate;
- (void)setPrimitiveReceivedDate:(NSDate*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

@end

@interface NotificationAttributes: NSObject 
+ (NSString *)receivedDate;
+ (NSString *)text;
+ (NSString *)url;
@end

NS_ASSUME_NONNULL_END
