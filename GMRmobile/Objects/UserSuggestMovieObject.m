//
//  UserSuggestMovie.m
//  GMRmobile
//
//  Created by   on 22/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "UserSuggestMovieObject.h"
#import "NSObject+SBJSON.h"

@implementation UserSuggestMovieObject

@synthesize user_suggest_id = _user_suggest_id;
@synthesize user_id = _user_id;
@synthesize movie_id = _movie_id;
@synthesize suggested_users_id = _suggested_users_id;


-(NSString*)ToJSON
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    
    if (self.user_suggest_id)
        [jsonDict setValue:[NSNumber numberWithInt:self.user_suggest_id] forKey:@"user_suggest_id"];
    
    [jsonDict setValue:self.suggested_users_id forKey:@"suggested_users_id"];

    [jsonDict setValue:[NSNumber numberWithInt:self.user_id]forKey:@"user_id"];
    [jsonDict setValue:[NSNumber numberWithInt:self.movie_id]forKey:@"movie_id"];
    [jsonDict setObject:@"UserSuggestMovie" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}
@end
