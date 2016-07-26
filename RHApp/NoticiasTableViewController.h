//
//  NoticiasTableViewController.h
//  RHApp
//
//  Created by Luis Ángel García Muñoz on 27/5/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


FOUNDATION_EXPORT NSString *const kNOTICIAITEM;
FOUNDATION_EXPORT NSString *const kNOTICIATITLE;
FOUNDATION_EXPORT NSString *const kNOTICIACREATOR;
FOUNDATION_EXPORT NSString *const kNOTICIAPUBDATE;
FOUNDATION_EXPORT NSString *const kNOTICIADESCRIPTION;
FOUNDATION_EXPORT NSString *const kNOTICIACONTENT;
FOUNDATION_EXPORT NSString *const kNOTICIAIMAGE;
FOUNDATION_EXPORT NSString *const kNOTICIALINK;

@interface NoticiasTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@end
