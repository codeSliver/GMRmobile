//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRHomeCellView.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"
#import "MBProgressHUD.h"

@implementation GMRHomeCellView
@synthesize movieImageView = _movieImageView;
@synthesize userImageView = _userImageView;
@synthesize likeButton = _likeButton;
@synthesize commentButton = _commentButton;
@synthesize groupButton = _groupButton;
@synthesize movieButton = _movieButton;
@synthesize movieName = _movieName;
@synthesize movieImageURL = _movieImageURL;
@synthesize userImageURL = _userImageURL;
@synthesize groupCount = _groupCount;
@synthesize feedMessage = _feedMessage;
@synthesize firstName = _firstName;
@synthesize commentsCount = _commentsCount;
@synthesize likeCount = _likeCount;
@synthesize userRatings = _userRatings;

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
    likeCountLabel = [[UILabel alloc] initWithFrame:likeCountView.frame];
    likeCountLabel.text = @"";
    likeCountLabel.textColor = [UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f];
    likeCountLabel.textAlignment = NSTextAlignmentLeft;
    likeCountLabel.backgroundColor = [UIColor clearColor];
    likeCountLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [likeCountView.superview addSubview:likeCountLabel];
    
    userNameLabel = [[UILabel alloc] initWithFrame:userNameView.frame];
    userNameLabel.text = @"";
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
    [userNameView.superview addSubview:userNameLabel];
    
    commentsCountLabel = [[UILabel alloc] initWithFrame:commentsCountView.frame];
    commentsCountLabel.text = @"";
    commentsCountLabel.textColor = [UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f];
    commentsCountLabel.textAlignment = NSTextAlignmentLeft;
    commentsCountLabel.backgroundColor = [UIColor clearColor];
    commentsCountLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [commentsCountView.superview addSubview:commentsCountLabel];
    
    movieNameLabel = [[UILabel alloc] initWithFrame:movieNameView.frame];
    movieNameLabel.text = @"";
    movieNameLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:200.0/255.0 blue:13.0/255.0 alpha:1.0f];
    movieNameLabel.textAlignment = NSTextAlignmentLeft;
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:22.0];
    [movieNameView.superview addSubview:movieNameLabel];
    
    groupCountLabel = [[UILabel alloc] initWithFrame:groupCountView.frame];
    groupCountLabel.text = @"";
    groupCountLabel.textColor = [UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f];
    groupCountLabel.textAlignment = NSTextAlignmentLeft;
    groupCountLabel.backgroundColor = [UIColor clearColor];
    groupCountLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [groupCountView.superview addSubview:groupCountLabel];
    
    
    roundUserImage = [[UIImageView alloc] initWithFrame:_userImageView.frame];
    
    CALayer * l = [roundUserImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:30.0];
    
    // You can even add a border
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [_userImageView.superview addSubview:roundUserImage];
    [roundUserImage setUserInteractionEnabled:NO];

    [_movieImageView setClipsToBounds:YES];
    [_movieImageView setContentMode:UIViewContentModeScaleAspectFill];

}

-(void)setFeedDictionary:(NSDictionary*)_feedDict
{
    feedDict = _feedDict;
    [self performSelectorInBackground:@selector(populateData) withObject:self];
    
}

-(void)populateData
{
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[feedDict objectForKey:@"movie_id"] intValue]];
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[feedDict objectForKey:@"user_id"] intValue]];
    
    _userImageURL = @"";
    _firstName = @"";
    
    if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
    {
        NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        NSArray * nameArray = [[NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"user_complete_name"]] componentsSeparatedByString:@" "];
        if ([nameArray count]>0)
            _firstName = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:0]];
        _userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
    }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
    {
        NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        NSArray * nameArray = [[NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"user_complete_name"]] componentsSeparatedByString:@" "];
        if ([nameArray count]>0)
            _firstName = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:0]];
        _userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
        
        
    }
    if ([[feedDict objectForKey:@"user_id"] intValue] == [GMRAppState sharedState].userAccountInfo.login_id)
    {
        _firstName = @"You";
    }
    
    currentRatings = [[GMRAppState sharedState].movieReviewRateDictionary objectForKey:[NSString stringWithFormat:@"%i_Rate_Data",movieInfo.movie_id]];
    
    if (!currentRatings)
    {
        currentRatings = [[GMRCoreDataModelManager sharedManager] getRatingsForMovie:movieInfo.movie_id];
        [[GMRAppState sharedState].movieReviewRateDictionary setObject:currentRatings forKey:[NSString stringWithFormat:@"%i_Rate_Data",movieInfo.movie_id]];
    }
    
    _userRatings = 1.0f;

        for (NSDictionary * movieRate in currentRatings)
        {
            int userID = [[movieRate objectForKey:@"user_id"] intValue];
            if (userID == [GMRAppState sharedState].userAccountInfo.login_id)
            {
                _userRatings = [[movieRate objectForKey:@"movie_rating"] doubleValue];
                break;
            }
        }
    _groupCount = [NSString stringWithFormat:@"%0.1f",movieInfo.movie_rating];
    _commentsCount = [NSString stringWithFormat:@"%i",movieInfo.movie_comments_count];
    _likeCount = [NSString stringWithFormat:@"%0.1f",_userRatings];
    _feedMessage = [NSString stringWithFormat:@"%@",[feedDict objectForKey:@"feed_comment"]];
    _movieImageURL = movieInfo.movie_image_url;
    _movieName = movieInfo.movie_name;
    
    [self performSelectorOnMainThread:@selector(populateViews) withObject:self waitUntilDone:YES];
  }

-(void)populateViews
{
    [movieNameLabel setText:_movieName];
    [userNameLabel setText:_firstName];
    [groupCountLabel setText:_groupCount];
    [commentsCountLabel setText:_commentsCount];
    [likeCountLabel setText:_likeCount];
    
    
    CGSize size = [_firstName sizeWithFont:userNameLabel.font
                        constrainedToSize:CGSizeMake(userNameLabel.frame.size.width, 10000)
                            lineBreakMode:NSLineBreakByWordWrapping];
    
    userMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x+size.width+10, userNameLabel.frame.origin.y+2, 150, userNameLabel.frame.size.height)];
    [userMessageLabel setFont:[UIFont fontWithName:@"Lato-Light" size:12.0]];
    [userMessageLabel setText:_feedMessage];
    [userMessageLabel setTextColor:[UIColor whiteColor]];
    userMessageLabel.backgroundColor = [UIColor clearColor];
    [userNameLabel.superview addSubview:userMessageLabel];

    [_movieImageView setImageWithURL:[NSURL URLWithString:[[GMRAppState sharedState] getDetMovieImage:_movieImageURL]] placeholderImage:[UIImage imageNamed:@"poster.png"] options:SDWebImageRetryFailed];
    [roundUserImage setImageWithURL:[NSURL URLWithString:_userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"]  options:SDWebImageRetryFailed];
}

@end
