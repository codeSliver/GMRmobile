//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRSearchCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"

@implementation GMRSearchCell


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
    [titleLabel setText:[NSString stringWithFormat:@"%@",[movieDict objectForKey:@"movie_name"]]];
    
//    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieDict.movie_image_url];
    [roundImage setContentMode:UIViewContentModeScaleAspectFill];
    [roundImage setClipsToBounds:YES];
    [roundImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[movieDict objectForKey:@"movie_image_url"]]] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
}

-(void)setMovieInfo:(MovieBasicInfo*)movieDict
{
    [titleLabel setText:[NSString stringWithFormat:@"%@",movieDict.movie_name]];
    
    //    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieDict.movie_image_url];
    [roundImage setContentMode:UIViewContentModeScaleAspectFill];
    [roundImage setClipsToBounds:YES];
    [roundImage setImageWithURL:[NSURL URLWithString:[[GMRAppState sharedState] getThumbnailMovieImage:[NSString stringWithFormat:@"%@",movieDict.movie_image_url]]] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
}

-(void)setTitle:(NSString*)title
{
    [titleLabel setText:title];
}



@end
