//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRNewsFeedCell.h"

@implementation GMRNewsFeedCell


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
    titleLabel = [[UILabel alloc] initWithFrame:titleLabelView.frame];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:200.0/255.0 blue:13.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setNumberOfLines:2];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0];
    [titleLabelView.superview addSubview:titleLabel];

}

-(void)setTitleString:(NSString*)titleString
{
    [titleLabel setText:titleString];
}
@end
