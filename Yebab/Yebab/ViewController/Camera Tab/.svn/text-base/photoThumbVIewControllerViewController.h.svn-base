//
//  photoThumbVIewControllerViewController.h
//  shareHappiness
//
//  Created by Xicom on 01/07/13.
//  Copyright (c) 2013 Xicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commonFunction.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BJImageCropper.h"

@protocol CaptureImageDelegate ;

@interface photoThumbVIewControllerViewController : UIViewController {
    BJImageCropper *imageCropper;
    id<CaptureImageDelegate>delegate ;
    UIImage *finalImg ;
}
@property(nonatomic,retain)id<CaptureImageDelegate>delegate ;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIImage *imgThumb;
@property (strong, nonatomic) NSMutableDictionary *instagramImgDic;
@property (strong, nonatomic) ALAsset *asset;
@property (nonatomic, assign) int index;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
//@property (assign)SHSourceType sourceType;
//@property (assign) SHMediaType mediaType;


// Cropping stuff
@property (nonatomic, strong) BJImageCropper *imageCropper;
@property (strong, nonatomic) IBOutlet UIImageView *preview;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIButton *undoBtn;
@property(nonatomic,retain)UIImage *currentImage;
@property(nonatomic,retain)UIImage *finalImg ;

- (IBAction)undoBtnPressed:(id)sender;
- (IBAction)playBtnPressed:(id)sender;
- (IBAction)selectImgBtnPressed:(id)sender;
- (UIImage*)imageWithRotation:(UIImage*)image;

@end


@protocol CaptureImageDelegate
- (void)photoThumbControllerDidFinish:(photoThumbVIewControllerViewController*)photoThumbViewController;
@end
