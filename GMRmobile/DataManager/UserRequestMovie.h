//
//  UserRequestMovie.h
//  GMRmobile
//
//  Created by   on 22/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserRequestMovie : NSManagedObject

@property (nonatomic, retain) NSNumber * user_request_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * requested_users_id;

@end
