//
//  UserAccount.h
//  GMRmobile
//
//  Created by   on 13/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MovieReviewInfoObject : NSObject
{
    
}
@property (nonatomic) int movie_review_info;
@property (nonatomic) int movie_id;
@property (nonatomic, retain) NSString * user_review;
@property (nonatomic) int user_id;

-(NSString*)ToJSON;

@end
