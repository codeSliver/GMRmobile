//
//  MovieRateInfo.h
//  GMRmobile
//
//  Created by   on 18/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MovieRateInfoObject : NSObject

@property (nonatomic) int16_t movie_rate_id;
@property (nonatomic) int16_t movie_id;
@property (nonatomic) int16_t user_id;
@property (nonatomic) double movie_rating;

-(NSString*)ToJSONWithID:(BOOL)isAddID;
@end
