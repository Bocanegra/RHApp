//
//  HeaderTableViewCell.h
//
//  Created by Luis Ángel García Muñoz on 13/5/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeaderViewDelegate;

@interface HeaderTableViewCell : UITableViewHeaderFooterView

@property (nonatomic, weak) id<SectionHeaderViewDelegate> delegate;
@property (nonatomic) BOOL opened;
@property (nonatomic) NSInteger section;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderCell:(HeaderTableViewCell *)sectionHeaderCell sectionOpened:(NSInteger)section;
- (void)sectionHeaderCell:(HeaderTableViewCell *)sectionHeaderCell sectionClosed:(NSInteger)section;

@end
