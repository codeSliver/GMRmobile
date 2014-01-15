//
//  GMRRegistraionViewController.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRBaseViewController.h"
#import "SSTextField.h"
#import <FacebookSDK/FacebookSDK.h>

@interface GMRRegistraionViewController : GMRBaseViewController<UITextFieldDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIImageView *topBackgroundImgView;
    IBOutlet UIImageView *photoImgView;
    
    IBOutlet UIView * nameFieldView;
    SSTextField * nameField;
    
    IBOutlet UIView * locationFieldView;
    SSTextField * locationField;

    IBOutlet UIView * userNameFieldView;
    SSTextField * usernameField;
    
    IBOutlet UIView * passwordFieldView;
    SSTextField * passwordField;
    
    IBOutlet UIView * emailFieldView;
    SSTextField * emailField;
    
    BOOL isScrolledUP;
    
    UIImage * userImage;
    
    IBOutlet UIView * userImageView;
    NSArray * citiesArray;
    NSMutableArray * searchCitiesArray;
    
    
}


-(IBAction)backButtonPressed:(id)sender;
-(IBAction)imageSelectPressed:(id)sender;
@property (nonatomic,strong) UITableView * locationTableView;
@end
