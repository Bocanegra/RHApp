//
//  UsuarioManager.m
//  DOKENSIP
//
//  Created by Luis Ángel García Muñoz on 12/4/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import "APIManager.h"
#import "MappingProvider.h"
#import "JobPosition.h"
#import "NewsEntry.h"

@implementation APIManager

- (void)getNewsEntriesWithBlock:(void (^)(NSArray *newsEntries, NSError *error))block {
    [self getObject:nil
               path:@"/news"
         parameters:nil
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        if (block) {
            NSArray *news = mappingResult.array ? : [NSArray array];
            block(news, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        if (block) {
//            block(nil, error);
//            NewsEntry *entry = [NewsEntry new];
//            entry.imageURL = @"http://i0.wp.com/blogthinkbig.com/wp-content/uploads/2016/05/Touch-ID.jpg?resize=640%2C225";
//            entry.title = @"5 medidas básicas para aumentar la seguridad de tu smartphone";
//            entry.subtitle = @"Aumentar la seguridad de tu smartphone es muy sencillo prestando atención a unos ajustes básicos que recomendamos aplicar.";
//            NewsEntry *entry2 = [NewsEntry new];
//            entry2.imageURL = @"http://i0.wp.com/blogthinkbig.com/wp-content/uploads/2016/05/Touch-ID.jpg?resize=640%2C225";
//            entry2.title = @"5 medidas básicas para aumentar la seguridad de tu smartphone";
//            entry2.subtitle = @"Aumentar la seguridad de tu smartphone es muy sencillo prestando atención a unos ajustes básicos que recomendamos aplicar.";
//            NewsEntry *entry3 = [NewsEntry new];
//            entry3.imageURL = @"http://i0.wp.com/blogthinkbig.com/wp-content/uploads/2016/05/Touch-ID.jpg?resize=640%2C225";
//            entry3.title = @"5 medidas básicas para aumentar la seguridad de tu smartphone";
//            entry3.subtitle = @"Aumentar la seguridad de tu smartphone es muy sencillo prestando atención a unos ajustes básicos que recomendamos aplicar.";
//            NSArray *ejemplo = @[entry, entry2, entry3];
//            block(ejemplo, nil);
        }
    }];
}

- (void)getPositionsWithBlock:(void (^)(NSArray *positions, NSError *error))block {
    [self getObject:nil
               path:@"/jobs"
         parameters:nil
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         if (block) {
             NSArray *jobs = mappingResult.array ? : [NSArray array];
             block(jobs, nil);
         }
     } failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         if (block) {
             block(nil, error);
         }
     }];
}

- (void)setupResponseDescriptors {
    [super setupResponseDescriptors];
    
    RKResponseDescriptor *jobsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider jobMapping]
                                                                                        method:RKRequestMethodGET
                                                                                   pathPattern:@"/jobs"
                                                                                       keyPath:nil
                                                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKResponseDescriptor *newsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider newsMapping]
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/news"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    // Se añade un formato adicional para el parseo correcto de fechas de tipo "lastdata": "12/10/2014 14:00"
    NSDateFormatter *sensorFormatter = [NSDateFormatter new];
    [sensorFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    [RKObjectMapping addDefaultDateFormatter:sensorFormatter];
    
    // Se añade un formato adicional para el parseo correcto de fechas de tipo "alarmdate": "2014-12-16 11:10:36"
    NSDateFormatter *alertsFormatter = [NSDateFormatter new];
    [alertsFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [RKObjectMapping addDefaultDateFormatter:alertsFormatter];
    
    [self addResponseDescriptorsFromArray:@[jobsDescriptor, newsDescriptor]];
}

@end
