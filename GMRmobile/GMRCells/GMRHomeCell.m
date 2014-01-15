//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRHomeCell.h"

@implementation GMRHomeCell
@synthesize movieImageView = _movieImageView;
@synthesize userImageView = _userImageView;
@synthesize likeButton = _likeButton;
@synthesize commentButton = _commentButton;
@synthesize groupButton = _groupButton;

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
    
    commentsCountLabel = [[UILabel alloc] initWithFrame:commentsCountView.frame];
    commentsCountLabel.text = @"";
    commentsCountLabel.textColor = [UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f];
    commentsCountLabel.textAlignment = NSTextAlignmentLeft;
    commentsCountLabel.backgroundColor = [UIColor clearColor];
    commentsCountLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [commentsCountView.superview addSubview:commentsCountLabel];
    
    groupCountLabel = [[UILabel alloc] initWithFrame:groupCountView.frame];
    groupCountLabel.text = @"";
    groupCountLabel.textColor = [UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f];
    groupCountLabel.textAlignment = NSTextAlignmentLeft;
    groupCountLabel.backgroundColor = [UIColor clearColor];
    groupCountLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [groupCountView.superview addSubview:groupCountLabel];


}

-(void)setMovieDictionary:(NSDictionary*)movieDict
{
    NSString * likeCount = [NSString stringWithFormat:@"%@",[movieDict objectForKey:@"likeCount"]];
    [likeCountLabel setText:likeCount];
    
    NSString * commentsCount = [NSString stringWithFormat:@"%@",[movieDict objectForKey:@"commentCount"]];
    [commentsCountLabel setText:commentsCount];
    
    NSString * groupCount = [NSString stringWithFormat:@"%@",[movieDict objectForKey:@"groupDiscussion"]];
    [groupCountLabel setText:groupCount];
    
    [_movieImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[movieDict objectForKey:@"movieImage"]]]];
}


@end
