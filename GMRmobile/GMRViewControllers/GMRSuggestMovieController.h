//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "MBProgressHUD.h"
#import "GMRSuggestRequestFriendCell.h"
#import "GMRAddMoreFriendsController.h"

@interface GMRSuggestMovieController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,SuggestRequestFriendCellDalegate,AddMoreFiendsControllerDelegate>
{
    NSArray * movieList;
    NSMutableArray * searchMovieList;
    IBOutlet UITextField * movieTextField;
    IBOutlet UITableView * movieTableView;
    
    NSMutableArray * userList;
    NSMutableArray * searchUserList;
    IBOutlet UITableView * userTableView;
    IBOutlet UITextField * userTextField;
    
    NSMutableArray * addFriendList;
    IBOutlet UITableView * addFriendTableView;
    
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
    
    IBOutlet UIView * toView;
    UILabel * toLabel;
    
    IBOutlet UIView * movieSelectedView;
    IBOutlet UIImageView * movieSelectedImage;
    UIImageView * roundMovieSelected;
    IBOutlet UIView * movieSelectedLabelView;
    UILabel * movieSelectedLabel;
    
    IBOutlet UIView * userSelectedView;
    IBOutlet UIImageView * userSelectedImage;
    UIImageView * roundUserSelected;
    IBOutlet UIView * userSelectedLabelView;
    UILabel * userSelectedLabel;
    
    IBOutlet UIView *  addNewFriendView;
    UILabel * addNewFriendLabel;
    
    IBOutlet UIButton * addNewFriendButton;
    
    int suggest_movie_id;
    NSMutableArray * suggested_users_id;
    int selectedFriend;
    
    NSDate * textChangingDate;
    MBProgressHUD * HUD;
    NSString * searchString;

}

@property (nonatomic,strong)  NSString * backButtonType;
@property (nonatomic,strong) NSDictionary * requestedMovieInfo;
-(IBAction)cancelSelectedButton:(id)sender;
-(IBAction)sendButtonPressed:(id)sender;
-(void)setUser:(int)userID;

-(IBAction)addFriendButton:(id)sender;
-(void)selectFriend:(NSDictionary *)friendDict;
-(void)setMovieID:(int)movieID;
@end
