//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"


@protocol ContactCellDalegate <NSObject>
- (void)favoritePressed:(BOOL)selected;
- (void)deletePressed:(BOOL)isFavorite;
- (void)suggestMovie:(int)contactID;
- (void)requestMovie:(int)contactID;
@end


@interface GMRContactsCell : GMRBaseCell
{
    UIImageView * roundUserImage;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    IBOutlet UIView * userAddressView;
    UILabel * userAddressLabel;
    
    IBOutlet UIView * requestView;
    UILabel * requestLabel;
    
    IBOutlet UIImageView * favoriteImage;
    
    IBOutlet UIButton * favoriteButton;
    IBOutlet UIButton * settingsButton;
    IBOutlet UIButton * deleteButton;
    
    IBOutlet UIView * drawerView;
    BOOL isDrawerOpen;
    
    IBOutlet UILabel * favoriteLabel;
    
    NSDictionary * contactDictionary;

}


@property (nonatomic, strong) id <ContactCellDalegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton * userImage;
-(void)setViews;
-(void)setContact:(NSDictionary*)contactDictionary;
-(IBAction)slideDrawer:(id)sender;

-(IBAction)favoriteButtonPressed:(id)sender;
-(IBAction)settingsButtonPressed:(id)sender;
-(IBAction)deleteButtonPressed:(id)sender;
-(IBAction)sendMoviePressed:(id)sender;
-(IBAction)requestMoviePressed:(id)sender;

@end
