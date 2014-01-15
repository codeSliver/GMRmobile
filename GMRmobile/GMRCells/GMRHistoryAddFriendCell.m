//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRHistoryAddFriendCell.h"
#import "GMRCoreDataModelManager.h"

@implementation GMRHistoryAddFriendCell


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
    
    ratingLabel = [[UILabel alloc] initWithFrame:ratingView.frame];
    ratingLabel.text = @"You added";
    ratingLabel.textColor = [UIColor colorWithRed:244.0/255.0 green:183.0/255.0 blue:45.0/255.0 alpha:1.0f];
    ratingLabel.textAlignment = NSTextAlignmentRight;
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.font = [UIFont fontWithName:@"Lato-Light" size:13.0];
    [ratingView.superview addSubview:ratingLabel];


}

-(void)setUserDictionary:(NSDictionary*)userDict
{

    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[userDict objectForKey:@"subjectID"] intValue]];
    
    NSString * userImageURL = @"";
    NSString * firstName = @"";
    
    if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
    {
        NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        NSArray * nameArray = [[NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"user_complete_name"]] componentsSeparatedByString:@" "];
        if ([nameArray count]>0)
            firstName = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:0]];
            userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
    }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
    {
        NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        NSArray * nameArray = [[NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"user_complete_name"]] componentsSeparatedByString:@" "];
        if ([nameArray count]>0)
            firstName = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:0]];
            userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
        
        
    }
    
    UIFont * titleFont = [UIFont fontWithName:@"Lato-Light" size:13.0];
    CGSize sizeOfText=[firstName sizeWithFont:titleFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, titleView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(titleView.frame.origin.x,titleView.frame.origin.y,sizeOfText.width,titleView.frame.size.height)];
    titleLabel.text=firstName;
    titleLabel.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:titleFont];
    [titleView.superview addSubview:titleLabel];

    
    UILabel * asFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+10, titleLabel.frame.origin.y, 200, titleLabel.frame.size.height)];
    asFriendLabel.text = @"as a friend";
    asFriendLabel.textColor = [UIColor colorWithRed:244.0/255.0 green:183.0/255.0 blue:45.0/255.0 alpha:1.0f];
    asFriendLabel.textAlignment = NSTextAlignmentLeft;
    asFriendLabel.backgroundColor = [UIColor clearColor];
    asFriendLabel.font = [UIFont fontWithName:@"Lato-Light" size:13.0];
    [titleView.superview addSubview:asFriendLabel];

    UIImageView * _userImageView = [[UIImageView alloc] initWithFrame:movieImage.frame];
    
    CALayer * l = [_userImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:12.0];
    
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [movieImage.superview addSubview:_userImageView];
    [_userImageView setUserInteractionEnabled:NO];
    [_userImageView setBackgroundColor:[UIColor clearColor]];
    [_userImageView setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image)
        {
            
        }
    }];

}

@end
