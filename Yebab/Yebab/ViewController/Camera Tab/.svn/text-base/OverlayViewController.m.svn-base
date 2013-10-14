//
//  OverlayViewController.m
//  Yebab
//
//  Created by Virendra on 24/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "OverlayViewController.h"
#import "photoThumbVIewControllerViewController.h"

@interface OverlayViewController (){
    BOOL capturedImg;
    NSDictionary *capturedDic;
}

@end

@implementation OverlayViewController
@synthesize  customButtonView ,delegate,image,imagePath,imageData,fileNames;
@synthesize assetGroups ; 
@synthesize photos = _photos;

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
    Crop = NO ;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
    
    if (!load) {
        if (!Album) {
//camera opens as when screen appers, imagepicker is added over OverLay View . 
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker  = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate = self;
                imagePicker.showsCameraControls = NO;
                imagePicker.wantsFullScreenLayout = YES;
                
                //changes done on 1 Feb 2013//
                CGRect screenBounds = [[UIScreen mainScreen] bounds];
                CGFloat screenScale = [[UIScreen mainScreen] scale];
                CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
 //               NSLog(@"width:%f ,height:%f",screenSize.width,screenSize.height);
                
                if(screenSize.height > 480)
                {
                    if(self.view.frame.size.height > 480)
                    {
                        customButtonView.frame=CGRectMake(0,480, customButtonView.frame.size.width, customButtonView.frame.size.height);
                    }
                    else{
                        customButtonView.frame=CGRectMake(0,400, customButtonView.frame.size.width, customButtonView.frame.size.height);
                    }
                }
                else{
                    customButtonView.frame=CGRectMake(0,400, customButtonView.frame.size.width, customButtonView.frame.size.height);
                }
                imagePicker.cameraOverlayView = customButtonView;
                
                
                [self presentViewController:imagePicker animated:YES completion:nil];
                load =YES;
            }
        }else{
//album opens ,when we dismiss the imagePicker from OverLay View
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
            load=YES ;
            
        }
//Asset Library to fetch the images from libary ,to show thumbnail
        NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
        ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
        
        [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                          usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
              {
                  if (asset) {
                      [collector addObject:asset];
                  }
              }];
//             NSLog(@"%lu",(unsigned long)[collector count]);
             self.photos = collector;
             if ([self.photos count]>0) {
                 ALAsset *asset = [self.photos objectAtIndex:self.photos.count-1];
                
                 [_addBtn setBackgroundImage:[UIImage imageWithCGImage:[asset thumbnail]] forState:UIControlStateNormal];
             }
         }
                        failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
         ];
    }
    else{
//validation imp. so that the presentview should not dismiss,when we move to gallery .
        if(!Crop){
        [self.navigationController dismissModalViewControllerAnimated:YES ];
        }
    }
}



-(IBAction)openAlbum:(id)sender{
    
    Album=YES ;
    load=NO;
//method called to remove the view ,to add the album picker view
    [self removeView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    load=YES;
    Album=NO;
    Crop =YES ;
     
    UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//Save Photo to library only if it wasnt already saved i.e. its just been taken
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(photoTaken, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
 
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:photoTaken forKey:@"image"];
    
   [self dismissViewControllerAnimated:YES completion:^{
//this view is pushed to crop the selected image 
        photoThumbVIewControllerViewController *controller1 = [[photoThumbVIewControllerViewController alloc] initWithNibName:@"photoThumbVIewControllerViewController" bundle:nil];
        controller1.delegate=self ;
        [controller1 setInstagramImgDic:dic];
        [self.navigationController pushViewController:controller1 animated:YES];
    }];
}


//UIImagePicker Delegate
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
 
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    Album=NO;
    [self.navigationController dismissModalViewControllerAnimated:YES ];
}

//-(NSString *)getFileName:(NSString *)fileName
//{
//	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
//	NSString *suffix = [temp lastObject];
//	
//	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
//	
//	NSString *name = [temp lastObject];
//	
//	name = [name stringByAppendingFormat:@".%@",suffix];
//	return name;
//}


//method called to open camera
-(IBAction)startCamera:(id)sender
{
    [imagePicker takePicture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//method called to remove the screen open to select the Image
- (IBAction)backBtnClick:(id)sender{
    [imagePicker dismissModalViewControllerAnimated:YES];
}

//method called to remove the view opened for camera .
-(void)removeView{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissModalViewControllerAnimated:YES ];
}


//Delegate :- To pass the image to othr View
-(void)photoThumbControllerDidFinish:(photoThumbVIewControllerViewController *)photoThumbViewController{
 self.image=photoThumbViewController.finalImg ;
    
    [delegate secondViewControllerDidFinish:self];
}

@end
