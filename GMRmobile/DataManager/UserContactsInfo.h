//
//  UserContactsInfo.h
//  GMRmobile
//
//  Created by   on 21/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserContactsInfo : NSManagedObject

@property (nonatomic) int16_t user_contact_id;
@property (nonatomic) int16_t user_id;
@property (nonatomic, retain) NSString * contacts_list;
@property (nonatomic, retain) NSString * favorite_contacts_list;

@end
