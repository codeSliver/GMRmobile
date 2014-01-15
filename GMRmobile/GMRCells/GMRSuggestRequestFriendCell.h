//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"


@protocol SuggestRequestFriendCellDalegate <NSObject>
- (void)unselectFriend:(NSDictionary*)friendDict;
@end


@interface GMRSuggestRequestFriendCell : GMRBaseCell
{
    IBOutlet UIImageView * userImage;
    UIImageView * roundUserImage;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    IBOutlet UIButton * cancelButton;
    
    
    
    NSDictionary * contactDictionary;
    
}

@property (nonatomic, strong) id <SuggestRequestFriendCellDalegate> delegate;

-(void)setViews;
-(void)setContact:(NSDictionary*)contactDictionary;
-(IBAction)cancelPressed:(id)sender;

@end
