//
//  MovieRateInfo.m
//  GMRmobile
//
//  Created by   on 18/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "MovieRateInfoObject.h"
#import "NSObject+SBJSON.h"

@implementation MovieRateInfoObject

@synthesize movie_rate_id = _movie_rate_id;
@synthesize movie_id = _movie_id;
@synthesize user_id = _user_id;
@synthesize movie_rating = _movie_rating;


-(NSString*)ToJSONWithID:(BOOL)isAddID
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:[NSNumber numberWithInt:self.movie_id] forKey:@"movie_id"];
    [jsonDict setValue:[NSNumber numberWithInt:self.user_id] forKey:@"user_id"];
    
    [jsonDict setValue:[NSNumber numberWithFloat:self.movie_rating] forKey:@"movie_rating"];
    if (isAddID)
    {
        [jsonDict setValue:@"movie_rate_id"forKey:@"idname"];
        [jsonDict setValue:[NSNumber numberWithInt:self.movie_rate_id] forKey:@"id"];
    }
    [jsonDict setObject:@"MovieRateInfo" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}

@end
