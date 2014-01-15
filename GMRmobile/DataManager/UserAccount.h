//
//  UserAccount.h
//  GMRmobile
//
//  Created by   on 18/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserAccount : NSManagedObject

@property (nonatomic) int16_t detailed_id;
@property (nonatomic) int16_t login_id;
@property (nonatomic, retain) NSString * login_type;
@property (nonatomic) int32_t login_type_id;

@end
