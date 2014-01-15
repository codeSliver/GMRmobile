//
//  PEAppState.m
//  PeteEvans
//
//  Created by Mrudul Vasavada on 1/10/13.
//  Copyright (c) 2013 Mrudul Vasavada. All rights reserved.
//

#import "GMRAppState.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "GMRCoreDataModelManager.h"
#import "Reachability.h"
#import "GMRDrawerTableViewCell.h"
#import "GMRDrawerTableViewProfileCell.h"
@implementation GMRAppState

@synthesize isRetinaDisplay = _isRetinaDisplay;
@synthesize userFBLoginInfo = _userFBLoginInfo;
@synthesize userMNLoginInfo = _userMNLoginInfo;
@synthesize userLoginType = _userLoginType;
@synthesize loggedInFBUser = _loggedInFBUser;
@synthesize FBUserDictionary = _FBUserDictionary;
@synthesize userAccountInfo = _userAccountInfo;
@synthesize userHistoryData = _userHistoryData;
@synthesize userRecommendationsData = _userRecommendationsData;
@synthesize userContactsInfo = _userContactsInfo;
@synthesize userContactsAccountData = _userContactsAccountData;
@synthesize userContactsFBData = _userContactsFBData;
@synthesize userContactsLoginData = _userContactsLoginData;
@synthesize favouriteContacts = _favouriteContacts;
@synthesize feedArray = _feedArray;
@synthesize todayTopReviewd = _todayTopReviewd;
@synthesize todayTopRated = _todayTopRated;
@synthesize sideController = _sideController;
@synthesize movieRequestsToUser = _movieRequestsToUser;
@synthesize alertViewCell = _alertViewCell;
@synthesize movieSuggestedToUser = _movieSuggestedToUser;
@synthesize movieReviewRateDictionary = _movieReviewRateDictionary;
@synthesize userFriendsAccountData = _userFriendsAccountData;
@synthesize profileCell =_profileCell;
@synthesize chartsArray = _chartsArray;
@synthesize IS_IPHONE_5 = _IS_IPHONE_5;
static GMRAppState * _sharedState = nil;



- (GMRAppState *) init
{
    if ((self = [super init]))
    {
        _feedArray = [[NSMutableArray alloc] init];
        _todayTopReviewd = [[NSMutableArray alloc] init];
        _todayTopRated = [[NSMutableArray alloc] init];
        _movieReviewRateDictionary =[[NSMutableDictionary alloc] init];
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            self.isRetinaDisplay = YES;
        } else {
            self.isRetinaDisplay = NO;
        }
        _IS_IPHONE_5 = (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f);
        [NSTimer scheduledTimerWithTimeInterval:AUTOUPDATE_TIME target:self selector:@selector(autoUpdateState) userInfo:nil repeats:YES];

        
    }
    return self;
}


+ (GMRAppState*)sharedState {
	@synchronized(self) {
		if (_sharedState == nil) {
			_sharedState = [[GMRAppState alloc] init];
            
		}
	}
	return _sharedState;
}

-(NSString*)getRetinaImage:(NSString*)imageName
{
    if (!self.isRetinaDisplay)
        return imageName;
    
    imageName = [imageName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    imageName = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"];
    imageName = [imageName stringByReplacingOccurrencesOfString:@".jpeg" withString:@"@2x.jpeg"];

    
    return imageName;
}

-(NSString*)getUserName
{
    switch (self.userLoginType) {
        case USER_LOGIN_MANUAL:
        {
            return self.userMNLoginInfo.user_complete_name;
        }
        break;
        case USER_LOGIN_FB:
        {
            return self.loggedInFBUser.name;
        }
        break;
            
        default:
            break;
    }
    return @"";
}

-(NSString*)getUserImage
{
    switch (self.userLoginType) {
        case USER_LOGIN_MANUAL:
        {
            return [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,self.userMNLoginInfo.user_image_url];
        }
        break;
        case USER_LOGIN_FB:
        {
            NSString * url = self.userFBLoginInfo.user_image_url;
            return url;
        }
        break;
            
        default:
            break;
    }
    return @"people.png";
}

-(void)loadHistoryForUser:(int)userID
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * histDictString = [defaults stringForKey:[NSString stringWithFormat:@"%i_HistoryInfo",userID]];
    
    if (histDictString)
    {
        _userHistoryData = [[histDictString JSONValue] mutableCopy];
    }else
    {
        _userHistoryData = [[NSMutableDictionary alloc] init];
        [_userHistoryData setObject:[NSNumber numberWithInt:userID] forKey:@"userID"];
        [_userHistoryData setObject:[[NSArray alloc] init] forKey:@"userHistoryArray"];
        [self saveUserHistory];
    }
}

-(void)loadRecommendationsForUser:(int)userID
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * recDictString = [defaults stringForKey:[NSString stringWithFormat:@"%i_RecommendationsInfo",userID]];
    
    if (recDictString)
    {
        _userRecommendationsData = [[recDictString JSONValue] mutableCopy];
    }else
    {
        _userRecommendationsData = [[NSMutableDictionary alloc] init];
        [_userRecommendationsData setObject:[NSNumber numberWithInt:userID] forKey:@"userID"];
        [_userRecommendationsData setObject:[[NSArray alloc] init] forKey:@"userRecommendationsArray"];
        [self saveUserRecommendations];
    }

}
-(void)addDataToHistory:(NSDictionary*)historyDict
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy";
    
    NSDate * todayDate = [NSDate date];
    NSArray * histArray = [_userHistoryData objectForKey:@"userHistoryArray"];
    NSMutableArray * historyArray = [histArray mutableCopy];
    BOOL alreadyExist = NO;
    for (int i=0;i<[historyArray count];i++)
    {
        NSMutableDictionary * histDateDict = [((NSDictionary*)[histArray objectAtIndex:i]) mutableCopy];
        NSString * histDateString = [NSString stringWithFormat:@"%@",[histDateDict objectForKey:@"date"]];
        NSDate * histDate = [dateFormatter dateFromString:histDateString];
        int comaprison = [self compareDate:todayDate andDate:histDate];
        if (comaprison == 0)
        {
            NSMutableArray * dateHistArray = [((NSArray*)[histDateDict objectForKey:@"dateHistArray"]) mutableCopy];
            [dateHistArray addObject:historyDict];
            [histDateDict setObject:dateHistArray forKey:@"dateHistArray"];
            [historyArray replaceObjectAtIndex:i withObject:histDateDict];
            [_userHistoryData setObject:historyArray forKey:@"userHistoryArray"];
            alreadyExist = YES;
            break;
        }
    }
    if (!alreadyExist)
    {
        NSMutableDictionary * dateHistDict = [[NSMutableDictionary alloc] init];
        [dateHistDict setObject:[dateFormatter stringFromDate:todayDate] forKey:@"date"];
        [dateHistDict setObject:[NSArray arrayWithObject:historyDict] forKey:@"dateHistArray"];
        [historyArray addObject:dateHistDict];
        [_userHistoryData setObject:historyArray forKey:@"userHistoryArray"];
    }
    
    [self saveUserHistory];
    
}

-(void)addDataToRecommendations:(int)recommendationID
{

    NSArray * recArray = [_userRecommendationsData objectForKey:@"userRecommendationsArray"];
    if (![recArray containsObject:[NSString stringWithFormat:@"%i",recommendationID]])
    {
        NSMutableArray * recommendationsArray = [recArray mutableCopy];
        [recommendationsArray addObject:[NSString stringWithFormat:@"%i",recommendationID]];
        [_userRecommendationsData setObject:recommendationsArray forKey:@"userRecommendationsArray"];
        [self saveUserRecommendations];
    }
    
}

-(void)removeDataToRecommendations:(int)recommendationID
{
    
    NSArray * recArray = [_userRecommendationsData objectForKey:@"userRecommendationsArray"];
    if ([recArray containsObject:[NSString stringWithFormat:@"%i",recommendationID]])
    {
        NSMutableArray * recommendationsArray = [recArray mutableCopy];
        [recommendationsArray removeObject:[NSString stringWithFormat:@"%i",recommendationID]];
        [_userRecommendationsData setObject:recommendationsArray forKey:@"userRecommendationsArray"];
        [self saveUserRecommendations];
    }
    
}

-(BOOL)isFavoriteRecommendation:(int)recommendationID
{
    NSArray * recArray = [_userRecommendationsData objectForKey:@"userRecommendationsArray"];
    if ([recArray containsObject:[NSString stringWithFormat:@"%i",recommendationID]])
    {
        return YES;
    }else
    {
        return NO;
    }
}
-(void)saveUserHistory
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userHistoryString = [_userHistoryData JSONRepresentation];
    [defaults setObject:userHistoryString forKey:[NSString stringWithFormat:@"%i_HistoryInfo",self.userAccountInfo.login_id]];
    [defaults synchronize];
}

-(void)saveUserRecommendations
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userRecommendationsString = [_userRecommendationsData JSONRepresentation];
    [defaults setObject:userRecommendationsString forKey:[NSString stringWithFormat:@"%i_RecommendationsInfo",self.userAccountInfo.login_id]];
    [defaults synchronize];
}

-(int)compareDate:(NSDate*)date1 andDate:(NSDate*)date2
{
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date1 interval:NULL forDate:date1];
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date2 interval:NULL forDate:date2];
    
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedAscending) {
        return -1;
    } else if (result == NSOrderedDescending) {
        return 1;
    }  else {
        return 0;
    }
}

-(void)loadUserContacts
{
    if (!self.userContactsInfo)
    {
        self.userContactsInfo  = [[GMRCoreDataModelManager sharedManager] getUserContacts:self.userAccountInfo.login_id];
        if (self.userContactsInfo)
        {
            NSString * friendsList =  self.userContactsInfo.contacts_list;
            NSString * favListString =  self.userContactsInfo.favorite_contacts_list;
            
            NSArray * favArray = [favListString componentsSeparatedByString:@","];
            if (favArray)
            {
                _favouriteContacts = [favArray mutableCopy];
            }else
            {
                _favouriteContacts = [[NSMutableArray alloc] init];
            }
            self.userContactsAccountData = [(NSArray*)[[GMRCoreDataModelManager sharedManager] getMultipleUserInfo:friendsList] mutableCopy];
            self.userFriendsAccountData = [(NSArray*)[[GMRCoreDataModelManager sharedManager] getMultipleUserInfo:friendsList] mutableCopy];
            self.userContactsFBData = [[NSMutableArray alloc] init];
            self.userContactsLoginData = [[NSMutableArray alloc] init];
            NSString * FBAccountsString = [NSString stringWithFormat:@""];
            NSString * loginAccountsString = [NSString stringWithFormat:@""];

            for (NSDictionary * accountInfo in self.userContactsAccountData)
            {
                NSString * accountType = [NSString stringWithFormat:@"%@",[accountInfo objectForKey:@"login_type"]];
                int accountID = [[accountInfo objectForKey:@"login_type_id"] intValue];
                
                if ([accountType isEqualToString:@"facebook"])
                {
                    if ([FBAccountsString isEqualToString:@""])
                    {
                        FBAccountsString = [NSString stringWithFormat:@"%i",accountID];
                    }else
                    {
                        FBAccountsString = [FBAccountsString stringByAppendingFormat:@",%i",accountID];

                    }
//                    UserFBLoginInfo * fbUserInfo = [[GMRCoreDataModelManager sharedManager] geFBAccountForID:accountID];
//                    [self.userContactsFBData addObject:fbUserInfo];
                    
                }else if ([accountType isEqualToString:@"manual"])
                {
                    if ([loginAccountsString isEqualToString:@""])
                    {
                        loginAccountsString = [NSString stringWithFormat:@"%i",accountID];
                    }else
                    {
                        loginAccountsString = [loginAccountsString stringByAppendingFormat:@",%i",accountID];
                        
                    }

//                    UserLoginInfo * loginUserInfo = [[GMRCoreDataModelManager sharedManager] getLoginAccountForID:accountID];
//                    [self.userContactsLoginData addObject:loginUserInfo];
                    
                }
            }
            NSArray * FBAccounts = [[GMRCoreDataModelManager sharedManager] getMultipleFBAccounts:FBAccountsString];
            
            if (FBAccounts)
            {
                self.userContactsFBData = [FBAccounts mutableCopy];
            }else
            {
                self.userContactsFBData = [[NSMutableArray alloc] init];
            }
            NSArray * loginAccounts = [[GMRCoreDataModelManager sharedManager] getMultipleLoginAccounts:loginAccountsString];
            if (loginAccounts)
            {
                self.userContactsLoginData = [loginAccounts mutableCopy];
            }else
            {
                self.userContactsLoginData = [[NSMutableArray alloc] init];
            }
        }else
        {
            self.userContactsAccountData = [[NSMutableArray alloc] init];
            self.userFriendsAccountData = [[NSMutableArray alloc] init];
            self.userContactsFBData = [[NSMutableArray alloc] init];
            self.userContactsLoginData = [[NSMutableArray alloc] init];
        }
    }

}

-(BOOL)updateUserContactsInfo
{

        UserContactsInfoObject * updatedContact = [[UserContactsInfoObject alloc] init];
        updatedContact.user_id = [GMRAppState sharedState].userAccountInfo.login_id;
        NSString * contacts_list = [NSString stringWithFormat:@""];
        int count = 0;
        for (NSDictionary * userAccount in [GMRAppState sharedState].userFriendsAccountData)
        {
            if (count ==0)
                contacts_list = [contacts_list stringByAppendingFormat:@"%@",[userAccount objectForKey:@"login_id"]];
            else
                contacts_list = [contacts_list stringByAppendingFormat:@",%@",[userAccount objectForKey:@"login_id"]];
            count++;
        }
        NSString * fav_list = [NSString stringWithFormat:@""];
        count = 0;
        for (NSNumber * favContact in [GMRAppState sharedState].favouriteContacts)
        {
            int favCon = [favContact intValue];
            if (favCon != 0)
            {
                if (count ==0)
                    fav_list = [fav_list stringByAppendingFormat:@"%i",[favContact intValue]];
                else
                    fav_list = [fav_list stringByAppendingFormat:@",%i",[favContact intValue]];
                count++;
            }
        }
    updatedContact.contacts_list = contacts_list;
    updatedContact.favorite_contacts_list = fav_list;
    NSString * updatedContactJSON = @"";
    if (self.userContactsInfo)
    {
        updatedContact.user_contact_id = self.userContactsInfo.user_contact_id;
        updatedContactJSON =[updatedContact ToJSONWithID:YES];
    }else
    {
        updatedContactJSON = [updatedContact ToJSONWithID:NO];
    }
    return [[GMRCoreDataModelManager sharedManager] setUserContactsInfo:updatedContactJSON];
    
}

-(void)addFriendLocally:(int)userID
{
    NSDictionary * user = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:userID];
    [[GMRAppState sharedState].userFriendsAccountData addObject:user];
    NSString * accountType = [NSString stringWithFormat:@"%@",[user objectForKey:@"login_type"]];
    int accountID = [[user objectForKey:@"login_type_id"] intValue];
    
    if ([accountType isEqualToString:@"facebook"])
    {
        [[GMRCoreDataModelManager sharedManager] geFBAccountDictionaryForID:accountID];
        
    }else if ([accountType isEqualToString:@"manual"])
    {
        [[GMRCoreDataModelManager sharedManager] getLoginAccountDictionaryForID:accountID];
        
    }

}

-(BOOL)checkInternetConnectivity
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connectivity!" message:@"Please check your internet connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    } else {
        
        return YES;
        
        
    }        
}

-(void)autoUpdateState
{
    if (self.alertViewCell)
        [self.alertViewCell showAlert];
}
- (void)sendRequestsWithGraphRequest:(NSString*)graphRequest {
    // extract the id's for which we will request the profile
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    // for each fbid in the array, we create a request object to fetch
    // the profile, along with a handler to respond to the results of the request
    
    // create a handler block to handle the results of the request for fbid's profile
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection forFbID:self.loggedInFBUser result:result error:error];
    };
    
    
    // create the request object, using the fbid as the graph path
    // as an alternative the request* static methods of the FBRequest class could
    // be used to fetch common requests, such as /me and /me/friends
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:graphRequest];
    
    // add the request to the connection object, if more than one request is added
    // the connection object will compose the requests as a batch request; whether or
    // not the request is a batch or a singleton, the handler behavior is the same,
    // allowing the application to be dynamic in regards to whether a single or multiple
    // requests are occuring
    [newConnection addRequest:request completionHandler:handler];
    
    
    // if there's an outstanding connection, just cancel
    [self.requestConnection cancel];
    
    // keep track of our connection, and start it
    self.requestConnection = newConnection;
    [newConnection start];
}

// FBSample logic
// Report any results.  Invoked once for each request we make.
- (void)requestCompleted:(FBRequestConnection *)connection
                 forFbID:fbID
                  result:(id)result
                   error:(NSError *)error {
    // not the completion we were looking for...
    if (self.requestConnection &&
        connection != self.requestConnection) {
        return;
    }
    
    // clean this up, for posterity
    self.requestConnection = nil;
    
    NSString *text;
    if (error) {
        // error contains details about why the request failed
        text = error.localizedDescription;
    } else {
        // result is the json response from a successful request
        NSDictionary * userInfo = (NSDictionary *)result;
        
        NSString * userInfoString = [userInfo JSONRepresentation];
        _FBUserDictionary = userInfo;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userInfoString forKey:GMR_USER_LOGIN_FB_DATA];
        [defaults synchronize];
        
    }
    
}


- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hud];
    hud.labelText = title;
    return hud;
}

- (void)dismissGlobalHUD {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

-(NSString*)getThumbnailMovieImage:(NSString*)movieURL
{
    return [movieURL stringByReplacingOccurrencesOfString:@"_ori.jpg" withString:@"_mob.jpg"];
}
-(NSString*)getDetMovieImage:(NSString*)movieURL
{
    return [movieURL stringByReplacingOccurrencesOfString:@"_ori.jpg" withString:@"_det.jpg"];
}
@end
