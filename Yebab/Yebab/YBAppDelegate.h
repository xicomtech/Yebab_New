//
//  YBAppDelegate.h
//  Yebab
//
//  Created by xicom-213 on 4/4/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

//#define UIAppDelegate \
((YBAppDelegate *)[UIApplication sharedApplication].delegate)

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GGTabarController.h"

@interface YBAppDelegate : UIResponder <UIApplicationDelegate>{
    GGTabarController *tabBarcontroller;
    NSMutableDictionary *globalDict ;
}
@property (strong, nonatomic) UIWindow               *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) FBSession              *fbSession;
@property (strong, nonatomic) NSMutableDictionary *globalDict ;
@end
