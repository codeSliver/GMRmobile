//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"


@protocol SearchContactCellDalegate <NSObject>
- (void)addFriendPressed;
@end

@interface GMRSearchContactsCell : GMRBaseCell
{
    IBOutlet UIImageView * userImage;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    IBOutlet UIView * userAddressView;
    UILabel * userAddressLabel;
    
    IBOutlet UIButton * friendButton;
    
    NSDictionary * contactDictionary;
  
}

@property (nonatomic, strong) id <SearchContactCellDalegate> delegate;

-(void)setViews;
-(void)setContact:(NSDictionary*)_contactDictionary;
-(IBAction)addFriendButtonPressed:(id)sender;
@end
