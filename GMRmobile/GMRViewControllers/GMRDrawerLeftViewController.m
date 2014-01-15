// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "GMRDrawerLeftViewController.h"
#import "GMRWallFeedViewController.h"
#import "GMRDrawerTableViewCell.h"
#import "GMRDrawerSectionHeaderView.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRLogInViewController.h"
#import "GMRAppDelegate.h"
#import "GMRCollapsableTableViewController.h"
#import "GMRWriteReviewViewController.h"
#import "GMRRateMovieController.h"
#import "GMRContactsViewController.h"
#import "GMRUserHistoryController.h"
#import "GMRUserProfileViewController.h"
#import "GMRSuggestMovieController.h"
#import "GMRRequestMovieController.h"
#import "GMRRecommendationsAdminController.h"
#import "GMRAppState.h"
#import "GMRNewsFeedController.h"
#import "GMRRequestedMoviesController.h"
#import "GMRSettingsViewController.h"
#import "GMRMovieChartsController.h"

@interface GMRDrawerLeftViewController ()

@end

@implementation GMRDrawerLeftViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
    
//    NSLog(@"Left will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect frame ;
    if ([GMRAppState sharedState].IS_IPHONE_5)
        frame = CGRectMake(0, 0, 320, 548);
    else
        frame = CGRectMake(0, 0, 320, 450);
    _tableView.frame = frame;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSLog(@"Left will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    NSLog(@"Left did disappear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeSectionsData];
    if (OSVersionIsAtLeastiOS7()) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    CGRect frame ;
    if ([GMRAppState sharedState].IS_IPHONE_5)
        frame = CGRectMake(0, 0, 320, 568);
    else
        frame = CGRectMake(0, 0, 320, 450);
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    if (IS_IOS7)
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0f]];
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.bounces = NO;
    [self.view setBackgroundColor:[UIColor colorWithRed:44.0f/255.0
                                                  green:44.0f/255.0
                                                   blue:44.0f/255.0
                                                  alpha:1.0]];
    
    
    UIColor * barColor = [UIColor colorWithRed:161.0/255.0
                                         green:164.0/255.0
                                          blue:166.0/255.0
                                         alpha:1.0];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    [self.navigationController.navigationBar setHidden:YES];
    
    
    NSDictionary *navBarTitleDict;
    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
                                           green:70.0/255.0
                                            blue:77.0/255.0
                                           alpha:1.0];
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
//    [self.view setBackgroundColor:[UIColor clearColor]];
}


-(void)initializeSectionsData
{
    sectionItemsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary * section1 = [[NSMutableDictionary alloc] init];
    [section1 setObject:@"ACCOUNT" forKey:@"name"];
    NSArray * section1Array = [[NSArray alloc] initWithObjects:@"Profile",@"NewsFeed", @"Settings", nil];
    NSArray * section1ArrayImages = [[NSArray alloc] initWithObjects:@"Profile",@"newsfeed_logo.png", @"settings_logo.png", nil];
    [section1 setObject:section1Array forKey:@"ItemsName"];
    [section1 setObject:section1ArrayImages forKey:@"ItemsImages"];
    [sectionItemsArray addObject:section1];
    
    NSMutableDictionary * section2 = [[NSMutableDictionary alloc] init];
    [section2 setObject:@"CREATE" forKey:@"name"];
    NSArray * section2Array = [[NSArray alloc] initWithObjects:@"Write review",@"Rate movie", @"History", nil];
    NSArray * section2ArrayImages = [[NSArray alloc] initWithObjects:@"review_logo.png",@"ratemovie_logo.png", @"history_logo.png", nil];
    [section2 setObject:section2Array forKey:@"ItemsName"];
    [section2 setObject:section2ArrayImages forKey:@"ItemsImages"];
    [sectionItemsArray addObject:section2];
    
    NSMutableDictionary * section3 = [[NSMutableDictionary alloc] init];
    [section3 setObject:@"CONTACTS" forKey:@"name"];
    NSArray * section3Array = [[NSArray alloc] initWithObjects:@"My Friends",@"Suggest movie",@"Request movie",@"Suggested movie", @"Search for Friends", nil];
    NSArray * section3ArrayImages = [[NSArray alloc] initWithObjects:@"my_friends.png",@"request_movie.png",@"request_movie.png",@"request_movie.png", @"history_logo.png", nil];
    [section3 setObject:section3Array forKey:@"ItemsName"];
    [section3 setObject:section3ArrayImages forKey:@"ItemsImages"];
    [sectionItemsArray addObject:section3];
    
    NSMutableDictionary * section4 = [[NSMutableDictionary alloc] init];
    [section4 setObject:@"MOVIES" forKey:@"name"];
    NSArray * section4Array = [[NSArray alloc] initWithObjects:@"My Movies",@"Charts", nil];
    NSArray * section4ArrayImages = [[NSArray alloc] initWithObjects:@"my_movies_logo.png",@"charts_logo.png", nil];
    [section4 setObject:section4Array forKey:@"ItemsName"];
    [section4 setObject:section4ArrayImages forKey:@"ItemsImages"];
    [sectionItemsArray addObject:section4];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionItemsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * sectionInfo = [sectionItemsArray objectAtIndex:section];
    
    NSArray * itemsArray = [sectionInfo objectForKey:@"ItemsName"];
    
    return [itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell =nil;
    if ((indexPath.section == 0) &&(indexPath.row == 0))
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRDrawerTableViewProfileCell"];
        
        cell = (GMRDrawerTableViewProfileCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRDrawerTableViewProfileCell class]])
                    
                    cell = (GMRDrawerTableViewProfileCell *)oneObject;
            
            [(GMRDrawerTableViewProfileCell*)cell setLabels];
        }

        ((GMRDrawerTableViewProfileCell*)cell).customTitleLabel.text = [[GMRAppState sharedState] getUserName];
        [GMRAppState sharedState].profileCell = (GMRDrawerTableViewProfileCell*)cell;
        [self performSelector:@selector(setProfileImageForCell) withObject:self afterDelay:2.0f];
        
        [[GMRAppState sharedState].profileCell.logoutButton addTarget:self action:@selector(promptLogout) forControlEvents:UIControlEventTouchUpInside];

    }else
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRDrawerTableViewCell"];
        
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRDrawerTableViewCell class]])
                    
                    cell = (GMRDrawerTableViewCell *)oneObject;
            
            [(GMRDrawerTableViewCell*)cell setLabels];
        

        NSDictionary * sectionInfo = [sectionItemsArray objectAtIndex:indexPath.section];
    
        NSArray * itemsArray = [sectionInfo objectForKey:@"ItemsName"];
        NSArray * itemsArrayImages = [sectionInfo objectForKey:@"ItemsImages"];

        NSString * titleText = [NSString stringWithFormat:@"%@",[itemsArray objectAtIndex:indexPath.row]];
        ((GMRDrawerTableViewCell *)cell).customTitleLabel.text = titleText;
        [((GMRDrawerTableViewCell *)cell) setLogoImage:[NSString stringWithFormat:@"%@",[itemsArrayImages objectAtIndex:indexPath.row]]];
        ((GMRDrawerTableViewCell *)cell).logoView.tag =2;
        
        if ([titleText isEqualToString:@"Request movie"])
        {
            ((GMRDrawerTableViewCell*)cell).delegate = self;
            [((GMRDrawerTableViewCell *)cell) showAlert];
            [GMRAppState sharedState].alertViewCell = ((GMRDrawerTableViewCell *)cell);
        }
    }
    //[cell.textLabel setText:[self.menuArray objectAtIndex:indexPath.row]];
    /*cell.textLabel.textColor = [UIColor colorWithRed:255.0/255.0
                                               green:255.0/255.0
                                                blue:255.0/255.0
                                               alpha:1.0];*/

    return cell;
}

-(void)promptLogout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"You want to logout!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    alert.tag = 100;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView.tag == 100)
    {
        if ([title isEqualToString:@"OK"])
        {
            [self logoutUser];
        }
    }
}
-(void)logoutUser
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:GMR_USER_LOGIN_TYPE];
    [defaults setValue:nil forKey:GMR_USER_LOGIN_ACCOUNT];
    [defaults setValue:nil forKey:GMR_USER_LOGIN_MN];
    [defaults setValue:nil forKey:GMR_USER_LOGIN_FB];
    [defaults setValue:nil forKey:GMR_USER_LOGIN_FB_DATA];
    [defaults setBool:NO forKey:GMR_IS_USER_LOGGEDIN];
    [defaults synchronize];
    
    [GMRAppState sharedState].userContactsAccountData = nil;
    [GMRAppState sharedState].userFriendsAccountData = nil;
    [GMRAppState sharedState].alertViewCell = nil;
    [GMRAppState sharedState].userContactsFBData = nil;
    [GMRAppState sharedState].userContactsInfo = nil;
    [GMRAppState sharedState].userContactsLoginData = nil;
    [GMRAppState sharedState].userFBLoginInfo = nil;
    [GMRAppState sharedState].userLoginType = -1;
    [GMRAppState sharedState].userMNLoginInfo = nil;
    [GMRAppState sharedState].loggedInFBUser = nil;
    [GMRAppState sharedState].FBUserDictionary = nil;
    [GMRAppState sharedState].favouriteContacts = nil;
    [GMRAppState sharedState].movieRequestsToUser = nil;
    [GMRAppState sharedState].movieSuggestedToUser = nil;
    [GMRAppState sharedState].profileCell = nil;
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    GMRLogInViewController *loginVc;
    
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
-(void)setProfileImageForCell
{
    [[GMRAppState sharedState].profileCell setLogoImage:[[GMRAppState sharedState] getUserImage] andPlaceholder:@"people.png"];

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    NSDictionary * sectionInfo = [sectionItemsArray objectAtIndex:section];
    
    NSString * sectionName = [NSString stringWithFormat:@"%@",[sectionInfo objectForKey:@"name"]];

    GMRDrawerSectionHeaderView * headerView;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GMRDrawerSectionHeaderView" owner:self options:nil];
    headerView = (GMRDrawerSectionHeaderView*)[nib objectAtIndex:0];
    [headerView initializeViews];
    [headerView setTitle:sectionName];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}


#pragma mark - Table view delegate
-(GMRBaseViewController*)getViewControllerForIndexPath:(NSIndexPath*)indexPath{
   GMRBaseViewController *rootViewController = nil;
    
    if (indexPath.section ==0)
    {
        int row = indexPath.row;
        
    switch (row) {
        case 0:{//home
            GMRWallFeedViewController *home = [[GMRWallFeedViewController alloc] init];
            rootViewController = home;
        }
            break;
        case 1:{
            GMRNewsFeedController *cVC = [[GMRNewsFeedController alloc] initWithNibName:@"GMRNewsFeedController" bundle:nil];
            rootViewController = cVC;
        }
            break;
        case 2:{
            GMRSettingsViewController *cVC;
            if ([GMRAppState sharedState].IS_IPHONE_5)
                cVC = [[GMRSettingsViewController alloc] initWithNibName:@"GMRSettingsViewController_iPhone5" bundle:nil];
            else
                cVC = [[GMRSettingsViewController alloc] initWithNibName:@"GMRSettingsViewController" bundle:nil];
            
            rootViewController = cVC;
        }
            break;

    }
    }else if (indexPath.section == 1)
    {
        int row = indexPath.row;
        switch (row) {
            case 0:{
                GMRWriteReviewViewController *cVC;
                if ([GMRAppState sharedState].IS_IPHONE_5)
                    cVC = [[GMRWriteReviewViewController alloc] initWithNibName:@"GMRWriteReviewViewController" bundle:nil];
                else
                    cVC = [[GMRWriteReviewViewController alloc] initWithNibName:@"GMRWriteReviewViewController_iPhone4" bundle:nil];
                
                rootViewController = cVC;
            }
            break;
            case 1:{
                GMRRateMovieController *cVC;
                if ([GMRAppState sharedState].IS_IPHONE_5)
                    cVC = [[GMRRateMovieController alloc] initWithNibName:@"GMRRateMovieController" bundle:nil];
                else
                    cVC = [[GMRRateMovieController alloc] initWithNibName:@"GMRRateMovieController_iPhone4" bundle:nil];
                
                rootViewController = cVC;
            }
                break;
            case 2:{//home
                GMRUserHistoryController *historyController = [[GMRUserHistoryController alloc] initWithNibName:@"GMRUserHistoryController" bundle:nil];
                rootViewController = historyController;
            }
                break;

        
    }
    }else if (indexPath.section == 2)
    {
        int row = indexPath.row;
        switch (row) {
            case 0:{
                GMRContactsViewController *cVC = [[GMRContactsViewController alloc] initWithNibName:@"GMRContactsViewController" bundle:nil];
                [cVC enableTab:1];
                rootViewController = cVC;
            }
                break;
            case 1:{//home
                GMRSuggestMovieController *cVC = [[GMRSuggestMovieController alloc] initWithNibName:@"GMRSuggestMovieController" bundle:nil];
                rootViewController = cVC;
            }
                break;
            case 2:{//home
                GMRRequestMovieController *cVC = [[GMRRequestMovieController alloc] initWithNibName:@"GMRRequestMovieController" bundle:nil];
                rootViewController = cVC;
            }
                break;
            case 3:
            {
                GMRRecommendationsAdminController *cVC = [[GMRRecommendationsAdminController alloc] initWithNibName:@"GMRRecommendationsAdminController" bundle:nil];
                rootViewController = cVC;
            }
                break;
            case 4:{//home
                GMRContactsViewController *cVC = [[GMRContactsViewController alloc] initWithNibName:@"GMRContactsViewController" bundle:nil];
                [cVC enableTab:3];
                rootViewController = cVC;
            }
                break;
                
                
        }
    }else if (indexPath.section == 3)
    {
        int row = indexPath.row;
        switch (row) {
            case 0:{
                GMRUserProfileViewController *  cVC ;
                if ([GMRAppState sharedState].IS_IPHONE_5)
                {
                    cVC= [[GMRUserProfileViewController alloc] initWithNibName:@"GMRUserProfileViewController" bundle:nil];
                }else
                {
                    cVC= [[GMRUserProfileViewController alloc] initWithNibName:@"GMRUserProfileViewController_iPhone4" bundle:nil];
                }
                cVC.userID = [GMRAppState sharedState].userAccountInfo.login_id;
                cVC.backButtonType = [NSString stringWithFormat:@"side_menu_button.png"];
                
                rootViewController = cVC;
            }
                break;
            case 1:{//home
                GMRMovieChartsController *cVC = [[GMRMovieChartsController alloc] initWithNibName:@"GMRMovieChartsController" bundle:nil];
                rootViewController = cVC;
            }
                break;
    }
    }
    return rootViewController;
}

-(BOOL)shouldReplaceRootViewControllerForIndexPath:(NSIndexPath*)indexPath{
    
    GMRCenterNavigationControllerViewController *centerNav = (GMRCenterNavigationControllerViewController*) self.gmr_drawerController.centerViewController;
    
    if (centerNav && [centerNav isKindOfClass:[UINavigationController class]]) {
        
        if (indexPath.section ==0)
        {
            
            if (indexPath.row == 0)
            {
            if (centerNav.viewControllers.count)
                {
                    if (![centerNav.topViewController isMemberOfClass:[GMRWallFeedViewController class]]) {
                        return YES;
                    }
                }
            }else if (indexPath.row == 1)
            {
                if (centerNav.viewControllers.count)
                {
                    if (![centerNav.topViewController isMemberOfClass:[GMRNewsFeedController class]]) {
                        return YES;
                    }
                }
            }else if (indexPath.row == 2)
            {
                if (centerNav.viewControllers.count)
                {
                    if (![centerNav.topViewController isMemberOfClass:[GMRSettingsViewController class]]) {
                        return YES;
                    }
                }
            }
            
        }else if (indexPath.section == 1)
        {
            int row = indexPath.row;
            
            switch (row) {
                case 0:
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRWriteReviewViewController class]]) {
                            return YES;
                        }
                    }
                    break;
                case 1:
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRRateMovieController class]]) {
                            return YES;
                        }
                    }
                    break;

                case 2:{
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRUserHistoryController class]]) {
                            return YES;
                        }
                    }
                }
                    break;
        }
        
        }else if (indexPath.section == 2)
        {
            int row = indexPath.row;
            
            switch (row) {
                case 0:
                    if (centerNav.viewControllers.count)
                    {
                            return YES;
                        
                    }
                    break;
                case 1:
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRSuggestMovieController class]]) {
                            return YES;
                        }
                    }
                    break;
                case 2:
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRRequestMovieController class]]) {
                            return YES;
                        }
                    }
                    break;
                    case 3:
                    {
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRRecommendationsAdminController class]]) {
                            return YES;
                        }
                    }

                    }
                    break;
                case 4:{
                    if (centerNav.viewControllers.count)
                    {
                            return YES;
                        
                    }
                }
                    break;
            }
            
        }else if (indexPath.section == 3)
        {
            int row = indexPath.row;
            
            switch (row) {
                case 0:
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRUserProfileViewController class]]) {
                            return YES;
                        }
                    }
                    break;
                case 1:
                    if (centerNav.viewControllers.count)
                    {
                        if (![centerNav.topViewController isMemberOfClass:[GMRMovieChartsController class]]) {
                            return YES;
                        }
                    }
                    break;
            }
    }
    }

    return false;
}

-(void)changeCenterViewControllerAsRoot:(NSIndexPath*)indexPath{
    if ([self shouldReplaceRootViewControllerForIndexPath:indexPath]) {
        GMRCenterNavigationControllerViewController *centerNav = (GMRCenterNavigationControllerViewController*) self.gmr_drawerController.centerViewController;
        GMRBaseViewController *rootViewController = [self getViewControllerForIndexPath:indexPath];
        [rootViewController setCenterNavigationController:centerNav];
        NSArray *viewController = [NSArray arrayWithObjects:rootViewController, nil];
        [centerNav setViewControllers:viewController animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GMRDrawerTableViewCell *cell = (GMRDrawerTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (prevCell)
        [prevCell setUnselected];
    
    prevCell = cell;
    [cell setSelected];

    [self changeCenterViewControllerAsRoot:indexPath];
    [self.gmr_drawerController toggleDrawerSide:GMRDrawerSideLeft animated:YES completion:nil];

}

-(void)pressHome
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    GMRDrawerTableViewCell *cell = (GMRDrawerTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (prevCell)
        [prevCell setUnselected];
    
    prevCell = cell;
    [cell setSelected];
    
    [self changeCenterViewControllerAsRoot:indexPath];
 //   [self.gmr_drawerController toggleDrawerSide:GMRDrawerSideLeft animated:NO completion:nil];
}
-(void) showStartUpPage
{
    GMRAppDelegate *delegate = (GMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showStartUpPage];
    
    /*GMRLogInViewController *svc = [[GMRLogInViewController alloc] initWithNibName:@"GMRLogInViewController" bundle:nil];
    [svc setTitle:@"GMR"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
    GMRAppDelegate *delegate= (GMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.window setRootViewController:navController];*/
}

-(void)showRequestedMoviesToUser
{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    GMRDrawerTableViewCell *cell = (GMRDrawerTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (prevCell)
        [prevCell setUnselected];
    
    prevCell = cell;
    [cell setSelected];
    
    GMRCenterNavigationControllerViewController *centerNav = (GMRCenterNavigationControllerViewController*) self.gmr_drawerController.centerViewController;
    GMRRequestedMoviesController *rootViewController = [[GMRRequestedMoviesController alloc] initWithNibName:@"GMRRequestedMoviesController" bundle:nil];
    [rootViewController setCenterNavigationController:centerNav];
    NSArray *viewController = [NSArray arrayWithObjects:rootViewController, nil];
    [centerNav setViewControllers:viewController animated:YES];
    
    [self.gmr_drawerController toggleDrawerSide:GMRDrawerSideLeft animated:YES completion:nil];


}
@end
