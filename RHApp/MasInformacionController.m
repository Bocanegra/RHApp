//
//  MasInformacionController.m
//  Tu Ocio
//
//  Created by Luis Ángel García Muñoz on 24/11/14.
//  Copyright (c) 2014 Luis Ángel García Muñoz. All rights reserved.
//

#import "MasInformacionController.h"

@interface MasInformacionController ()

@property (weak, nonatomic) IBOutlet UIWebView *masInfoWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reload;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;

- (void)loadRequestFromString:(NSString *)urlString;
- (void)abrirEnSafari;
- (void)updateButtons;

@end

@implementation MasInformacionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hack para añadir http a las URLs que no lo tengan
    if (![self.urlMasInfo hasPrefix:@"http"]) {
        self.urlMasInfo = [NSString stringWithFormat:@"http://%@", self.urlMasInfo];
    }
    // Botón para abrir en el navegador del sistema
    UIBarButtonItem *abrirEnSafariButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"safari.png"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(abrirEnSafari)];
    self.navigationItem.rightBarButtonItem = abrirEnSafariButton;
    // Cargar URL de más info
    [self loadRequestFromString:self.urlMasInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

#pragma mark - Methods

- (void)loadRequestFromString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.masInfoWebView loadRequest:urlRequest];
}

- (void)abrirEnSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlMasInfo]];
}

- (void)updateButtons {
    self.forward.enabled = self.masInfoWebView.canGoForward;
    self.back.enabled = self.masInfoWebView.canGoBack;
    self.stop.enabled = self.masInfoWebView.loading;
}

@end
