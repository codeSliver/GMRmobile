//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRequestMovieController.h"
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
#import "UserRequestMovieObject.h"

@interface GMRRequestMovieController ()

@end

@implementation GMRRequestMovieController

@synthesize backButtonType = _backButtonType;
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
    [navigationLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:13.0f]];
    [navigationLabel setText:@"Request movie suggestion"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;

    requestedUserIDs = [[NSMutableArray alloc] init];
    
    if (IS_IOS7)
    {
        [userTableView setSeparatorInset:UIEdgeInsetsZero];

    }
    [userTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    if (!_backButtonType)
        [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    else
        [self.centerNavigationController changeBackButton:_backButtonType];    [userTableView setBounces:NO];
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    UIFont *regularFont = [UIFont fontWithName:@"Lato-Light" size:15.0];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldItalicFont, NSFontAttributeName, nil];
    
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, nil];
    const NSRange range = NSMakeRange(12,7);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"I'd like to request a movie suggestion from..."]
                                           attributes:subAttrs];
    [attributedText setAttributes:attrs range:range];

    
    titleLabel = [[UILabel alloc] initWithFrame:titleView.frame];
    titleLabel.attributedText = attributedText;
    titleLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleView.superview addSubview:titleLabel];
    
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
    [self setUpData];
    [userTableView.superview bringSubviewToFront:userTableView];
}

-(void)setUpData
{
    [[GMRAppState sharedState] loadUserContacts];
    
    searchUserList = [[NSMutableArray alloc] init];
    addFriendList = [[NSMutableArray alloc] init];

    userTableView.delegate = self;
    userTableView.dataSource = self;
    addFriendTableView.delegate = self;
    addFriendTableView.dataSource = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_backButtonType)
        [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    else
        [self.centerNavigationController changeBackButton:_backButtonType];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2)
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

            NSDictionary * userInfo = [searchUserList objectAtIndex:indexPath.row];
        [cell setUserDictionary:userInfo];
    
    
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
        NSDictionary * userInfo = [searchUserList objectAtIndex:indexPath.row];
    if ([addFriendList containsObject:userInfo])
        return;
    [addFriendList addObject:userInfo];
    [addFriendTableView setHidden:NO];
    [addNewFriendButton setHidden:NO];
    [addNewFriendView setHidden:NO];
    [addNewFriendLabel setHidden:NO];
    [addFriendTableView reloadData];
    
    NSString * userType = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
    NSString * user_login_type_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type_id"]];
    for (NSDictionary * accountDict in [GMRAppState sharedState].userFriendsAccountData)
    {
        NSString * login_type_id = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type_id"]];
        NSString * login_type = [NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_type"]];
        
        if ([login_type_id isEqualToString:user_login_type_id]&&[login_type isEqualToString:userType])
        {
            [requestedUserIDs addObject:[NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_id"]] ];
            break;
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
    if (tableView.tag == 2)
            return [searchUserList count];
    else
            return [addFriendList count];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
 
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
        NSRange substringRangeLowerCase = [[[NSString stringWithFormat:@"%@",[FBLogin objectForKey:@"user_complete_name"]] lowercaseString] rangeOfString:newString];
        
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
        
        
        NSRange substringRangeLowerCase = [[[NSString stringWithFormat:@"%@",[login objectForKey:@"user_complete_name"]] lowercaseString] rangeOfString:newString];
        
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
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [userTableView setHidden:YES];
    return NO;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-150,self.view.frame.size.width,self.view.frame.size.height)];
    
    [UIView commitAnimations];
    

        [userTableView setHidden:NO];

    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
   
        [userTableView setHidden:NO];

}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                    self.view.frame.origin.y+150,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
    [userTableView setHidden:YES];

    return YES;
}

-(IBAction)sendButtonPressed:(id)sender
{
    if ([requestedUserIDs count] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Add a friend to request" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    UserRequestMovieObject * requestObject = [[UserRequestMovieObject alloc] init];
    requestObject.requested_users_id = [requestedUserIDs componentsJoinedByString:@","];;
    requestObject.user_id = [GMRAppState sharedState].userAccountInfo.login_id;
    NSString * requestObjectJSON = [requestObject ToJSON];
    NSString * responseString = [[GMRCoreDataModelManager sharedManager] requestUserMovie:requestObjectJSON];
    if (responseString)
    {
        NSDictionary * respDict = [responseString JSONValue];
        NSString * respString = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
        if ([respString isEqualToString:@"success"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Movie request sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [requestedUserIDs removeAllObjects];
            [addFriendList removeAllObjects];
            [addFriendTableView reloadData];
            [userSelectedView setHidden:YES];
            [userTextField setText:@""];
        }
        
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Error sending movie request!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }

}

-(void)setUser:(int)userID
{
    selectedFriend = userID;
    [self performSelector:@selector(selectUser) withObject:self afterDelay:0.5f];
    
}

-(void)selectUser
{
    NSDictionary * userAccount = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:selectedFriend];
    
    NSString * userImageURL = @"";
    NSString * firstName = @"";
    
    if (userAccount)
    {
        if ([[NSString stringWithFormat:@"%@",[userAccount objectForKey:@"login_type"]] isEqualToString:@"facebook"])
        {
            NSDictionary * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:[[userAccount objectForKey:@"login_type_id"] intValue]];
            if (fbUserInfo)
            {
                firstName = [NSString stringWithFormat:@"%@",[fbUserInfo objectForKey:@"user_complete_name"]];
                userImageURL = [NSString stringWithFormat:@"http://%@",[fbUserInfo objectForKey:@"user_image_url"]];;
            }
        }else if ([[NSString stringWithFormat:@"%@",[userAccount objectForKey:@"login_type"]] isEqualToString:@"manual"])
        {
            NSDictionary * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:[[userAccount objectForKey:@"login_type_id"] intValue]];
            if (loginUserInfo)
            {
                firstName = [NSString stringWithFormat:@"%@",[loginUserInfo objectForKey:@"user_complete_name"]];
                userImageURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,[loginUserInfo objectForKey:@"user_image_url"]];
            }
        }
        [requestedUserIDs addObject:[NSString stringWithFormat:@"%@",[userAccount objectForKey:@"login_id"]]];
    }
    
    [userSelectedView setHidden:NO];
    
    [userSelectedLabel setText:firstName];
    
    [roundUserSelected setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"people.png"] resize:YES options:SDWebImageRetryFailed];
    
    
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
    cVC.selectedFriends = requestedUserIDs;
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
            [requestedUserIDs removeObject:[NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_id"]] ];
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
            [requestedUserIDs addObject:[NSString stringWithFormat:@"%@",[accountDict objectForKey:@"login_id"]] ];
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
                [requestedUserIDs addObject:[NSString stringWithFormat:@"%i",friendID]];
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
                [requestedUserIDs addObject:[NSString stringWithFormat:@"%i",friendID]];
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
                [requestedUserIDs removeObject:[NSString stringWithFormat:@"%i",friendID]];
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
                [requestedUserIDs removeObject:[NSString stringWithFormat:@"%i",friendID]];
                [addFriendTableView reloadData];
                break;
            }
            
            
        }
    }
    
}


@end
