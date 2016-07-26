//
//  NewsEntry.h
//  RHApp
//
//  Created by Luis Ángel García Muñoz on 27/5/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsEntry : NSObject

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *creator;
@property (strong, nonatomic) NSString *pubDate;
@property (strong, nonatomic) NSString *textDescription;
@property (strong, nonatomic) NSNumber *comments;

@end
