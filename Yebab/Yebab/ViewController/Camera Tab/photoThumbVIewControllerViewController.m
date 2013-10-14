//
//  photoThumbVIewControllerViewController.m
//  shareHappiness
//
//  Created by Xicom on 01/07/13.
//  Copyright (c) 2013 Xicom. All rights reserved.
//

#import "photoThumbVIewControllerViewController.h"
#define MAX_CROPPING_HEIGHT 250
#define MAX_CROPPING_WIDTH 250
#define MIN_CROPPING_HEIGHT 150
#define MIN_CROPPING_WIDHT 150


#import <QuartzCore/QuartzCore.h>
#define SHOW_PREVIEW NO

#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif


@interface photoThumbVIewControllerViewController ()

@end

@implementation photoThumbVIewControllerViewController
@synthesize imgThumb;
@synthesize asset;
@synthesize instagramImgDic;
@synthesize index;
@synthesize imageCropper;

// Cropping Stuff
@synthesize imgView, currentImage;
@synthesize delegate , finalImg ;
static inline double radians (double degrees) {return degrees * M_PI/180;}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload {
    [self setImageCropper:nil];
    [self setPreview:nil];
    [self setSelectBtn:nil];
    [self setPreview:nil];
    [self setUndoBtn:nil];
    [super viewDidUnload];
}

#pragma mark - View lifecycle
- (void)updateDisplay {
    if (SHOW_PREVIEW) {
        
        self.preview.image = [self.imageCropper getCroppedImage];
        [self.view sendSubviewToBack:self.preview];
        self.preview.frame = CGRectMake(10,10,self.imageCropper.crop.size.width * 0.1, self.imageCropper.crop.size.height * 0.1);
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        [self updateDisplay];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar_logo.png"] forBarMetrics:UIBarMetricsDefault];

//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn addTarget:self action:@selector(backAction:) forControlEvents: UIControlEventTouchUpInside];
//    [backBtn setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
//    [backBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
//    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    [backBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
//    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backBarBtn;
    self.navigationItem.hidesBackButton=YES ;
    
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(selectImgBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = saveBtn;

    
    if (self.asset == nil) {
        [self.imgView setImage:[self.instagramImgDic objectForKey:@"image"]];
        
        // Cropping Stuff
        [self setCroppingControls:[self.instagramImgDic objectForKey:@"image"]];
    }
}

-(void)setCroppingControls:(UIImage*)image {
    
    self.imageCropper = [[BJImageCropper alloc] initWithImage:image andMaxSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.imageCropper];
    
    self.imageCropper.center = self.view.center;
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    
    if (SHOW_PREVIEW) {
        self.preview.image = [self.imageCropper getCroppedImage];
        self.preview.clipsToBounds = YES;
        self.preview.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.preview.layer.shadowRadius = 3.0f;
        self.preview.layer.shadowOpacity = 0.8f;
        self.preview.layer.shadowOffset = CGSizeMake(1, 1);
    }
}

-(void)backAction:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)selectImgBtnPressed {
    finalImg = [self.imageCropper getCroppedImage];

    [delegate photoThumbControllerDidFinish:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Rotating Image
- (UIImage*)imageWithRotation:(UIImage*)image {
    CGImageRef imageRef = [image CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, image.size.width, image.size.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    }
    else
    {
        bitmap = CGBitmapContextCreate(NULL, image.size.height, image.size.width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    }
    if (image.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -image.size.height);
        
    } else if (image.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -image.size.width, 0);
        
    } else if (image.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (image.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, image.size.width, image.size.height);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}
*/

#pragma mark - Orientation Support

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
- (IBAction)undoBtnPressed:(id)sender {
    
    [self.imageCropper setHidden:NO];
    [self.preview setHidden:YES];
    [self.undoBtn setHidden:YES];
    [self.selectBtn setTitle:@"Crop Image" forState:UIControlStateNormal];
}
@end
