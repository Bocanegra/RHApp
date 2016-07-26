//
//  DetalleViewController.m
//  RHApp
//
//  Created by Luis Ángel García Muñoz on 3/6/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import "DetalleViewController.h"
#import "NoticiasTableViewController.h"

@interface DetalleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *jobsButton;

@end

@implementation DetalleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNoticia];
}

- (void)showNoticia {
    self.titleLabel.text = self.noticia[kNOTICIATITLE];
    self.authorLabel.text = self.noticia[kNOTICIACREATOR];
    self.pubDateLabel.text = self.noticia[kNOTICIAPUBDATE];
    if ([self.noticia objectForKey:kNOTICIAIMAGE]) {
        [self.backgroundImage sd_setImageWithURL:self.noticia[kNOTICIAIMAGE]];
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:[self.noticia[kNOTICIACONTENT] dataUsingEncoding:NSUnicodeStringEncoding]
                                                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                          documentAttributes:NULL
                                                                       error:nil];
    self.contentTextView.attributedText = attString;
    self.jobsButton.titleLabel.text = @"Hay 0 ofertas relacionadas";
    
}

#pragma mark - Actions

- (IBAction)openInSafari:(id)sender {
    if ([self.noticia objectForKey:kNOTICIALINK]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.noticia[kNOTICIALINK]]];
    }
}

- (IBAction)goToJobs:(id)sender {
    
}

@end
