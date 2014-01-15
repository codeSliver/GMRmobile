//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRecommendationCell.h"
#import "MovieBasicInfo.h"
#import "UserAccount.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"

@implementation GMRRecommendationCell

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
    userNameLabel.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0f];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
    [userNameView.superview addSubview:userNameLabel];
    
    movieLabel = [[UILabel alloc] initWithFrame:movieNamView.frame];
    movieLabel.text = @"";
    movieLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:200.0/255.0 blue:13.0/255.0 alpha:1.0f];
    movieLabel.textAlignment = NSTextAlignmentLeft;
    movieLabel.backgroundColor = [UIColor clearColor];
    movieLabel.font = [UIFont fontWithName:@"Lato-Regular" size:22.0];
    [movieNamView.superview addSubview:movieLabel];
    
    roundView = [[UIImageView alloc] initWithFrame:userImage.frame];
    
    CALayer * l = [roundView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:22.5];
    
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [userImage.superview addSubview:roundView];
    [roundView setUserInteractionEnabled:NO];

    isDrawerOpen = NO;
    [drawerView.superview bringSubviewToFront:drawerView];


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

-(void)setRecommendation:(NSDictionary*)_recommendationDictionary
{
    recommendationDictionary = _recommendationDictionary;
    
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[recommendationDictionary objectForKey:@"movie_id"] intValue]];
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[recommendationDictionary objectForKey:@"user_id"] intValue]];
    
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

    [roundView setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
    
    [userNameLabel setText:firstName];
    
    UIFont * titleFont = [UIFont fontWithName:@"Lato-Regular" size:16.0];
    CGSize sizeOfText=[userNameLabel.text sizeWithFont:titleFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, userNameLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    messageLabel= [[UILabel alloc] initWithFrame:CGRectMake(sizeOfText.width+userNameLabel.frame.origin.x+10, userNameLabel.frame.origin.y+2,  130, userNameLabel.frame.size.height)];
    messageLabel.text = @"thinks you might like";
    messageLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0f];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.userInteractionEnabled = NO;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [userNameView.superview addSubview:messageLabel];

    
    [movieLabel setText:movieInfo.movie_name];
    
    [drawerView.superview bringSubviewToFront:drawerView];
    
    BOOL isFavoriteRecommendation = [[GMRAppState sharedState] isFavoriteRecommendation:[[recommendationDictionary objectForKey:@"user_suggest_id"] intValue]];
    
    if (isFavoriteRecommendation)
    {
        [thanksButton setSelected:YES];
        [thanksLabel setTextColor:[UIColor colorWithRed:254.0/255.0 green:197.0/255.0 blue:67.0/255.0 alpha:1.0f]];
    }

    
}

-(IBAction)deletePressed:(id)sender
{
    int suggestionID = [[recommendationDictionary objectForKey:@"user_suggest_id"] intValue];
    BOOL isDeleted = [[GMRCoreDataModelManager sharedManager] deleteRecommendation:recommendationDictionary];
    if (isDeleted)
    {
        if ([self.delegate respondsToSelector:@selector(deletePressed:)])
        {
            [self.delegate deletePressed:suggestionID];
        }
    }
}

-(IBAction)thanksPressed:(id)sender
{
    int suggestionID = [[recommendationDictionary objectForKey:@"user_suggest_id"] intValue];
    if (![thanksButton isSelected])
    {
        [thanksButton setSelected:YES];
        [[GMRAppState sharedState] addDataToRecommendations:suggestionID];
        [thanksLabel setTextColor:[UIColor colorWithRed:254.0/255.0 green:197.0/255.0 blue:67.0/255.0 alpha:1.0f]];
        
    }else
    {
        [thanksButton setSelected:NO];
        [[GMRAppState sharedState] removeDataToRecommendations:suggestionID];
        [thanksLabel setTextColor:[UIColor whiteColor]];
        
    }
}

@end
