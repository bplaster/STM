//
//  ViewController.m
//  STM
//
//  Created by Brandon Plaster on 4/8/15.
//  Copyright (c) 2015 BrandonPlaster. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Accelerate/Accelerate.h>

@interface ViewController () <AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *pig_dialogue1;
@property (strong, nonatomic) IBOutlet UIImageView *pig_dialogue2;
@property (strong, nonatomic) NSTimer *timer1;
@property (strong, nonatomic) NSTimer *timer2;

// Views
@property (nonatomic, strong) CALayer *previewLayer;

// Variables
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;

@property (nonatomic, assign) CGRect screen;

@end

@implementation ViewController


- (IBAction)pig1ButtonPressed:(id)sender {
    [self.pig_dialogue1 setHidden:NO];
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timer1DidFire:) userInfo:nil repeats:NO];
}

- (IBAction)pig2ButtonPressed:(id)sender {
    [self.pig_dialogue2 setHidden:NO];
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timer2DidFire:) userInfo:nil repeats:NO];

}

-(void) timer1DidFire: (NSTimer *) timer {
    [self.pig_dialogue1 setHidden:YES];
}

-(void) timer2DidFire: (NSTimer *) timer {
    [self.pig_dialogue2 setHidden:YES];
    [self pig1ButtonPressed:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pig_dialogue1 setHidden:YES];
    [self.pig_dialogue2 setHidden:YES];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup layer for preview
    self.screen = ([UIScreen mainScreen]).bounds;
    
    self.previewLayer = [CALayer layer];
    [self.previewLayer setFrame:self.screen];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // Setup capture session
    self.captureSession = [AVCaptureSession new];
    self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    //    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        //        if (device.position == AVCaptureDevicePositionFront) {
        //            frontCamera = device;
        //        }
        if (device.position == AVCaptureDevicePositionBack) {
            backCamera = device;
        }
    }
    
    //    AVCaptureDeviceInput *frontCaptureInput = [[AVCaptureDeviceInput alloc] initWithDevice:frontCamera error:nil];
    AVCaptureDeviceInput *backCaptureInput = [[AVCaptureDeviceInput alloc] initWithDevice:backCamera error:nil];
    
    //    [self.captureSession addInput:frontCaptureInput];
    [self.captureSession addInput:backCaptureInput];
    
    
    // Setup outputs
    self.videoOutput = [AVCaptureVideoDataOutput new];
    [self.videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    //    [self.videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    dispatch_queue_t videoDataDispatchQueue = dispatch_queue_create("edu.CS2049.videoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [self.videoOutput setSampleBufferDelegate:self queue:videoDataDispatchQueue];
    [self.captureSession addOutput:self.videoOutput];
    
    // Mirror the video
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.videoOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                //[videoConnection setVideoMirrored:YES];
                [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    // Start
    [self.captureSession startRunning];
    [self pig2ButtonPressed:nil];

}

//-(BOOL)shouldAutorotate {
//    return YES;
//}
//
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
//}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegateMethods

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CVPixelBufferRef processedBuffer = [self processPixelBuffer:CMSampleBufferGetImageBuffer(sampleBuffer)];
    
}


- (CVPixelBufferRef) processPixelBuffer: (CVImageBufferRef) pixelBuffer {
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    size_t srcWidth = CVPixelBufferGetWidth(pixelBuffer);
    size_t srcHeight = CVPixelBufferGetHeight(pixelBuffer);
    size_t srcBytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    //    size_t dstHeight = srcHeight;
    //    size_t dstWidth = srcWidth;
    //    size_t dstBytesPerRow = srcBytesPerRow;
    
    unsigned char *srcAddress = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    //    unsigned char *dstAddress = malloc(dstBytesPerRow*dstHeight);
    
    int bitsPerComponent = 8;
    
    //    vImage_Buffer src = { srcAddress, srcHeight, srcWidth, srcBytesPerRow };
    //    vImage_Buffer dst = { dstAddress, dstHeight, dstWidth, dstBytesPerRow };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context;
    
    //    vImageCopyBuffer(&src, &dst, 1, kvImageNoFlags);
    context = CGBitmapContextCreate(srcAddress, srcWidth, srcHeight,
                                    bitsPerComponent, srcBytesPerRow,
                                    colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //
    //    context = CGBitmapContextCreate(dstAddress, dstWidth, dstHeight,
    //                                    bitsPerComponent, dstBytesPerRow,
    //                                    colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    // Display in view
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.view.layer setContents: (__bridge id)imageRef];
        CGImageRelease(imageRef);
    });
    
    // Create new pixel buffer
    CVPixelBufferRef processedBuffer = NULL;
    //    CVReturn status = CVPixelBufferCreateWithBytes(NULL, srcWidth, srcHeight, kCVPixelFormatType_OneComponent8, dstAddress, srcBytesPerRow, pixelBufferReleaseCallback, NULL, NULL, &processedBuffer);
    
    return processedBuffer;
    
}

void pixelBufferReleaseCallback (void *releaseRefCon, const void *baseAddress)
{
    free((void *)baseAddress);
}


#pragma mark - AVCaptureFileOutputRecordingDelegateMethods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
