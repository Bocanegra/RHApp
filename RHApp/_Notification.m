// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Notification.m instead.

#import "_Notification.h"

@implementation NotificationID
@end

@implementation _Notification

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Notification";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:moc_];
}

- (NotificationID*)objectID {
	return (NotificationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic receivedDate;

@dynamic text;

@dynamic url;

@end

@implementation NotificationAttributes 
+ (NSString *)receivedDate {
	return @"receivedDate";
}
+ (NSString *)text {
	return @"text";
}
+ (NSString *)url {
	return @"url";
}
@end

