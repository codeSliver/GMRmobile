//
//  UserRequestMovie.m
//  GMRmobile
//
//  Created by   on 22/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "UserRequestMovieObject.h"
#import "NSObject+SBJSON.h"

@implementation UserRequestMovieObject

@synthesize user_request_id = _user_request_id;
@synthesize user_id = _user_id;
@synthesize requested_users_id = _requested_users_id;


-(NSString*)ToJSON
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    
    if (self.user_request_id)
        [jsonDict setValue:[NSNumber numberWithInt:self.user_request_id] forKey:@"user_request_id"];
    
    [jsonDict setValue:self.requested_users_id forKey:@"requested_users_id"];
    
    [jsonDict setValue:[NSNumber numberWithInt:self.user_id]forKey:@"user_id"];
    [jsonDict setObject:@"UserRequestMovie" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}

@end
