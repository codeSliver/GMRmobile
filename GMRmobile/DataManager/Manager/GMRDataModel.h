//
//  QuirQyDataModel.h
//  QuirQyDemo
//
//  Created by Quirqy on 14/02/13.
//  Copyright (c) 2013 QuirQy-Joey. All rights reserved.
//

#ifndef GMRDemo_GMRDataModel_h
#define GMRDemo_GMRDataModel_h

//include all data model headers
#import "MovieBasicInfo.h"
#import "UserFeedMovie.h"
#import "UserAccount.h"
#import "UserFBLoginInfo.h"
#import "UserLoginInfo.h"
#import "MovieDetailedInfo.h"
//#import "RecipeDesc.h"
//#import "RecipeInfo.h"
//#import "RecipeType.h"
//#import "AboutPete.h"
//#import "AdvertisementInfo.h"
//
//// define table names
#define TABLE_UserFeedMovie @"UserFeedMovie"
#define TABLE_UserAccount @"UserAccount"
#define TABLE_UserFBLoginInfo @"UserFBLoginInfo"
#define TABLE_UserLoginInfo @"UserLoginInfo"
#define TABLE_MovieBasicInfo @"MovieBasicInfo"
//#define TABLE_RecipeInfo @"RecipeInfo"
//#define TABLE_RecipeType @"RecipeType"
//#define TABLE_AboutPete @"AboutPete"
//#define TABLE_Advertisement @"AdvertisementInfo"


//define an array of tables
#define GMR_DB_TABLELIST [NSArray arrayWithObjects: TABLE_MovieBasicInfo,/*TABLE_UserFeedMovie,TABLE_UserAccount,TABLE_UserLoginInfo,TABLE_UserFBLoginInfo,TABLE_MovieDetailedInfo,*/ nil]

#endif
