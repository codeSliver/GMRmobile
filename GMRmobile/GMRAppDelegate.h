//
//  GMRAppDelegate.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 02/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRDrawerController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"

@interface GMRAppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD * HUD;
    BOOL isFBLogin;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) GMRDrawerController * drawerController;


-(void) showHomeScreen;
-(void) showStartUpPage;
-(void)hideAlertView;
@end
