//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRequestedMovieCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"

@implementation GMRRequestedMovieCell

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
    
    
    [userImage.superview addSubview:roundUserImage];
    

}

-(void)setMovieRequested:(NSDictionary*)_movieRequestedDict
{
    movieRequestedDictionary = _movieRequestedDict;
    
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[movieRequestedDictionary objectForKey:@"user_id"] intValue]];
    
    NSString * userImageURL = @"";
    NSString * firstName = @"";
    NSString * userAddressString = @"";
    if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
    {
        NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        firstName = [NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"user_complete_name"]];
        userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
        userAddressString = [NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"location"]];;
    }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
    {
        NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        firstName = [NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"user_complete_name"]];;
        userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
    }
    [roundUserImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    [userNameLabel setText:firstName];
    
    [userAddressLabel setText:userAddressString];

    

}

-(IBAction)requestedMoviePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(movieRequestPressed:)])
    {
        [self.delegate movieRequestPressed:movieRequestedDictionary];
        
    }
   
}
@end
