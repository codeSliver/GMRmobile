//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "MBProgressHUD.h"
#import "GMRRateMovieView.h"

@interface GMRRateMovieController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,RateMovieViewDelegate>
{
    IBOutlet UITableView * movieTableView;
    NSArray * topRatedArray;
    NSMutableArray * movieArray;
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
    
    IBOutlet UITextField * searchField;
    
    NSMutableArray * searchAutoCompleteArray;
    NSArray * searchMovieData;
    
    MBProgressHUD * HUD;
    NSString * searchString;
    
    NSDate * textChangingDate;
}
@end
