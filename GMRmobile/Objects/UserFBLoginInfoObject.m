//
//  UserFBLoginInfo.m
//  GMRmobile
//
//  Created by   on 13/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "UserFBLoginInfoObject.h"
#import "NSObject+SBJSON.h"

@implementation UserFBLoginInfoObject

@synthesize fb_login_id = _fb_login_id;
@synthesize user_cover_photo = _user_cover_photo;
@synthesize facebook_id = _facebook_id;
@synthesize user_complete_name = _user_complete_name;
@synthesize location = _location;
@synthesize user_image_url = _user_image_url;

-(NSString*)ToJSONWithID:(BOOL)isAddID
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:self.facebook_id forKey:@"facebook_id"];
    if (self.user_cover_photo)
    {
        [jsonDict setValue:self.user_cover_photo forKey:@"user_cover_photo"];
    }
    if (self.fb_login_id)
    {
        [jsonDict setValue:self.fb_login_id forKey:@"fb_login_id"];
    }
    [jsonDict setValue:self.user_complete_name forKey:@"user_complete_name"];
    [jsonDict setValue:self.location forKey:@"location"];
    [jsonDict setValue:[self.user_image_url stringByReplacingOccurrencesOfString:@"https://" withString:@""] forKey:@"user_image_url"];

    if (isAddID)
    {
        [jsonDict setValue:@"fb_login_id"forKey:@"idname"];
        [jsonDict setValue:self.fb_login_id forKey:@"id"];
    }
    [jsonDict setObject:@"UserFBLoginInfo" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}

@end
