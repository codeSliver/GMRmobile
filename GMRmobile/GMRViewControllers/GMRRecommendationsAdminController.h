//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "GMRRecommendationCell.h"

@interface GMRRecommendationsAdminController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,RecommendationCellDalegate>
{
    IBOutlet UITableView * recommendationsTableView;
    NSMutableArray * recommendaionsArray;
    NSMutableArray * suggestedMoviesArray;
    
    
}
@end
