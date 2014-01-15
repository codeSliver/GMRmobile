//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "MBProgressHUD.h"

@interface GMRWriteReviewViewController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView * movieTableView;
    NSArray * topReviewedArray;
    
    IBOutlet UIView * titleView;
    UILabel * titleLabel;
    
    IBOutlet UITextField * searchField;
    
    NSMutableArray * searchAutoCompleteArray;
    NSArray * searchMovieData;
    
    MBProgressHUD * HUD;
    NSString * searchString;
    
    NSDate * textChangingDate;
    
    UIView * headerView;
}
@end
