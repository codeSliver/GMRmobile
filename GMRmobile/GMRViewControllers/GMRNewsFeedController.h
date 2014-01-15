//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "GMRNewsFeedWebController.h"

@interface GMRNewsFeedController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * rssTableView;
    NSOperationQueue *_queue;
    NSArray *_feeds;
    NSMutableArray *_allEntries;
    
}

@property (retain) NSOperationQueue *queue;
@property (retain) NSArray *feeds;
@property (retain) NSMutableArray *allEntries;
@property (retain) GMRNewsFeedWebController *webViewController;
@end
