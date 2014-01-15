//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRUserHistoryController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRRateMovieCell.h"
#import "GMRHistoryRateCell.h"
#import "GMRHistoryReviewCell.h"
#import "GMRHistoryAddFriendCell.h"
#import "GMRAppState.h"

@interface GMRUserHistoryController ()

@end

@implementation GMRUserHistoryController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel * navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [navigationLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0f]];
    [navigationLabel setText:@"History"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;

    historyTableView.hidden = NO;
    if (IS_IOS7)
        [historyTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [historyTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
//    movieTableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    [historyTableView setBounces:NO];
    
    
    
    [self setUpComments];
}

-(void)setUpComments
{
    historyTableView.dataSource = self;
    historyTableView.delegate = self;
    if (IS_IOS7)
        [historyTableView setSeparatorInset:UIEdgeInsetsZero];
    [historyTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
    
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * histArray = [[GMRAppState sharedState].userHistoryData objectForKey:@"userHistoryArray"];
    NSDictionary * historySection = [histArray objectAtIndex:indexPath.section];
    NSArray * historySectionArray = [historySection objectForKey:@"dateHistArray"];
    NSDictionary * historyRow = [historySectionArray objectAtIndex:indexPath.row];
    NSString * historyType = [NSString stringWithFormat:@"%@",[historyRow objectForKey:@"historyType"]];
    
    UITableViewCell * cell;
    
    if ([historyType isEqualToString:@"rate"])
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRHistoryRateCell"];
        
        cell = (GMRHistoryRateCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRHistoryRateCell class]])
                    
                    cell = (GMRHistoryRateCell *)oneObject;
            
            [(GMRHistoryRateCell*)cell setViews];
        }
        [(GMRHistoryRateCell*)cell setHistoryReview:historyRow];
    }else if ([historyType isEqualToString:@"review"])
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRHistoryReviewCell"];
        
        cell = (GMRHistoryReviewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRHistoryReviewCell class]])
                    
                    cell = (GMRHistoryReviewCell *)oneObject;
            
            [(GMRHistoryReviewCell*)cell setViews];
        }
        [(GMRHistoryReviewCell*)cell setHistoryReview:historyRow];
    }else if ([historyType isEqualToString:@"addfriend"])
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRHistoryAddFriendCell"];
        
        cell = (GMRHistoryAddFriendCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRHistoryAddFriendCell class]])
                    
                    cell = (GMRHistoryAddFriendCell *)oneObject;
            
            [(GMRHistoryAddFriendCell*)cell setViews];
        }
        [(GMRHistoryAddFriendCell*)cell setUserDictionary:historyRow];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f]];
    
    NSArray * histArray = [[GMRAppState sharedState].userHistoryData objectForKey:@"userHistoryArray"];
    NSDictionary * historyDict = [histArray objectAtIndex:section];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy";
    
    NSDate * histDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[historyDict objectForKey:@"date"]]];
    
    NSString * histDateString = [self convertDateToStringWithDaySuffix:histDate];
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (headerView.frame.size.height-15)/2, 300, 15)];
    [_titleLabel setFont:boldItalicFont];
    [_titleLabel setText:histDateString];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextColor:[UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0f]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:_titleLabel];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray * histArray = [[GMRAppState sharedState].userHistoryData objectForKey:@"userHistoryArray"];
    return [histArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * histArray = [[GMRAppState sharedState].userHistoryData objectForKey:@"userHistoryArray"];
    NSDictionary * historyDict = [histArray objectAtIndex:section];
    NSArray * _histArray = [historyDict objectForKey:@"dateHistArray"];
    return [_histArray count];
}

-(NSString*)convertDateToStringWithDaySuffix:(NSDate*)date
{
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init] ;
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"dd"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    NSString * replacement = [NSString stringWithFormat:@"%@ ",suffix];
    NSRange rOriginal = [prefixDateString rangeOfString: @" "];
    if (NSNotFound != rOriginal.location) {
        prefixDateString = [prefixDateString
                    stringByReplacingCharactersInRange: rOriginal
                    withString:                         replacement];
    }
    return prefixDateString;
    
}

@end
