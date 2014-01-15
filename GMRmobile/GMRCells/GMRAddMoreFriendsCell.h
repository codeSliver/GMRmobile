//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"

@class GMRAddMoreFriendsController;

@protocol AddMoreFriendCellDalegate <NSObject>
- (void)addFriend:(int)friendID;
- (void)removeFriend:(int)friendID;
@end


@interface GMRAddMoreFriendsCell : GMRBaseCell
{
    IBOutlet UIImageView * userImage;
    UIImageView * roundUserImage;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    IBOutlet UIView * userAddressView;
    UILabel * userAddressLabel;
    
    
    IBOutlet UIImageView * favoriteImage;
    
    IBOutlet UIButton * addButton;

    
    
    NSDictionary * contactDictionary;

}


@property (nonatomic, strong) id <AddMoreFriendCellDalegate> delegate;
@property (nonatomic, assign) GMRAddMoreFriendsController * parent;
-(void)setViews;
-(void)setContact:(NSDictionary*)contactDictionary;

-(IBAction)addButtonPressed:(id)sender;

@end
