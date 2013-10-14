//
//  YBMeViewController.h
//  Yebab
//
//  Created by Xicom on 07/06/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>

// Muhannad's code
#import "Connections.h"
// Muhannad's code

// Muhannad's code
@interface YBMeViewController : UIViewController <ConnectionsDelegate>{
    
    NSString *requestType;
}
// Muhannad's code

@property (strong, nonatomic) IBOutlet UIView *userInfoView;
@property (strong, nonatomic) IBOutlet UILabel *photoLbl;
@property (strong, nonatomic) IBOutlet UILabel *albumLbl;
@property (strong, nonatomic) IBOutlet UILabel *followerLbl;
@property (strong, nonatomic) IBOutlet UILabel *followingLbl;
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic)   IBOutlet UITableView *tableNotifications;

- (void)tabChanged:(id)sender;

-(IBAction)editBtnClick:(id)sender ;
@end