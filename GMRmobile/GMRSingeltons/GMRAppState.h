//
//  PEAppState.h
//  PeteEvans
//
//  Created by Mrudul Vasavada on 1/10/13.
//  Copyright (c) 2013 Mrudul Vasavada. All rights reserved.
//

#import "UserAccount.h"
//#import "UserFBLoginInfo.h"
#import "UserLoginInfo.h"
#import "UserLoginInfoObject.h"
#import "UserFBLoginInfoObject.h"
#import "UserAccountObject.h"
#import "UserContactsInfoObject.h"
#import "GMRDrawerLeftViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"

#define AUTOUPDATE_TIME 60.0f


@class GMRDrawerTableViewCell,GMRDrawerTableViewProfileCell;
typedef enum {
    USER_LOGIN_FB = 1,
    USER_LOGIN_MANUAL,
} UserLoginType;

@interface GMRAppState : NSObject <FBLoginViewDelegate>
{
    NSString * HUDTitle;
}

@property (nonatomic) BOOL isRetinaDisplay;
@property (nonatomic,strong) UserLoginInfoObject * userMNLoginInfo;
@property (nonatomic,strong) UserFBLoginInfoObject * userFBLoginInfo;
@property (nonatomic,strong) UserAccountObject * userAccountInfo;
@property (nonatomic) UserLoginType userLoginType;

@property (strong, nonatomic) id<FBGraphUser> loggedInFBUser;
@property (strong,nonatomic) NSDictionary * FBUserDictionary;
@property (nonatomic, strong) NSMutableDictionary * userHistoryData;
@property (nonatomic, strong) NSMutableDictionary * userRecommendationsData;
@property (strong, nonatomic) FBRequestConnection *requestConnection;

@property (nonatomic,strong) UserContactsInfoObject * userContactsInfo;
@property (nonatomic,strong) NSMutableArray * userFriendsAccountData;
@property (nonatomic,strong) NSMutableArray * userContactsAccountData;
@property (nonatomic,strong) NSMutableArray * userContactsFBData;
@property (nonatomic,strong) NSMutableArray * userContactsLoginData;
@property (nonatomic,strong) NSMutableArray * favouriteContacts;
@property (nonatomic,strong) NSMutableArray * feedArray;
@property (nonatomic,strong) NSMutableArray * todayTopReviewd;
@property (nonatomic,strong) NSMutableArray * todayTopRated;
@property (nonatomic,strong) NSMutableArray * movieRequestsToUser;
@property (nonatomic,strong) NSMutableArray * movieSuggestedToUser;
@property (nonatomic,strong) GMRDrawerLeftViewController * sideController;
@property (nonatomic,strong) GMRDrawerTableViewCell * alertViewCell;
@property (nonatomic,strong) NSMutableDictionary * movieReviewRateDictionary;
@property (nonatomic,assign) GMRDrawerTableViewProfileCell * profileCell;
@property (nonatomic,strong) NSMutableArray * chartsArray;
@property (nonatomic) BOOL IS_IPHONE_5;
- (void)sendRequestsWithGraphRequest:(NSString*)graphRequest;

+ (GMRAppState*)sharedState;
- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title ;
- (void)dismissGlobalHUD ;
-(NSString*)getRetinaImage:(NSString*)imageName;
-(NSString*)getUserImage;
-(NSString*)getUserName;
-(void)loadHistoryForUser:(int)userID;
-(void)saveUserHistory;
-(void)addDataToHistory:(NSDictionary*)historyDict;
-(int)compareDate:(NSDate*)date1 andDate:(NSDate*)date2;
-(void)loadUserContacts;
-(BOOL)updateUserContactsInfo;
-(void)addFriendLocally:(int)userID;
-(BOOL)checkInternetConnectivity;
-(BOOL)isFavoriteRecommendation:(int)recommendationID;
-(void)loadRecommendationsForUser:(int)userID;
-(void)addDataToRecommendations:(int)recommendationID;
-(void)removeDataToRecommendations:(int)recommendationID;
-(void)autoUpdateState;
-(NSString*)getThumbnailMovieImage:(NSString*)movieURL;
-(NSString*)getDetMovieImage:(NSString*)movieURL;
@end
