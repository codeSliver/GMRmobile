//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRMovieLikeCell.h"
#import "GMRAppState.h"

@implementation GMRMovieLikeCell


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
    titleLabel = [[UILabel alloc] initWithFrame:titleView.frame];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Lato-Light" size:13.0];
    [titleView.superview addSubview:titleLabel];
    
    ratingLabel = [[UILabel alloc] initWithFrame:ratingView.frame];
    ratingLabel.text = @"";
    ratingLabel.textColor = [UIColor colorWithRed:244.0/255.0 green:183.0/255.0 blue:45.0/255.0 alpha:1.0f];
    ratingLabel.textAlignment = NSTextAlignmentRight;
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.font = [UIFont fontWithName:@"Lato-Light" size:13.0];
    [ratingView.superview addSubview:ratingLabel];

    [movieImage setHidden:YES];
    roundImage= [[UIImageView alloc] initWithFrame:movieImage.frame];
    CALayer * l = [roundImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:12.0];
    
    [movieImage.superview addSubview:roundImage];

}

-(void)setMovieInfo:(NSDictionary*)movieDict
{
    
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[movieDict objectForKey:@"movie_id"] intValue]];
    [titleLabel setText:movieInfo.movie_name];
    
//    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieInfo.movie_image_url];
    [roundImage setContentMode:UIViewContentModeScaleAspectFill];
    [roundImage setClipsToBounds:YES];
    [roundImage setImageWithURL:[NSURL URLWithString:[[GMRAppState sharedState] getThumbnailMovieImage:movieInfo.movie_image_url]] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
 //   [ratingLabel setText:[NSString stringWithFormat:@"%0.1f",movieDict.movie_rating]];
}

-(void)setMovieRateInfo:(NSDictionary*)movieDict
{
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[movieDict objectForKey:@"movie_id"] intValue]];
    [titleLabel setText:movieInfo.movie_name];
    
//    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieInfo.movie_image_url];
    [roundImage setContentMode:UIViewContentModeScaleAspectFill];
    [roundImage setClipsToBounds:YES];
    [roundImage setImageWithURL:[NSURL URLWithString:[[GMRAppState sharedState] getThumbnailMovieImage:movieInfo.movie_image_url]]  placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
    [ratingLabel setText:[NSString stringWithFormat:@"%0.1f",[[movieDict objectForKey:@"movie_rating"] floatValue]]];

}
-(void)setTitle:(NSString*)title
{
    [titleLabel setText:title];
}

@end
