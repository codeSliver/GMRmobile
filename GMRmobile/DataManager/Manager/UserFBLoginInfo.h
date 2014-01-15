//
//  UserFBLoginInfo.h
//  GMRmobile
//
//  Created by Nouman Khan on 14/11/13.
//  Copyright (c) 2013 Arslan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserFBLoginInfo : NSManagedObject

@property (nonatomic) int16_t fb_login_id;
@property (nonatomic, retain) NSString * user_cover_photo;
@property (nonatomic, retain) NSString * facebook_id;

@end
