//
//  GMRCollapsableCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 06/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"

@interface GMRMovieGroupLikeCell : GMRBaseCell

{
    IBOutlet UIView * firstLabelView;
    UILabel * firstLabel;
    IBOutlet UIImageView * firstUserImage;
    UIImageView * firstRoundImage;
    
    IBOutlet UIView * secondLabelView;
    UILabel * secondLabel;
    IBOutlet UIImageView * secondUserImage;
    UIImageView * secondRoundImage;
    
    IBOutlet UIView * thirdLabelView;
    UILabel * thirdLabel;
    IBOutlet UIImageView * thirdUserImage;
    UIImageView * thirdRoundImage;
    
    IBOutlet UIView * fourthLabelView;
    UILabel * fourthLabel;
    IBOutlet UIImageView * fourthUserImage;
    UIImageView * fourthRoundImage;
    
    IBOutlet UIView * fifthLabelView;
    UILabel * fifthLabel;
    IBOutlet UIImageView * fifthUserImage;
    UIImageView * fifthRoundImage;
    
}

-(void)setFirstUser:(NSDictionary *)ratingInfo;
-(void)setSecondUser:(NSDictionary *)ratingInfo;
-(void)setThirdUser:(NSDictionary *)ratingInfo;
-(void)setFourthUser:(NSDictionary *)ratingInfo;
-(void)setFifthUser:(NSDictionary *)ratingInfo;

@end
