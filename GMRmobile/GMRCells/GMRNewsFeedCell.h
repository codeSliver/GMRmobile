//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"

@interface GMRNewsFeedCell : GMRBaseCell
{
   
    IBOutlet UIView * titleLabelView;
    UILabel * titleLabel;
}

-(void)setViews;
-(void)setTitleString:(NSString*)titleString;

@end
