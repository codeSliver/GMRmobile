//
//  UserAccount.h
//  GMRmobile
//
//  Created by   on 13/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserAccountObject : NSObject

@property (nonatomic) int detailed_id;
@property (nonatomic) int login_id;
@property (nonatomic, retain) NSString * login_type;
@property (nonatomic) int login_type_id;

-(NSString*)ToJSON;

@end
