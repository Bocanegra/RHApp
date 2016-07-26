//
//  BarReaderViewController.m
//  RHApp
//
//  Created by Luis Ángel García Muñoz on 27/5/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import "BarReaderViewController.h"
#import "MasInformacionController.h"
@import AVFoundation;

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface BarReaderViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (strong, nonatomic) NSString *urlInfo;

@end


@implementation BarReaderViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isReading = NO;
    _captureSession = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cambiaOrientacion)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopScanning];
}

#pragma mark - Actions

- (void)startScanning {
    if (!self.isReading) {
        if ([self startReading]) {
            [self.statusLabel setText:@"Escaneando QR..."];
        }
    }
}

- (void)stopScanning {
    if (self.isReading) {
        [self stopReading];
        [self.statusLabel setText:@"..."];
    }
}

#pragma mark - AVCapture methods

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        [self.statusLabel setText:@"No se puede capturar video"];
        return NO;
    }
    
    // Crear capture session
    self.captureSession = [AVCaptureSession new];
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [AVCaptureMetadataOutput new];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue = dispatch_queue_create("qrQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // Se pueden añadir múltiples tipos de códigos aceptados
    NSLog(@"%@", [captureMetadataOutput availableMetadataObjectTypes]);
    //    "org.iso.Aztec",
    //    "org.iso.Code128",
    //    "org.iso.Code39",
    //    "org.iso.Code39Mod43",
    //    "com.intermec.Code93",
    //    "org.iso.DataMatrix",
    //    "org.gs1.EAN-13",
    //    "org.gs1.EAN-8",
    //    "org.ansi.Interleaved2of5",
    //    "org.gs1.ITF14",
    //    "org.iso.PDF417",
    //    "org.iso.QRCode",
    //    "org.gs1.UPC-E",
    //    face
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,
                                                    AVMetadataObjectTypeAztecCode,
                                                    AVMetadataObjectTypeCode128Code,
                                                    AVMetadataObjectTypeCode39Code,
                                                    AVMetadataObjectTypeCode93Code,
                                                    AVMetadataObjectTypeDataMatrixCode,
                                                    AVMetadataObjectTypeEAN13Code,
                                                    AVMetadataObjectTypeEAN8Code,
                                                    AVMetadataObjectTypeInterleaved2of5Code,
                                                    AVMetadataObjectTypeITF14Code,
                                                    AVMetadataObjectTypePDF417Code,
                                                    AVMetadataObjectTypeUPCECode
                                                    ]];
    
    // Añadimos la vista previa
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.previewView.layer.bounds];
    [self.previewView.layer insertSublayer:self.videoPreviewLayer below:self.statusLabel.layer];
    
    [self.captureSession startRunning];
    self.isReading = YES;
    return YES;
}

- (void)stopReading {
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    [self.videoPreviewLayer removeFromSuperlayer];
    self.isReading = NO;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    NSString *result;
    if (metadataObjects && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        result = [NSString stringWithFormat:@"[%@]: %@", metadataObj.type, metadataObj.stringValue];
        if ([metadataObj.stringValue hasPrefix:@"http://"]) {
            self.urlInfo = metadataObj.stringValue;
            [self stopReading];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"masInfoWeb" sender:self];
            });
        }
        // Actualizar en la cola principal toda la parte gráfica
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusLabel setText:result];
        });
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"masInfoWeb"]) {
        MasInformacionController *viewController = segue.destinationViewController;
        viewController.urlMasInfo = self.urlInfo;
    }
}

#pragma mark - Rotation methods

- (void)cambiaOrientacion {
    UIDeviceOrientation nuevaOrientacion = [[UIDevice currentDevice] orientation];
    // Cambiamos la orientación de la cámara: no es necesario
    // [self.videoPreviewLayer.connection setVideoOrientation:(AVCaptureVideoOrientation)nuevaOrientacion];
    
    // Rotamos los iconos de la interfaz
    if (nuevaOrientacion != UIDeviceOrientationUnknown) {
        switch (nuevaOrientacion) {
            case UIDeviceOrientationPortrait:
                [self rotaInterfaz:0];
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                [self rotaInterfaz:180];
                break;
            case UIDeviceOrientationLandscapeLeft:
                [self rotaInterfaz:90];
                break;
            case UIDeviceOrientationLandscapeRight:
                [self rotaInterfaz:-90];
                break;
            default:
                break;
        }
    }
}

- (void)rotaInterfaz:(CGFloat)grados {
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGAffineTransform rotacion = CGAffineTransformMakeRotation(DegreesToRadians(grados));
                         self.statusLabel.transform = rotacion;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

@end
