//
//  YBMeViewController.m
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "YBMeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "YBEditProfileViewController.h"
#import "YBAppDelegate.h"

#define ME_SCREEN @"me/counters"
#define FONT_SIZE 15
#define FONT_HELVETICA_BOLD @"Helvetica-Bold"
#define FONT_HELVETICA @"Helvetica"
#define GREEN_COLOR [UIColor colorWithRed:27.0/255 green:173.0/255 blue:124.0/255 alpha:1.0]

@interface YBMeViewController ()

@end

@implementation YBMeViewController

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
    self.userInfoView.clipsToBounds = YES;
    self.userInfoView.layer.cornerRadius = 5.0f;
    self.userInfoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userInfoView.layer.borderWidth = 1.0f;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UISegmentedControl *topTabs = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Following", @"You", [UIImage imageNamed:@"inbox_icon.png"], nil]];
    [topTabs setTintColor:GREEN_COLOR];
    [topTabs setSegmentedControlStyle:UISegmentedControlStyleBar];
    [topTabs sizeToFit];
    [topTabs setSelectedSegmentIndex:1];
    [topTabs addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = topTabs;

    [self fetchCounters];
}

-(void)fetchCounters{
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"18",@"userId", nil];
    Connections *connections = [[Connections alloc] init];
    [connections setDelegate:self];
    requestType = ME_SCREEN;
    [connections setRequestType:ME_SCREEN];
    [connections sendRequestWithPath:ME_SCREEN andParameters:postParams showLoader:YES];
}

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString *)message{
    
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)data];
    if ([[responseDictionary objectForKey:@"success"] integerValue]){
        
        NSArray *responseArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"response"]];

        [self setCounter:[[[responseArray objectAtIndex:0] objectForKey:@"albums"] objectForKey:@"count"] andCaption:@"Albums" forLabel:self.albumLbl];
        [self setCounter:[[[responseArray objectAtIndex:1] objectForKey:@"photos"] objectForKey:@"count"] andCaption:@"Photos" forLabel:self.photoLbl];
        [self setCounter:[[[responseArray objectAtIndex:2] objectForKey:@"followers"] objectForKey:@"count"] andCaption:@"Followers" forLabel:self.followerLbl];
        [self setCounter:[[[responseArray objectAtIndex:3] objectForKey:@"following"] objectForKey:@"count"] andCaption:@"Following" forLabel:self.followingLbl];
    }
}

-(void)setCounter:(NSString*)counter andCaption:(NSString*)caption forLabel:(UILabel*)label{
    
    //set the properties for counter
    NSMutableParagraphStyle *counterParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    counterParagraphStyle.alignment = NSTextAlignmentCenter;
    UIFont * labelFont1 = [UIFont fontWithName:FONT_HELVETICA_BOLD size:FONT_SIZE];
    UIColor * labelColor1 = GREEN_COLOR;
    NSAttributedString *counterText = [[NSAttributedString alloc] initWithString:counter attributes:@ { NSParagraphStyleAttributeName:counterParagraphStyle, NSFontAttributeName : labelFont1, NSForegroundColorAttributeName : labelColor1}];

    //set the properties for caption
    NSMutableParagraphStyle *captionParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    captionParagraphStyle.alignment = NSTextAlignmentCenter;
    UIFont * labelFont2 = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    UIColor * labelColor2 = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
    NSAttributedString *captionText = [[NSAttributedString alloc] initWithString:caption attributes:@ { NSParagraphStyleAttributeName:captionParagraphStyle, NSFontAttributeName : labelFont2, NSForegroundColorAttributeName : labelColor2}];

    //show the final result
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    [mutableAttributedString appendAttributedString:counterText];
    [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [mutableAttributedString appendAttributedString:captionText];
    [label setAttributedText:mutableAttributedString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserInfoView:nil];
    [self setPhotoLbl:nil];
    [self setAlbumLbl:nil];
    [self setFollowerLbl:nil];
    [self setFollowingLbl:nil];
    [self setUserNameLbl:nil];
    [self setTableNotifications:nil];
    [super viewDidUnload];
}

- (void)tabChanged:(UISegmentedControl*)sender {
 
    if (sender.selectedSegmentIndex !=1){
       
        [UIView animateWithDuration:0.4 animations:^{
            [self.userInfoView setFrame:CGRectMake(self.userInfoView.frame.origin.x, -125, self.userInfoView.frame.size.width,self.userInfoView.frame.size.height)];
            [self.tableNotifications setFrame:CGRectMake(0, 6, 320, 361)];
        }];
    }
    else{
     
        [UIView animateWithDuration:0.4 animations:^{
            [self.userInfoView setFrame:CGRectMake(self.userInfoView.frame.origin.x, 6, self.userInfoView.frame.size.width, self.userInfoView.frame.size.height)];
            [self.tableNotifications setFrame:CGRectMake(0, 139, 320, 228)];
        }];
    }
}


-(IBAction)editBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewAdded" object:nil];
    
//    YBEditProfileViewController *controller = [[YBEditProfileViewController alloc] initWithNibName:@"YBEditProfileViewController" bundle:nil];
//    UINavigationController *navController =[[UINavigationController alloc]initWithRootViewController:controller];
//     YBAppDelegate *appDelegate = (YBAppDelegate *)[[UIApplication sharedApplication] delegate];
//    controller.userdetailsDic=[appDelegate.globalDict mutableCopy];
//    //   [self.navigationController pushViewController:controller animated:YES];
//    [navController pushViewController:controller animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"me_tab.png"]];
}


@end