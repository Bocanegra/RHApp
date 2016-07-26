#import "Notification.h"

@interface Notification ()

// Private interface goes here.

@end

@implementation Notification

+ (instancetype)notificationWithContent:(NSString *)content
                                context:(NSManagedObjectContext *)context {
    Notification *not = [NSEntityDescription insertNewObjectForEntityForName:[Notification entityName]
                                                      inManagedObjectContext:context];
    not.text = content;
    not.receivedDate = [NSDate date];
    return not;
}

@end
