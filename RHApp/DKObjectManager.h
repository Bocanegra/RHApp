//
//  DKObjectManager.h
//  DOKENSIP
//
//  Created by Luis Ángel García Muñoz on 12/4/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface DKObjectManager : RKObjectManager

+ (instancetype)sharedManager;

- (void)setupRequestDescriptors;
- (void)setupResponseDescriptors;

@end
