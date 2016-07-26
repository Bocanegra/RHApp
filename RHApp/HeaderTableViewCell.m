//
//  CoreHeaderTableViewCell.m
//  DOKENSIP
//
//  Created by Luis Ángel García Muñoz on 13/5/15.
//  Copyright (c) 2015 Luis Ángel García Muñoz. All rights reserved.
//

#import "HeaderTableViewCell.h"

@implementation HeaderTableViewCell

- (void)awakeFromNib {    
    // Gesto para seleccionar/deseleccionar
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    // if this was a user action, send the delegate the appropriate message
    if (userAction) {
//        if (!self.opened) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderCell:sectionOpened:)]) {
                [self.delegate sectionHeaderCell:self sectionOpened:self.section];
            }
            self.opened = YES;
//        }
    } else {
        if ([self.delegate respondsToSelector:@selector(sectionHeaderCell:sectionClosed:)]) {
            [self.delegate sectionHeaderCell:self sectionClosed:self.section];
        }
        self.opened = NO;
    }
}

@end

/*
 else {
    if ([self.delegate respondsToSelector:@selector(sectionHeaderCell:sectionClosed:)]) {
        [self.delegate sectionHeaderCell:self sectionClosed:self.section];
    }
    self.opened = NO;
 }*/
