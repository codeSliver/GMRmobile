//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"

@interface GMRUserHistoryController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * historyTableView;
    NSMutableArray * historyArray;
    
    
}
@end
