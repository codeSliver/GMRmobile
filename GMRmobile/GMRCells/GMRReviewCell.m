//
//  GMRReviewCell.m
//  GMRmobile
//
//  Created by   on 7/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRReviewCell.h"
#import "GMRCoreDataModelManager.h"

@implementation GMRReviewCell

@synthesize userImage = _userImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setLabels
{
    userNameLabel = [[UILabel alloc] initWithFrame:userName.frame];
    userNameLabel.text = @"";
    userNameLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:200.0/255.0 blue:13.0/255.0 alpha:1.0f];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
    [userName.superview addSubview:userNameLabel];
    
    userAddressLabel = [[UILabel alloc] initWithFrame:userAddress.frame];
    userAddressLabel.text = @"";
    userAddressLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0f];
    userAddressLabel.textAlignment = NSTextAlignmentLeft;
    userAddressLabel.backgroundColor = [UIColor clearColor];
    userAddressLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [userAddress.superview addSubview:userAddressLabel];
    
    pointLabel = [[UILabel alloc] initWithFrame:pointView.frame];
    pointLabel.text = @"";
    pointLabel.textColor = [UIColor colorWithRed:244.0/255.0 green:185.0/255.0 blue:75.0/255.0 alpha:1.0f];
    pointLabel.textAlignment = NSTextAlignmentLeft;
    pointLabel.backgroundColor = [UIColor clearColor];
    pointLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
//    [pointView.superview addSubview:pointLabel];
    
    commentTextView = [[UITextView alloc] initWithFrame:commentView.frame];
    [commentTextView setFont:[UIFont fontWithName:@"Lato-Light" size:11]];
    [commentTextView setUserInteractionEnabled:YES];
    [commentTextView setEditable:NO];
    [commentTextView setText:@""];
    [commentTextView setBackgroundColor:[UIColor clearColor]];
    [commentTextView setTextColor:[UIColor colorWithRed:75.0f/255.0f green:75.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    [commentView.superview addSubview:commentTextView];
    
    roundUserImage= [[UIImageView alloc] initWithFrame:_userImage.frame];
    CALayer * l = [roundUserImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:24.0];
    
    [roundUserImage setUserInteractionEnabled:NO];
    [_userImage.superview addSubview:roundUserImage];
}

-(void)setComment:(NSDictionary*)commentDictionary
{
//    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[commentDictionary objectForKey:@"movie_id"] intValue]];
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[commentDictionary objectForKey:@"user_id"] intValue]];
    
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
    
    NSString * pointsString = [NSString stringWithFormat:@"%0.1f",[[commentDictionary objectForKey:@"movie_rating"] doubleValue]];
    [pointLabel setText:pointsString];
    
    NSString * commentsString = [NSString stringWithFormat:@"%@",[commentDictionary objectForKey:@"user_review"]];
    CGSize size = [commentsString sizeWithFont:commentTextView.font
                       constrainedToSize:CGSizeMake(commentTextView.frame.size.width, 10000)
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    [commentTextView setFrame:CGRectMake(commentTextView.frame.origin.x, commentTextView.frame.origin.y, commentTextView.frame.size.width, size.height+30)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + size.height+ 10)];
    [commentTextView setText:commentsString];
}

-(float)getHeightForComment:(NSDictionary*)commentDictionary
{
    NSString * commentsString = [NSString stringWithFormat:@"%@",[commentDictionary objectForKey:@"user_review"]];
    CGSize size = [commentsString sizeWithFont:commentTextView.font
                             constrainedToSize:CGSizeMake(commentTextView.frame.size.width, 10000)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height+10;

}


@end
