//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRContactsCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"
#import "GMRRequestMovieController.h"

@implementation GMRContactsCell

@synthesize delegate = _delegate;
@synthesize userImage = _userImage;

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
    
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"MyriadPro-BoldIt" size:11.0];
    UIFont *regularFont = [UIFont fontWithName:@"MyriadPro-Regular" size:10.0];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldItalicFont, NSFontAttributeName,[UIColor colorWithRed:243.0/255.0 green:174.0/255.0 blue:52.0/255.0 alpha:1.0f],NSForegroundColorAttributeName, nil];
    
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, nil];
    const NSRange range1 = NSMakeRange(0,4);
    const NSRange range2 = NSMakeRange(8,7);

    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"send or request a movie suggestion."]
                                           attributes:subAttrs];
    [attributedText setAttributes:attrs range:range1];
    [attributedText setAttributes:attrs range:range2];

    requestLabel = [[UILabel alloc] initWithFrame:requestView.frame];
    requestLabel.attributedText = attributedText;
    requestLabel.textAlignment = NSTextAlignmentLeft;
    requestLabel.backgroundColor = [UIColor clearColor];
    [requestView.superview addSubview:requestLabel];
    
    isDrawerOpen = NO;
    [drawerView.superview bringSubviewToFront:drawerView];
    
    roundUserImage= [[UIImageView alloc] initWithFrame:_userImage.frame];
    CALayer * l = [roundUserImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:24.0];
    
    [_userImage.superview addSubview:roundUserImage];
    [roundUserImage setUserInteractionEnabled:NO];
    
    [favoriteImage.superview bringSubviewToFront:favoriteImage];

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [drawerView setFrame:CGRectMake(drawerView.frame.origin.x-156, drawerView.frame.origin.y,drawerView.frame.size.width,drawerView.frame.size.height)];
    [drawerView.superview bringSubviewToFront:drawerView];
    [UIView commitAnimations];


}

-(IBAction)slideDrawer:(id)sender
{
    [drawerView.superview bringSubviewToFront:drawerView];
    if (isDrawerOpen)
    {
        isDrawerOpen = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [drawerView setFrame:CGRectMake(drawerView.frame.origin.x+120, drawerView.frame.origin.y,drawerView.frame.size.width,drawerView.frame.size.height)];
        [drawerView.superview bringSubviewToFront:drawerView];
        [UIView commitAnimations];

    }else
    {
        isDrawerOpen = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [drawerView setFrame:CGRectMake(drawerView.frame.origin.x-120, drawerView.frame.origin.y,drawerView.frame.size.width,drawerView.frame.size.height)];
        [drawerView.superview bringSubviewToFront:drawerView];
        [UIView commitAnimations];
        
    }
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
        [favoriteButton setSelected:YES];
        [favoriteLabel setTextColor:[UIColor colorWithRed:254.0/255.0 green:197.0/255.0 blue:67.0/255.0 alpha:1.0f]];
    }
    [self bringSubviewToFront:drawerView];

    
}

-(IBAction)favoriteButtonPressed:(id)sender
{
        int accountID = [[contactDictionary objectForKey:@"login_id"] intValue];
    if (![favoriteButton isSelected])
    {
        [favoriteButton setSelected:YES];
        [[GMRAppState sharedState].favouriteContacts addObject:[NSString stringWithFormat:@"%i",accountID]];
        [favoriteImage setImage:[UIImage imageNamed:@"star-icon.png"]];
        [favoriteLabel setTextColor:[UIColor colorWithRed:254.0/255.0 green:197.0/255.0 blue:67.0/255.0 alpha:1.0f]];

    }else
    {
        [favoriteButton setSelected:NO];
        [[GMRAppState sharedState].favouriteContacts removeObject:[NSString stringWithFormat:@"%i",accountID]];
        [favoriteImage setImage:nil];
        [favoriteLabel setTextColor:[UIColor whiteColor]];

    }
    [[GMRAppState sharedState] updateUserContactsInfo];
    
    if ([self.delegate respondsToSelector:@selector(favoritePressed:)])
    {
        [self.delegate favoritePressed:[favoriteButton isSelected]];
    }
}

-(IBAction)settingsButtonPressed:(id)sender
{
    
}

-(IBAction)deleteButtonPressed:(id)sender
{
    int accountID = [[contactDictionary objectForKey:@"login_id"] intValue];
    for (NSDictionary * userAccount in [GMRAppState sharedState].userContactsAccountData)
    {
        int login_id = [[userAccount objectForKey:@"login_id"] intValue];
        
        if (accountID == login_id)
        {
            [[GMRAppState sharedState].userFriendsAccountData removeObject:userAccount];
            break;
        }
    }
    if ([favoriteButton isSelected])
    {
        [[GMRAppState sharedState].favouriteContacts removeObject:[NSString stringWithFormat:@"%i",accountID]];
    }
    [[GMRAppState sharedState] updateUserContactsInfo];
    
    if ([self.delegate respondsToSelector:@selector(deletePressed:)])
    {
        [self.delegate deletePressed:[favoriteButton isSelected]];
    }
}

-(IBAction)sendMoviePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(suggestMovie:)])
    {
        [self.delegate suggestMovie:[[contactDictionary objectForKey:@"login_id"] intValue]];
    }
}

-(IBAction)requestMoviePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(requestMovie:)])
    {
        [self.delegate requestMovie:[[contactDictionary objectForKey:@"login_id"] intValue]];
    }
}

@end
