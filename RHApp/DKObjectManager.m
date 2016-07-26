//
//  DKObjectManager.m
//  DOKENSIP
//
//  Created by Luis Ángel García Muñoz on 12/4/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import "DKObjectManager.h"

static DKObjectManager *sharedManager = nil;

@implementation DKObjectManager

/*
 THIS CLASS IS MAIN POINT FOR CUSTOMIZATION:
 - setup HTTP headers that should exist on all HTTP Requests
 - override methods in this class to change default behavior for all HTTP Requests
 - define methods that should be available across all object managers
 */
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://10.95.10.10/base"];
        
        sharedManager = [self managerWithBaseURL:url];
        //sharedManager.requestSerializationMIMEType = RKMIMETypeJSON;
        [sharedManager setupRequestDescriptors];
        [sharedManager setupResponseDescriptors];
    });
    return sharedManager;
}

- (void)setupRequestDescriptors {
    
}

- (void)setupResponseDescriptors {
    
}

@end
