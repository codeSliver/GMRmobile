//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"
#import "GMRCoreDataModelManager.h"

@interface GMRSuggestRequestMovieCell : GMRBaseCell
{
    IBOutlet UIImageView * movieImage;
    UIImageView * roundImage;
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
}


-(void)setViews;
-(void)setMovieDictionary:(NSDictionary*)movieDict;
-(void)setUserDictionary:(NSDictionary*)movieDict;

@end
