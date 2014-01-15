//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRecommendationsAdminController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRRateMovieCell.h"
#import "GMRHistoryRateCell.h"
#import "GMRHistoryReviewCell.h"
#import "GMRHistoryAddFriendCell.h"
#import "GMRRecommendationCell.h"
#import "GMRAppState.h"

@interface GMRRecommendationsAdminController ()

@end

@implementation GMRRecommendationsAdminController

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
    [navigationLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:13.0f]];
    [navigationLabel setText:@"Suggested movies"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;

    
    recommendationsTableView.hidden = NO;
    if (IS_IOS7)
        [recommendationsTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [recommendationsTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
//    movieTableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    [recommendationsTableView setBounces:NO];
    
    
    
    [self setUpComments];
}

-(void)setUpComments
{
    suggestedMoviesArray = [(NSArray*)[[GMRCoreDataModelManager sharedManager] getSuggestedMovieListOfUser:[GMRAppState sharedState].userAccountInfo.login_id] mutableCopy];
    if (!suggestedMoviesArray)
    {
        [self.centerNavigationController goHome];
    }
    recommendaionsArray = [[NSMutableArray alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy";
    
    NSDateFormatter * serverDateFormatter = [[NSDateFormatter alloc] init];
    serverDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    for (NSDictionary * suggestedMovie in suggestedMoviesArray)
    {
        NSString * suggestedServerString = [NSString stringWithFormat:@"%@",[suggestedMovie objectForKey:@"date_modified"]];
        NSDate * suggestDate = [serverDateFormatter dateFromString:suggestedServerString];
        NSString * suggestedDateString = [dateFormatter stringFromDate:suggestDate];
        BOOL alreadyExist = NO;
        for (NSMutableDictionary * recommendation in recommendaionsArray)
        {
            NSString * dateString = [NSString stringWithFormat:@"%@",[recommendation objectForKey:@"date"]];
            
            if ([dateString isEqualToString:suggestedDateString])
            {
                NSMutableArray * recomArray = [(NSArray*)[recommendation objectForKey:@"RecommendationsArray"] mutableCopy];
                [recomArray addObject:suggestedMovie];
                [recommendation setObject:recomArray forKey:@"RecommendationsArray"];
                alreadyExist = YES;
                break;
            }
            
        }
        if (!alreadyExist)
        {
            NSMutableDictionary * recommendationDict = [[NSMutableDictionary alloc] init];
            [recommendationDict setObject:suggestedDateString forKey:@"date"];
            [recommendationDict setObject:[NSArray arrayWithObject:suggestedMovie] forKey:@"RecommendationsArray"];
            [recommendaionsArray addObject:recommendationDict];
        }
    }
    
    recommendationsTableView.showsHorizontalScrollIndicator = NO;
    recommendationsTableView.showsVerticalScrollIndicator = NO;
    recommendationsTableView.dataSource = self;
    recommendationsTableView.delegate = self;
    if (IS_IOS7)
        [recommendationsTableView setSeparatorInset:UIEdgeInsetsZero];
    [recommendationsTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
    
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * recSection = [recommendaionsArray objectAtIndex:indexPath.section];
    NSArray * recSectionArray = [recSection objectForKey:@"RecommendationsArray"];
    NSDictionary * recRow = [recSectionArray objectAtIndex:indexPath.row];
    
    UITableViewCell * cell;
    
        NSString *CellIdentifier = [NSString stringWithFormat:@"GMRRecommendationCell"];
        
        cell = (GMRRecommendationCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRRecommendationCell class]])
                    
                    cell = (GMRRecommendationCell *)oneObject;
            
            [(GMRRecommendationCell*)cell setViews];
            ((GMRRecommendationCell*)cell).delegate = self;
        }
        [(GMRRecommendationCell*)cell setRecommendation:recRow];
    
return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f]];
    
    NSDictionary * historyDict = [recommendaionsArray objectAtIndex:section];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy";
    
    NSDate * histDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[historyDict objectForKey:@"date"]]];
    
    NSString * histDateString = [self convertDateToStringWithDaySuffix:histDate];
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (headerView.frame.size.height-15)/2, 300, 15)];
    [_titleLabel setFont:boldItalicFont];
    [_titleLabel setText:histDateString];
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
    // Return the number of sections.
    return [recommendaionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * recDict = [recommendaionsArray objectAtIndex:section];
    NSArray * _recArray  = [recDict objectForKey:@"RecommendationsArray"];
    
    return [_recArray count];
}

-(void)deletePressed:(int)suggestionID
{
    for (NSDictionary * suggested in suggestedMoviesArray)
    {
        int suggestion_id = [[suggested objectForKey:@"user_suggest_id"] intValue];
        
        if (suggestion_id == suggestionID)
        {
            [suggestedMoviesArray removeObject:suggested];
            break;
        }
    }
    [recommendaionsArray removeAllObjects];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy";
    
    NSDateFormatter * serverDateFormatter = [[NSDateFormatter alloc] init];
    serverDateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
    for (NSDictionary * suggestedMovie in suggestedMoviesArray)
    {
        NSString * suggestedServerString = [NSString stringWithFormat:@"%@",[suggestedMovie objectForKey:@"date_modified"]];
        NSDate * suggestDate = [serverDateFormatter dateFromString:suggestedServerString];
        NSString * suggestedDateString = [dateFormatter stringFromDate:suggestDate];
        BOOL alreadyExist = NO;
        for (NSMutableDictionary * recommendation in recommendaionsArray)
        {
            NSString * dateString = [NSString stringWithFormat:@"%@",[recommendation objectForKey:@"date"]];
            
            if ([dateString isEqualToString:suggestedDateString])
            {
                NSMutableArray * recomArray = [(NSArray*)[recommendation objectForKey:@"RecommendationsArray"] mutableCopy];
                [recomArray addObject:suggestedMovie];
                [recommendation setObject:recomArray forKey:@"RecommendationsArray"];
                alreadyExist = YES;
                break;
            }
            
        }
        if (!alreadyExist)
        {
            NSMutableDictionary * recommendationDict = [[NSMutableDictionary alloc] init];
            [recommendationDict setObject:suggestedDateString forKey:@"date"];
            [recommendationDict setObject:[NSArray arrayWithObject:suggestedMovie] forKey:@"RecommendationsArray"];
            [recommendaionsArray addObject:recommendationDict];
        }
    }

    [recommendationsTableView reloadData];
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
