//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"

@class GMRCollapsableTableViewController;
@interface GMRReviewViewController : GMRBaseViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * reviewTableView;
    NSArray * commentsArray;
    BOOL beginEditing;
    IBOutlet UIView * bottomView;
    
    IBOutlet UIImageView * movieImageView;
    
    IBOutlet UIView * movieNameView;
    UILabel * movieNameLabel;
    
    IBOutlet UITextField * commentField;
}

@property (nonatomic) int movieID;
@property (nonatomic,strong) GMRCollapsableTableViewController * parentController;

-(IBAction)sendComment:(id)sender;

@end
