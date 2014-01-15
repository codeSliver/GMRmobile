//
//  UserAccount.m
//  GMRmobile
//
//  Created by   on 13/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "MovieReviewInfoObject.h"
#import "NSObject+SBJSON.h"

@implementation MovieReviewInfoObject

@synthesize movie_review_info = _movie_review_info;
@synthesize movie_id = movie_id;
@synthesize user_id = _user_id;
@synthesize user_review = _user_review;


-(NSString*)ToJSON
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    if (self.movie_review_info)
        [jsonDict setValue:[NSNumber numberWithInt:self.movie_review_info]forKey:@"movie_review_info"];
    
    [jsonDict setValue:[NSNumber numberWithInt:self.movie_id]forKey:@"movie_id"];
    [jsonDict setValue:self.user_review forKey:@"user_review"];
    [jsonDict setValue:[NSNumber numberWithInt:self.user_id]forKey:@"user_id"];
    [jsonDict setObject:@"MovieReviewInfo" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}

@end
