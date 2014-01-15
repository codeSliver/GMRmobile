//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRateMovieCell.h"
#import "GMRAppState.h"

@implementation GMRRateMovieCell


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
    titleLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [titleView.superview addSubview:titleLabel];

    rateLabel = [[UILabel alloc] initWithFrame:rateView.frame];
    rateLabel.text = @"";
    rateLabel.textColor = [UIColor colorWithRed:247.0/255.0 green:204.0/255.0 blue:32.0/255.0 alpha:1.0f];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.backgroundColor = [UIColor clearColor];
    rateLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    [rateView.superview addSubview:rateLabel];
    
    [movieImage setHidden:YES];
    roundImage= [[UIImageView alloc] initWithFrame:movieImage.frame];
    CALayer * l = [roundImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:12.0];
    
    [movieImage.superview addSubview:roundImage];
}

-(void)setMovieInfo:(NSDictionary*)movieDict;
{
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[movieDict objectForKey:@"movie_id"] intValue]];
    [titleLabel setText:movieInfo.movie_name];
    
    
//    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieInfo.movie_image_url];
    [roundImage setContentMode:UIViewContentModeScaleAspectFill];
    [roundImage setClipsToBounds:YES];
    [roundImage setImageWithURL:[NSURL URLWithString:[[GMRAppState sharedState] getThumbnailMovieImage:movieInfo.movie_image_url]] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
    if (movieInfo.movie_rating > 0.1f)
        [rateLabel setText:[NSString stringWithFormat:@"%0.1f",movieInfo.movie_rating]];

}

-(void)setTitle:(NSString*)title
{
    [titleLabel setText:title];
}

-(void)setRate:(NSString*)rate
{
    [rateLabel setText:rate];
}

@end
