//
//  ExistingAlbumViewController.m
//  Yebab
//
//  Created by Virendra on 23/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "ExistingAlbumViewController.h"
#import "YBCameraViewController.h"

@interface ExistingAlbumViewController ()

@end

@implementation ExistingAlbumViewController
@synthesize albumId ,imageUrlString,albumType,albumLabel,openCameras,dataImage;
@synthesize docFile = _docFile;
@synthesize jpgPath ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    serviceCount=NO ;
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"Add Photo";
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(editAlbumService) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    isShowSheet = YES;
    [self followerService];
    
    //Custom ToolBar added to move keypad down for Numeric keypad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    _priceTextField.inputAccessoryView = numberToolbar;
    
    currencyListArray =[[NSArray alloc]initWithObjects:@"AED",@"SAR",@"OMR",@"AED",@"BHD",@"QAR",@"EGP",@"JOD",@"MAD",@"DZD",@"DOL",@"EUR",@"PND",nil];
}

//toolbar button action moving keypad down, with removing text from UITextfield
-(void)cancelNumberPad{
  
    [_priceTextField resignFirstResponder];
    _priceTextField.text = @"";
}

//action for ,toolbar done button
-(void)doneWithNumberPad{
    [_priceTextField resignFirstResponder];
}

//edit Album Service called
-(void)editAlbumService {
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    
    requestType = EDIT_IMAGE_ALBUM;
    [connections setRequestType:EDIT_IMAGE_ALBUM];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:[userDefault objectForKey:@"userId"] forKey:@"userId"];
    
if ([_captionTextField.text length] > 0)
{
        
        [postParams setObject:_captionTextField.text forKey:@"image_description"];
        NSNumber * myNumber =[NSNumber numberWithInt:[albumId integerValue]];
        
    if ([_selectAlbumBtn.titleLabel.text length] > 0)
    {
             [postParams setObject:myNumber forKey:@"albumId"];
            
        if ([imageUrlString length] > 0)
        {
            [postParams setObject:imageUrlString forKey:@"image_url"];
            //  [postParams setObject:imageUrlString forKey:@"location "];
                if (number == 1) {
                     [postParams setObject:_priceTextField.text forKey:@"price"];
                     [postParams setObject:_currencyButton.titleLabel.text forKey:@"currency"];
                     [postParams setObject:_locationTextField.text forKey:@"location"];
                    
                     if ([_priceTextField.text length]>0 && [_currencyButton.titleLabel.text length]>0 && [_locationTextField.text length]>0 ) {
                         [connections sendRequestWithPath:EDIT_IMAGE_ALBUM andParameters:postParams showLoader:YES];
                     }else{
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter All Fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 }else{
                   
                   [connections sendRequestWithPath:EDIT_IMAGE_ALBUM andParameters:postParams showLoader:YES];  
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Add Photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            }
           
    }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Select Album Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
}else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    serviceCount=NO;
     [self followerService];
    if ([controller.CameraOpen isEqualToString:@"YES"]) {
  //    [self followerService];
        
    }
    else{
        [ self openCamera];
    }
    controller.CameraOpen =[[NSString alloc ]initWithFormat:@"NO"];
//    NSLog(@"%@",controller.CameraOpen);
}

//method called to open camera,Btn placed where image is shown
- (IBAction)selectImgSourceBtnTapped:(id)sender {
    [self openCamera];
}

//create Album Btn click
- (IBAction)createAlbum:(id)sender {
    [_locationTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
    [_captionTextField resignFirstResponder];
    [self createNewAlbum];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)followerService {
 //   if (![existingAlbumList count]){
        Connections *connections = [[Connections alloc] init];
        [connections setDelegate:self];
        
        requestType = ADD_ALBUM;
        [connections setRequestType:ADD_ALBUM];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [connections sendRequestWithPath:ADD_ALBUM andParameters:[NSDictionary dictionaryWithObjectsAndKeys:[userDefault objectForKey:@"userId"],@"userId",nil] showLoader:YES];
        
//    }
}

//Method to select the Type of  
- (IBAction)currencyList:(id)sender {
    NSString *listValue=[[NSString alloc]initWithFormat:@"currencyList"];
    [self selectAlbumActionSheet:listValue];
}

- (IBAction)existingAlbumList:(id)sender {
    [_locationTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
    [_captionTextField resignFirstResponder];
    
    NSString *listValue=[[NSString alloc]initWithFormat:@"albumList"];
    [self selectAlbumActionSheet:listValue];
}

- (void)selectAlbumActionSheet:(NSString *)list {
    NSString *languageTitleString = [[NSString alloc]init];
    _selectAlbumBtn.titleLabel.text=[existAlbumArray objectAtIndex:0];
    
    _createAlbumActionSheet = [[UIActionSheet alloc] initWithTitle:languageTitleString delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Done",nil];
    _createAlbumActionSheet.delegate= self ;
   
    if ([list isEqualToString:@"albumList"]) {
        _createAlbumPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,80, 320, 200)];
        _createAlbumPicker.dataSource = self;
        _createAlbumPicker.delegate = self;
        _createAlbumPicker.showsSelectionIndicator=YES ;
        _createAlbumPicker.tag=1 ;
        
    /* Select the previous selected value, which for me is stored in 'currentPosition' */
        [_createAlbumPicker selectRow:0 inComponent:0 animated:NO];

         [_createAlbumActionSheet addSubview:_createAlbumPicker];
    }
    else{
        UIPickerView *currencyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,80, 320, 200)];
        currencyPicker.dataSource = self;
        currencyPicker.delegate = self;
        currencyPicker.showsSelectionIndicator=YES ;
       currencyPicker.tag=2 ;
        
    /* Select the previous selected value, which for me is stored in 'currentPosition' */
        [currencyPicker selectRow:0 inComponent:0 animated:NO];

         [_createAlbumActionSheet addSubview:currencyPicker];
    }
    
    _createAlbumActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [_createAlbumActionSheet showInView:self.view];
    /* Make sure the UIActionSheet is big enough to fit your UIPickerView and it's buttons */
    [_createAlbumActionSheet setBounds:CGRectMake(0,0, 320, 411)];
    
}

#pragma mark - Connection Delagate
-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    NSString *msgString =[[NSString alloc]initWithFormat:@"%@",[data objectForKey:@"message"]];
    
    
        if ([msgString isEqualToString:@"Uploaded successfully"]) {
            imageUrlString=[[NSString alloc]initWithFormat:@"%@",[data objectForKey:@"location"]];
            
        }
        else if ([msgString isEqualToString:@"Pin created successfully"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
            
        }
        else if ([msgString isEqualToString:@"Failed to upload file!"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
        }
        else if ([msgString isEqualToString:@"Image added to album successfully."]){
            
            self.imgView.hidden=YES ;
            _currencyButton.hidden=YES;
            _priceTextField.hidden=YES;
            _locationTextField.hidden=YES;
            [_captionTextField setText:@""];
            [_captionTextField setPlaceholder:@"Add Description"];
            albumLabel.text=@"Select Album Name";
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Image added in Album Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(serviceCount==NO){
            existAlbumArray =[[NSMutableArray alloc]init];
            existingAlbumList= [[NSArray alloc] initWithArray:[data objectForKey:@"albums"]];
            for (int i = 0; i<existingAlbumList.count; i++) {
                [existAlbumArray insertObject:[[existingAlbumList objectAtIndex:i] objectForKey:@"title"] atIndex:i];
                serviceCount=YES;
            }
       
        }
}

#pragma - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.tabBarController setSelectedIndex:4];
}

#pragma mark - UIPickerDelegate
/* Defines the total number of Components (like groups in a UITableView) in a UIPickerView */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        return existAlbumArray.count;
    }
    else{
        return currencyListArray.count;
    }
    return 0 ;
}


/* What to do when a row from a UIPickerView is selected. This will trigger each time you scroll the UIPickerView, so only lightweight stuff. */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag==1) {
        
    row = [_createAlbumPicker selectedRowInComponent:0];
    albumLabel.text =[existAlbumArray objectAtIndex:row];
    
    albumId=[[NSString alloc]init];
    albumId=[[existingAlbumList objectAtIndex:row ] objectForKey:@"id"] ;
    albumType=[[existingAlbumList objectAtIndex:row ] objectForKey:@"type"] ;
    
         number = [albumType intValue];
    
        if (number == 1) {
            _currencyButton.hidden=NO;
            _locationTextField.hidden=NO;
            _priceTextField.hidden=NO;
        }else{
            _currencyButton.hidden=YES;
            _priceTextField.hidden=YES;
            _locationTextField.hidden=YES;
        }
    }
    else{
    _currencyButton.titleLabel.text=[currencyListArray objectAtIndex:row];
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)rows forComponent:(NSInteger)component {
    
    if (thePickerView.tag==1) {
        NSString *reason =[[NSString alloc]init];
        reason= [existAlbumArray objectAtIndex:rows] ;
        return reason;
    }
    else{
        NSString *reason =[[NSString alloc]init];
        reason= [currencyListArray objectAtIndex:rows] ;
        return reason;
    }
    return nil;
}

-(void)createNewAlbum{
    controller = [[YBCameraViewController  alloc] initWithNibName:@"YBCameraViewController" bundle:nil];
    controller.delegate=self ;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createdAlbumNameController:(YBCameraViewController*)ybCameraView{
    albumLabel.text= controller.albumName ;
   
}


#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
-(void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
    // Insert the overlay 
        overlay = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
        overlay.delegate=self ;
        
       UINavigationController *navCtroller = [[UINavigationController alloc] initWithRootViewController:overlay];
        [self.navigationController presentViewController:navCtroller animated:YES completion:nil];
    }
}

- (void)secondViewControllerDidFinish:(OverlayViewController *)overlayViewController
{
    self.imgView.hidden=NO ;
    self.imgView.image=overlayViewController.image ;
    image=self.imgView.image; 
    
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    
    requestType = SAVE_IMAGE;
    [connections setRequestType:SAVE_IMAGE];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:image forKey:@"file"];
    [connections sendRequestWithPath:SAVE_IMAGE andParameters:postParams showLoader:YES];

}


#pragma- UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"result: %@", _locationTextField.text);
//    NSLog(@"result: %@", _priceTextField.text);
}


//-(IBAction)saveToInstagram:(id)sender {
//    
//    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0) {
//    //        float i = [[[UIDevice currentDevice] systemVersion] floatValue];
//    //        NSString *str = [NSString stringWithFormat:@"We're sorry, but Instagram is not supported with your iOS %.1f version.", i];
//    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    //        [alert show];
//    //    }
//    //    else{
//    CGRect rect = CGRectMake(0 ,0 , 0, 0);
//    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.ig"];
//    
//    NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
//    NSLog(@"JPG path %@", jpgPath);
//    NSLog(@"URL Path %@", igImageHookFile);
//    self.docFile.UTI = @"com.instagram.photo";
//    self.docFile = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
//    self.docFile=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
//    [self.docFile presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
//    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//        [self.docFile presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
//        //        }
//        //        else {
//        //            NSLog(@"No Instagram Found");
//        //        }
//        // 
//    }
//    
//}
//
//- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
//    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
//    interactionController.delegate = interactionDelegate;
//    return interactionController;
//}
//
//- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
//    
//}


-(IBAction)saveToInstagram:(id)sender 
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        CGRect rect = CGRectMake(0,0,0,0);
        CGRect cropRect=CGRectMake(0,0,image.size.width,image.size.height);
        jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.igo"];
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        UIImage *img = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [UIImageJPEGRepresentation(img, 1.0) writeToFile:jpgPath atomically:YES];
        NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@",jpgPath]];
        self.docFile.UTI = @"com.instagram.photo";
        self.docFile = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        self.docFile.annotation = [NSDictionary dictionaryWithObject:@"Yebab" forKey:@"InstagramCaption"];
        [self.docFile presentOpenInMenuFromRect: rect  inView: self.view animated: YES ];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Instagram not installed in this device!\nTo share image please install instagram." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}


- (void)viewDidUnload {
    [self setLocationTextField:nil];
    [self setPriceTextField:nil];
    [self setSelectAlbumBtn:nil];
    [super viewDidUnload];
}
@end
