//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "GMRCoreDataModelManager.h"
#import "UIImageView+WebCache.h"

@interface GMRMovieLikeCell : GMRBaseCell
{
    IBOutlet UIImageView * movieImage;
    UIImageView * roundImage;
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
    
    IBOutlet UIView * ratingView;
    UILabel * ratingLabel;
}


-(void)setViews;
-(void)setTitle:(NSString*)title;
-(void)setMovieInfo:(NSDictionary*)movieDict;
-(void)setMovieRateInfo:(NSDictionary*)movieDict;
@end
