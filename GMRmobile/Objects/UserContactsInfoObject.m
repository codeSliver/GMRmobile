//
//  UserContactsInfo.m
//  GMRmobile
//
//  Created by   on 21/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "UserContactsInfoObject.h"
#import "NSObject+SBJSON.h"

@implementation UserContactsInfoObject

@synthesize user_contact_id=_user_contact_id;
@synthesize user_id=_user_id;
@synthesize contacts_list=_contacts_list;
@synthesize favorite_contacts_list=_favorite_contacts_list;


-(NSString*)ToJSONWithID:(BOOL)isAddID
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:self.contacts_list forKey:@"contacts_list"];
    if (self.user_contact_id)
    {
        [jsonDict setValue:[NSNumber numberWithInt:self.user_contact_id] forKey:@"user_contact_id"];
    }
    
    if (isAddID)
    {
        [jsonDict setValue:@"user_contact_id"forKey:@"idname"];
        [jsonDict setValue:[NSNumber numberWithInt:self.user_contact_id] forKey:@"id"];
    }
    [jsonDict setObject:self.favorite_contacts_list forKey:@"favorite_contacts_list"];
    [jsonDict setObject:@"UserContactsInfo" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}


@end
