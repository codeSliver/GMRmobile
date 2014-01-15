//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRMovieChartsController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRRateMovieCell.h"
#import "GMRHistoryRateCell.h"
#import "GMRHistoryReviewCell.h"
#import "GMRHistoryAddFriendCell.h"
#import "GMRAppState.h"
#import "GMRSearchCell.h"
#import "GMRCollapsableTableViewController.h"

@interface GMRMovieChartsController ()

@end

@implementation GMRMovieChartsController

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
    [navigationLabel setText:@"Charts"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;

    chartsTableView.hidden = NO;
    if (IS_IOS7)
        [chartsTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [chartsTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
//    movieTableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    [chartsTableView setBounces:NO];
    
    chartsTableView.dataSource = self;
    chartsTableView.delegate = self;
    if (IS_IOS7)
        [chartsTableView setSeparatorInset:UIEdgeInsetsZero];
    [chartsTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    
    boxOfficeArray = [[NSMutableArray alloc] init];
    inTheatures = [[NSMutableArray alloc] init];
    openingArray = [[NSMutableArray alloc] init];
    upcomingArray = [[NSMutableArray alloc] init];
    
    [self setUpComments];
}

-(void)setUpComments
{
    if (![GMRAppState sharedState].chartsArray)
        [GMRAppState sharedState].chartsArray = [[GMRCoreDataModelManager sharedManager] getAllMoviesData];
    
    
    
    if (![GMRAppState sharedState].chartsArray)
        return;
    
    for (MovieBasicInfo * movieDict in [GMRAppState sharedState].chartsArray)
    {
        NSString * movieType = movieDict.movie_popularity;
        
        if ([movieType isEqualToString:@"Box Office"])
        {
            [boxOfficeArray addObject:movieDict];
        }else if ([movieType isEqualToString:@"In Theatures"])
        {
            [inTheatures addObject:movieDict];
        }else if ([movieType isEqualToString:@"Upcoming"])
        {
            [upcomingArray addObject:movieDict];
        }else if ([movieType isEqualToString:@"Opening"])
        {
            [openingArray addObject:movieDict];
        }
    }

    [chartsTableView reloadData];
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
    NSArray * movieArray ;
    
    switch (indexPath.section) {
        case 0:
        {
            movieArray = boxOfficeArray;
        }
            break;
        case 1:
        {
            movieArray = inTheatures;
        }
            break;
        case 2:
        {
            movieArray = upcomingArray;
        }
            break;
        case 3:
        {
            movieArray = openingArray;
        }
            break;
        default:
            break;
    }
    NSString *CellIdentifier = [NSString stringWithFormat:@"GMRSearchCell"];
    
    GMRSearchCell *cell = (GMRSearchCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GMRSearchCell class]])
                
                cell = (GMRSearchCell *)oneObject;
        
    }
    [cell setViews];
    MovieBasicInfo * movieInfo = [movieArray objectAtIndex:indexPath.row];
    [cell setMovieInfo:movieInfo];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f]];
    
    NSString * titleString = @"Box Office";
    switch (section) {
        case 0:
            titleString = @"Box Office";
            break;
        case 1:
            titleString = @"In Theatures";
            break;
        case 2:
            titleString = @"Upcoming";
            break;
        case 3:
            titleString = @"Opening";
            break;
        default:
            break;
    }
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (headerView.frame.size.height-15)/2, 300, 15)];
    [_titleLabel setFont:boldItalicFont];
    [_titleLabel setText:titleString];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [boxOfficeArray count];
            break;
        case 1:
            return [inTheatures count];
            break;
        case 2:
            return [upcomingArray count];
            break;
        case 3:
            return [openingArray count];
            break;
        default:
            break;
    }
    return [boxOfficeArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * movieArray ;
    
    switch (indexPath.section) {
        case 0:
        {
            movieArray = boxOfficeArray;
        }
            break;
        case 1:
        {
            movieArray = inTheatures;
        }
            break;
        case 2:
        {
            movieArray = upcomingArray;
        }
            break;
        case 3:
        {
            movieArray = openingArray;
        }
            break;
        default:
            break;
    }

    MovieBasicInfo * movieInfo = [movieArray objectAtIndex:indexPath.row];
    GMRCollapsableTableViewController *  reviewController ;
    reviewController= [[GMRCollapsableTableViewController alloc] initWithNibName:@"GMRCollapsableTableViewController" bundle:nil];
    [reviewController setMovieID:movieInfo.movie_id];
    reviewController.centerNavigationController = self.centerNavigationController;
    [self.centerNavigationController pushViewController:reviewController animated:YES];
}

@end
