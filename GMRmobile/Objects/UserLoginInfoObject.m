//
//  UserLoginInfo.m
//  GMRmobile
//
//  Created by   on 13/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "UserLoginInfoObject.h"
#import "NSObject+SBJSON.h"

@implementation UserLoginInfoObject

@synthesize location = _location;
@synthesize login_id = _login_id;
@synthesize user_cover_photo = _user_cover_photo;
@synthesize user_email = _user_email;
@synthesize user_image_url = _user_image_url;
@synthesize user_name = _user_name;
@synthesize user_password = _user_password;
@synthesize user_complete_name = _user_complete_name;


-(NSString*)ToJSON
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:self.location forKey:@"location"];
    [jsonDict setValue:self.user_name forKey:@"user_name"];
    [jsonDict setValue:self.user_password forKey:@"user_password"];
    [jsonDict setValue:self.user_email forKey:@"user_email"];
    [jsonDict setValue:self.user_complete_name forKey:@"user_complete_name"];
    
    if (self.user_cover_photo)
    {
        [jsonDict setValue:self.user_cover_photo forKey:@"user_cover_photo"];
    }
    if (self.user_image_url)
    {
        [jsonDict setValue:self.user_image_url forKey:@"user_image_url"];
    }
    if (self.login_id)
    {
        [jsonDict setValue:[NSNumber numberWithInt:self.login_id] forKey:@"login_id"];
    }
    
    [jsonDict setObject:@"UserLoginInfo" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;

}

-(NSString*)ToJSONUpdate
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:self.location forKey:@"location"];
    [jsonDict setValue:self.user_name forKey:@"user_name"];
    [jsonDict setValue:self.user_password forKey:@"user_password"];
    [jsonDict setValue:self.user_email forKey:@"user_email"];
    [jsonDict setValue:self.user_complete_name forKey:@"user_complete_name"];
    
    if (self.user_cover_photo)
    {
        [jsonDict setValue:self.user_cover_photo forKey:@"user_cover_photo"];
    }
    if (self.user_image_url)
    {
        [jsonDict setValue:self.user_image_url forKey:@"user_image_url"];
    }
    if (self.login_id)
    {
        [jsonDict setValue:[NSNumber numberWithInt:self.login_id] forKey:@"login_id"];
        [jsonDict setValue:@"login_id"forKey:@"idname"];
        [jsonDict setValue:[NSNumber numberWithInt:self.login_id] forKey:@"id"];
        
    }
    
    [jsonDict setObject:@"UserLoginInfo" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}

@end
