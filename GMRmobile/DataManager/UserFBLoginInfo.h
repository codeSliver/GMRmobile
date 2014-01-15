//
//  UserFBLoginInfo.h
//  GMRmobile
//
//  Created by   on 18/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserFBLoginInfo : NSManagedObject

@property (nonatomic, retain) NSString * facebook_id;
@property (nonatomic) int16_t fb_login_id;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * user_complete_name;
@property (nonatomic, retain) NSString * user_cover_photo;
@property (nonatomic, retain) NSString * user_image_url;

@end
