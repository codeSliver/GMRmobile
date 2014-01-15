




#import "GMRCoreDataModelManager.h"
//#import "NSDataAdditions.h"
#import "NSString+HTML.h"
#import "NSObject+JSON.h"
#include <sys/xattr.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "GMRAppState.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+URLEncoding.h"

@implementation GMRCoreDataModelManager

@synthesize		persistentStoreCoordinator;
@synthesize		managedObjectModel;
@synthesize		managedObjectContext;
@synthesize     sharedDateFormatter;

static GMRCoreDataModelManager	*sharedDataModelManager = nil;

- (GMRCoreDataModelManager *) init
{
    if ((self = [super init])) {
        self.sharedDateFormatter = [[NSDateFormatter alloc] init];
        [self.sharedDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        
        
        [self.sharedDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [self.sharedDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
       // [self.sharedDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"] ] ;
    }
    return self;
}

+ (GMRCoreDataModelManager*)sharedManager {
	@synchronized(self) {
		if (sharedDataModelManager == nil) {
			sharedDataModelManager = [[GMRCoreDataModelManager alloc] init];
            
		}
	}
	return sharedDataModelManager;
}

#pragma mark - shared method
/**
 Returns the path to the application's documents directory.
 */
+ (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (BOOL)addSkipBackupAttributeToFile:(NSString *)filePathString
{
    
    //NSLog(@"Skipping backup for %@", filePathString);
    
    const char* filePath = [filePathString UTF8String];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (BOOL)removeSkipBackupAttributeFromItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    
    int result = removexattr(filePath, attrName, 0);
    return result == 0;
}


+ (BOOL)removeSkipBackupAttributeFromFile:(NSString *)filePathString
{
    
    NSLog(@"Allowing backup for %@", filePathString);
    
    const char* filePath = [filePathString UTF8String];
    
    const char* attrName = "com.apple.MobileBackup";
    
    int result = removexattr(filePath, attrName, 0);
    return result == 0;
}

+ (BOOL)isAbsoluteURL:(NSString *)url
{
    NSURL *absoluteURL = [[NSURL URLWithString:url] absoluteURL];
    
    //NSLog(@"scheme: %@, host: %@", absoluteURL.scheme, absoluteURL.host);
    if (absoluteURL && absoluteURL.scheme && absoluteURL.host) {
        return YES;
    }else
        return NO;
}

+ (NSString *)getAbsoluteURL:(NSString *)url
{
    if (!url) {
        return nil;
    }
    
    if ([GMRCoreDataModelManager isAbsoluteURL:url]) {
        return url;
    }else
    {
        if ([url length] > 0) {
            if ([[url substringToIndex:1] caseInsensitiveCompare:@"/"] != NSOrderedSame) {
                url = [NSString stringWithFormat:@"/%@", url];
            }
            url = [NSString stringWithFormat:@"%@%@", URLPREFIX, url];
            
        }
        
        return url;
        
    }
}

#pragma mark - constructors
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
        
        NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
    }
    return managedObjectContext;
}

- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *savedContext = [saveNotification object];
    
    // ignore change notifications for the main MOC
    if (managedObjectContext == savedContext)
    {
        return;
    }
    
    if (managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        // that's another database
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
    });}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"GMRDataModel" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSString *storePath = [[GMRCoreDataModelManager applicationDocumentsDirectory] stringByAppendingPathComponent: @"GMRDataModel.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"DBExisted"] boolValue]) {
        if (![fileManager fileExistsAtPath:storePath]) {
            [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"GMRDataModel" ofType:@"sqlite"] toPath:storePath error:nil];
        }
        
    }else
    {
        if ([fileManager fileExistsAtPath:storePath]) {
            [fileManager removeItemAtPath:storePath error:nil];
        }
        
    }
    
	// If the expected store doesn't exist, copy the default store.
    
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
	
    return persistentStoreCoordinator;
}

#pragma mark - utilities
-(NSString*)getFileNameFromURL:(NSString*)URLString{
	
	while ([URLString rangeOfString:@"/"].location != NSNotFound) {
		URLString = [URLString substringFromIndex:[URLString rangeOfString:@"/"].location + 1] ;
	}
    
	return URLString;
	
}

- (NSString *)getDocumentPathFromURL:(NSString*) URLString
{
    NSString *tempFilePath = [NSString stringWithString:URLString];
    tempFilePath = [tempFilePath lastPathComponent];
    tempFilePath = [[[GMRCoreDataModelManager applicationDocumentsDirectory] stringByAppendingString:@"/"] stringByAppendingString:tempFilePath];
    return tempFilePath;
}



-(NSDate*)getDateWithoutTime:(NSDate*)dateToConvert{
	//	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	//	NSCalendar *calendar = [NSCalendar currentCalendar];
	
    //	nsdate_formater.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
	[[[GMRCoreDataModelManager sharedManager] sharedDateFormatter] setDateFormat:@"yyyy-MM-dd"] ;
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
	[comps setYear:[[[[[GMRCoreDataModelManager sharedManager] sharedDateFormatter] stringFromDate:dateToConvert] substringToIndex:4] integerValue]];
	[comps setMonth:[[[[[GMRCoreDataModelManager sharedManager] sharedDateFormatter] stringFromDate:dateToConvert] substringWithRange:NSMakeRange(5, 2)] integerValue]];
	[comps setDay:[[[[[GMRCoreDataModelManager sharedManager] sharedDateFormatter] stringFromDate:dateToConvert] substringWithRange:NSMakeRange(8, 2)] integerValue]];
	
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	NSDate *retDate = [cal dateFromComponents:comps];
	return retDate;
}


-(NSString *) getDownloadURL:(NSString *) URL
{
    NSString *sourceURL = [NSString stringWithString:URL];
    NSLog(@"Proceeding...%@", sourceURL);
    
    if ([[sourceURL substringToIndex:6] compare:@"http://"]) {
        NSString *prefixURL = @"http://";
        prefixURL = [prefixURL stringByAppendingFormat:@"stagingmedia.agnsw.org/"];
        sourceURL = [prefixURL stringByAppendingString:sourceURL];
    }
    
    sourceURL = [sourceURL substringFromIndex:7];		// clip off assumed "http://"
    sourceURL = [NSString stringWithFormat:@"http://%@", sourceURL];	// add login
    return sourceURL;
    
}

#pragma mark - download methods
-(BOOL) getImages:(MBProgressHUD *)hud overwrite:(BOOL) isOverwrite{
    if (hud) {
        hud.progress = 0.6f;
        hud.labelText = @"downloading images...";
        
    }
    isInProgress = YES;
    //download all exhibition images
	/*NSArray * exhibitions = [self fetchAllExhibitions];
     
     CGFloat increment = 0.1f/[exhibitions count];
     for (DBExhibitions *exhibition in exhibitions) {
     
     NSString *targetPath = [NSString stringWithFormat:@"%@/%@",[DataModelManager applicationDocumentsDirectory], [exhibition.image lastPathComponent],nil];
     [self downloadImageFromURL:exhibition.image toPath:targetPath overwrite:isOverwrite skipBackup:YES];
     
     if (hud) {
     hud.progress += increment;
     //  hud.labelText = [exhibition.image lastPathComponent];
     }
     if (!isInProgress ) {
     return NO;
     }
     }*/
    
	return TRUE;
}


-(BOOL) getAudio:(MBProgressHUD *)hud  overwrite:(BOOL) isOverwrite
{
    return TRUE;
}


- (void)downloadImageFromURL:(NSString *) url toPath:(NSString *) path overwrite:(BOOL) isOverwrite skipBackup:(BOOL) aSkipBackup
{
    if (!isOverwrite && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return;
    }
	
	url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	
	NSLog(@"Downloading %@ to %@...", url, path);
	
	NSError *error = nil;
    UIImage *myimage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:0 error:&error]];
    
	if (error) {
		NSLog(@"Failed to download %@", url);
	} else {
		NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(myimage, 1.0f)];//1.0f = 100% quality
		if (![data2 writeToFile:path atomically:NO]) {
			NSLog(@"write failed");
		} else {
            if (aSkipBackup)
                [GMRCoreDataModelManager addSkipBackupAttributeToFile:path];
        }
	}
	
}


- (void)downloadFileFromURL:(NSString *) url toPath:(NSString *) path overwrite:(BOOL) isOverwrite skipBackup:(BOOL) aSkipBackup
{
    if (!isOverwrite && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return;
    }
	
	url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	
	NSLog(@"Downloading %@ to %@...", url, path);
	
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:0 error:&error];
	
	if (error) {
		NSLog(@"Failed to download %@", url);
	} else {
		if (![data writeToFile:path atomically:NO]) {
			NSLog(@"write failed");
		} else {
            if (aSkipBackup)
                [GMRCoreDataModelManager addSkipBackupAttributeToFile:path];
        }
	}
	
}


#pragma mark - fetch data from feeds
- (BOOL)getAllAppData:(MBProgressHUD *)hud
{
    for (NSString *table in GMR_DB_TABLELIST) {
        NSString *jSON = [self getDataByTableName:table];
        [self updateTable:[jSON JSONValue] withTableName:table];
    }
    return YES;
}

#pragma mark - get JSON string from feeds
- (NSString *)getDataByTableName: (NSString *) tableName
{
    NSString * jSONData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX, tableName];
    jSONData = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
    
//    jSONData = [jSONData stringByConvertingHTMLToPlainText];
    
    //error check
    if (err.code != 0) {
        [NSException raise:[err description] format:nil];
    }
    
    return jSONData;
}


#pragma mark - update local database

- (BOOL)updateTable:(NSDictionary *) jsonData withTableName:(NSString *) tableName
{
    //get fields types
    NSDictionary *fields = [jsonData objectForKey:@"fields"];
    //get all data of that table
    NSArray *data = [jsonData objectForKey:@"data"];
    for (NSDictionary *item in data) {
        
        //create managedobject by entity name
        NSManagedObject * entity = [NSEntityDescription
                                    insertNewObjectForEntityForName:tableName
                                    inManagedObjectContext:[self managedObjectContext]];
        
        NSEnumerator *keyEnumerator = [item keyEnumerator];
        
        //iterate through all keys
        NSString *key = nil;
        do {
            key = [keyEnumerator nextObject];
            if (key != nil) {
                //get the value by key from jSON data
                id value = [item objectForKey:key];
                //get field type by key
                NSString * type = [fields objectForKey:key];
                
                //skip for null values
                if (value == [NSNull null]) {
                    continue;
                }
                
                //assign the value by type
                @try {
                    if ([type isEqualToString:@"int"]) {
                        [entity setValue:[NSNumber numberWithInt:[value intValue]] forKey:key];
                    }else if (([type isEqualToString:@"real"])||([type isEqualToString:@"double"]))
                    {
                        [entity setValue:[NSDecimalNumber numberWithFloat:[value floatValue]] forKey:key];
                    }else if([type isEqualToString:@"timestamp"] || [type isEqualToString:@"datetime"])
                    {
                        [entity setValue:[[[GMRCoreDataModelManager sharedManager] sharedDateFormatter ] dateFromString:value] forKey:key];
                    }
                    else
                    {
                        [entity setValue:value forKey:key];
                    }
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"exception raised: %@ when updating table %@ for field: %@", [exception description], tableName, key);
                }
                @finally {
                    
                }
                
            }
            
        } while (key != nil);
        
    }
    
    //save datacontext
    [self saveData];
    
    return TRUE;
    
}

- (NSManagedObject*)updateTableData:(NSDictionary *) jsonData withTableName:(NSString *) tableName
{
    NSManagedObject * managedObject = nil;
    //get fields types
    NSDictionary *fields = [jsonData objectForKey:@"fields"];
    //get all data of that table
    NSArray *data = [jsonData objectForKey:@"data"];
    for (NSDictionary *item in data) {
        
        //create managedobject by entity name
        NSManagedObject * entity = [NSEntityDescription
                                    insertNewObjectForEntityForName:tableName
                                    inManagedObjectContext:[self managedObjectContext]];
        
        NSEnumerator *keyEnumerator = [item keyEnumerator];
        
        //iterate through all keys
        NSString *key = nil;
        do {
            key = [keyEnumerator nextObject];
            if (key != nil) {
                //get the value by key from jSON data
                id value = [item objectForKey:key];
                //get field type by key
                NSString * type = [fields objectForKey:key];
                
                //skip for null values
                if (value == [NSNull null]) {
                    continue;
                }
                
                //assign the value by type
                @try {
                    if ([type isEqualToString:@"int"]) {
                        [entity setValue:[NSNumber numberWithInt:[value intValue]] forKey:key];
                    }else if (([type isEqualToString:@"real"])||([type isEqualToString:@"double"]))
                    {
                        [entity setValue:[NSDecimalNumber numberWithFloat:[value floatValue]] forKey:key];
                    }else if([type isEqualToString:@"timestamp"] || [type isEqualToString:@"datetime"])
                    {
                        [entity setValue:[[[GMRCoreDataModelManager sharedManager] sharedDateFormatter ] dateFromString:value] forKey:key];
                    }
                    else
                    {
                        [entity setValue:value forKey:key];
                    }
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"exception raised: %@ when updating table %@ for field: %@", [exception description], tableName, key);
                }
                @finally {
                }
                
            }
            
        } while (key != nil);
        managedObject = entity;
    }
         [self saveData];
    
    return managedObject;
    
}
- (NSMutableArray*)convertFeed:(NSDictionary *) jsonData
{
    NSMutableArray * itemsArray = [[NSMutableArray alloc] init];
    //get fields types
    NSDictionary *fields = [jsonData objectForKey:@"fields"];
    //get all data of that table
    NSArray *data = [jsonData objectForKey:@"data"];
    for (NSDictionary *item in data) {
        
        //create managedobject by entity name
        NSMutableDictionary * entity = [[NSMutableDictionary alloc] init];
        NSEnumerator *keyEnumerator = [item keyEnumerator];

        //iterate through all keys
        NSString *key = nil;
        do {
            key = [keyEnumerator nextObject];
            if (key != nil) {
                //get the value by key from jSON data
                id value = [item objectForKey:key];
                //get field type by key
                NSString * type = [fields objectForKey:key];
                
                //skip for null values
                if (value == [NSNull null]) {
                    continue;
                }
                
                //assign the value by type
                @try {
                    if ([type isEqualToString:@"int"]) {
                        [entity setValue:[NSNumber numberWithInt:[value intValue]] forKey:key];
                    }else if (([type isEqualToString:@"real"])||([type isEqualToString:@"double"]))
                    {
                        [entity setValue:[NSDecimalNumber numberWithFloat:[value floatValue]] forKey:key];
                    }else if([type isEqualToString:@"timestamp"] || [type isEqualToString:@"datetime"])
                    {
                        [entity setValue:[[[GMRCoreDataModelManager sharedManager] sharedDateFormatter ] dateFromString:value] forKey:key];
                    }
                    else
                    {
                        [entity setValue:value forKey:key];
                    }
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"exception raised: %@ when updating table for field: %@", [exception description], key);
                }
                @finally {
                    
                }
                
            }
            
        } while (key != nil);
        [itemsArray addObject:entity];
        entity = nil;
    }
    

    
    return itemsArray;
    
}
#pragma mark - utility methods
- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
	
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

#pragma mark - database utilities
-(BOOL)saveData{
    
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [self managedObjectContext];
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        
        // push to parent
        NSError *error;
        if (![temporaryContext save:&error])
        {
            // handle error
        }
        
        // save parent to disk asynchronously
        [[self managedObjectContext] performBlock:^{
            NSError *error;
            if (![[self managedObjectContext] save:&error])
            {
                // handle error
            }else
            {
            }
        }];
    }];
//    NSError *error = nil;
//	if (![[self managedObjectContext ]save:&error]) {
//		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//		return FALSE;
//	}else {
//		return TRUE;
//	}
    return TRUE;
}




#pragma mark - update check
- (BOOL)contentUpdatedWithURL:(NSString *)url
{
    //prepare if-modify-since parameter
    //[sharedDateFormatter setDateFormat: @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];
    return YES;
}

- (BOOL)isDataCurrent:(BOOL)staging
{
    //check update once a day
    return YES;
}


- (BOOL)setLastUpdateDate{
    
    return YES;
}

#pragma mark - clean up methods

- (void)cleanVideos
{
    
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (NSDate *)nextDate:(NSDate*) date
{
    // start by retrieving day, weekday, month and year components for yourDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: thisDate options:0];
    return nextDate;
}

+ (NSDate *)dateBegin:(NSDate*) date
{
    // start by retrieving day, weekday, month and year components for yourDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:0];
    [offsetComponents setMinute:0];
    [offsetComponents setSecond:0];
    NSDate *dateBegin = [gregorian dateByAddingComponents:offsetComponents toDate: thisDate options:0];
    return dateBegin;
}

+ (NSDate *)dateEnd:(NSDate*) date
{
    // start by retrieving day, weekday, month and year components for yourDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:23];
    [offsetComponents setMinute:59];
    [offsetComponents setSecond:59];
    NSDate *dateEnd = [gregorian dateByAddingComponents:offsetComponents toDate: thisDate options:0];
    return dateEnd;
}

+ (NSDate *)localDateToDate:(NSDate *)date
{
    
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
}

+ (NSDate *)GMTDateToDate:(NSDate *)date
{
    
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = sourceGMTOffset - destinationGMTOffset;
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
}

- (void)stopProgress
{
    isInProgress = NO;
}

- (NSString *)registerUserViaLogin:(NSString*)userJSONString
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERREGISTERLOGIN, userJSONString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    return jsonData;
}

- (NSString *)postComment:(NSString*)userJSONString
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERPOSTCOMMENT, userJSONString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    return jsonData;
}

- (NSString *)postRatings:(NSString*)userJSONString
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERPOSTRATINGS, userJSONString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    return jsonData;
}
- (NSString *)registerUserViaFB:(NSString*)userJSONString
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERREGISTERLOGINFB, userJSONString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    url =[url urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    return jsonData;
}

- (NSString *)requestUserMovie:(NSString*)userJSONString
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERREGISTERLOGIN, userJSONString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    return jsonData;
}


- (NSString *)suggestUsersMovie:(NSString*)userJSONString
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERSUGGESTMOVIE, userJSONString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    return jsonData;
}
- (UserAccountObject *)getUserAccountForID:(int)userID andType:(NSString*)type
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i&type=%@", URLPREFIX_USERLOGINACCOUNTCHECK, userID,type];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSDictionary * jSONData = [jsonData JSONValue];
    NSArray *data = [jSONData objectForKey:@"data"];
    if ([data count]>0)
    {
        NSDictionary * userLoginDict = [data objectAtIndex:0];
        UserAccountObject * loginUser = [[UserAccountObject alloc] init];
        loginUser.login_type = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"login_type"]];
        loginUser.login_type_id = [[userLoginDict objectForKey:@"login_type_id"] integerValue];
        loginUser.login_id = [[userLoginDict objectForKey:@"login_id"] integerValue];
        return loginUser;
    }
    
    return nil;

    
}

-(NSArray *)getReviewsForMovie:(int)movieID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_MOVIEREVIEWSINFO, movieID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * ratingsArray = [self convertFeed:[jsonData JSONValue]];
    
    return ratingsArray;
}
- (UserLoginInfoObject *)getUserInfoWithUser:(NSString*)userName andPassword:(NSString*)password
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@&pass=%@", URLPREFIX_USERLOGINCHECK, userName,password];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSDictionary * jSONData = [jsonData JSONValue];
    NSArray *data = [jSONData objectForKey:@"data"];
    if ([data count]>0)
    {
        NSDictionary * userLoginDict = [data objectAtIndex:0];
        UserLoginInfoObject * loginUser = [[UserLoginInfoObject alloc] init];
        loginUser.user_complete_name = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_complete_name"]];
        loginUser.user_email = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_email"]];
        loginUser.user_name = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_name"]];
        loginUser.location = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"location"]];
        loginUser.user_password = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_password"]];
        loginUser.login_id = [[userLoginDict objectForKey:@"login_id"] integerValue];
        loginUser.user_image_url = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_image_url"]];
        return loginUser;
    }
        
    return nil;

}
- (UserFBLoginInfoObject*)getFacebookUserInfoForID:(NSString*)userID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERFBINFO, userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    NSDictionary * jSONData = [jsonData JSONValue];
    NSArray *data = [jSONData objectForKey:@"data"];
    if ([data count]>0)
    {
        NSDictionary * userLoginDict = [data objectAtIndex:0];
        UserFBLoginInfoObject * loginUser = [[UserFBLoginInfoObject alloc] init];
        loginUser.fb_login_id = [NSNumber numberWithInt:[[userLoginDict objectForKey:@"fb_login_id"] integerValue]];
        loginUser.user_cover_photo = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"user_cover_photo"]];
        loginUser.facebook_id = [NSString stringWithFormat:@"%@",[userLoginDict objectForKey:@"facebook_id"]];
        return loginUser;
    }
    
    return nil;
}

-(NSArray *)getMoviesWithLimit:(int)movieLimit andPriority:(BOOL)isPriority
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieBasicInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
     if (isPriority)
     {
         NSSortDescriptor *sort = [NSSortDescriptor
                                   sortDescriptorWithKey:@"movie_priority" ascending:NO];
         [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
     }
    
    if (movieLimit != -1)
        [fetchRequest setFetchLimit:movieLimit];

   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        return nil;
    }
   
    return array;
}

-(NSArray *)getFeedsWithLimit:(int)movieLimit
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UserFeedMovie" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor
                              sortDescriptorWithKey:@"date_modified" ascending:NO];
    NSSortDescriptor *sort2 = [NSSortDescriptor
                               sortDescriptorWithKey:@"feed_id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1,sort2, nil]];
    
    if (movieLimit != -1)
        [fetchRequest setFetchLimit:movieLimit];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        return nil;
    }
    
    return array;
}
-(NSArray*)getLiveFeeds
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_LIVEFEEDS, [GMRAppState sharedState].userAccountInfo.login_id];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    NSMutableArray * feedArray = [self convertFeed:[jsonData JSONValue]] ;
    
    NSMutableArray * objectsToRemove = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in feedArray)
        {
            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"feed_comment"]] isEqualToString:@"thinks you might like"])
            {
                NSString * recvUsers = [NSString stringWithFormat:@"%@",[dict objectForKey:@"recv_users_id"]];
                
                NSArray * usersarray = [recvUsers componentsSeparatedByString:@","];
                
                if (![usersarray containsObject:[NSString stringWithFormat:@"%i",[GMRAppState sharedState].userAccountInfo.login_id]])
                {
                    [objectsToRemove addObject:dict];
                }
                
            }
        }
        [feedArray removeObjectsInArray:objectsToRemove];
    return feedArray;
}

-(NSArray*)getTopReviewedMoviesToday
{
    
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@", URLPREFIX_GETTODAYTOPREVIEWED];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        
        if ([[GMRAppState sharedState].todayTopReviewd count]>0)
            return [GMRAppState sharedState].todayTopReviewd;
        else
            return [[NSArray alloc] init];
    }
    NSMutableArray * topReviewed = [[NSMutableArray alloc] init];
    
    NSArray * feedArray = [self convertFeed:[jsonData JSONValue]];
    for (int i=0;i<[feedArray count];i++)
    {
        NSDictionary * feed = [feedArray objectAtIndex:i];
        int movie_id = [[feed objectForKey:@"movie_id"] intValue];
        BOOL alreadyExist = NO;
        for(int j = 0;j<[topReviewed count];j++)
        {
            NSMutableDictionary * reviewed = [(NSDictionary*)[topReviewed objectAtIndex:j] mutableCopy];
            int reviewed_movie_id = [[reviewed objectForKey:@"movie_id"] intValue];
            if (reviewed_movie_id == movie_id)
            {
                alreadyExist = YES;
                int count = [[reviewed objectForKey:@"count"] intValue];
                count++;
                [reviewed setValue:[NSNumber numberWithInt:count] forKey:@"count"];
                [topReviewed replaceObjectAtIndex:j withObject:reviewed];
                break;
            }
        }
        if (!alreadyExist)
        {
            NSMutableDictionary * reviewed = [[NSMutableDictionary alloc] init];
            [reviewed setValue:[NSNumber numberWithInt:movie_id]forKey:@"movie_id"];
            [reviewed setValue:[NSNumber numberWithInt:1] forKey:@"count"];
            [topReviewed addObject:reviewed];
        }
        
    }
    if ([topReviewed count]>0)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray = [topReviewed sortedArrayUsingDescriptors:sortDescriptors];
        topReviewed =[NSMutableArray arrayWithArray:sortedArray];
    }else
    {
        if ([[GMRAppState sharedState].todayTopReviewd count]>0)
            return [GMRAppState sharedState].todayTopReviewd;
    }
    [GMRAppState sharedState].todayTopReviewd = [topReviewed mutableCopy];
    
    return topReviewed;
}

-(NSArray*)getTopRatedMoviesToday
{
    
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@", URLPREFIX_GETTODAYTOPRATED];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        if ([[GMRAppState sharedState].todayTopRated count]>0)
            return [GMRAppState sharedState].todayTopRated;
        else
            return [[NSArray alloc] init];
    }
    NSMutableArray * topRated = [[NSMutableArray alloc] init];
    
    NSArray * feedArray = [self convertFeed:[jsonData JSONValue]];
    for (int i=0;i<[feedArray count];i++)
    {
        NSDictionary * feed = [feedArray objectAtIndex:i];
        int movie_id = [[feed objectForKey:@"movie_id"] intValue];
        BOOL alreadyExist = NO;
        for(int j = 0;j<[topRated count];j++)
        {
            NSMutableDictionary * reviewed = [(NSDictionary*)[topRated objectAtIndex:j] mutableCopy];
            int reviewed_movie_id = [[reviewed objectForKey:@"movie_id"] intValue];
            if (reviewed_movie_id == movie_id)
            {
                alreadyExist = YES;
                int count = [[reviewed objectForKey:@"count"] intValue];
                count++;
                [reviewed setValue:[NSNumber numberWithInt:count] forKey:@"count"];
                [topRated replaceObjectAtIndex:j withObject:reviewed];
                break;
            }
        }
        if (!alreadyExist)
        {
            NSMutableDictionary * reviewed = [[NSMutableDictionary alloc] init];
            [reviewed setValue:[NSNumber numberWithInt:movie_id]forKey:@"movie_id"];
            [reviewed setValue:[NSNumber numberWithInt:1] forKey:@"count"];
            [topRated addObject:reviewed];
        }
        
    }
    if ([topRated count]>0)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"movie_rating" ascending:NO];

        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor1,nil];
        NSArray *sortedArray = [topRated sortedArrayUsingDescriptors:sortDescriptors];
        topRated =[NSMutableArray arrayWithArray:sortedArray];
    }else
    {
        if ([[GMRAppState sharedState].todayTopRated count]>0)
            return [GMRAppState sharedState].todayTopRated;
    }
    [GMRAppState sharedState].todayTopRated = [topRated mutableCopy];
    
    return topRated;
}

-(NSMutableArray*)getAllMoviesData
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieBasicInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
            return nil;
        }
    

    return [array mutableCopy];

}
-(MovieBasicInfo*)getMovieForID:(int)movieID
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieBasicInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"movie_id == %i", movieID];
    [fetchRequest setPredicate:newPredicate];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        MovieBasicInfo * movieInfo = [self downloadMovieForID:movieID];
        if (!movieInfo)
        {
            [[GMRAppState sharedState] checkInternetConnectivity];
            return nil;
        }
        return movieInfo;
    }
    MovieBasicInfo * movieInfo = [array objectAtIndex:0];
    
    return movieInfo;

}

-(BOOL)incrementCommentCountForMovieID:(int)movieID
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieBasicInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"movie_id == %i", movieID];
    [fetchRequest setPredicate:newPredicate];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        return NO;
    }
    MovieBasicInfo * movieInfo = [array objectAtIndex:0];
    movieInfo.movie_comments_count ++;
    
    [self saveData];
    
    return YES;

}

-(BOOL)setAverageValueForMovie:(int)movieID andRatings:(float)ratings
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieBasicInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"movie_id == %i", movieID];
    [fetchRequest setPredicate:newPredicate];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        return NO;
    }
    MovieBasicInfo * movieInfo = [array objectAtIndex:0];
    movieInfo.movie_rating = ratings;
    
    [self saveData];
    
    return YES;
    
}
-(MovieBasicInfo*)downloadMovieForID:(int)movieID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_MOVIEFORID, movieID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    MovieBasicInfo * movieInfo = (MovieBasicInfo*)[self updateTableData:[jsonData JSONValue] withTableName:@"MovieBasicInfo"];

    return movieInfo;

   
}

-(MovieDetailedInfo*)getMovieDetailedForMovieID:(int)movieDetailedID
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieDetailedInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"movie_detailed_id == %i", movieDetailedID];
    [fetchRequest setPredicate:newPredicate];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        MovieDetailedInfo * movieInfo = [self downloadDetailedMovieForID:movieDetailedID];
        return movieInfo;
    }
    
    MovieDetailedInfo * movieInfo = [array objectAtIndex:0];
    
    return movieInfo;
    
}


-(MovieDetailedInfo*)downloadDetailedMovieForID:(int)movieDetailedID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_MOVIEDETAILEDFORID, movieDetailedID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    MovieDetailedInfo * movieInfo = (MovieDetailedInfo*)[self updateTableData:[jsonData JSONValue] withTableName:@"MovieDetailedInfo"];
    
    return movieInfo;
}


-(UserAccount*)getUserAccountForID:(int)userAccountID
{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UserAccount" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"login_id == %i", userAccountID];
    [fetchRequest setPredicate:newPredicate];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        return nil;
    }
    UserAccount * userInfo = [array objectAtIndex:0];
    
    return userInfo;
    
}

-(NSDictionary*)getUserAccountDictionaryForID:(int)userAccountID
{
    
    for (int i = 0; i<[[GMRAppState sharedState].userContactsAccountData count];i++)
    {
        NSDictionary *userAccount = [[GMRAppState sharedState].userContactsAccountData objectAtIndex:i];
        if (userAccountID == [[userAccount objectForKey:@"login_id"] intValue])
        {
            return userAccount;
        }
    }
    
    NSDictionary * userAccount = [self downloadUserAccountForID:userAccountID];
    
    if (userAccount)
    {
        [[GMRAppState sharedState].userContactsAccountData addObject:userAccount];
        return userAccount;
    }

    return nil;
}

-(UserFBLoginInfo*)geFBAccountForID:(int)FBID
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UserFBLoginInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"facebook_id == %i", FBID];
    [fetchRequest setPredicate:newPredicate];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        return nil;
    }
    UserFBLoginInfo * userInfo = [array objectAtIndex:0];
    
    return userInfo;

}

-(NSDictionary*)geFBAccountDictionaryForID:(int)FBID
{
    for (int i = 0; i<[[GMRAppState sharedState].userContactsFBData count];i++)
    {
        NSDictionary *userAccount = [[GMRAppState sharedState].userContactsFBData objectAtIndex:i];
        if (FBID == [[userAccount objectForKey:@"facebook_id"] intValue])
        {
            return userAccount;
        }
    }
    
    NSDictionary * FBAccount = [self downloadFBAccountForID:FBID];
    
    if (FBAccount)
    {
        [[GMRAppState sharedState].userContactsFBData addObject:FBAccount];
        return FBAccount;
    }
    return nil;
    
}

- (NSDictionary *)downloadFBAccountForID:(int)userID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_USERFBACCOUNTINFO, userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * fbAccountsArray = [self convertFeed:[jsonData JSONValue]];
    
    if ([fbAccountsArray count]>0)
    {
        return [fbAccountsArray objectAtIndex:0];
    }
    return nil;
    
}

- (NSDictionary *)downloadUserAccountForID:(int)userID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_USERUSERACCOUNTINFO, userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * fbAccountsArray = [self convertFeed:[jsonData JSONValue]];
    
    if ([fbAccountsArray count]>0)
        return [fbAccountsArray objectAtIndex:0];
    
    return nil;
    
}

-(NSDictionary*)getLoginAccountDictionaryForID:(int)loginID
{
    for (int i = 0; i<[[GMRAppState sharedState].userContactsLoginData count];i++)
    {
        NSDictionary *userAccount = [[GMRAppState sharedState].userContactsLoginData objectAtIndex:i];
        if (loginID == [[userAccount objectForKey:@"login_id"] intValue])
        {
            return userAccount;
        }
    }
    NSDictionary * loginAccount = [self downloadLoginAccountForID:loginID];
    
    if (loginAccount)
    {
        [[GMRAppState sharedState].userContactsLoginData addObject:loginAccount];
        return loginAccount;
    }
    return nil;
    
}

- (NSDictionary *)downloadLoginAccountForID:(int)userID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_USERLOGINACCOUNTINFO, userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * loginAccountsArray = [self convertFeed:[jsonData JSONValue]];
    
    if ([loginAccountsArray count]>0)
        return [loginAccountsArray objectAtIndex:0];
    
    return nil;
    
}

-(NSArray*)getMultipleFBAccounts:(NSString*)FBAccountsString
{
    if ([FBAccountsString isEqualToString:@""])
        return nil;
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_MULTIPLEFBACCOUNTS, FBAccountsString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * fbAccountsArray = [self convertFeed:[jsonData JSONValue]];
    
    return fbAccountsArray;
}

-(NSArray*)getMoviesUserRated:(int)userID
{

    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_GETMOVIESRATEDBYUSER,userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * ratedArray = [self convertFeed:[jsonData JSONValue]];
    
    return ratedArray;
}
-(NSArray*)getMultipleLoginAccounts:(NSString*)loginAccountsString
{
    if ([loginAccountsString isEqualToString:@""])
        return nil;
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_MULTIPLELOGINACCOUNTS, loginAccountsString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * loginAccountsArray = [self convertFeed:[jsonData JSONValue]];
    
    return loginAccountsArray;
}
-(UserLoginInfo*)getLoginAccountForID:(int)loginID
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UserLoginInfo" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    [fetchRequest setEntity:entityDescription];
    
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"login_id == %i", loginID];
    [fetchRequest setPredicate:newPredicate];
    
   	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error || [array count] <= 0) {
        return nil;
    }
    UserLoginInfo * userInfo = [array objectAtIndex:0];
    
    return userInfo;
    
}
- (NSArray *)getRatingsForMovie:(int)movieID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_MOVIERATINGSINFO, movieID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        return [[NSArray alloc] init];
    }
    NSArray * ratingsArray = [self convertFeed:[jsonData JSONValue]];
    
    return ratingsArray;
    
    
}

-(NSArray*)getSuggestedMovieListOfUser:(int)userID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_USERSUGGESTEDMOVIEINFO, userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        if ([GMRAppState sharedState].movieSuggestedToUser)
        {
            return [GMRAppState sharedState].movieSuggestedToUser;
        }else
            return [[NSArray alloc] init];
    }
    
    NSArray * suggestedMoviesArray = [self convertFeed:[jsonData JSONValue]];
    
    if ([suggestedMoviesArray count] == 0)
    {
        if ([GMRAppState sharedState].movieSuggestedToUser)
        {
            return [GMRAppState sharedState].movieSuggestedToUser;
        }
    }
    return suggestedMoviesArray;

}
- (NSArray *)getMultipleUserInfo:(NSString*)userList
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_USERACCOUNTSMULTIPLE, userList];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * usersAccountArray = [self convertFeed:[jsonData JSONValue]];
    
    return usersAccountArray;
    
    
}
-(NSArray *)getContactsForString:(NSString*)searchString
{
    if ([searchString isEqualToString:@""])
    {
        return nil;
    }
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_SEARCHCONTACTS, searchString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * contactsArray = [jsonData JSONValue];
    
    return contactsArray;

}

-(NSArray *)getMoviesForString:(NSString*)searchString
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_SEARCHMOVIES, searchString];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    NSArray * moviesArray = [self convertFeed:[jsonData JSONValue]];
    
    return moviesArray;
    
}

-(NSArray*)getMovieRequestsToUser:(int)userID
{
    
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_GETMOVIESREQUESTEDTOUSER, userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        if ([GMRAppState sharedState].movieRequestsToUser)
            return [GMRAppState sharedState].movieRequestsToUser;
        else
            return[[NSArray alloc] init];

    }
    NSArray * requestedMovies = [self convertFeed:[jsonData JSONValue]];
    
    if ([requestedMovies count] == 0)
    {
        if ([GMRAppState sharedState].movieRequestsToUser)
            return [GMRAppState sharedState].movieRequestsToUser;
    }
        
    return requestedMovies;

    
    
}
-(BOOL)deleteRecommendation:(NSDictionary*)recommendationDictionary
{
    int suggestionID = [[recommendationDictionary objectForKey:@"user_suggest_id"] intValue];
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i&user_id=%i", URLPREFIX_DELETESUGGESTION, suggestionID,[GMRAppState sharedState].userAccountInfo.login_id];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return NO;
    }
    NSDictionary * respDict = [jsonData JSONValue];
    NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
    if ([respString1 isEqualToString:@"success"])
    {
        return YES;
    }
    return NO;

}

-(BOOL)addUserAsFriend:(int)userID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i&friend_id=%i", URLPREFIX_ADDFRIEND, [GMRAppState sharedState].userAccountInfo.login_id,userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return NO;
    }
    NSDictionary * respDict = [jsonData JSONValue];
    NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
    if ([respString1 isEqualToString:@"success"])
    {
        return YES;
    }
    return NO;

}

-(BOOL)removeUserRequestMovieForID:(int)requestedUserID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i&user_id=%i", URLPREFIX_DELETEUSERFROMREQUESTMOVIE,requestedUserID,[GMRAppState sharedState].userAccountInfo.login_id];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return NO;
    }
    NSDictionary * respDict = [jsonData JSONValue];
    NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
    if ([respString1 isEqualToString:@"success"])
    {
        return YES;
    }
    return NO;
}

-(BOOL)checkUserNameAlreadyExists:(NSString*)userName
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_CHECKLOGINUSERNAMEEXISTS,userName];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return YES;
    }
    NSDictionary * respDict = [jsonData JSONValue];
    NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
    if ([respString1 isEqualToString:@"success"])
    {
        return YES;
    }
    
    return NO;

}
-(UserContactsInfoObject*)getUserContacts:(int)userID
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%i", URLPREFIX_USERCONTACTS,userID];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return nil;
    }
    
    NSDictionary * jSONData = [jsonData JSONValue];
    NSArray *data = [jSONData objectForKey:@"data"];
    if ([data count]>0)
    {
        NSDictionary * userContactsDict = [data objectAtIndex:0];
        UserContactsInfoObject * userContacts = [[UserContactsInfoObject alloc] init];
        userContacts.user_contact_id = [[userContactsDict objectForKey:@"user_contact_id"] integerValue];
        userContacts.user_id = [[userContactsDict objectForKey:@"user_id"] integerValue];;
        userContacts.contacts_list = [NSString stringWithFormat:@"%@",[userContactsDict objectForKey:@"contacts_list"]];
        userContacts.favorite_contacts_list = [NSString stringWithFormat:@"%@",[userContactsDict objectForKey:@"favorite_contacts_list"]];
        return userContacts;
    }
    
    return nil;
}

-(BOOL)setUserContactsInfo:(NSString *)jsonValue
{
    NSString * jsonData = nil;
    NSError *err = [NSError new];
    
    //http request for JSON text
    NSString *url = [NSString stringWithFormat:@"%@%@", URLPREFIX_SETUSERCONTACT, jsonValue];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedURL] encoding:NSUTF8StringEncoding error:&err];
    
    //error check
    if (err.code != 0) {
        [[GMRAppState sharedState] checkInternetConnectivity];
        return NO;
    }
    NSDictionary * respDict = [jsonData JSONValue];
    NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
    if ([respString1 isEqualToString:@"success"])
    {
        return YES;
    }
    return NO;

}
-(BOOL)uploadImage:(UIImage*)image andName:(NSString*)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
	// setting up the URL to post to
	NSString *urlString = URLPREFIXIMAGESUPLOAD;
	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
    return YES;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did Receive Response %@", response);
    responseData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Did Finish");
    // Do something with responseData
}
@end
