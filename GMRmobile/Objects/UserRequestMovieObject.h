//
//  UserRequestMovie.h
//  GMRmobile
//
//  Created by   on 22/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserRequestMovieObject : NSObject

@property (nonatomic) int16_t user_request_id;
@property (nonatomic) int16_t user_id;
@property (nonatomic,strong) NSString * requested_users_id;

-(NSString*)ToJSON;

@end
