//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRSuggestRequestMovieCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"

@implementation GMRSuggestRequestMovieCell


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

    [movieImage setHidden:YES];
    roundImage= [[UIImageView alloc] initWithFrame:movieImage.frame];
    CALayer * l = [roundImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:12.0];
    
    [movieImage.superview addSubview:roundImage];

}

-(void)setMovieDictionary:(NSDictionary*)movieDict
{
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[movieDict objectForKey:@"movie_id"] intValue]];
    [titleLabel setText:movieInfo.movie_name];
    
    
 //   NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieInfo.movie_image_url];
    [roundImage setContentMode:UIViewContentModeScaleAspectFill];
    [roundImage setClipsToBounds:YES];
    [roundImage setImageWithURL:[NSURL URLWithString:[[GMRAppState sharedState] getThumbnailMovieImage:movieInfo.movie_image_url]] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];

}

-(void)setUserDictionary:(NSDictionary*)movieDict
{
    NSString * userName = [NSString stringWithFormat:@"%@",[movieDict objectForKey:@"name"]];
    [titleLabel setText:userName];
    
    NSString * movieType = [NSString stringWithFormat:@"%@",[movieDict objectForKey:@"type"]];
    NSString * completeURL =@"";
    if ([movieType isEqualToString:@"manual"])
    {
        completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[movieDict objectForKey:@"image_url"]];
    }else if ([movieType isEqualToString:@"facebook"])
    {
        completeURL = [NSString stringWithFormat:@"%@",[movieDict objectForKey:@"image_url"]];
    }
    [roundImage setImageWithURL:[NSURL URLWithString:completeURL] placeholderImage:[UIImage imageNamed:@"people.png"] options:SDWebImageRetryFailed];

}



@end
