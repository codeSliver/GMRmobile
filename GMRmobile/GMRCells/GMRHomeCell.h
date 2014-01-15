//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"

@interface GMRHomeCell : GMRBaseCell
{
    IBOutlet UIView * likeCountView;
    UILabel * likeCountLabel;
    
    IBOutlet UIView * commentsCountView;
    UILabel * commentsCountLabel;
    
    IBOutlet UIView * groupCountView;
    UILabel * groupCountLabel;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    IBOutlet UIView * userMessageView;
    UILabel * userMessageLabel;
    
    IBOutlet UIView * movieNameView;
    UILabel * movieNameLabel;
}


-(void)setViews;
@property (nonatomic,strong) IBOutlet UIImageView * movieImageView;
@property (nonatomic,strong) IBOutlet UIImageView * userImageView;
@property (nonatomic,strong) IBOutlet UIButton * likeButton;
@property (nonatomic,strong) IBOutlet UIButton * commentButton;
@property (nonatomic,strong) IBOutlet UIButton * groupButton;;

-(void)setMovieDictionary:(NSDictionary*)movieDict;
@end
