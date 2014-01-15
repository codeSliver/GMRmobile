//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRequestedMoviesController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRRateMovieCell.h"
#import "GMRHistoryRateCell.h"
#import "GMRHistoryReviewCell.h"
#import "GMRHistoryAddFriendCell.h"
#import "GMRAppState.h"
#import "GMRAddMoreFriendsCell.h"
#import "GMRRequestedMovieCell.h"
#import "GMRSuggestMovieController.h"

@interface GMRRequestedMoviesController ()

@end

@implementation GMRRequestedMoviesController


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
    [navigationLabel setText:@"Requested movie suggestion"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = navigationLabel;

    requestedTableView.hidden = NO;
    if (IS_IOS7)
        [requestedTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [requestedTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
    [requestedTableView setBounces:NO];
    
    
    
    [self setUpFriends];
}

-(void)setUpFriends
{
    requestedTableView.dataSource = self;
    requestedTableView.delegate = self;
    if (IS_IOS7)
        [requestedTableView setSeparatorInset:UIEdgeInsetsZero];
    [requestedTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];

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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMRRequestedMovieCell * cell;
    NSString *CellIdentifier = [NSString stringWithFormat:@"GMRRequestedMovieCell"];
        
        cell = (GMRRequestedMovieCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRRequestedMovieCell class]])
                    
                    cell = (GMRRequestedMovieCell *)oneObject;
            
            [cell setViews];
        }
        cell.tag = tableView.tag;
    cell.delegate = self;
        NSDictionary * movieRequestedInfo = [[GMRAppState sharedState].movieRequestsToUser objectAtIndex:indexPath.row];
        [cell setMovieRequested:movieRequestedInfo];
        return cell;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [requestedTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [UIView new];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[GMRAppState sharedState].movieRequestsToUser count];
}

-(void)movieRequestPressed:(NSDictionary *)requestDict
{
    GMRSuggestMovieController *cVC = [[GMRSuggestMovieController alloc] initWithNibName:@"GMRSuggestMovieController" bundle:nil];
    cVC.centerNavigationController = self.centerNavigationController;
    cVC.backButtonType = [NSString stringWithFormat:@"back-arrow.png"];
    [self.centerNavigationController pushViewController:cVC animated:YES];
    [cVC setUser:[[requestDict objectForKey:@"user_id"] intValue]];
    cVC.requestedMovieInfo = requestDict;

}

@end
