//
//  MappingProvider.h
//  DOKENSIP
//
//  Created by Luis Ángel García Muñoz on 12/4/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface MappingProvider : NSObject

+ (RKObjectMapping *)jobMapping;
+ (RKObjectMapping *)newsMapping;

@end
