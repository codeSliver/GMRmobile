//
//  GMRCenterNavigationControllerViewController.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 02/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRNavigationController.h"
#import "GMRSearchView.h"
#import "MBProgressHUD.h"

@interface GMRCenterNavigationControllerViewController : GMRNavigationController <HeaderSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    NSMutableArray * searchAutoCompleteArray;
    NSArray * searchMovieData;
    
    NSDate * textChangingDate;
    MBProgressHUD * HUD;
    NSString * searchString;
}
-(id)initWithRootViewController:(UIViewController *)rootViewController;
-(void)initialize;
-(UIButton*)changeBackButton:(NSString*)buttonImage;
-(UIButton*)changeRightButton:(NSString*)buttonImage;
-(void)drawerButtonPressed:(id)sender;
@property (nonatomic,strong) UIButton * searchButton;
@property (nonatomic,strong) GMRSearchView * searchView;
@property (nonatomic,strong) UITableView * searchTableView;
-(void)addSearchButton;
-(void)goHome;
-(void)goBack;
@end
