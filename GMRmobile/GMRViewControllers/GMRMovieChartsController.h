//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"

@interface GMRMovieChartsController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * chartsTableView;
    NSMutableArray * chartsArray;
    NSMutableArray * boxOfficeArray;
    NSMutableArray * inTheatures;
    NSMutableArray * openingArray;
    NSMutableArray * upcomingArray;
    
    
}
@end
