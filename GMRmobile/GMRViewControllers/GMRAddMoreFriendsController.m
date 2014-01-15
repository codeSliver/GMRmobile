//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRAddMoreFriendsController.h"
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

@interface GMRAddMoreFriendsController ()

@end

@implementation GMRAddMoreFriendsController

@synthesize delegate = _delegate;
@synthesize selectedFriends = _selectedFriends;

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
    [navigationLabel setText:@"Add More Friends"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;

    moreFriendsTableView.hidden = NO;
    if (IS_IOS7)
        [moreFriendsTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [moreFriendsTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    [self.centerNavigationController addSearchButton];
    [moreFriendsTableView setBounces:NO];
    
    
    
    [self setUpFriends];
}

-(void)setUpFriends
{
    moreFriendsTableView.dataSource = self;
    moreFriendsTableView.delegate = self;
    if (IS_IOS7)
        [moreFriendsTableView setSeparatorInset:UIEdgeInsetsZero];
    [moreFriendsTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    [self.centerNavigationController addSearchButton];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMRAddMoreFriendsCell * cell;
    NSString *CellIdentifier = [NSString stringWithFormat:@"GMRAddMoreFriendsCell"];
        
        cell = (GMRAddMoreFriendsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[GMRAddMoreFriendsCell class]])
                    
                    cell = (GMRAddMoreFriendsCell *)oneObject;
            
            [cell setViews];
            cell.parent = self;
            cell.delegate = self;
        }
        cell.tag = tableView.tag;
        NSDictionary * contactsInfo = [[GMRAppState sharedState].userFriendsAccountData objectAtIndex:indexPath.row];
        [cell setContact:contactsInfo];
        return cell;
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
    return [[GMRAppState sharedState].userFriendsAccountData count];
}


-(IBAction)okPressed:(id)sender
{
    [self.centerNavigationController drawerButtonPressed:nil];
}

-(void)addFriend:(int)friendID
{
    if ([self.delegate respondsToSelector:@selector(addFriend:)])
    {
        [self.delegate addFriend:friendID];
    }
    
    

}
-(void)removeFriend:(int)friendID
{
    if ([self.delegate respondsToSelector:@selector(removeFriend:)])
    {
        [self.delegate removeFriend:friendID];
    }
}
@end
