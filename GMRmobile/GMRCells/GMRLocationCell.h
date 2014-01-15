//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"

@interface GMRLocationCell : GMRBaseCell
{
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
}


-(void)setViews;
-(void)setTitle:(NSString*)title;
@end
