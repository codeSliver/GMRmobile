//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "UIImageView+WebCache.h"

@interface GMRUserProfileViewController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * reviewTableView;
    NSArray * userFavArray;
    
    IBOutlet UIView * userImageView;
    UIImageView * userImage;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    IBOutlet UIView * userAddressView;
    UILabel * userAddressLabel;
    
    NSString * firstName;
    
    UIView * headerView;
    
    IBOutlet UIButton * favButton;
    IBOutlet UIButton * settingsButton;
    IBOutlet UIButton * deleteButton;
    
    BOOL isFriend;
    
    
}

@property (nonatomic,strong)  NSString * backButtonType;
@property (nonatomic) int userID;

-(IBAction)favouritePressed:(id)sender;
-(IBAction)settingsPressed:(id)sender;
-(IBAction)deletePressed:(id)sender;

@end
