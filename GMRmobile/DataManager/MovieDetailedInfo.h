//
//  MovieDetailedInfo.h
//  GMRmobile
//
//  Created by   on 27/11/13.
//  Copyright (c) 2013 Arslan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MovieDetailedInfo : NSManagedObject

@property (nonatomic) NSTimeInterval date_modified;
@property (nonatomic) int16_t movie_detailed_id;
@property (nonatomic, retain) NSString * movie_facebook_link;
@property (nonatomic, retain) NSString * movie_twitter_link;

@end
