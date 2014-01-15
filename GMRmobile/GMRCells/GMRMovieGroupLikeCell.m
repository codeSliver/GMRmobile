//
//  GMRCollapsableCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 06/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRMovieGroupLikeCell.h"
#import "GMRCoreDataModelManager.h"

@implementation GMRMovieGroupLikeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFirstUser:(NSDictionary *)ratingInfo
{
    int userID = [[ratingInfo objectForKey:@"user_id"] intValue];
    if (userID != -1)
    {
        NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:userID];
        
        NSString * userImageURL = @"";
        if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
        {
            NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];
        }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
        {
            NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
        }
       
        
        [firstUserImage setHidden:YES];
        firstRoundImage= [[UIImageView alloc] initWithFrame:firstUserImage.frame];
        CALayer * l = [firstRoundImage layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:23.0];
        
        
        [firstUserImage.superview addSubview:firstRoundImage];
        [firstRoundImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        
        float ratings = [[ratingInfo objectForKey:@"rating"] doubleValue];
        if (ratings > 0.0f)
        {
        firstLabel = [[UILabel alloc] initWithFrame:firstLabelView.frame];
        firstLabel.text = [[NSString stringWithFormat:@"%0.1f",ratings] stringByReplacingOccurrencesOfString:@"." withString:@","];
        firstLabel.textColor = [UIColor whiteColor];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.alpha = 0.7f;
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
        [firstLabelView.superview addSubview:firstLabel];
        
        [firstLabel.superview bringSubviewToFront:firstLabel];
        }

    }
        
}

-(void)setSecondUser:(NSDictionary *)ratingInfo
{
    int userID = [[ratingInfo objectForKey:@"user_id"] intValue];
    if (userID != -1)
    {
        NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:userID];
        
        NSString * userImageURL = @"";
        if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
        {
            NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
        }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
        {
            NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
        }
        
        
        
        
        [secondUserImage setHidden:YES];
        secondRoundImage= [[UIImageView alloc] initWithFrame:secondUserImage.frame];
        CALayer * l = [secondRoundImage layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:23.0f];
        
        
        [secondUserImage.superview addSubview:secondRoundImage];
        [secondRoundImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        
        float ratings = [[ratingInfo objectForKey:@"rating"] doubleValue];
        if (ratings > 0.0f)
        {
            secondLabel = [[UILabel alloc] initWithFrame:secondLabelView.frame];
            secondLabel.text = [[NSString stringWithFormat:@"%0.1f",ratings] stringByReplacingOccurrencesOfString:@"." withString:@","];
            secondLabel.textColor = [UIColor whiteColor];
            secondLabel.textAlignment = NSTextAlignmentCenter;
            secondLabel.alpha = 0.7f;
            secondLabel.backgroundColor = [UIColor clearColor];
            secondLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
            [secondLabelView.superview addSubview:secondLabel];
            
            [secondLabel.superview bringSubviewToFront:secondLabel];
        }
    }

}

-(void)setThirdUser:(NSDictionary *)ratingInfo
{
    int userID = [[ratingInfo objectForKey:@"user_id"] intValue];
    if (userID != -1)
    {
        NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:userID];
        
        NSString * userImageURL = @"";
        if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
        {
            NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
        }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
        {
            NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
        }
        
        
        
        
        [thirdUserImage setHidden:YES];
        thirdRoundImage= [[UIImageView alloc] initWithFrame:thirdUserImage.frame];
        CALayer * l = [thirdRoundImage layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:23.0];
        
        
        [thirdUserImage.superview addSubview:thirdRoundImage];
        [thirdRoundImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        
        float ratings = [[ratingInfo objectForKey:@"rating"] doubleValue];
        if (ratings > 0.0f)
        {
            thirdLabel = [[UILabel alloc] initWithFrame:thirdLabelView.frame];
            thirdLabel.text = [[NSString stringWithFormat:@"%0.1f",ratings] stringByReplacingOccurrencesOfString:@"." withString:@","];
            thirdLabel.textColor = [UIColor whiteColor];
            thirdLabel.textAlignment = NSTextAlignmentCenter;
            thirdLabel.alpha = 0.7f;
            thirdLabel.backgroundColor = [UIColor clearColor];
            thirdLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
            [thirdLabelView.superview addSubview:thirdLabel];
            
            [thirdLabel.superview bringSubviewToFront:thirdLabel];
        }


    }

}

-(void)setFourthUser:(NSDictionary *)ratingInfo
{
    int userID = [[ratingInfo objectForKey:@"user_id"] intValue];
    if (userID != -1)
    {
        NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:userID];
        
        NSString * userImageURL = @"";
        if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
        {
            NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
        }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
        {
            NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
        }
        
        
        
        
        [fourthUserImage setHidden:YES];
        fourthRoundImage= [[UIImageView alloc] initWithFrame:fourthUserImage.frame];
        CALayer * l = [fourthRoundImage layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:23.0];
        
        
        [fourthUserImage.superview addSubview:fourthRoundImage];
        [fourthRoundImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        
        float ratings = [[ratingInfo objectForKey:@"rating"] doubleValue];
        if (ratings > 0.0f)
        {
            fourthLabel = [[UILabel alloc] initWithFrame:fourthLabelView.frame];
            fourthLabel.text = [[NSString stringWithFormat:@"%0.1f",ratings] stringByReplacingOccurrencesOfString:@"." withString:@","];
            fourthLabel.textColor = [UIColor whiteColor];
            fourthLabel.textAlignment = NSTextAlignmentCenter;
            fourthLabel.alpha = 0.7f;
            fourthLabel.backgroundColor = [UIColor clearColor];
            fourthLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
            [fourthLabelView.superview addSubview:fourthLabel];
            
            [fourthLabelView.superview bringSubviewToFront:fourthLabel];
        }


    }

}

-(void)setFifthUser:(NSDictionary *)ratingInfo
{
    int userID = [[ratingInfo objectForKey:@"user_id"] intValue];
    if (userID != -1)
    {
        NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:userID];
        
        NSString * userImageURL = @"";
        if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
        {
            NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
        }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
        {
            NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
            userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
        }
        
        
        [fifthUserImage setHidden:YES];
        fifthRoundImage= [[UIImageView alloc] initWithFrame:fifthUserImage.frame];
        CALayer * l = [fifthRoundImage layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:23.0];
        
        
        [fifthUserImage.superview addSubview:fifthRoundImage];
        [fifthRoundImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        
        float ratings = [[ratingInfo objectForKey:@"rating"] doubleValue];
        if (ratings > 0.0f)
        {
            fifthLabel = [[UILabel alloc] initWithFrame:fifthLabelView.frame];
            fifthLabel.text = [[NSString stringWithFormat:@"%0.1f",ratings] stringByReplacingOccurrencesOfString:@"." withString:@","];
            fifthLabel.textColor = [UIColor whiteColor];
            fifthLabel.textAlignment = NSTextAlignmentCenter;
            fifthLabel.alpha = 0.7f;
            fifthLabel.backgroundColor = [UIColor clearColor];
            fifthLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
            [fifthLabelView.superview addSubview:fifthLabel];
            
            [fifthLabelView.superview bringSubviewToFront:fifthLabel];
        }
    }

}

@end
