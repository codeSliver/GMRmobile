//
//  UserContactsInfo.h
//  GMRmobile
//
//  Created by   on 21/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserContactsInfoObject : NSObject

@property (nonatomic) int16_t user_contact_id;
@property (nonatomic) int16_t user_id;
@property (nonatomic, retain) NSString * contacts_list;
@property (nonatomic, retain) NSString * favorite_contacts_list;

-(NSString*)ToJSONWithID:(BOOL)isAddID;
@end
