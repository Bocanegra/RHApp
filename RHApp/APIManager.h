//
//  UsuarioManager.h
//  DOKENSIP
//
//  Created by Luis Ángel García Muñoz on 12/4/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKObjectManager.h"

@class JobPosition, NewsEntry;

@interface APIManager : DKObjectManager

- (void)getNewsEntriesWithBlock:(void (^)(NSArray *newsEntries, NSError *error))block;

- (void)getPositionsWithBlock:(void (^)(NSArray *positions, NSError *error))block;

@end
