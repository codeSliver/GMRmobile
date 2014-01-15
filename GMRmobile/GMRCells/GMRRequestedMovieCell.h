//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"

@protocol RequestedMoviewCellDelegate <NSObject>
- (void)movieRequestPressed:(NSDictionary*)requestDict;
@end

@interface GMRRequestedMovieCell : GMRBaseCell
{
    IBOutlet UIImageView * userImage;
    UIImageView * roundUserImage;
    
    IBOutlet UIView * userNameView;
    UILabel * userNameLabel;
    
    IBOutlet UIView * userAddressView;
    UILabel * userAddressLabel;
    
    NSDictionary * movieRequestedDictionary;

}


@property (nonatomic, strong) id <RequestedMoviewCellDelegate> delegate;


-(void)setViews;
-(void)setMovieRequested:(NSDictionary*)_movieRequestedDict;
-(IBAction)requestedMoviePressed:(id)sender;

@end
