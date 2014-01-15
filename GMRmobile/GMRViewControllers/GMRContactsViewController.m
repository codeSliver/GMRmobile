//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRContactsViewController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRContactsCell.h"
#import "GMRSearchContactsCell.h"
#import "GMRAppState.h"
#import "GMRRequestMovieController.h"
#import "GMRSuggestMovieController.h"
#import "GMRUserProfileViewController.h"

@interface GMRContactsViewController ()

@end

@implementation GMRContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel * navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [navigationLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0f]];
    [navigationLabel setText:@"Contacts"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;
    
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];

    favoritesArray = [[NSMutableArray alloc] init];
    [self setUpContactsData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD hide:YES];
    
    allTableView.delegate = self;
    allTableView.dataSource = self;
    if (IS_IOS7)
        [allTableView setSeparatorInset:UIEdgeInsetsZero];
    [allTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    favoritesTableView.delegate = self;
    favoritesTableView.dataSource = self;
    if (IS_IOS7)
        [favoritesTableView setSeparatorInset:UIEdgeInsetsZero];
    [favoritesTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];

    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    if (IS_IOS7)
        [searchTableView setSeparatorInset:UIEdgeInsetsZero];
    [searchTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];

    searchAutoCompleteArray = [[NSMutableArray alloc] init];
    
    searchField.delegate =self;
    
    prevTab = 1;
    [allButton setSelected:YES];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
    [allTableView reloadData];
    [favoritesTableView reloadData];


}

-(void)enableTab:(int)_tabToEnable
{
    if (prevTab == _tabToEnable)
        return;
    tabToEnable = _tabToEnable;
    [self performSelector:@selector(enableSegment) withObject:self afterDelay:0.2f];
    
}

-(void)enableSegment
{
    switch (tabToEnable) {
        case 1:
            [self toggleButtonPressed:allButton];
            break;
        case 2:
            [self toggleButtonPressed:favoritesButton];
            break;
        case 3:
            [self toggleButtonPressed:searchButton];
            break;
        default:
            break;
    }
}
-(void)setUpContactsData
{
    MBProgressHUD * hud =[[GMRAppState sharedState] showGlobalProgressHUDWithTitle:@"Loading Contacts Information"];
    [hud showAnimated:YES whileExecutingBlock:^{
        [[GMRAppState sharedState] loadUserContacts];
        [self loadFavoritesContacts];
        [allTableView reloadData];
        [favoritesTableView reloadData];
    } completionBlock:^{
        [[GMRAppState sharedState] dismissGlobalHUD];
    }];

    
}

-(void)loadFavoritesContacts
{
    [favoritesArray removeAllObjects];
    if (![GMRAppState sharedState].favouriteContacts)
        return;
    for (NSString * favID in [GMRAppState sharedState].favouriteContacts)
    {
        int favoriteID = [favID intValue];
        for (NSDictionary * accountDict in [GMRAppState sharedState].userFriendsAccountData)
        {
            int account_id = [[accountDict objectForKey:@"login_id"] intValue];
            
            if (favoriteID == account_id)
            {
                [favoritesArray addObject:accountDict];
                break;
            }
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((tableView.tag ==1)||(tableView.tag == 2))
        return 78;

    return 78;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell;
    if ((tableView.tag ==1)||(tableView.tag == 2))
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRContactsCell"];
        
        cell = (GMRContactsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRContactsCell class]])
                    
                    cell = (GMRContactsCell *)oneObject;
            
            [(GMRContactsCell*)cell setViews];
            ((GMRContactsCell*)cell).delegate = self;
        }
        cell.tag = tableView.tag;
        if (tableView.tag == 1)
        {
            NSDictionary * contactsInfo = [[GMRAppState sharedState].userFriendsAccountData objectAtIndex:indexPath.row];
            [(GMRContactsCell*)cell setContact:contactsInfo];
        }else if (tableView.tag == 2)
        {
            NSDictionary * contactsInfo = [favoritesArray objectAtIndex:indexPath.row];
            [(GMRContactsCell*)cell setContact:contactsInfo];
        }
        ((GMRContactsCell*)cell).userImage.tag = indexPath.row;
        [((GMRContactsCell*)cell).userImage addTarget:self action:@selector(userProfilePressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }else
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRSearchContactsCell"];
        
        cell = (GMRSearchContactsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRSearchContactsCell class]])
                    
                    cell = (GMRSearchContactsCell *)oneObject;
            
            [(GMRSearchContactsCell*)cell setViews];
            ((GMRSearchContactsCell*)cell).delegate = self;

        }
            NSDictionary * contactsInfo = [searchAutoCompleteArray objectAtIndex:indexPath.row];
            [(GMRSearchContactsCell*)cell setContact:contactsInfo];
    }
    
    return cell;
}



-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
        return [[GMRAppState sharedState].userFriendsAccountData count];
    else if (tableView.tag == 2)
        return [favoritesArray count];
    else
        return [searchAutoCompleteArray count];
}

-(IBAction)toggleButtonPressed:(id)sender
{
    UIButton * button = (UIButton*)sender;
    
    if (prevTab == button.tag)
        return;
    
    prevTab = button.tag;
    [allButton setSelected:NO];
    [favoritesButton setSelected:NO];
    [searchButton setSelected:NO];
    
    [allView setHidden:YES];
    [favoritesView setHidden:YES];
    [searchView setHidden:YES];
    
    
    switch (button.tag) {
        case 1:
            [allButton setSelected:YES];
            [allView setHidden:NO];
            [searchField resignFirstResponder];
            break;
        case 2:
            [favoritesButton setSelected:YES];
            [favoritesView setHidden:NO];
            [searchField resignFirstResponder];
            break;
        case 3:
            [searchButton setSelected:YES];
            [searchView setHidden:NO];
            break;
        default:
            break;
    }
}


-(void)userProfilePressed:(id)sender
{
    int contactID = ((UIButton*)sender).tag;
    NSDictionary * contactInfo;
    if (prevTab ==1)
    {
        contactInfo = [[GMRAppState sharedState].userFriendsAccountData objectAtIndex:contactID];
    }else if (prevTab == 2)
    {
        contactInfo = [favoritesArray objectAtIndex:contactID];
    }
    
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[contactInfo objectForKey:@"login_id"] intValue]];
    if (userInfo)
    {
        GMRUserProfileViewController *  loginVc ;
        if ([GMRAppState sharedState].IS_IPHONE_5)
        {
            loginVc= [[GMRUserProfileViewController alloc] initWithNibName:@"GMRUserProfileViewController" bundle:nil];
        }else
        {
            loginVc= [[GMRUserProfileViewController alloc] initWithNibName:@"GMRUserProfileViewController_iPhone4" bundle:nil];
        }
        loginVc.centerNavigationController = self.centerNavigationController;
        [self.centerNavigationController pushViewController:loginVc animated:YES];
        [loginVc setUserID:[[userInfo objectForKey:@"login_id"] intValue]];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (([searchString length]>0)&&([searchString length]<3))
        return YES;
    
    [searchAutoCompleteArray removeAllObjects];
    
    textChangingDate = [NSDate date];
    
    
    [self performSelector:@selector(searchContactsWithDelay) withObject:self afterDelay:2.0f];
    
    return YES;
    
}

-(void)searchContactsWithDelay
{
    if ([[NSDate date] timeIntervalSinceDate:textChangingDate]>=2.0f)
    {
        [HUD show:YES];
        [self performSelector:@selector(searchContacts) withObject:self];
    }else
    {
        [self performSelector:@selector(searchContactsWithDelay) withObject:self afterDelay:1.0f];
    }
}

-(void)searchContacts
{
    NSArray * contactsArray = [[GMRCoreDataModelManager sharedManager] getContactsForString:searchString];
    
    [HUD hide:YES];
    
    if (!contactsArray)
    {
        searchAutoCompleteArray = [[NSMutableArray alloc] init];
        [searchTableView reloadData];
        return;
    }
    
    searchAutoCompleteArray = [contactsArray mutableCopy];
    for (NSDictionary * contact in searchAutoCompleteArray)
    {
        int contactID = [[contact objectForKey:@"login_id"] intValue];
        if (contactID == [GMRAppState sharedState].userAccountInfo.login_id)
        {
            [searchAutoCompleteArray removeObject:contact];
            break;
        }
    }
    if ([searchAutoCompleteArray count]>0)
        searchTableView.hidden = NO;
    else
        searchTableView.hidden = YES;
    [searchTableView reloadData];


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)favoritePressed:(BOOL)selected
{
    [self loadFavoritesContacts];
    [favoritesTableView reloadData];
    [allTableView reloadData];
}

- (void)deletePressed:(BOOL)isFavorite
{
    if (isFavorite)
    {
        [self loadFavoritesContacts];
        [favoritesTableView reloadData];
    }
    [allTableView reloadData];
    [searchTableView reloadData];
}

-(void)addFriendPressed
{
    [allTableView reloadData];
}

-(void)suggestMovie:(int)contactID
{
    GMRSuggestMovieController *cVC = [[GMRSuggestMovieController alloc] initWithNibName:@"GMRSuggestMovieController" bundle:nil];
    cVC.centerNavigationController = self.centerNavigationController;
    cVC.backButtonType = [NSString stringWithFormat:@"back-arrow.png"];
    [self.centerNavigationController pushViewController:cVC animated:YES];
    [cVC setUser:contactID];
}

-(void)requestMovie:(int)contactID
{
    GMRRequestMovieController *cVC = [[GMRRequestMovieController alloc] initWithNibName:@"GMRRequestMovieController" bundle:nil];
    cVC.centerNavigationController = self.centerNavigationController;
    cVC.backButtonType = [NSString stringWithFormat:@"back-arrow.png"];
    [self.centerNavigationController pushViewController:cVC animated:YES];
    [cVC setUser:contactID];

}
@end
