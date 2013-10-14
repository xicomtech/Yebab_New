//
//  ExistingAlbumViewController.h
//  Yebab
//
//  Created by Virendra on 23/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import "OverlayViewController.h"
#import "YBCameraViewController.h"


@interface ExistingAlbumViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ConnectionsDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,CameraImageDelegate,createdAlbumNameDelegate ,UIDocumentInteractionControllerDelegate>{
    
    NSString *requestType;
    NSArray *existingAlbumList, *currencyListArray ;
    NSMutableArray *existAlbumArray ;
    
    BOOL isShowSheet;
    UIImage *image ;
    OverlayViewController *overlay ;
    
    NSString *albumId ;
    UIImagePickerController *imagePicker ;
    NSString *imageUrlString ;
    NSURL *url  ;
    NSData *dataImage ;
    NSString *albumType ;
    int number ;

    UILabel *albumLabel ;
    BOOL serviceCount ;
    YBCameraViewController *controller ;
    NSString *openCameras ;
    
    NSString *jpgPath ;
}
@property (nonatomic,retain)IBOutlet UILabel *albumLabel ;
@property (nonatomic,retain)NSString *albumId ;
@property (nonatomic,retain)NSData *dataImage ;
@property (nonatomic,retain)NSString *albumType ;
@property (nonatomic,retain)NSString *openCameras ;
@property (nonatomic,retain)NSString *imageUrlString ;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectAlbumBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton ;

@property (nonatomic,retain)UIActionSheet *createAlbumActionSheet ;
@property (nonatomic,retain)UIPickerView *createAlbumPicker;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;


@property(nonatomic,retain)IBOutlet UIButton *instagramBtn ;
@property(nonatomic,retain)UIDocumentInteractionController *docFile;
@property(nonatomic,retain)NSString *jpgPath ;
@property(nonatomic,retain)IBOutlet UIImageView *instagramImage ;

- (IBAction)existingAlbumList:(id)sender  ;
@end
