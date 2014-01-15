//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

@protocol HeaderSearchViewDelegate <NSObject>

-(void)headerSearchTextChanged:(NSString*)searchText;

@end

@interface GMRSearchView : UIView <UITextFieldDelegate>
{
    IBOutlet UIImageView * movieImage;
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
    
}


@property (nonatomic,strong) IBOutlet UIButton * cancelButton;
@property (nonatomic,strong) IBOutlet UITextField * searchTextField;
@property (nonatomic, weak) id<HeaderSearchViewDelegate> delegate;

-(void)setViews;
@end
