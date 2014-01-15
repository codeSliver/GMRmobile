//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "GMRSuggestRequestFriendCell.h"
#import "GMRAddMoreFriendsController.h"

@interface GMRRequestMovieController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SuggestRequestFriendCellDalegate,AddMoreFiendsControllerDelegate>
{
    
    NSMutableArray * userList;
    NSMutableArray * searchUserList;
    IBOutlet UITableView * userTableView;
    IBOutlet UITextField * userTextField;

    
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
    
    IBOutlet UIView * userSelectedView;
    IBOutlet UIImageView * userSelectedImage;
    UIImageView * roundUserSelected;
    IBOutlet UIView * userSelectedLabelView;
    UILabel * userSelectedLabel;
    
    NSMutableArray * requestedUserIDs;
    int selectedFriend;
    
    IBOutlet UIView *  addNewFriendView;
    UILabel * addNewFriendLabel;
    
    IBOutlet UIButton * addNewFriendButton;
    
    NSMutableArray * addFriendList;
    IBOutlet UITableView * addFriendTableView;
    
}


@property (nonatomic,strong)  NSString * backButtonType;
-(IBAction)cancelSelectedButton:(id)sender;
-(IBAction)sendButtonPressed:(id)sender;
-(void)setUser:(int)userID;
@end
