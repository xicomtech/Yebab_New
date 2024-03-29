//
//  YBCameraViewController.h
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connections.h"
#import "createAlbumViewController.h"
@protocol createdAlbumNameDelegate;

@interface YBCameraViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ConnectionsDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,SecondViewControllerDelegate>{
    
    NSMutableArray *catogeryList;
    NSMutableString *categoryListId ;
    NSArray *albumList;
    NSString *requestType;
//    BOOL isShowSheet;
    
    UIButton *selectAlbumButton ;
    UIButton *createAlbumButton ;
    UIPickerView *catogeryPicker ;
    UIActionSheet *catogeryActionSheet ;
    NSString *languageValueString ;
    
    NSArray *existingAlbumList ;
    NSArray *followerList ;
    
    UITextField *albumTxtFld;
    UIButton *addButton;
    NSMutableDictionary *typeDic ;
    NSMutableArray *followerArray ;
//    UIImage *image ;
    int catType ;
    BOOL addAlbum ;
    int typeValue ;
    BOOL userType ;
    BOOL userCat ;
    int contribType ;
    NSString *albumName ;
    id<createdAlbumNameDelegate> delegate;
    NSString *CameraOpen ;
    
    int privateAlbum ; 
}
@property (nonatomic, retain) id<createdAlbumNameDelegate> delegate;;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *businessBtnCollection;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *userBtnCollection;


@property (strong, nonatomic) IBOutlet UILabel *personalLabel ;
@property (strong, nonatomic) IBOutlet UILabel *bussinesLabel ;



@property (strong, nonatomic) IBOutlet UIButton *businessBtn ;
@property (strong, nonatomic) IBOutlet UIButton *personalBtn ;

@property (strong, nonatomic) IBOutlet UIButton *meBtn ;
@property (strong, nonatomic) IBOutlet UIButton *groupBtn ;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shareBtnCollection;

@property (nonatomic, retain) NSString *albumName ;
@property (nonatomic, retain) NSString *CameraOpen ;
@property (strong, nonatomic) IBOutlet UITextField *albumTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *currencyTxtFld;
@property (strong, nonatomic) IBOutlet  UIButton *selectAlbumButton ;
@property (strong, nonatomic) IBOutlet UIButton *createAlbumButton, *addButton, *selectExistAlbumButton;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UITextField *captionTxt;
@property (strong, nonatomic) IBOutlet UIView *subUserView;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel ;
@property (strong, nonatomic) IBOutlet UIView *userTypeView ,*typeView ;
@property (strong, nonatomic) IBOutlet UIView *editAlbumView;
@property (strong, nonatomic)NSMutableArray *followerArray ;
@property (strong, nonatomic)NSMutableString *categoryListId ;


//changes done on 10 Oct 2012
@property (nonatomic, retain)IBOutlet UISwitch *storeSwitch ;
@property (nonatomic, retain)IBOutlet UISwitch *groupSwitch ;
@property (nonatomic, retain)IBOutlet UISwitch *prvtSwitch ;
@property (nonatomic, retain)IBOutlet UIButton *selectFollowerBtn ;
@property (nonatomic, retain)IBOutlet UIImageView *arrowImage ;

- (IBAction) toggleOnForStoreSwitch:(id)sender;
- (IBAction) toggleOnForGroupSwitch:(id)sender;
- (IBAction) toggleOnForprvSwitch:(id)sender;
- (IBAction) selectFolBtnClick:(id)sender;

- (IBAction)selectAlbumBtnTapped:(id)sender;
- (IBAction)selectImgSourceBtnTapped:(id)sender;

- (IBAction)businessTypeBtnTapped:(id)sender;
- (IBAction)userTypeBtnTapped:(id)sender;
- (IBAction)shareTypeBtnTapped:(id)sender;

- (void)followerService ;
- (void)followerBtnTapped ;
@end


@protocol createdAlbumNameDelegate
- (void)createdAlbumNameController:(YBCameraViewController*)ybCameraView ;
@end