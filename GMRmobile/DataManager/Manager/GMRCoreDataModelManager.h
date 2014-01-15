
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"
#import "GMRDataModel.h"
#import "NSObject+Properties.h"
#import "JSON.h"
#import "UserLoginInfoObject.h"
#import "UserFBLoginInfoObject.h"
#import "UserAccountObject.h"
#import "UserAccount.h"
#import "UserContactsInfoObject.h"


#define URLPREFIX @"http://gmr.poiseinteractive.net.au/getData.php?table="
#define URLPREFIXIMAGES @"http://gmr.poiseinteractive.net.au/images/"
#define URLPREFIXIMAGESUPLOAD @"http://gmr.poiseinteractive.net.au/upload.php"
#define URLPREFIX_USERREGISTERLOGIN @"http://gmr.poiseinteractive.net.au/registerUserViaLogin.php?jsonval="
#define URLPREFIX_USERREGISTERLOGINFB @"http://gmr.poiseinteractive.net.au/registerUserViaFB.php?jsonval="
#define URLPREFIX_CHECKLOGINUSERNAMEEXISTS @"http://gmr.poiseinteractive.net.au/checkLoginUserExists.php?user_name="

#define URLPREFIX_USERLOGINCHECK @"http://gmr.poiseinteractive.net.au/getUserInfo.php?user="
#define URLPREFIX_USERFBACCOUNTINFO @"http://gmr.poiseinteractive.net.au/getFBAccountInfo.php?user="
#define URLPREFIX_USERUSERACCOUNTINFO @"http://gmr.poiseinteractive.net.au/getUserAccountInfo.php?user="
#define URLPREFIX_USERLOGINACCOUNTINFO @"http://gmr.poiseinteractive.net.au/getLoginAccountInfo.php?user="
#define URLPREFIX_USERLOGINACCOUNTCHECK @"http://gmr.poiseinteractive.net.au/getAccountUserInfo.php?user_id="

#define URLPREFIX_USERFBINFO @"http://gmr.poiseinteractive.net.au/getFBUserInfo.php?user="
#define URLPREFIX_MOVIERATINGSINFO @"http://gmr.poiseinteractive.net.au/getMovieRatings.php?movie_id="
#define URLPREFIX_MOVIEREVIEWSINFO @"http://gmr.poiseinteractive.net.au/getMovieReviews.php?movie_id="
#define URLPREFIX_USERPOSTCOMMENT @"http://gmr.poiseinteractive.net.au/postComment.php?jsonval="
#define URLPREFIX_USERPOSTRATINGS @"http://gmr.poiseinteractive.net.au/postLike.php?jsonval="
#define URLPREFIX_SEARCHCONTACTS @"http://gmr.poiseinteractive.net.au/getSearchContacts.php?search_text="
#define URLPREFIX_SEARCHMOVIES @"http://gmr.poiseinteractive.net.au/getSearchMovies.php?search_text="
#define URLPREFIX_ADDFRIEND @"http://gmr.poiseinteractive.net.au/addUserAsFriend.php?user_id="
#define URLPREFIX_USERCONTACTS @"http://gmr.poiseinteractive.net.au/getUserContacts.php?user_id="
#define URLPREFIX_USERACCOUNTSMULTIPLE @"http://gmr.poiseinteractive.net.au/getMultipleUserInfo.php?user_list="
#define URLPREFIX_SETUSERCONTACT @"http://gmr.poiseinteractive.net.au/registerUserViaLogin.php?jsonval="
#define URLPREFIX_USERSUGGESTEDMOVIEINFO @"http://gmr.poiseinteractive.net.au/getUserSuggestedMovies.php?user_id="
#define URLPREFIX_GETMOVIESREQUESTEDTOUSER @"http://gmr.poiseinteractive.net.au/getMoviesRequestedToUser.php?user_id="
#define URLPREFIX_MOVIEFORID @"http://gmr.poiseinteractive.net.au/getMovieForID.php?movie_id="
#define URLPREFIX_MOVIEDETAILEDFORID @"http://gmr.poiseinteractive.net.au/getMovieDetailedForID.php?movie_detailed_id="
#define URLPREFIX_DELETESUGGESTION @"http://gmr.poiseinteractive.net.au/deleteUserFromRecommendation.php?suggestion_id="
#define URLPREFIX_LIVEFEEDS @"http://gmr.poiseinteractive.net.au/getLiveFeedsForUser.php?user_id="
#define URLPREFIX_GETTODAYTOPREVIEWED @"http://gmr.poiseinteractive.net.au/getTopReviewedToday.php"
#define URLPREFIX_GETTODAYTOPRATED @"http://gmr.poiseinteractive.net.au/getTopRatedToday.php"
#define URLPREFIX_MULTIPLEFBACCOUNTS @"http://gmr.poiseinteractive.net.au/getMultipleFBUserInfo.php?user_list="
#define URLPREFIX_GETMOVIESRATEDBYUSER @"http://gmr.poiseinteractive.net.au/getMoviesRatedByUser.php?user_id="
#define URLPREFIX_MULTIPLELOGINACCOUNTS @"http://gmr.poiseinteractive.net.au/getMultipleLoginUserInfo.php?user_list="
#define URLPREFIX_DELETEUSERFROMREQUESTMOVIE @"http://gmr.poiseinteractive.net.au/deleteUserFromRequestMovie.php?user_request_id="
#define URLPREFIX_USERSUGGESTMOVIE @"http://gmr.poiseinteractive.net.au/suggestMovie.php?jsonval="


@interface GMRCoreDataModelManager : NSObject <NSURLConnectionDelegate>{
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    
    NSDateFormatter *sharedDateFormatter;   //make sure it's been alloced just once and never be alloced in loop since the performance hit
    
    BOOL isInProgress; //a flag if we want to stop the thread
    
    NSMutableData * responseData;
}

@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSDateFormatter *sharedDateFormatter;

+ (GMRCoreDataModelManager*)sharedManager;
+ (NSString *)applicationDocumentsDirectory;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (BOOL)addSkipBackupAttributeToFile:(NSString *)filePathString;
+ (BOOL)removeSkipBackupAttributeFromItemAtURL:(NSURL *)URL;
+ (BOOL)removeSkipBackupAttributeFromFile:(NSString *)filePathString;
+ (BOOL)isAbsoluteURL:(NSString *)url;
+ (NSString *)getAbsoluteURL:(NSString *)url;

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+ (NSDate *)nextDate:(NSDate*) date;
+ (NSDate *)dateBegin:(NSDate*) date;
+ (NSDate *)dateEnd:(NSDate*) date;
+ (NSDate *)localDateToDate:(NSDate *)date;
+ (NSDate *)GMTDateToDate:(NSDate *)date;

- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;


- (NSURL *)smartURLForString:(NSString *)str;

/*download rich content in seperate thread */
-(BOOL) getImages:(MBProgressHUD *)hud overwrite:(BOOL) isOverwrite;    //download images in background
-(BOOL) getAudio:(MBProgressHUD *)hud overwrite:(BOOL) isOverwrite;     //download audio in bacground

/* fetch records methods */
- (NSString *) localisedTextForKey:(NSString *) idText;

/* fetch record methods */

/* download JSON from feeds and update local database */
- (BOOL)getAllAppData:(MBProgressHUD *)hud;
/* download seperate JSON feed */
- (NSString *)getDataByTableName: (NSString *) tableName;     //get current exhibitions feed from staging server or product server
/* update database by JSON */
- (BOOL)updateTable:(NSDictionary *) jsonData withTableName:(NSString *) tableName;      //parse json and write to local database
/* Return Array by JSON */
- (NSMutableArray*)convertFeed:(NSDictionary *) jsonData;


/*clean up old content */
- (void)cleanVideos;                            //remove old videos

-(BOOL) setFavouriteWork:(int)workID isFavourite:(BOOL)isFavourite; //set favourites

- (BOOL)contentUpdatedWithURL:(NSString *)url;  //check url header with if-modified-since, status code 200: modified, code 304: not modified
- (BOOL)isDataCurrent:(BOOL)staging;            //to tell if we need to update local database
- (BOOL)saveData;                               //save data base
- (BOOL)setLastUpdateDate;                      //save the last update date

- (void)stopProgress;

/*utilities*/
- (NSString*)getFileNameFromURL:(NSString*)URLString;
- (NSString *)getDocumentPathFromURL:(NSString*) URLString;
- (void) downloadImageFromURL:(NSString*)url toPath:(NSString*)targetPath overwrite:(BOOL) isOverwrite skipBackup:(BOOL) aSkipBackup;
- (void) downloadFileFromURL:(NSString*)url toPath:(NSString*)targetPath overwrite:(BOOL) isOverwrite skipBackup:(BOOL) aSkipBackup;


- (NSString *)registerUserViaLogin:(NSString*)userJSONString;
- (UserLoginInfoObject *)getUserInfoWithUser:(NSString*)userName andPassword:(NSString*)password;
- (UserFBLoginInfoObject*)getFacebookUserInfoForID:(NSString*)userID;
-(BOOL)uploadImage:(UIImage*)image andName:(NSString*)imageName;
- (UserAccountObject *)getUserAccountForID:(int)userID andType:(NSString*)type;
-(NSArray *)getMoviesWithLimit:(int)movieLimit andPriority:(BOOL)isPriority;
-(MovieBasicInfo*)getMovieForID:(int)movieID;
-(UserAccount*)getUserAccountForID:(int)userAccountID;
- (NSString *)registerUserViaFB:(NSString*)userJSONString;
-(NSArray *)getFeedsWithLimit:(int)movieLimit;
-(UserFBLoginInfo*)geFBAccountForID:(int)FBID;
-(UserLoginInfo*)getLoginAccountForID:(int)loginID;
-(MovieDetailedInfo*)getMovieDetailedForMovieID:(int)movieDetailedID;
- (NSArray *)getRatingsForMovie:(int)movieID;
-(NSArray *)getReviewsForMovie:(int)movieID;
- (NSString *)postComment:(NSString*)userJSONString;
-(NSArray *)getContactsForString:(NSString*)searchString;
-(BOOL)addUserAsFriend:(int)userID;
-(UserContactsInfoObject*)getUserContacts:(int)userID;
- (NSArray *)getMultipleUserInfo:(NSString*)userList;
-(BOOL)setUserContactsInfo:(NSString *)jsonValue;
- (NSString *)requestUserMovie:(NSString*)userJSONString;
- (NSString *)suggestUsersMovie:(NSString*)userJSONString;
-(NSArray*)getSuggestedMovieListOfUser:(int)userID;
-(MovieBasicInfo*)downloadMovieForID:(int)movieID;
- (NSManagedObject*)updateTableData:(NSDictionary *) jsonData withTableName:(NSString *) tableName;
-(BOOL)deleteRecommendation:(NSDictionary*)recommendationDictionary;
-(MovieDetailedInfo*)downloadDetailedMovieForID:(int)movieDetailedID;
-(NSArray*)getLiveFeeds;
-(NSDictionary*)getUserAccountDictionaryForID:(int)userAccountID;
-(NSDictionary*)geFBAccountDictionaryForID:(int)FBID;
-(NSArray*)getMultipleFBAccounts:(NSString*)FBAccountsString;
-(NSArray*)getMultipleLoginAccounts:(NSString*)loginAccountsString;
-(NSDictionary*)getLoginAccountDictionaryForID:(int)loginID;
- (NSDictionary *)downloadFBAccountForID:(int)userID;
- (NSDictionary *)downloadLoginAccountForID:(int)userID;
-(NSArray*)getTopReviewedMoviesToday;
-(NSArray*)getTopRatedMoviesToday;
-(NSArray *)getMoviesForString:(NSString*)searchString;
-(NSArray*)getMoviesUserRated:(int)userID;
-(NSArray*)getMovieRequestsToUser:(int)userID;
-(BOOL)removeUserRequestMovieForID:(int)requestedUserID;
-(BOOL)checkUserNameAlreadyExists:(NSString*)userName;
-(BOOL)incrementCommentCountForMovieID:(int)movieID;
- (NSString *)postRatings:(NSString*)userJSONString;
-(BOOL)setAverageValueForMovie:(int)movieID andRatings:(float)ratings;
-(NSMutableArray*)getAllMoviesData;
@end
