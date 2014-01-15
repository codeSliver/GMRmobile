//
//  UserAccount.m
//  GMRmobile
//
//  Created by   on 13/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "UserAccountObject.h"
#import "NSObject+SBJSON.h"

@implementation UserAccountObject

@synthesize detailed_id = _detailed_id;
@synthesize login_id = _login_id;
@synthesize login_type = _login_type;
@synthesize login_type_id = _login_type_id;


-(NSString*)ToJSON
{
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    if (self.detailed_id)
        [jsonDict setValue:[NSNumber numberWithInt:self.detailed_id]forKey:@"detailed_id"];
    if (self.login_id)
        [jsonDict setValue:[NSNumber numberWithInt:self.login_id]forKey:@"login_id"];
    [jsonDict setValue:self.login_type forKey:@"login_type"];
    [jsonDict setValue:[NSNumber numberWithInt:self.login_type_id]forKey:@"login_type_id"];
    [jsonDict setObject:@"UserAccount" forKey:@"tablename"];
    NSString *jsonString = [jsonDict JSONRepresentation];
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    return jsonString;
    
}

@end
