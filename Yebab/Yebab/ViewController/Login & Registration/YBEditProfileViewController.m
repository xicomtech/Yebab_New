//
//  YBEditProfileViewController.m
//  Yebab
//
//  Created by xicom-213 on 4/5/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBEditProfileViewController.h"
#import "YBInviteFriendViewController.h"
#import "YBAppDelegate.h"
#import "commonFunction.h"
#import "YBAppDelegate.h"

@interface YBEditProfileViewController ()

@end

NSString* USER_ID;

@implementation YBEditProfileViewController

@synthesize userdetailsDic;

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
    [super viewDidLoad];
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden=NO ;
  
    countriesList       = COUNTRIES_LIST_ARR;
    countries_code_list = COUNTRIES_CODE_LIST_ARR;
    
    
    //nameTxt.text        =[userdetailsDic objectForKey:@""];
    usernameTxt.text      =[userdetailsDic objectForKey:@"userName"];
    emailTxt.text         =[userdetailsDic objectForKey:@"userMail"];
   /// countryTxt.text    =[userdetailsDic objectForKey:@"userCountry"];
    bioTxt.text         =[userdetailsDic objectForKey:@"userBio"];
   // websiteTxt.text     =[userdetailsDic objectForKey:@"userWebsite"];
    storeNameTxt.text     =[userdetailsDic objectForKey:@"storeName"];
 //   storeCityTxt.text     =[userdetailsDic objectForKey:@"storeCity"];
    storePhoneTxt.text    =[userdetailsDic objectForKey:@"storePhone"];
    storeMobileTxt.text   =[userdetailsDic objectForKey:@"storeMobile"];
    storeAddressTxt.text  =[userdetailsDic objectForKey:@"storeAddress"];
    if (userdetailsDic.count >0) {
        countryTxt.text = [countriesList objectAtIndex:[countries_code_list indexOfObject:[userdetailsDic objectForKey:@"userCountry"]]] ; 
    }
   
   // NSLog(@"Country:%@",[NSString stringWithFormat:@"%@",[countriesList objectAtIndex:[countries_code_list indexOfObject:[userdetailsDic objectForKey:@"userCountry"]]]]);
    //if ([[userdetailsDic objectForKey:@"userMail"]length])
           //emailTxt.enabled = NO;
    
    NSURL *dataURL = [NSURL URLWithString:[GET_IMAGE_HOST_URL stringByAppendingFormat:@"%@",[userdetailsDic objectForKey:@"userPicture"]]];
    NSData *imgData = [NSData dataWithContentsOfURL:dataURL];
    
    [userPicBtn setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
    
    [bgScroll setFrame:CGRectMake(0, 0, 320.0f, self.view.frame.size.height)];
    [bgScroll setContentSize:CGSizeMake(320, 555)];//1006
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [leftbutton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 51, 30)];
    [rightbutton setImage:[UIImage imageNamed:@"next_button.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Gallery", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    
    
    countryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f,[[UIScreen mainScreen] bounds].size.height-240.0f, 320.0f, 200.0f)];
    [countryPicker setDataSource:self];
    [countryPicker setDelegate:self];
    [countryPicker setShowsSelectionIndicator:YES];
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame=CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-270.0f,320,30);
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked)];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(calcelClicked)];
    
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton,flexibleSpaceLeft, doneButton, nil]];
    countryTxt.inputAccessoryView = toolbar;
    [countryPicker addSubview:toolbar];
    [countryTxt setInputView:countryPicker];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

/*
-(void)dismissKeyboard:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}
 */

-(void)calcelClicked{
    [toolbar removeFromSuperview];
    [countryPicker removeFromSuperview];
}
-(void)doneClicked{
    [toolbar removeFromSuperview];
    [countryPicker removeFromSuperview];
    [countryTxt setText:[NSString stringWithFormat:@"%@",[countriesList objectAtIndex:[countryPicker selectedRowInComponent:0]]]];
}

-(void)backButtonTapped{
 //   if (userdetailsDic.count >0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewDismiss" object:nil];
//    }
//    else{
//        YBAppDelegate *appDelegate = (YBAppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.fbSession closeAndClearTokenInformation];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

-(void)nextButtonTapped{
    if ([userdetailsDic count]>0) {
        [self editUser];
    }
    else {
        [self registerUser];
    }
}

-(BOOL)valiadateFieldsForStoreFormAlso:(BOOL)status{
    if (nameTxt.text.length >3) {
        if ([commonFunction isValidString:nameTxt.text]) {
        if ([commonFunction isValidUsername:usernameTxt.text]) {
            if ([commonFunction validateEmail:emailTxt.text]) {
                if ([commonFunction isValidString:passwordTxt.text]) {
                    if ([commonFunction isValidString:confirmPasswordTxt.text]) {
                        if ([commonFunction isValidString:countryTxt.text]) {
//                            if (status) {
//                                        NSLog(@"Not Worked Done For Store");
//                                        return NO;
//                                    }else{
//                                        return YES;
//                                    }
                        }else{
                            [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Please Select your Country." andDelegate:nil];
                            return NO;
                        }
                    }else{
                        [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Please enter confirm password." andDelegate:nil];
                        return NO;
                    }
                }else{
                    [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Please enter your password." andDelegate:nil];
                    return NO;
                }
            }else{
                [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Please enter valid email." andDelegate:nil];
                return NO;
            }
        }else{
            [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Please enter your desired username. Username can have spaces and ( . , - , _ ) only" andDelegate:nil];
            return NO;
        }
      }
        else{
            [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Please enter your name." andDelegate:nil];
            return NO;
        }
    }
    else{
        [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Name should be of atleast 3 characters." andDelegate:nil];
        return NO;
    }

    if ([passwordTxt.text isEqualToString:confirmPasswordTxt.text]) {
        if ([passwordTxt.text length]>5) {
            return YES;
        }else{
            [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Password should be of atleast 6 characters." andDelegate:nil];
            return NO;
        }
    }else{
        [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:@"Password and Confirm Password do not match." andDelegate:nil];
        return NO;
    }
    
    if ([commonFunction validateEmail:emailTxt.text]) {
        return YES;
    }else{
        return NO;
    }
    return YES;
}

-(void)editUser{
    if ([storeChkBtn isSelected]) {
        //        NSLog(@"Will be Done Later");
    }else{
        if ([self valiadateFieldsForStoreFormAlso:YES]) {
            NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [postParams setObject:[userDefault objectForKey:@"userId"] forKey:@"userId"];
            [postParams setObject:@"edit" forKey:@"type"];
            [postParams setObject:nameTxt.text forKey:@"name"];
            [postParams setObject:usernameTxt.text forKey:@"username"];
            [postParams setObject:emailTxt.text forKey:@"mail"];
          //  [postParams setObject:passwordTxt.text forKey:@"password"];
            [postParams setObject:[NSString stringWithFormat:@"%@",[countries_code_list objectAtIndex:[countriesList indexOfObject:countryTxt.text]]] forKey:@"country"];
            
            if ([bioTxt.text length] && ![bioTxt.text isEqualToString:@"Talk About Yourself"]) {
                [postParams setObject:bioTxt.text forKey:@"bio"];
            }
            if ([websiteTxt.text length]) {
                [commonFunction validateEmail:websiteTxt.text ] ;
                
                // if ([commonFunction validateEmail:websiteTxt.text ]) {
                //          [postParams setObject:websiteTxt.text forKey:@"website"];
                //          connectionObj = [[Connections alloc] init];
                //          [connectionObj setDelegate:self];
                //          [connectionObj setRequestType:REGISTER_NEW_EMAIL_USER];
                //          [connectionObj sendRequestWithPath:REGISTER_NEW_EMAIL_USER andParameters:postParams showLoader:YES];
                //  }else{
                //          UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Enter Valide Url" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //  [al show];
                // } 
            }
            connectionObj = [[Connections alloc] init];
            [connectionObj setDelegate:self];
            [connectionObj setRequestType:EDIT_USER];
            [connectionObj sendRequestWithPath:EDIT_USER andParameters:postParams showLoader:YES];
        }
    }
}

-(void)registerUser{
    
    if ([storeChkBtn isSelected]) {
        //    NSLog(@"Will be Done Later");
    }else{
        if ([self valiadateFieldsForStoreFormAlso:YES]) {
            NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
            [postParams setObject:nameTxt.text forKey:@"name"];
            [postParams setObject:usernameTxt.text forKey:@"username"];
            [postParams setObject:emailTxt.text forKey:@"mail"];
            [postParams setObject:passwordTxt.text forKey:@"password"];
            [postParams setObject:confirmPasswordTxt.text forKey:@"confirmPassword"];
            [postParams setObject:[NSString stringWithFormat:@"%@",[countries_code_list objectAtIndex:[countriesList indexOfObject:countryTxt.text]]] forKey:@"country"];
            
            if ([bioTxt.text length] && ![bioTxt.text isEqualToString:@"Talk About Yourself"]) {
                [postParams setObject:bioTxt.text forKey:@"bio"];
            }
            if ([websiteTxt.text length]) {
                [commonFunction validateEmail:websiteTxt.text ] ;
//                if ([commonFunction validateEmail:websiteTxt.text ]) {
//                    [postParams setObject:websiteTxt.text forKey:@"website"];
//                    connectionObj = [[Connections alloc] init];
//                    [connectionObj setDelegate:self];
//                    [connectionObj setRequestType:REGISTER_NEW_EMAIL_USER];
//                    [connectionObj sendRequestWithPath:REGISTER_NEW_EMAIL_USER andParameters:postParams showLoader:YES];                    
//                }else{
//                    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Enter Valide Url" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [al show];
//                }
            }
            connectionObj = [[Connections alloc] init];
            [connectionObj setDelegate:self];
            [connectionObj setRequestType:REGISTER_NEW_EMAIL_USER];
            [connectionObj sendRequestWithPath:REGISTER_NEW_EMAIL_USER andParameters:postParams showLoader:YES];
        }
    }
}

-(IBAction)storeChkBtnTapped:(id)sender{
    
    [UIView beginAnimations:@"animateScrollView" context:nil];
    [UIView setAnimationDuration:0.4];
    if ([storeChkBtn isSelected]) {
        [storeChkBtn setSelected:NO];
        [bgScroll setContentSize:CGSizeMake(320, 555)];
        [storeRegisterView setHidden:YES];
    }else{
        [storeChkBtn setSelected:YES];
        [bgScroll setContentSize:CGSizeMake(320, 1006)];
        [storeRegisterView setHidden:NO];
        [bgScroll setContentOffset:CGPointMake(0, 450)];
    }
    [UIView commitAnimations];
}

-(IBAction)userPictureBtnClicked:(id)sender{
    [actionSheet setTag:111];
    [actionSheet showInView:self.view];
}

-(IBAction)storePictureBtnClicked:(id)sender{
    NSLog(@"store Picture Button clicked");
    [actionSheet setTag:222];
    [actionSheet showInView:self.view];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewDismiss" object:nil];
}



#pragma mark - Connection Delegate  Response Data
-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    
    if (isSuccess) {
        NSLog(@"success");
        
        if ([[data objectForKey:@"status"]isEqual: @"InComplete"]) {
            return;
        }
        else if([[data objectForKey:@"status"]isEqual: @"partialComplete"]){
             USER_ID = [data objectForKey:@"user_id"];
            
            YBSelectInterestViewController *controller = [[YBSelectInterestViewController alloc] initWithNibName:@"YBSelectInterestViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([[data objectForKey:@"status"]isEqual: @"Complete"]){
             USER_ID = [data objectForKey:@"user_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
        }
        else if ([message isEqualToString:@"success"]){
            [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:message andDelegate:self];
        }
     }
    else{
    [commonFunction showAlertViewWithTitle:@"Alert!" andMessage:message andDelegate:nil];
    }
   
}

#pragma mark - UIPickerView DataSource and Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [countriesList count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [countriesList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSLog(@"selected Row Index: %d",row);
}


#pragma mark -  
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == websiteTxt) 
        bgScroll.frame = CGRectMake(0, -160, 320.0f, self.view.frame.size.height);
    else if (textField == storeMobileTxt)
        bgScroll.frame = CGRectMake(0, -60, 320.0f, self.view.frame.size.height);
    else if (textField == storePhoneTxt)
        bgScroll.frame = CGRectMake(0, -80, 320.0f, self.view.frame.size.height);
    else if (textField == storeAddressTxt)
        bgScroll.frame = CGRectMake(0, -100, 320.0f, self.view.frame.size.height);
    else if (textField == passwordTxt)
        bgScroll.frame = CGRectMake(0, -100, 320.0f, self.view.frame.size.height);
    else if (textField == confirmPasswordTxt)
        bgScroll.frame = CGRectMake(0, -100, 320.0f, self.view.frame.size.height);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
        bgScroll.frame = CGRectMake(0,0, 320.0f, self.view.frame.size.height);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [toolbar removeFromSuperview];
    [countryPicker removeFromSuperview];
    NSLog(@"text field should begin editing");
    
    if (textField==countryTxt) {
      [self.view endEditing:YES];
        NSLog(@"text field is country text");
        [self.view addSubview:countryPicker];
        [self.view addSubview:toolbar];
        return NO;
    }
    else if(textField == storeCityTxt){
         [self.view endEditing:YES];
        NSLog(@"text field is city text");
        [self.view addSubview:countryPicker];
        [self.view addSubview:toolbar];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == nameTxt) 
        [usernameTxt becomeFirstResponder];
    
    else if (textField == usernameTxt)
         if ([[userdetailsDic objectForKey:@"userMail"]length])
            [passwordTxt becomeFirstResponder];
    else
        [emailTxt becomeFirstResponder];
    
    else if(textField == emailTxt) 
        [passwordTxt becomeFirstResponder];
    
    else if (textField == passwordTxt) 
        [confirmPasswordTxt becomeFirstResponder];
    
    else if (textField == confirmPasswordTxt) 
        [websiteTxt becomeFirstResponder];
    
    else if (textField == websiteTxt)
        [textField resignFirstResponder];
    
    else if (textField == storeNameTxt)
        [storeCityTxt becomeFirstResponder];

    else if (textField == storeCityTxt)
        [storePhoneTxt becomeFirstResponder];
    
    else if (textField == storePhoneTxt)
        [storeMobileTxt becomeFirstResponder];
    
    else if (textField == storeMobileTxt)
        [storeAddressTxt becomeFirstResponder];
    
    else if (textField == storeAddressTxt)
        [textField resignFirstResponder];
    else
        [textField resignFirstResponder];        
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ((textField ==storePhoneTxt)||(textField ==storeMobileTxt)){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([newString length] >10){
            return NO;
        }
        else if([newString length]) {
            int holder;
            NSScanner *scan = [NSScanner scannerWithString: newString];
            return [scan scanInt:&holder] &&[scan isAtEnd];
        }
    }
    return YES;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == bioTxt) {
        bgScroll.frame = CGRectMake(0, -100, 320.0f, self.view.frame.size.height);
        if ([bioTxt.text isEqualToString:@"Talk About Yourself"]) {
            [bioTxt setText:@""];
            [bioTxt setTextColor:[UIColor blackColor]];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == bioTxt) {
        bgScroll.frame = CGRectMake(0,0, 320.0f, self.view.frame.size.height);
        if ([bioTxt.text isEqualToString:@""]) {
            [bioTxt setText:@"Talk About Yourself"];
            [bioTxt setTextColor:[UIColor lightGrayColor]];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        if (actionSheet.tag==111) {
            [userPicBtn setImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
        }else if (actionSheet.tag==222){
            [storePicBtn setImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
        }     
    }];                                  
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setAllowsEditing:YES];
    [controller setDelegate:self];
    switch (buttonIndex) {
        case 0:{
            if (TARGET_IPHONE_SIMULATOR) {
                //NSLog(@"Unable to use Camera on Simulator");
                [commonFunction showAlertViewWithTitle:@"Sorry!" andMessage:@"Unable to use Camera on Simulator" andDelegate:nil];
                return;
            }else{
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            }            
        }
            break;
        case 1:{
            controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
            break;
        case 2:{
            return;
        }
            break;

    }
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
