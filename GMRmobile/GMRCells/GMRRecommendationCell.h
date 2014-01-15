//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"

@protocol RecommendationCellDalegate <NSObject>
- (void)deletePressed:(int)suggestionID;
@end

@interface GMRRecommendationCell : GMRBaseCell
{
    IBOutlet UIImageView * userImage;
    UIImageView * roundView;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    UILabel * messageLabel;
    
    IBOutlet UIView * movieNamView;
    UILabel * movieLabel;
    
    
    IBOutlet UIView * drawerView;
    BOOL isDrawerOpen;
    
    IBOutlet UILabel * thanksLabel;
    IBOutlet UIButton * thanksButton;
    
    NSDictionary * recommendationDictionary;

}


@property (nonatomic, strong) id <RecommendationCellDalegate> delegate;


-(void)setViews;
-(void)setRecommendation:(NSDictionary*)recommendationDictionary;
-(IBAction)slideDrawer:(id)sender;
-(IBAction)deletePressed:(id)sender;
-(IBAction)thanksPressed:(id)sender;
@end
