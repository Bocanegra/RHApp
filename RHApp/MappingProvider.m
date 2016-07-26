//
//  MappingProvider.m
//  DOKENSIP
//
//  Created by Luis Ángel García Muñoz on 12/4/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import "MappingProvider.h"
#import <RestKit/RestKit.h>
#import "JobPosition.h"
#import "NewsEntry.h"


@implementation MappingProvider

+ (RKObjectMapping *)jobMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[JobPosition class]];
    NSDictionary *mappingDictionary = @{@"id": @"jobId",
                                        @"position": @"position",
                                        @"jobDescription": @"jobDescription",
                                        @"publishDate": @"publishDate",
                                        @"expirationDate": @"expirationDate",
                                        @"location": @"location",
                                        @"area": @"area"
                                        };
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    return mapping;
}

+ (RKObjectMapping *)newsMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NewsEntry class]];
    NSDictionary *mappingDictionary = @{@"imageURL": @"imageURL",
                                        @"title": @"title",
                                        @"subtitle": @"subtitle"
                                        };
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    return mapping;
}

@end
