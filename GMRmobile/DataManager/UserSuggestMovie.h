//
//  UserSuggestMovie.h
//  GMRmobile
//
//  Created by   on 22/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserSuggestMovie : NSManagedObject

@property (nonatomic) int16_t user_suggest_id;
@property (nonatomic) int16_t user_id;
@property (nonatomic) int16_t movie_id;
@property (nonatomic, retain) NSString * suggested_users_id;

@end
