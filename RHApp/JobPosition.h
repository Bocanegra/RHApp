//
//  JobPosition.h
//  RHApp
//
//  Created by Luis Ángel García Muñoz on 27/5/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobPosition : NSObject

@property (strong, nonatomic) NSString *jobId;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *jobDescription;
@property (strong, nonatomic) NSDate *publishDate;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *area;

@end
