//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRAddMoreFriendsCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"
#import "GMRRequestMovieController.h"
#import "GMRAddMoreFriendsController.h"
@implementation GMRAddMoreFriendsCell

@synthesize delegate = _delegate;
@synthesize parent =_parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setViews
{
    userNameLabel = [[UILabel alloc] initWithFrame:userNameView.frame];
    userNameLabel.text = @"";
    userNameLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:200.0/255.0 blue:13.0/255.0 alpha:1.0f];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
    [userNameView.superview addSubview:userNameLabel];
    
    userAddressLabel = [[UILabel alloc] initWithFrame:userAddressView.frame];
    userAddressLabel.text = @"";
    userAddressLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0f];
    userAddressLabel.textAlignment = NSTextAlignmentLeft;
    userAddressLabel.backgroundColor = [UIColor clearColor];
    userAddressLabel.font = [UIFont fontWithName:@"Lato-Light" size:10.0];
    [userAddressView.superview addSubview:userAddressLabel];
    
    [userImage setHidden:YES];
    roundUserImage= [[UIImageView alloc] initWithFrame:userImage.frame];
    CALayer * l = [roundUserImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:24.0];
    [roundUserImage setBackgroundColor:[UIColor clearColor]];
    
    [userImage.superview addSubview:roundUserImage];
    
    [favoriteImage.superview bringSubviewToFront:favoriteImage];

}

-(void)setContact:(NSDictionary*)_contactDictionary
{
    contactDictionary = _contactDictionary;
    
    NSString * accountType = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"login_type"]];
    NSString *  accountID = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"login_type_id"]];
    
    NSString * userImageURL = @"";
    NSString * firstName = @"";
    NSString * userAddressString = @"";
    
    if ([accountType isEqualToString:@"facebook"])
        {
            NSDictionary * fbUserInfo;
            for (NSDictionary * fbUser in [GMRAppState sharedState].userContactsFBData)
            {
                
                if ([accountID isEqualToString:[NSString stringWithFormat:@"%@",[fbUser objectForKey:@"facebook_id"]]])
                {
                    fbUserInfo = fbUser;
                    break;
                }
            }
            if (fbUserInfo)
            {
                firstName = [NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"user_complete_name"]];
                userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
                userAddressString = [NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"location"]];
            }
            
        }else if ([accountType isEqualToString:@"manual"])
        {
            NSDictionary * loginUserInfo;
            for (NSDictionary * loginUser in [GMRAppState sharedState].userContactsLoginData)
            {
                if ([accountID isEqualToString:[NSString stringWithFormat:@"%@",[loginUser objectForKey:@"login_id"]]])
                {
                    loginUserInfo = loginUser;
                    break;
                }
            }
            if (loginUserInfo)
            {
                firstName = [NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"user_complete_name"]];
                userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
                userAddressString = [NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"location"]];
            }
            
        }
    

    [roundUserImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
}];

    [userNameLabel setText:firstName];
    
    [userAddressLabel setText:userAddressString];
    
    NSString * accountIDString = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"login_id"]];
    BOOL isFavorite = [[GMRAppState sharedState].favouriteContacts containsObject:accountIDString];

    
    if (isFavorite)
    {
        [favoriteImage setImage:[UIImage imageNamed:@"star-icon.png"]];
    }
    
    BOOL alreadySelected = [self.parent.selectedFriends containsObject:accountIDString];
    
    if (alreadySelected)
    {
        [addButton setSelected:YES];
    }

    
}

-(IBAction)addButtonPressed:(id)sender
{
    int accountID = [[contactDictionary objectForKey:@"login_id"] intValue];
    if (![addButton isSelected])
    {
        [addButton setSelected:YES];
        if ([self.delegate respondsToSelector:@selector(addFriend:)])
        {
            [self.delegate addFriend:accountID];
        }

    }else
    {
        [addButton setSelected:NO];
        if ([self.delegate respondsToSelector:@selector(removeFriend:)])
        {
            [self.delegate removeFriend:accountID];
        }

    }
    
  
}
@end
