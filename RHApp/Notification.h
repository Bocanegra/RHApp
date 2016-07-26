#import "_Notification.h"

@interface Notification : _Notification

+ (instancetype)notificationWithContent:(NSString *)content
                                context:(NSManagedObjectContext *)context;

@end
