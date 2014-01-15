//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRSearchContactsCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"

@implementation GMRSearchContactsCell

@synthesize delegate = _delegate;

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


}

-(void)setContact:(NSDictionary*)_contactDictionary
{
    contactDictionary = _contactDictionary;
    NSString * userImageURL = @"";
    NSString * firstName = @"";
    
    NSString * contactType = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"login_type"]];
    NSString * userName = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"user_complete_name"]];
    NSArray * nameArray = [userName componentsSeparatedByString:@" "];
    if ([nameArray count]>0)
        firstName = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:0]];

    if ([contactType isEqualToString:@"facebook"])
    {
        userImageURL = [NSString stringWithFormat:@"http://%@",[contactDictionary objectForKey:@"user_image_url"]];
    }else if ([contactType isEqualToString:@"manual"])
    {
        userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[contactDictionary objectForKey:@"user_image_url"]];
    }

    UIImageView * _userImageView = [[UIImageView alloc] initWithFrame:userImage.frame];
    
    CALayer * l = [_userImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:23.0];
    

    
    [userImage.superview addSubview:_userImageView];
    [_userImageView setUserInteractionEnabled:NO];
    [_userImageView setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
    
    [userNameLabel setText:userName];
    
    NSString * userAddressString = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"location"]];
    [userAddressLabel setText:userAddressString];
    
    int login_id = [[contactDictionary objectForKey:@"login_id"] intValue];
    
    for (NSDictionary * userAccount in [GMRAppState sharedState].userFriendsAccountData)
    {
        int userId = [[userAccount objectForKey:@"login_id"] intValue];
        
        if (userId == login_id)
        {
            [friendButton setSelected:YES];
        }
    }
    
    
}

-(IBAction)addFriendButtonPressed:(id)sender
{
    if (![friendButton isSelected])
    {
        [[GMRCoreDataModelManager sharedManager] addUserAsFriend:[[contactDictionary objectForKey:@"login_id"] intValue]];
        [[GMRAppState sharedState] addFriendLocally:[[contactDictionary objectForKey:@"login_id"] intValue]];
        if ([self.delegate respondsToSelector:@selector(addFriendPressed)])
        {
            [self.delegate addFriendPressed];
        }
        [friendButton setSelected:YES];
        
        NSMutableDictionary * historyDictionary = [[NSMutableDictionary alloc] init];
        [historyDictionary setObject:[contactDictionary objectForKey:@"login_id"] forKey:@"subjectID"];
        [historyDictionary setObject:@"addfriend" forKey:@"historyType"];
        [[GMRAppState sharedState] addDataToHistory:historyDictionary];
    }
}
@end
