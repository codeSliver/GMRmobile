//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "MovieBasicInfo.h"

@protocol RateMovieViewDelegate <NSObject>
- (void)rateMovieChanged;
@end

@interface GMRRateMovieView : UIView
{
    IBOutlet UIView * titleLabelView;
    UITextView * titleLabel;
    
    IBOutlet UIView * ratingView;
    UILabel * ratingLabel;
    
    IBOutlet UIView * sliderView;
    
    UISlider * rangeSlider;
    
    MovieBasicInfo * movieInfo;
    NSArray * currentMovieRatings;
    NSDictionary * currentUserRate;
    float userRating;
}

@property (nonatomic, strong) id <RateMovieViewDelegate> delegate;
@property (nonatomic,strong) IBOutlet UIButton * cancelButton;
@property (nonatomic,assign) UIViewController * parent;

-(IBAction)cancelPressed:(id)sender;
-(void)initialize;
-(void)setMovieID:(int)movieID;
-(IBAction)okPressed:(id)sender;
@end
