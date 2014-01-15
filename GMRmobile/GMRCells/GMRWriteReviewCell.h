//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"

@interface GMRWriteReviewCell : GMRBaseCell
{
    IBOutlet UIImageView * movieImage;
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
}


-(void)setViews;
-(void)setMovieDictionary:(NSDictionary*)movieDict;
-(void)setTitle:(NSString*)title;
@end
