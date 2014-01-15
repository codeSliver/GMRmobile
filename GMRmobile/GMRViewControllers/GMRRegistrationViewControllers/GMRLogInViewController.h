//
//  GMRLogInViewController.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 02/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRBaseViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface GMRLogInViewController : GMRBaseViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,FBLoginViewDelegate>
{
    BOOL isScrolledUP;
    
    IBOutlet UIView * loginConnectLabelView;
    UILabel * loginConnectLabel;
    
    IBOutlet UIView * loginConnectGMRLabelView;
    UILabel * loginConnectGMRLabel;
    
    IBOutlet UIView * registerLabelView;
    UILabel * registerGMRLabel;
    
    IBOutlet UIButton * facebookButton;
    FBLoginView * loginView;
}

@property (nonatomic,strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic,strong) IBOutlet UIImageView *orLineImageView;

@property (nonatomic,strong) IBOutlet UITextField *usernameField;
@property (nonatomic,strong) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) FBRequestConnection *requestConnection;


@end
