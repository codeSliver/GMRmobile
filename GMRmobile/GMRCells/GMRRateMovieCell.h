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

@interface GMRRateMovieCell : GMRBaseCell
{
    IBOutlet UIImageView * movieImage;
    IBOutlet UIView * titleView;
    UIImageView * roundImage;
    UILabel * titleLabel;
    
    IBOutlet UIView * rateView;
    UILabel * rateLabel;
    
    NSArray * currentMovieRatings;

}


-(void)setViews;
-(void)setMovieInfo:(NSDictionary*)movieDict;
-(void)setTitle:(NSString*)title;
-(void)setRate:(NSString*)rate;
@end
