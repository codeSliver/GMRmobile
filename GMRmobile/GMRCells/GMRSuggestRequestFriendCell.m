//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRSuggestRequestFriendCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"

@implementation GMRSuggestRequestFriendCell

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
    userNameLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Lato-Light" size:15.0];
    [userNameView.superview addSubview:userNameLabel];
    
    [userImage setHidden:YES];
    roundUserImage= [[UIImageView alloc] initWithFrame:userImage.frame];
    CALayer * l = [roundUserImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    
    [userImage.superview addSubview:roundUserImage];
    
}

-(void)setContact:(NSDictionary*)_contactDictionary
{
    contactDictionary = _contactDictionary;
    
    NSString * userType = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"type"]];
    NSString * completeURL =@"";
    if ([userType isEqualToString:@"manual"])
    {
        completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[contactDictionary objectForKey:@"image_url"]];
    }else if ([userType isEqualToString:@"facebook"])
    {
        completeURL = [NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"image_url"]];
    }
    

    [roundUserImage setImageWithURL:[NSURL URLWithString:completeURL] placeholderImage:[UIImage imageNamed:@"people.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
}];

    [userNameLabel setText:[NSString stringWithFormat:@"%@",[contactDictionary objectForKey:@"name"]]];
    
    
}

-(IBAction)cancelPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(unselectFriend:)])
    {
        [self.delegate unselectFriend:contactDictionary];
    }
}
@end
