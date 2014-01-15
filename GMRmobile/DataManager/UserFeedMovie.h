//
//  UserFeedMovie.h
//  GMRmobile
//
//  Created by   on 18/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserFeedMovie : NSManagedObject

@property (nonatomic) NSTimeInterval date_modified;
@property (nonatomic, retain) NSString * feed_comment;
@property (nonatomic) int16_t feed_id;
@property (nonatomic) int16_t movie_id;
@property (nonatomic) int16_t user_id;

@end
