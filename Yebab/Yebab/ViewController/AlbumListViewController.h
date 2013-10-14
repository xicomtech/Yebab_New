//
//  AlbumListViewController.h
//  Yebab
//
//  Created by Virendra on 12/09/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *albumListView ;
}
@property(nonatomic,retain)IBOutlet UITableView *albumListView ;

@end
