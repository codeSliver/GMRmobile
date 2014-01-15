//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "GMRAddMoreFriendsCell.h"


@protocol AddMoreFiendsControllerDelegate <NSObject>
- (void)addFriend:(int)friendID;
- (void)removeFriend:(int)friendID;
@end

@interface GMRAddMoreFriendsController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,AddMoreFriendCellDalegate>
{
    IBOutlet UITableView * moreFriendsTableView;
    NSMutableArray * moreFriendsArray;
    
}

@property (nonatomic,assign) NSMutableArray * selectedFriends;
@property (nonatomic, strong) id <AddMoreFiendsControllerDelegate> delegate;
-(IBAction)okPressed:(id)sender;
@end
