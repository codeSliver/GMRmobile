//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRUserProfileViewController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"
#import "GMRCollapsableTableViewController.h"

@interface GMRUserProfileViewController ()

@end

@implementation GMRUserProfileViewController

@synthesize backButtonType = _backButtonType;
@synthesize userID = _userID;

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
    [navigationLabel setText:@"Profile"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;
    
    if (!_backButtonType)
        [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    else
        [self.centerNavigationController changeBackButton:_backButtonType];

    UIButton * homeButton = [self.centerNavigationController changeRightButton:@"home-icon.png"];
    [homeButton addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
 //   reviewTableView.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
    [reviewTableView setBounces:NO];
    
    if (IS_IOS7)
        [reviewTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [reviewTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self setLabels];
    
    reviewTableView.delegate = self;
    reviewTableView.dataSource = self;

    [self performSelector:@selector(setUpComments) withObject:self afterDelay:0.2f];
    userFavArray = [[NSMutableArray alloc] init];}


-(void)homePressed:(id)sender
{
    [self.centerNavigationController goHome];
}

-(void)setLabels
{
    userNameLabel = [[UILabel alloc] initWithFrame:userNameView.frame];
    userNameLabel.text = @"";
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:30.0];
    [userNameView.superview addSubview:userNameLabel];
    
    userAddressLabel = [[UILabel alloc] initWithFrame:userAddressView.frame];
    userAddressLabel.text = @"";
    userAddressLabel.textColor = [UIColor whiteColor];
    userAddressLabel.textAlignment = NSTextAlignmentCenter;
    userAddressLabel.backgroundColor = [UIColor clearColor];
    userAddressLabel.font = [UIFont fontWithName:@"Lato-Light" size:18.0];
    [userAddressView.superview addSubview:userAddressLabel];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_backButtonType)
        [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    else
        [self.centerNavigationController changeBackButton:_backButtonType];
    UIButton * homeButton = [self.centerNavigationController changeRightButton:@"home-icon.png"];
    [homeButton addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.hidesBackButton = TRUE;
}

-(void)setUpComments
{
    userFavArray = [[GMRCoreDataModelManager sharedManager] getMoviesUserRated:self.userID];
    [reviewTableView reloadData];
}

-(void)setUserID:(int)userID
{
    _userID = userID;
    [self performSelector:@selector(loadUser) withObject:self afterDelay:0.2f];

}

-(void)loadUser
{
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:self.userID];
    
    if (!userInfo)
    {
        [self.centerNavigationController drawerButtonPressed:nil];
    }
    
    NSString * userImageURL = @"";
    NSString * userAddressString = @"";
    if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"facebook"])
    {
        NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        if (fbUserInfo)
        {
            firstName = [NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"user_complete_name"]];;
            userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
            userAddressString = [NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"location"]];;
        }
    }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]] isEqualToString:@"manual"])
    {
        NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userInfo objectForKey:@"login_type_id"] intValue]];
        if (loginUserInfo)
        {
            firstName = [NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"user_complete_name"]];;
            userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
            userAddressString = [NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"location"]];;
        }
    }
    
    [userNameLabel setText:firstName];
    [userAddressLabel setText:userAddressString];
    
    userImage = [[UIImageView alloc] initWithFrame:userImageView.frame];
    
    CALayer * l = [userImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:68.0];
    
    // You can even add a border
    [l setBorderWidth:4.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [userImageView.superview addSubview:userImage];
    [userImage setUserInteractionEnabled:NO];
    [userImage setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    if ([firstName length]>0)
    {
        NSArray * nameList = [firstName componentsSeparatedByString:@" "];
        if ([nameList count]>0)
            firstName = [NSString stringWithFormat:@"%@",[nameList objectAtIndex:0]];
    }
    
    NSString * headerMessage = [NSString stringWithFormat:@"%@ loves these movies",firstName];
    
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"Lato-Bold" size:12.0];
    UIFont *regularFont = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldItalicFont, NSFontAttributeName, nil];
    
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, nil];
    const NSRange range = NSMakeRange(0,[firstName length]);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:headerMessage
                                           attributes:subAttrs];
    [attributedText setAttributes:attrs range:range];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 300, 15)];
    [titleLabel setAttributedText:attributedText];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:titleLabel];
    
    isFriend = NO;
    
    for (NSDictionary * userAccount in [GMRAppState sharedState].userFriendsAccountData)
    {
        int userId = [[userAccount objectForKey:@"login_id"] intValue];
        
        if ((userId == self.userID)&&(userId != [GMRAppState sharedState].userAccountInfo.login_id))
        {
            isFriend = YES;
            break;
        }
    }
    
    if (isFriend)
    {
        NSString * accountIDString = [NSString stringWithFormat:@"%i",self.userID];
        BOOL isFavorite = [[GMRAppState sharedState].favouriteContacts containsObject:accountIDString];
        if (isFavorite)
        {
            [favButton setSelected:YES];
        }
        [favButton setHidden:NO];
        [settingsButton setHidden:NO];
        [deleteButton setHidden:NO];

    }else
    {
            }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"GMRMovieLikeCell"];
    
    GMRMovieLikeCell * cell = (GMRMovieLikeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GMRMovieLikeCell class]])
                
                cell = (GMRMovieLikeCell *)oneObject;
        
        [cell setViews];
    }
    
    NSDictionary * movieInfo = [userFavArray objectAtIndex:indexPath.row];
    [cell setMovieRateInfo:movieInfo];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (headerView)
        return headerView;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:174.0/255.0 blue:52.0/255.0 alpha:1.0f]];
    
       return headerView;
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
    return [userFavArray count];
}

-(IBAction)favouritePressed:(id)sender
{
    if (![favButton isSelected])
    {
        [favButton setSelected:YES];
        [[GMRAppState sharedState].favouriteContacts addObject:[NSString stringWithFormat:@"%i",self.userID]];
        
    }else
    {
        [favButton setSelected:NO];
        [[GMRAppState sharedState].favouriteContacts removeObject:[NSString stringWithFormat:@"%i",self.userID]];
        
    }
    [[GMRAppState sharedState] updateUserContactsInfo];
}

-(IBAction)settingsPressed:(id)sender
{

}

-(IBAction)deletePressed:(id)sender
{
    for (NSDictionary * userAccount in [GMRAppState sharedState].userFriendsAccountData)
    {
        int login_id = [[userAccount objectForKey:@"login_id"] intValue];
        
        if (self.userID == login_id)
        {
            [[GMRAppState sharedState].userFriendsAccountData removeObject:userAccount];
            break;
        }
    }
    if ([favButton isSelected])
    {
        [[GMRAppState sharedState].favouriteContacts removeObject:[NSString stringWithFormat:@"%i",self.userID]];
    }
    [[GMRAppState sharedState] updateUserContactsInfo];
    isFriend = NO;
    [favButton setHidden:YES];
    [settingsButton setHidden:YES];
    [deleteButton setHidden:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * movieInfo = [userFavArray objectAtIndex:indexPath.row];

    GMRCollapsableTableViewController *  reviewController ;
    reviewController= [[GMRCollapsableTableViewController alloc] initWithNibName:@"GMRCollapsableTableViewController" bundle:nil];
    [reviewController setMovieID:[[movieInfo objectForKey:@"movie_id"] intValue]];
    reviewController.centerNavigationController = self.centerNavigationController;
    [self.centerNavigationController pushViewController:reviewController animated:YES];
}



@end
