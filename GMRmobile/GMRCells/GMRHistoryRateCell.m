//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRHistoryRateCell.h"
#import "GMRCoreDataModelManager.h"

@implementation GMRHistoryRateCell


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
    titleLabel.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Lato-Light" size:13.0];
    [titleView.superview addSubview:titleLabel];
    
    ratingLabel = [[UILabel alloc] initWithFrame:ratingView.frame];
    ratingLabel.text = @"You rated";
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

-(void)setHistoryReview:(NSDictionary*)historyDict;
{
    
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[historyDict objectForKey:@"subjectID"] intValue]];
//    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieInfo.movie_image_url];
    [roundImage setContentMode:UIViewContentModeScaleAspectFill];
    [roundImage setClipsToBounds:YES];
    [roundImage setImageWithURL:[NSURL URLWithString:movieInfo.movie_image_url] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
    
    NSString * movieName = [NSString stringWithFormat:@"%@",movieInfo.movie_name];
    [titleLabel setText:movieName];
    
}
@end
