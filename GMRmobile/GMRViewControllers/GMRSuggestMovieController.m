//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRSuggestMovieController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRRateMovieCell.h"
#import "GMRHistoryRateCell.h"
#import "GMRHistoryReviewCell.h"
#import "GMRHistoryAddFriendCell.h"
#import "GMRSuggestRequestMovieCell.h"
#import "GMRAppState.h"
#import "UserSuggestMovieObject.h"
#import "GMRAddMoreFriendsController.h"
#import "GMRSuggestRequestFriendCell.h"

@interface GMRSuggestMovieController ()

@end

@implementation GMRSuggestMovieController

@synthesize backButtonType = _backButtonType;
@synthesize requestedMovieInfo = _requestedMovieInfo;

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
    [navigationLabel setText:@"Suggest movie"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD hide:YES];
    
    
    if (IS_IOS7)
    {
        [movieTableView setSeparatorInset:UIEdgeInsetsZero];
        [userTableView setSeparatorInset:UIEdgeInsetsZero];
        [addFriendTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [movieTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [userTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [addFriendTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (!_backButtonType)
        [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    else
        [self.centerNavigationController changeBackButton:_backButtonType];
    
    [movieTableView setBounces:NO];
    [userTableView setBounces:NO];
    
    if (!suggest_movie_id)
        suggest_movie_id = -1;
    suggested_users_id = [[NSMutableArray alloc] init];
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    UIFont *regularFont = [UIFont fontWithName:@"Lato-Light" size:15.0];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldItalicFont, NSFontAttributeName, nil];
    
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, nil];
    const NSRange range = NSMakeRange(12,10);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"I'd like to suggest..."]
                                           attributes:subAttrs];
    [attributedText setAttributes:attrs range:range];
    
    
    titleLabel = [[UILabel alloc] initWithFrame:titleView.frame];
    titleLabel.attributedText = attributedText;
    titleLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleView.superview addSubview:titleLabel];
    
    toLabel = [[UILabel alloc] initWithFrame:toView.frame];
    toLabel.text = @"to...";
    toLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    toLabel.textAlignment = NSTextAlignmentCenter;
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.font = regularFont;
    [toView.superview addSubview:toLabel];
    
    movieSelectedLabel = [[UILabel alloc] initWithFrame:movieSelectedLabelView.frame];
    movieSelectedLabel.text = @"";
    movieSelectedLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    movieSelectedLabel.textAlignment = NSTextAlignmentLeft;
    movieSelectedLabel.backgroundColor = [UIColor clearColor];
    movieSelectedLabel.font = regularFont;
    [movieSelectedLabelView.superview addSubview:movieSelectedLabel];
    
    userSelectedLabel = [[UILabel alloc] initWithFrame:userSelectedLabelView.frame];
    userSelectedLabel.text = @"";
    userSelectedLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    userSelectedLabel.textAlignment = NSTextAlignmentLeft;
    userSelectedLabel.backgroundColor = [UIColor clearColor];
    userSelectedLabel.font = regularFont;
    [userSelectedLabelView.superview addSubview:userSelectedLabel];
    
    addNewFriendLabel = [[UILabel alloc] initWithFrame:addNewFriendView.frame];
    addNewFriendLabel.text = @"add more friends";
    addNewFriendLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    addNewFriendLabel.textAlignment = NSTextAlignmentLeft;
    addNewFriendLabel.backgroundColor = [UIColor clearColor];
    addNewFriendLabel.font = [UIFont fontWithName:@"Lato-Light" size:12.0f];
    [addNewFriendView.superview addSubview:addNewFriendLabel];
    [addNewFriendLabel setHidden:YES];
    
    [userSelectedImage setHidden:YES];
    roundUserSelected= [[UIImageView alloc] initWithFrame:userSelectedImage.frame];
    CALayer * l = [roundUserSelected layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    [userSelectedImage.superview addSubview:roundUserSelected];
    
    [movieSelectedImage setHidden:YES];
    roundMovieSelected= [[UIImageView alloc] initWithFrame:movieSelectedImage.frame];
    CALayer * l1 = [roundMovieSelected layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:10.0];
    
    [movieSelectedImage.superview addSubview:roundMovieSelected];
    
    [self setUpData];
    
    [userTableView.superview bringSubviewToFront:userTableView];
    [movieTableView.superview bringSubviewToFront:movieTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_backButtonType)
        [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    else
        [self.centerNavigationController changeBackButton:_backButtonType];
    

}

-(void)setUpData
{
    movieList = [[GMRCoreDataModelManager sharedManager] getMoviesWithLimit:-1 andPriority:YES];
    [[GMRAppState sharedState] loadUserContacts];
    
    addFriendList = [[NSMutableArray alloc] init];
    searchMovieList = [[NSMutableArray alloc] init];
    searchUserList = [[NSMutableArray alloc] init];
    
    movieTableView.delegate = self;
    movieTableView.dataSource = self;
    userTableView.delegate = self;
    userTableView.dataSource = self;
    addFriendTableView.delegate = self;
    addFriendTableView.dataSource = self;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 30;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView.tag == 1)||(tableView.tag == 2))
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRSuggestRequestMovieCell"];
        
        GMRSuggestRequestMovieCell* cell = (GMRSuggestRequestMovieCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRSuggestRequestMovieCell class]])
                    
                    cell = (GMRSuggestRequestMovieCell *)oneObject;
            
            [cell setViews];
        }
        
        if (tableView.tag ==1)
        {
            NSDictionary * movieInfo = [searchMovieList objectAtIndex:indexPath.row];
            [cell setMovieDictionary:movieInfo];
        }else if (tableView.tag == 2)
        {
            NSDictionary * userInfo = [searchUserList objectAtIndex:indexPath.row];
            [cell setUserDictionary:userInfo];
            
        }
        
        return cell;
    }else
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRSuggestRequestFriendCell"];
        
        GMRSuggestRequestFriendCell* cell = (GMRSuggestRequestFriendCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRSuggestRequestFriendCell class]])
                    
                    cell = (GMRSuggestRequestFriendCell *)oneObject;
            
            [cell setViews];
        }
        cell.delegate = self;
        NSDictionary * contactInfo = [addFriendList objectAtIndex:indexPath.row];
        [cell setContact:contactInfo];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        [movieSelectedView setHidden:NO];
        NSDictionary * movieInfo = [searchMovieList objectAtIndex:indexPath.row];
        [movieSelectedLabel setText:[NSString stringWithFormat:@"%@",[movieInfo objectForKey:@"movie_name"]]];
        suggest_movie_id = [[movieInfo objectForKey:@"movie_id"] intValue];
        NSString * completeURL = [[GMRAppState sharedState] getThumbnailMovieImage:[NSString stringWithFormat:@"%@",[movieInfo objectForKey:@"movie_image_url"]]];
        [roundMovieSelected setContentMode:UIViewContentModeScaleAspectFill];
        [roundMovieSelected setClipsToBounds:YES];
        [roundMovieSelected setImageWithURL:[NSURL URLWithString:completeURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
        
    }else if (tableView.tag == 2)
    {
        [addNewFriendView setHidden:NO];
        [addNewFriendButton setHidden:NO];
        [addNewFriendLabel setHidden:NO];
        [addFriendTableView setHidden:NO];
        
        NSDictionary * userInfo = [searchUserList objectAtIndex:indexPath.row];
        if ([addFriendList containsObject:userInfo])
            return;
        [addFriendList addObject:userInfo];
        [addFriendTableView reloadData];
        
        NSString * userType = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
        NSString * user_login_type_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type_id"]];
        for (NSDictionary * accountDict in [GMRAppState sharedState].userFriendsAccountData)
        {
            NSString * login_type_id = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type_id"]];
            NSString * login_type = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type"]];
            
            if ([login_type_id isEqualToString:user_login_type_id]&&[login_type isEqualToString:userType])
            {
                [suggested_users_id addObject:[NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_id"]] ];
                break;
            }
        }
        
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        return [searchMovieList count];
    }else if (tableView.tag == 2)
    {
        return [searchUserList count];
    }else if (tableView.tag == 3)
    {
        return [addFriendList count];
    }
    
    return [searchUserList count];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 1)
    {
        [searchMovieList removeAllObjects];
        
        textChangingDate = [NSDate date];
        
        
        [self performSelector:@selector(searchMoviesWithDelay) withObject:self afterDelay:2.0f];
        
    }else if (textField.tag == 2)
    {
        [searchUserList removeAllObjects];
        for(NSDictionary * FBLogin in [GMRAppState sharedState].userContactsFBData) {
            
            BOOL isContact = NO;
            for (NSDictionary * userAccount in [GMRAppState sharedState].userFriendsAccountData)
            {
                NSString * userFBLogin = [NSString stringWithFormat:@"%@",[userAccount objectForKey:@"login_type_id"]];
                if ([[NSString stringWithFormat:@"%@",[FBLogin objectForKey:@"facebook_id"]] isEqualToString:userFBLogin])
                {
                    isContact =YES;
                    break;
                }
            }
            if (!isContact)
                break;
            NSRange substringRangeLowerCase = [[[NSString stringWithFormat:@"%@",[FBLogin objectForKey:@"user_complete_name"]] lowercaseString] rangeOfString:searchString];
            
            if (substringRangeLowerCase.length !=0)
            {
                
                NSDictionary * searchDict = [[NSMutableDictionary alloc] init];
                [searchDict setValue:@"facebook" forKey:@"type"];
                [searchDict setValue:[FBLogin objectForKey:@"facebook_id"] forKey:@"type_id"];
                [searchDict setValue:[FBLogin objectForKey:@"user_complete_name"] forKey:@"name"];
                [searchDict setValue:[FBLogin objectForKey:@"user_image_url"] forKey:@"image_url"];
                [searchUserList addObject:searchDict];
            }
            
            
        }
        
        for(NSDictionary * login in [GMRAppState sharedState].userContactsLoginData) {
            
            
            BOOL isContact = NO;
            for (NSDictionary * userAccount in [GMRAppState sharedState].userFriendsAccountData)
            {
                NSString * userLogin = [NSString stringWithFormat:@"%@",[userAccount objectForKey:@"login_type_id"]];
                if ([[NSString stringWithFormat:@"%@",[login objectForKey:@"login_id"]] isEqualToString:userLogin])
                {
                    isContact =YES;
                    break;
                }
            }
            if (!isContact)
                break;

            
            NSRange substringRangeLowerCase = [[[NSString stringWithFormat:@"%@",[login objectForKey:@"user_complete_name"]] lowercaseString] rangeOfString:searchString];
            
            if (substringRangeLowerCase.length !=0)
            {
                
                NSDictionary * searchDict = [[NSMutableDictionary alloc] init];
                [searchDict setValue:@"manual" forKey:@"type"];
                [searchDict setValue:[login objectForKey:@"login_id"] forKey:@"type_id"];
                [searchDict setValue:[login objectForKey:@"user_complete_name"] forKey:@"name"];
                [searchDict setValue:[login objectForKey:@"user_image_url"] forKey:@"image_url"];
                [searchUserList addObject:searchDict];
            }
            
            
        }
        
        [userTableView reloadData];
    }
    return YES;
    
}

-(void)searchMoviesWithDelay
{
    if ([[NSDate date] timeIntervalSinceDate:textChangingDate]>=2.0f)
    {
        [HUD show:YES];
        [self performSelector:@selector(searchMovies) withObject:self];
    }else
    {
        [self performSelector:@selector(searchMoviesWithDelay) withObject:self afterDelay:1.0f];
    }
}

-(void)searchMovies
{
    if ([searchString isEqualToString:@""])
    {
        searchMovieList =[[NSMutableArray alloc] init];
        [movieTableView reloadData];
        [HUD hide:YES];
        return;
    }
    NSArray * moviesArray = [[GMRCoreDataModelManager sharedManager] getMoviesForString:searchString];
    if (!moviesArray)
    {
        [movieTableView reloadData];
        [HUD hide:YES];
        return;
    }
    searchMovieList = [moviesArray mutableCopy];
    if ([searchMovieList count]>0)
        movieTableView.hidden = NO;
    else
        movieTableView.hidden = YES;
    
    [movieTableView reloadData];
    [HUD hide:YES];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [movieTableView setHidden:YES];
    [userTableView setHidden:YES];
    [toLabel setHidden:NO];
    return NO;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-150,self.view.frame.size.width,self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
    if (textField.tag == 1)
    {
        [movieTableView setHidden:NO];
        [toLabel setHidden:YES];
    }
    else if (textField.tag == 2)
        [userTableView setHidden:NO];
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1)
    {
        [movieTableView setHidden:NO];
        [toLabel setHidden:YES];
    }
    else if (textField.tag == 2)
        [userTableView setHidden:NO];
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [HUD hide:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                   self.view.frame.origin.y+150,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
    [movieTableView setHidden:YES];
    [userTableView setHidden:YES];
    [toLabel setHidden:NO];
    
    return YES;
}

-(IBAction)cancelSelectedButton:(id)sender
{
    UIButton * button = (UIButton*)sender;
    
    if (button.tag == 1)
    {
        [movieSelectedView setHidden:YES];
        suggest_movie_id = -1;
        
    }else if (button.tag == 2)
    {
        [suggested_users_id removeAllObjects];
        [userSelectedView setHidden:YES];
        [addNewFriendView setHidden:YES];
        [addNewFriendLabel setHidden:YES];
        [addNewFriendButton setHidden:YES];
        
    }
}

-(IBAction)sendButtonPressed:(id)sender
{
    if ([suggested_users_id count] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Add a friend to suggeest a movie" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (suggest_movie_id == -1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Add a movie to be suggested" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (![[GMRAppState sharedState] checkInternetConnectivity])
    {
        return;
    }
    UserSuggestMovieObject * suggestObject = [[UserSuggestMovieObject alloc] init];
    suggestObject.movie_id = suggest_movie_id;
    suggestObject.suggested_users_id = [suggested_users_id componentsJoinedByString:@","];
    suggestObject.user_id = [GMRAppState sharedState].userAccountInfo.login_id;
    NSString * requestObjectJSON = [suggestObject ToJSON];
    NSString * responseString = [[GMRCoreDataModelManager sharedManager] suggestUsersMovie:requestObjectJSON];
    if (responseString)
    {
        NSDictionary * respDict = [responseString JSONValue];
        NSString * respString = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
        if ([respString isEqualToString:@"success"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Movie suggestion sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [suggested_users_id removeAllObjects];
            suggest_movie_id = -1;
            [addFriendList removeAllObjects];
            [addFriendTableView reloadData];
            
            [movieSelectedView setHidden:YES];
            [addNewFriendView setHidden:YES];
            [addNewFriendButton setHidden:YES];
            [addNewFriendLabel setHidden:YES];
            [userTextField setText:@""];
            [movieTextField setText:@""];
            
            if (_requestedMovieInfo)
            {
                int requestedUserID = [[_requestedMovieInfo objectForKey:@"user_request_id"] intValue];
                BOOL isDeleted = [[GMRCoreDataModelManager sharedManager] removeUserRequestMovieForID:requestedUserID];
                if (isDeleted)
                {
                    for (NSDictionary * requestedMovie in [GMRAppState sharedState].movieRequestsToUser)
                    {
                        int requestedID = [[requestedMovie objectForKey:@"user_request_id"] intValue];
                        
                        if (requestedID == requestedUserID)
                        {
                            [[GMRAppState sharedState].movieRequestsToUser removeObject:requestedMovie];
                            [[GMRAppState sharedState].alertViewCell showAlert];
                            break;
                        }
                    }
                }

            }
        }
        
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Error sending movie suggestion!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(void)setUser:(int)userID
{
    selectedFriend = userID;
    [self performSelector:@selector(selectUser) withObject:self afterDelay:0.5f];
    
}

-(void)setMovieID:(int)movieID
{
    suggest_movie_id = movieID;
    [self performSelector:@selector(selectMovie) withObject:self afterDelay:0.5f];
    
}
-(void)selectUser
{
    [self addFriend:selectedFriend];
    
}

-(void)selectMovie
{
    [movieSelectedView setHidden:NO];
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:suggest_movie_id];
    [movieSelectedLabel setText:[NSString stringWithFormat:@"%@",movieInfo.movie_name]];
    NSString * completeURL = [NSString stringWithFormat:@"%@",movieInfo.movie_image_url];
    [roundMovieSelected setContentMode:UIViewContentModeScaleAspectFill];
    [roundMovieSelected setClipsToBounds:YES];
    [roundMovieSelected setImageWithURL:[NSURL URLWithString:completeURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];

}

-(IBAction)addFriendButton:(id)sender
{
    GMRAddMoreFriendsController *cVC ;
    if ([GMRAppState sharedState].IS_IPHONE_5)
    {
        cVC = [[GMRAddMoreFriendsController alloc] initWithNibName:@"GMRAddMoreFriendsController" bundle:nil];
    }else
    {
        cVC = [[GMRAddMoreFriendsController alloc] initWithNibName:@"GMRAddMoreFriendsController_iPhone4" bundle:nil];
    }
    cVC.centerNavigationController = self.centerNavigationController;
    cVC.selectedFriends = suggested_users_id;
    [self.centerNavigationController pushViewController:cVC animated:YES];
    cVC.delegate = self;
}

-(void)unselectFriend:(NSDictionary *)friendDict
{
    [addFriendList removeObject:friendDict];
    [addFriendTableView reloadData];
    
    NSString * userType = [NSString stringWithFormat:@"%@",[friendDict objectForKey:@"type"]];
    NSString * user_login_type_id = [NSString stringWithFormat:@"%@",[friendDict objectForKey:@"type_id"]];
    for (NSDictionary * accountDict in [GMRAppState sharedState].userFriendsAccountData)
    {
        NSString * login_type_id = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type_id"]];
        NSString * login_type = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type"]];
        
        if ([login_type_id isEqualToString:user_login_type_id]&&[login_type isEqualToString:userType])
        {
            [suggested_users_id removeObject:[NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_id"]] ];
            break;
        }
    }


}


-(void)selectFriend:(NSDictionary *)friendDict
{
    if ([addFriendList containsObject:friendDict])
        return;
    [addFriendList addObject:friendDict];
    [addFriendTableView reloadData];
    
    NSString * userType = [NSString stringWithFormat:@"%@",[friendDict objectForKey:@"type"]];
    NSString * user_login_type_id = [NSString stringWithFormat:@"%@",[friendDict objectForKey:@"type_id"]];
    for (NSDictionary * accountDict in [GMRAppState sharedState].userFriendsAccountData)
    {
        NSString * login_type_id = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type_id"]];
        NSString * login_type = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type"]];
        
        if ([login_type_id isEqualToString:user_login_type_id]&&[login_type isEqualToString:userType])
        {
            [suggested_users_id addObject:[NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_id"]] ];
            break;
        }
    }
    
    
}
#pragma AddMoreFriendsControllerDelegate methods

-(void)addFriend:(int)friendID
{
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:friendID];
    
    NSString * userType = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]];
    NSString * user_login_type_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type_id"]];
    
    if ([userType isEqualToString:@"facebook"])
    {
        for(NSDictionary * FBLogin in [GMRAppState sharedState].userContactsFBData) {
            
            NSString * login_id = [NSString stringWithFormat:@"%@",[FBLogin objectForKey:@"facebook_id"]];
            
            if ([login_id isEqualToString:user_login_type_id])
            {
                
                NSDictionary * searchDict = [[NSMutableDictionary alloc] init];
                [searchDict setValue:@"facebook" forKey:@"type"];
                [searchDict setValue:[FBLogin objectForKey:@"facebook_id"] forKey:@"type_id"];
                [searchDict setValue:[FBLogin objectForKey:@"user_complete_name"] forKey:@"name"];
                [searchDict setValue:[FBLogin objectForKey:@"user_image_url"] forKey:@"image_url"];
                [addFriendList addObject:searchDict];
                [suggested_users_id addObject:[NSString stringWithFormat:@"%i",friendID]];
                [addNewFriendView setHidden:NO];
                [addNewFriendButton setHidden:NO];
                [addNewFriendLabel setHidden:NO];
                [addFriendTableView setHidden:NO];
                [addFriendTableView reloadData];
                break;
            }
            
            
        }
    }else if ([userType isEqualToString:@"manual"])
    {
        for(NSDictionary * login in [GMRAppState sharedState].userContactsLoginData) {
            
            NSString * login_id = [NSString stringWithFormat:@"%@",[login objectForKey:@"login_id"]];
            
            if ([login_id isEqualToString:user_login_type_id])
            {
                
                NSDictionary * searchDict = [[NSMutableDictionary alloc] init];
                [searchDict setValue:@"manual" forKey:@"type"];
                [searchDict setValue:[login objectForKey:@"login_id"] forKey:@"type_id"];
                [searchDict setValue:[login objectForKey:@"user_complete_name"] forKey:@"name"];
                [searchDict setValue:[login objectForKey:@"user_image_url"] forKey:@"image_url"];
                [addFriendList addObject:searchDict];
                [suggested_users_id addObject:[NSString stringWithFormat:@"%i",friendID]];
                [addNewFriendView setHidden:NO];
                [addNewFriendButton setHidden:NO];
                [addNewFriendLabel setHidden:NO];
                [addFriendTableView setHidden:NO];
                [addFriendTableView reloadData];
                break;
            }
            
            
        }
    }
    
}

-(void)removeFriend:(int)friendID
{
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:friendID];
    
    NSString * userType = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type"]];
    NSString * user_login_type_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"login_type_id"]];
    
    if ([userType isEqualToString:@"facebook"])
    {
        for(NSDictionary * FBLogin in [GMRAppState sharedState].userContactsFBData) {
            
            NSString * login_id = [NSString stringWithFormat:@"%@",[FBLogin objectForKey:@"facebook_id"]];
            
            if ([login_id isEqualToString:user_login_type_id])
            {
                
                NSDictionary * searchDict = [[NSMutableDictionary alloc] init];
                [searchDict setValue:@"facebook" forKey:@"type"];
                [searchDict setValue:[FBLogin objectForKey:@"facebook_id"] forKey:@"type_id"];
                [searchDict setValue:[FBLogin objectForKey:@"user_complete_name"] forKey:@"name"];
                [searchDict setValue:[FBLogin objectForKey:@"user_image_url"] forKey:@"image_url"];
                [addFriendList removeObject:searchDict];
                [suggested_users_id removeObject:[NSString stringWithFormat:@"%i",friendID]];
                [addFriendTableView reloadData];
                break;
            }
            
            
        }
    }else if ([userType isEqualToString:@"manual"])
    {
        for(NSDictionary * login in [GMRAppState sharedState].userContactsLoginData) {
            
            NSString * login_id = [NSString stringWithFormat:@"%@",[login objectForKey:@"login_id"]];
            
            if ([login_id isEqualToString:user_login_type_id])
            {
                
                NSDictionary * searchDict = [[NSMutableDictionary alloc] init];
                [searchDict setValue:@"manual" forKey:@"type"];
                [searchDict setValue:[login objectForKey:@"login_id"] forKey:@"type_id"];
                [searchDict setValue:[login objectForKey:@"user_complete_name"] forKey:@"name"];
                [searchDict setValue:[login objectForKey:@"user_image_url"] forKey:@"image_url"];
                [addFriendList removeObject:searchDict];
                [suggested_users_id removeObject:[NSString stringWithFormat:@"%i",friendID]];
                [addFriendTableView reloadData];
                break;
            }
            
            
        }
    }

}
@end
