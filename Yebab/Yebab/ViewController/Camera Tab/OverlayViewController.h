//
//  OverlayViewController.h
//  Yebab
//
//  Created by Virendra on 24/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "photoThumbVIewControllerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@protocol CameraImageDelegate ;
@interface OverlayViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CaptureImageDelegate>{
    
    UIImagePickerController *imagePicker ;
    UIView *customButtonView ;
    BOOL load ;
    BOOL Album ;
    BOOL Crop ;
    
    id<CameraImageDelegate>delegate ;
    UIImage *image ;
    NSURL *imagePath ;
    NSData *imageData ;
    NSString *fileNames ;
    photoThumbVIewControllerViewController *controller ;
    
    NSMutableArray *assets ;
    NSMutableArray *assetGroups ;
    NSMutableArray *assetURLDictionaries ;

}
@property (nonatomic, strong) NSArray *photos;
@property (strong, nonatomic) NSMutableArray *assetGroups;

@property (nonatomic,retain)UIImage *image ;
@property (nonatomic,retain) NSURL *imagePath ;
@property (nonatomic,retain) NSData *imageData ;
@property (nonatomic,retain) NSString *fileNames ;

@property(nonatomic,retain)id<CameraImageDelegate>delegate ;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,retain)IBOutlet UIView *customButtonView ;
@end

@protocol CameraImageDelegate
- (void)secondViewControllerDidFinish:(OverlayViewController*)overlayViewController;
@end
