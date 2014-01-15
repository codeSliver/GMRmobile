//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "GMRRequestedMovieCell.h"


@interface GMRRequestedMoviesController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,RequestedMoviewCellDelegate>
{
    IBOutlet UITableView * requestedTableView;
    NSMutableArray * requestedArray;
    
}

@end
