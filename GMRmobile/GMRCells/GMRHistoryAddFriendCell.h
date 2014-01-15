//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"

@interface GMRHistoryAddFriendCell : GMRBaseCell
{
    IBOutlet UIImageView * movieImage;
    
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
    
    IBOutlet UIView * ratingView;
    UILabel * ratingLabel;
}


-(void)setViews;
-(void)setUserDictionary:(NSDictionary*)movieDict;
@end
