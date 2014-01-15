//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "MBProgressHUD.h"
#import "GMRContactsCell.h"
#import "GMRSearchContactsCell.h"

@interface GMRContactsViewController : GMRBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,ContactCellDalegate,SearchContactCellDalegate>
{
    NSMutableArray * allUsersArray;
    
    NSMutableArray * favoritesArray;
    
    NSMutableArray * searchArray;
    NSMutableArray * searchAutoCompleteArray;
    
    IBOutlet UIView * allView;
    IBOutlet UITableView * allTableView;
    
    IBOutlet UIView * favoritesView;
    IBOutlet UITableView * favoritesTableView;
    
    IBOutlet UIView * searchView;
    IBOutlet UITextField * searchField;
    IBOutlet UITableView * searchTableView;
    
    IBOutlet UIButton * allButton;
    IBOutlet UIButton * favoritesButton;
    IBOutlet UIButton * searchButton;
    int prevTab;
    int tabToEnable;
    
    NSString * searchString;
    NSDate * textChangingDate;
    MBProgressHUD * HUD;
}

-(IBAction)toggleButtonPressed:(id)sender;
-(void)enableTab:(int)tabToEnable;
@end
