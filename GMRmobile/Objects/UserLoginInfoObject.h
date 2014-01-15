//
//  UserLoginInfo.h
//  GMRmobile
//
//  Created by   on 13/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserLoginInfoObject : NSObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic) int16_t login_id;
@property (nonatomic, retain) NSString * user_cover_photo;
@property (nonatomic, retain) NSString * user_email;
@property (nonatomic, retain) NSString * user_image_url;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * user_password;
@property (nonatomic, retain) NSString * user_complete_name;


-(NSString*)ToJSON;
-(NSString*)ToJSONUpdate;

@end
