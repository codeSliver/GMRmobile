//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRateMovieView.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"
#import "MovieRateInfoObject.h"

@implementation GMRRateMovieView

@synthesize cancelButton = _cancelButton;
@synthesize parent = _parent;
@synthesize delegate = _delegate;

#define SLIDER_MIN 1.0f
#define SLIDER_MAX 5.0f
#define SLIDER_INTERVAL 0.5f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initialize
{
    titleLabel = [[UITextView alloc] initWithFrame:titleLabelView.frame];
    titleLabel.text = @"Go ahead and rate your movie using rating scale below...";
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel setUserInteractionEnabled:NO];
    [titleLabel setEditable:NO];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Lato-Light" size:15.0];
    [titleLabelView.superview addSubview:titleLabel];
    
    ratingLabel = [[UILabel alloc] initWithFrame:ratingView.frame];
    ratingLabel.text = [NSString stringWithFormat:@"%0.1f",userRating];
    ratingLabel.textColor = [UIColor blackColor];
    ratingLabel.textAlignment = NSTextAlignmentCenter;
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.font = [UIFont fontWithName:@"Lato-Light" size:25.0];
    [ratingView.superview addSubview:ratingLabel];
    
    rangeSlider = [[UISlider alloc] initWithFrame:CGRectMake(sliderView.frame.origin.x+45, sliderView.frame.origin.y+42, sliderView.frame.size.height, 50)];
    [sliderView.superview addSubview:rangeSlider];
    rangeSlider.transform=CGAffineTransformRotate(rangeSlider.transform,90.0/180*M_PI);
    [rangeSlider setMaximumValue:5];
    [rangeSlider setMinimumValue:1];
    rangeSlider.value = userRating;
    [rangeSlider  setThumbImage:[UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
    [rangeSlider setMinimumTrackImage:[[UIImage imageNamed:@"slider-over-state.png"] stretchableImageWithLeftCapWidth:0.3 topCapHeight:0.0] forState:UIControlStateNormal];
    [rangeSlider setMaximumTrackImage:[[UIImage imageNamed:@"slider-normal-state"] stretchableImageWithLeftCapWidth:0.3 topCapHeight:0.0] forState:UIControlStateNormal];
    [rangeSlider addTarget:self action:@selector(sliderDidChangeValue:) forControlEvents:UIControlEventValueChanged];
   
}

-(void)setMovieID:(int)movieID
{
    movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:movieID];
    currentMovieRatings = [[GMRCoreDataModelManager sharedManager] getRatingsForMovie:movieID];
    
     userRating = 1.0f;
    if (currentMovieRatings)
    {
        for (NSDictionary * movieRate in currentMovieRatings)
        {
            int userID = [[movieRate objectForKey:@"user_id"] intValue];
            if (userID == [GMRAppState sharedState].userAccountInfo.login_id)
            {
                userRating = [[movieRate objectForKey:@"movie_rating"] doubleValue];
                currentUserRate = movieRate;
                break;
            }
        }
    }
    

}
- (void)sliderDidChangeValue:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    //Round the value to the a target interval
    CGFloat roundedValue = [self roundValue:slider.value];
    
    //Snap to the final value
    [slider setValue:roundedValue animated:NO];
    [ratingLabel setText:[NSString stringWithFormat:@"%0.1f",slider.value]];
}

- (float)roundValue:(float)value
{
    //get the remainder of value/interval
    //make sure that the remainder is positive by getting its absolute value
    float tempValue = fabsf(fmodf(value, SLIDER_INTERVAL)); //need to import <math.h>
    
    //if the remainder is greater than or equal to the half of the interval then return the higher interval
    //otherwise, return the lower interval
    if(tempValue >= (SLIDER_INTERVAL / 2.0)){
        return value - tempValue + SLIDER_INTERVAL;
    }
    else{
        return value - tempValue;
    }
}

-(IBAction)okPressed:(id)sender
{
    MovieRateInfoObject * newRatings = [[MovieRateInfoObject alloc] init];
    
    newRatings.user_id = [GMRAppState sharedState].userAccountInfo.login_id;
    newRatings.movie_id = movieInfo.movie_id;
    newRatings.movie_rating = rangeSlider.value;
    
    NSString * newRatingsJSON;
    if (currentUserRate)
    {
        newRatings.movie_rate_id = [[currentUserRate objectForKey:@"movie_rate_id"] intValue];
        newRatingsJSON = [newRatings ToJSONWithID:YES];
    }else
    {
        newRatingsJSON = [newRatings ToJSONWithID:NO];
    }
    NSString * commentResponseString = [[GMRCoreDataModelManager sharedManager] postRatings:newRatingsJSON];
    NSDictionary * respDict = [commentResponseString JSONValue];
    NSString * respString = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
    if ([respString isEqualToString:@"success"])
    {
        float averageValue = [[respDict objectForKey:@"average"] floatValue];
        [[GMRCoreDataModelManager sharedManager] setAverageValueForMovie:movieInfo.movie_id andRatings:averageValue];
        
        NSMutableDictionary * historyDictionary = [[NSMutableDictionary alloc] init];
        [historyDictionary setObject:[NSNumber numberWithInt:movieInfo.movie_id] forKey:@"subjectID"];
        [historyDictionary setObject:@"rate" forKey:@"historyType"];
        [[GMRAppState sharedState] addDataToHistory:historyDictionary];
        [[GMRAppState sharedState] todayTopRated];
        
        if ([self.delegate respondsToSelector:@selector(rateMovieChanged)])
        {
            [self.delegate rateMovieChanged];
        }
    }
    [self cancelPressed:nil];
}
-(IBAction)cancelPressed:(id)sender
{
        [self removeFromSuperview];
}

@end
