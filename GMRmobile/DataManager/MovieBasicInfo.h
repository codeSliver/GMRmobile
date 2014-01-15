//
//  MovieBasicInfo.h
//  GMRmobile
//
//  Created by   on 12/12/13.
//  Copyright (c) 2013 Arslan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MovieBasicInfo : NSManagedObject

@property (nonatomic) NSTimeInterval date_modified;
@property (nonatomic, retain) NSString * movie_cast;
@property (nonatomic) int16_t movie_comments_count;
@property (nonatomic, retain) NSString * movie_description;
@property (nonatomic) int16_t movie_detailed_id;
@property (nonatomic, retain) NSString * movie_genre;
@property (nonatomic) int16_t movie_groups_count;
@property (nonatomic) int16_t movie_id;
@property (nonatomic, retain) NSString * movie_image_url;
@property (nonatomic, retain) NSString * movie_name;
@property (nonatomic) int16_t movie_priority;
@property (nonatomic) double movie_rating;
@property (nonatomic, retain) NSString * movie_released_date;
@property (nonatomic) int16_t movie_rt_id;
@property (nonatomic, retain) NSString * movie_popularity;

@end
