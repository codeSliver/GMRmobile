//
//  GMRAppDelegate.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 02/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRAppDelegate.h"
#import "GMRLogInViewController.h"
#import "GMRWallFeedViewController.h"
#import "GMRDrawerLeftViewController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRDrawerSharedStateManager.h"
#import "GMRAppState.h"
#import "NSString+SBJSON.h"
#import "GMRCoreDataModelManager.h"
#import "GMRWallFeedViewController.h"

@implementation GMRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [[GMRCoreDataModelManager sharedManager] getAllAppData:nil];
    
    isFBLogin = NO;
    if (![GMRAppState sharedState].userLoginType)
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [GMRAppState sharedState].userLoginType = [defaults integerForKey:GMR_USER_LOGIN_TYPE];
        switch ([GMRAppState sharedState].userLoginType) {
            case USER_LOGIN_MANUAL:
            {
                MBProgressHUD * hud =[[GMRAppState sharedState] showGlobalProgressHUDWithTitle:@"Loading User Information"];
                [hud showAnimated:YES whileExecutingBlock:^{
                    NSString * userLoginJSON = [NSString stringWithFormat:@"%@",[defaults objectForKey:GMR_USER_LOGIN_MN]];
                    NSArray * userLoginArray = [userLoginJSON JSONValue];
                    NSDictionary * userLoginDict = [userLoginArray objectAtIndex:0];
                    UserLoginInfoObject * loginUser = [[UserLoginInfoObject alloc] init];
                    loginUser.user_complete_name = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_complete_name"]];
                    loginUser.user_email = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_email"]];
                    loginUser.user_name = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_name"]];
                    loginUser.location = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"location"]];
                    loginUser.user_password = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_password"]];
                    loginUser.login_id = [[userLoginDict objectForKey:@"login_id"] integerValue];
                    loginUser.user_cover_photo = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_cover_photo"]];
                    loginUser.user_image_url = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_image_url"]];
                    
                    [GMRAppState sharedState].userMNLoginInfo = loginUser;
                    
                    UserAccountObject * accountUser =  [[GMRCoreDataModelManager sharedManager] getUserAccountForID:loginUser.login_id andType:@"manual"];
                    
                    if (!accountUser)
                    {
                        UserAccountObject * userAccount = [[UserAccountObject alloc] init];
                        userAccount.login_type =[NSString stringWithFormat:@"manual"];
                        userAccount.login_type_id = loginUser.login_id;
                        
                        NSString * userAccountJSON = [userAccount ToJSON];
                        NSString * userAccountResponseString = [[GMRCoreDataModelManager sharedManager] registerUserViaLogin:userAccountJSON];
                        if (userAccountResponseString)
                        {
                            NSDictionary * respDict1 = [userAccountResponseString JSONValue];
                            NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict1 objectForKey:@"response"]];
                            if ([respString1 isEqualToString:@"success"])
                            {
                                userAccount.login_id = [[respDict1 objectForKey:@"login_id"] intValue];
                                [GMRAppState sharedState].userAccountInfo = userAccount;
                                [[GMRAppState sharedState] loadHistoryForUser:accountUser.login_id];
                                [[GMRAppState sharedState] loadRecommendationsForUser:accountUser.login_id];
                                userAccountJSON = [userAccount ToJSON];
                                [defaults setObject:userAccountJSON forKey:GMR_USER_LOGIN_ACCOUNT];
                                
                            }
                        }
                    }else
                    {
                        [GMRAppState sharedState].userAccountInfo = accountUser;
                        [[GMRAppState sharedState] loadHistoryForUser:accountUser.login_id];
                        [[GMRAppState sharedState] loadRecommendationsForUser:accountUser.login_id];
                        NSString * userAccountJSON = [accountUser ToJSON];
                        [defaults setObject:userAccountJSON forKey:GMR_USER_LOGIN_ACCOUNT];
                    }
                    [defaults synchronize];

                } completionBlock:^{
                    [self showHomeScreen];
                    [[GMRAppState sharedState] dismissGlobalHUD];
                }];

                            }
                break;
            case USER_LOGIN_FB:
            {
                isFBLogin = YES;
 //               [HUD show:YES];
            }
   
            default:
                break;
        }
        
    }

    if (([[NSUserDefaults standardUserDefaults] boolForKey:GMR_IS_USER_LOGGEDIN]) && (!isFBLogin)) {
//        [self showHomeScreen];
    }else{
        [self showStartUpPage];
    }

       //[self.window addSubview:navController.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)showStartUpPage
{
    GMRLogInViewController *loginVc;
    NSLog(@"%0.2f",[[UIScreen mainScreen] bounds].size.height);
    if ([GMRAppState sharedState].IS_IPHONE_5)
    {
        loginVc = [[GMRLogInViewController alloc] initWithNibName:@"GMRLogInViewController_iPhone5" bundle:nil];
    }else
    {
        loginVc = [[GMRLogInViewController alloc] initWithNibName:@"GMRLogInViewController" bundle:nil];
    }
    [loginVc setTitle:@"GMR"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVc];
    GMRAppDelegate *delegate= (GMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.window setRootViewController:navController];
    
    
    

}

-(void)hideAlertView
{
    [HUD hide:YES];
}
-(void) showHomeScreen
{
    [[GMRAppState sharedState] loadUserContacts];
    [HUD hide:YES];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GMR_IS_USER_LOGGEDIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
        /**
     *  Lets setup DKDrawer Controller.We will provide left and center view controllers.In iOS >=7.0 left controller will have its own navigation stack.For now we might not need it as a navigation controller but we may need it in the future
     */
    GMRDrawerLeftViewController *leftSideDrawerViewController = [[GMRDrawerLeftViewController alloc] init];
    [GMRAppState sharedState].sideController = leftSideDrawerViewController;
    GMRWallFeedViewController *centerViewController = [[GMRWallFeedViewController alloc] init];
    
    GMRCenterNavigationControllerViewController *navigationController = [[GMRCenterNavigationControllerViewController alloc] initWithRootViewController:centerViewController];
    [navigationController initialize];
    
    centerViewController.centerNavigationController = navigationController;
    leftSideDrawerViewController.centerNavigationController = navigationController;
    
    self.drawerController = [[GMRDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideDrawerViewController
                             rightDrawerViewController:nil];
    
    [self.drawerController setShowsStatusBarBackgroundView:YES];
    [self.drawerController setStatusBarViewBackgroundColor:[UIColor clearColor]];
    [self.drawerController setShowsShadow:NO];
    
    //Set Left Drawer's animation type as slide
    [[GMRDrawerSharedStateManager sharedManager] setLeftDrawerAnimationType:GMRDrawerAnimationTypeSlide];
    
    [self.drawerController setMaximumLeftDrawerWidth:leftSideDrawerViewController.view.bounds.size.width * 0.82];
    [self.drawerController setOpenDrawerGestureModeMask:GMROpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:GMRCloseDrawerGestureModeAll];
    
    /**
     *  Provide a block for drawers visual state changes i.e opening and closing.DKDrawerSharedStateManager chooses between various available animation blocks depending upon current configured properties of the drawer controller
     *
     *  @param drawerController drawer controller
     *  @param drawerSide       which side is going to change state.See the enum DKDrawerSide
     *  @param percentVisible   this factor decides the visibilty of the drawer
     *
     *  @return provide a handler for visual state update for drawer controller.
     */
    [self.drawerController setDrawerVisualStateBlock:^(GMRDrawerController *gmrDrawerController, GMRDrawerSide drawerSide, CGFloat percentVisible) {
        GMRDrawerControllerDrawerVisualStateBlock block;
        block = [[GMRDrawerSharedStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block){
            block(gmrDrawerController, drawerSide, percentVisible);
        }
    }];
    
    /**
     *  Configure window and set drawer as its root view controller
     */
    [self.window setRootViewController:self.drawerController];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

@end
