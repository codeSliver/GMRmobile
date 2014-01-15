//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "MovieBasicInfo.h"
#import "UIImageView+WebCache.h"

@interface GMRSearchCell : GMRBaseCell
{
    IBOutlet UIImageView * movieImage;
    UIImageView * roundImage;
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
}


-(void)setViews;
-(void)setTitle:(NSString*)title;
-(void)setMovieDictionary:(NSDictionary*)movieDict;
-(void)setMovieInfo:(MovieBasicInfo*)movieDict;
@end
