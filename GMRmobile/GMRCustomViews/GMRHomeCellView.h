//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "MovieBasicInfo.h"
#import "UserFeedMovie.h"

@interface GMRHomeCellView : UIView
{
    IBOutlet UIView * likeCountView;
    UILabel * likeCountLabel;
    
    IBOutlet UIView * commentsCountView;
    UILabel * commentsCountLabel;
    
    IBOutlet UIView * groupCountView;
    UILabel * groupCountLabel;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    UIImageView * roundUserImage;
    
    UILabel * userMessageLabel;
    
    IBOutlet UIView * movieNameView;
    UILabel * movieNameLabel;
    
    UIView * overlayView;
    
    NSDictionary * feedDict;
    
    NSArray * currentRatings;
}


-(void)setViews;
@property (nonatomic,strong) IBOutlet UIImageView * movieImageView;
@property (nonatomic,strong) IBOutlet UIButton * userImageView;
@property (nonatomic,strong) IBOutlet UIButton * likeButton;
@property (nonatomic,strong) IBOutlet UIButton * commentButton;
@property (nonatomic,strong) IBOutlet UIButton * groupButton;;
@property (nonatomic,strong) IBOutlet UIButton * movieButton;

@property (nonatomic,strong) NSString * userImageURL;
@property (nonatomic,strong) NSString * firstName;
@property (nonatomic,strong) NSString * feedMessage;
@property (nonatomic,strong) NSString * likeCount;
@property (nonatomic,strong) NSString * commentsCount;
@property (nonatomic,strong) NSString * groupCount;
@property (nonatomic,strong) NSString * movieImageURL;
@property (nonatomic,strong) NSString * movieName;
@property (nonatomic) float userRatings;

-(void)setFeedObject:(UserFeedMovie*)movieDict;
-(void)setFeedDictionary:(NSDictionary*)feedDict;
@end
