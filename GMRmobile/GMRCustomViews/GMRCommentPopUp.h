//
//  GMRHomeCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//


@interface GMRCommentPopUp : UIView <UITextViewDelegate>
{
    
}


@property (nonatomic,strong) IBOutlet UIButton * cancelButton;
@property (nonatomic,strong) IBOutlet UITextView * commentTextView;
@property (nonatomic,assign) UIViewController * parent;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)sendPressed:(id)sender;
-(void)initialize;

@end
