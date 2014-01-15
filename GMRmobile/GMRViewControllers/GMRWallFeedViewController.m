//
//  GMRCollapsableTableViewController.m
//
//  Created by    on 01/10/2013.
//  Copyright (c) 2013 DraftKings, Inc. All rights reserved.
//

#import "GMRWallFeedViewController.h"
#import "GMRSectionInfo.h"
#import "GMRAppDelegate.h"
#import "GMRCollapsableCell.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewViewController.h"
#import "UIImageView+WebCache.h"
#import "GMRAppState.h"
#import "GMRCommentPopUp.h"
#import "GMRMovieGroupLikeCell.h"
#import "GMRSuggestMovieController.h"
#import "GMRHomeCellView.h"
#import "GMRCollapsableTableViewController.h"
#import "GMRUserProfileViewController.h"

@interface GMRWallFeedViewController ()

@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, strong) NSMutableArray *collapsibleSections;
@end

@implementation GMRWallFeedViewController

@synthesize openSectionIndex;
@synthesize collapsibleSections;


- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark - Custom Methods

-(NSMutableArray*)createSectionsData{
    
    if ([[GMRAppState sharedState].feedArray count]>0)
    {
        movieInfoArray = [[NSMutableArray alloc] init];
        for (int i=0;i<[[GMRAppState sharedState].feedArray count];i++)
        {
            if (i>200)
                break;
            [movieInfoArray addObject:[[GMRAppState sharedState].feedArray objectAtIndex:i]];
        }
    }else
    {
        NSArray * liveFeeds = [[GMRCoreDataModelManager sharedManager] getLiveFeeds];
        if (liveFeeds)
        {
            movieInfoArray = [liveFeeds mutableCopy];
            [GMRAppState sharedState].feedArray = [movieInfoArray mutableCopy];
        }
    }
    sectionData = [[NSArray alloc] init];
    return movieInfoArray;
}

-(void)setupView{
    self.collapsibleSections = [self createSectionsData];
    [GMRAppState sharedState].movieReviewRateDictionary = nil;
    [GMRAppState sharedState].movieReviewRateDictionary = [[NSMutableDictionary alloc] init];
    prevSection =-1;
    prevCategory =-1;
    currentSection = -1;
    currentCategory = -1;
    [feedTableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.navigationItem.hidesBackButton = TRUE;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIImage *image = [UIImage imageNamed:@"home-logo-bar.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    
    feedTableView.backgroundColor=[UIColor clearColor];
    feedTableView.separatorColor=[UIColor clearColor];
    feedTableView.showsHorizontalScrollIndicator = NO;
    feedTableView.showsVerticalScrollIndicator = NO;
    [feedTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshFeeds:) forControlEvents:UIControlEventValueChanged];
    [feedTableView addSubview:refreshControl];
    
    isOpen = NO;
    self.openSectionIndex = NSNotFound;
    
    [self setupView];
}


-(void)refreshFeeds:(id)sender
{
    if (isOpen)
    {
        [self sectionClosed:prevSection];
    }
    
    NSArray * tempFeedArray = [GMRAppState sharedState].feedArray;
    
    [GMRAppState sharedState].feedArray = nil;

        NSArray * liveFeeds = [[GMRCoreDataModelManager sharedManager] getLiveFeeds];
        if (liveFeeds)
        {
            movieInfoArray = [liveFeeds mutableCopy];
            [GMRAppState sharedState].feedArray = [movieInfoArray mutableCopy];
        }else
        {
            movieInfoArray = [tempFeedArray mutableCopy];
            [GMRAppState sharedState].feedArray = [movieInfoArray mutableCopy];
        }
    
    self.collapsibleSections = movieInfoArray;
    
    prevSection =-1;
    prevCategory =-1;
    currentSection = -1;
    currentCategory = -1;
    
    [feedTableView reloadData];
    [refreshControl endRefreshing];

    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.collapsibleSections = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.collapsibleSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!isOpen)
        return 0;
    
    if (section != currentSection)
        return 0;
    
    if ([sectionData count] == 0)
        return 0;
    int val = ceil([sectionData count]/5.0f);
    return val;
}

- (UITableViewCell *)tableView:(UITableView *)senderTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMRMovieGroupLikeCell * cell;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"GMRMovieGroupLikeCell"];
    
    cell = (GMRMovieGroupLikeCell*)[senderTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GMRMovieGroupLikeCell class]])
                
                cell = (GMRMovieGroupLikeCell *)oneObject;
        
    }
    int row = indexPath.row;
    int startingIndex = row*5;

    for (int i=0;i<5;i++)
    {
        int currentIndex = startingIndex + i;
        NSMutableDictionary * ratingInfo = [[NSMutableDictionary alloc] init];
        if ([sectionData count] > currentIndex)
        {
            NSDictionary * currentRating = [sectionData objectAtIndex:currentIndex];
            [ratingInfo setObject:[currentRating objectForKey:@"user_id"] forKey:@"user_id"];
            if (currentCategory == 2)
            {
                [ratingInfo setObject:[currentRating objectForKey:@"movie_rating"] forKey:@"rating"];
            }else
            {
                [ratingInfo setObject:[NSNumber numberWithFloat:-1.0f] forKey:@"rating"];
            }
        }else
        {
            [ratingInfo setObject:[NSNumber numberWithInt:-1] forKey:@"user_id"];
        }
        
        switch (i) {
            case 0:
            {
                [(GMRMovieGroupLikeCell *)cell setFirstUser:ratingInfo];
            }
            break;
            case 1:
            {
                [(GMRMovieGroupLikeCell *)cell setSecondUser:ratingInfo];
            }
                break;
            case 2:
            {
                [(GMRMovieGroupLikeCell *)cell setThirdUser:ratingInfo];
            }
                break;
            case 3:
            {
                [(GMRMovieGroupLikeCell *)cell setFourthUser:ratingInfo];
            }
                break;
            case 4:
            {
                [(GMRMovieGroupLikeCell *)cell setFifthUser:ratingInfo];
            }
                break;

            default:
                break;
        }
    }
    
    [cell setAlpha:0.0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1];
    cell.alpha = 1;
    [UIView commitAnimations];
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 143;
}
    
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if (!isOpen)
        return 0;
    
    if (indexPath.section != currentSection)
        return 0;
    
    if ([sectionData count] == 0)
        return 0;
    
    return 69.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *collSect = [self.collapsibleSections objectAtIndex:section];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GMRHomeCellView" owner:self options:nil];
    GMRHomeCellView * headerView = (GMRHomeCellView*)[subviewArray objectAtIndex:0];
    [headerView setViews];
    [headerView setFeedDictionary:collSect];
    headerView.tag = section;
    headerView.commentButton.tag = section;
    headerView.groupButton.tag = section;
    headerView.userImageView.tag = section;
    headerView.movieButton.tag = section;
    [headerView.commentButton addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.groupButton addTarget:self action:@selector(groupPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.userImageView addTarget:self action:@selector(userProfilePressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.movieButton addTarget:self action:@selector(moviePressed:) forControlEvents:UIControlEventTouchUpInside];

    return headerView;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)senderTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [senderTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) sectionClosed : (NSInteger) section{
    
    NSInteger countOfRowsToDelete = [feedTableView numberOfRowsInSection:section];
    
    isOpen = NO;
    if (countOfRowsToDelete > 0)
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        [feedTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

- (void) sectionOpened : (NSInteger) section
{
    if (isOpen)
    {
        [self sectionClosed:prevSection];
    }
    if ([sectionData count] == 0){
        return;
    }
    
    isOpen = YES;
    int count =ceil([sectionData count]/5.0f);
    

    NSMutableArray *indexPathToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<count;i++)
    {
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenIndex = self.openSectionIndex;
    
    if (previousOpenIndex != NSNotFound)
    {
        NSInteger counts = ceil([sectionData count]/5.0f);
        for (NSInteger i = 0; i<counts; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenIndex]];
        }
    }
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenIndex == NSNotFound || section < previousOpenIndex)
    {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else
    {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    [feedTableView beginUpdates];
    [feedTableView insertRowsAtIndexPaths:indexPathToInsert withRowAnimation:insertAnimation];
    [feedTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [feedTableView endUpdates];
    self.openSectionIndex = section;
 //   [feedTableView reloadData];
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(void)moviePressed:(id)sender
{
    int movieId = ((UIButton*)sender).tag;
    NSDictionary * feedInfo = (NSDictionary*)[movieInfoArray objectAtIndex:movieId];
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:[[feedInfo objectForKey:@"movie_id"] intValue]];
    
    if (movieInfo)
    {
        GMRCollapsableTableViewController *  reviewController ;
        reviewController= [[GMRCollapsableTableViewController alloc] initWithNibName:@"GMRCollapsableTableViewController" bundle:nil];
        [reviewController setMovieID:movieInfo.movie_id];
        reviewController.centerNavigationController = self.centerNavigationController;
        [self.centerNavigationController pushViewController:reviewController animated:YES];
    }
}
-(void)userProfilePressed:(id)sender
{
    int userId = ((UIButton*)sender).tag;
    NSDictionary * feedInfo = (NSDictionary*)[movieInfoArray objectAtIndex:userId];
    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[feedInfo objectForKey:@"user_id"] intValue]];
    
    if (userInfo)
    {
        GMRUserProfileViewController *  loginVc ;
        if ([GMRAppState sharedState].IS_IPHONE_5)
        {
            loginVc= [[GMRUserProfileViewController alloc] initWithNibName:@"GMRUserProfileViewController" bundle:nil];
        }else
        {
            loginVc= [[GMRUserProfileViewController alloc] initWithNibName:@"GMRUserProfileViewController_iPhone4" bundle:nil];
        }
        loginVc.centerNavigationController = self.centerNavigationController;
        [self.centerNavigationController pushViewController:loginVc animated:YES];
        [loginVc setUserID:[[userInfo objectForKey:@"login_id"] intValue]];
    }
}

-(void)commentPressed:(id)sender
{
    if ((!(([sender tag] == prevSection)&&(prevCategory == 1)))||(!isOpen))
    {
        prevSectionData = sectionData;
        currentSection = [sender tag];
        currentCategory = 1;
        NSDictionary * movieInfo = [movieInfoArray objectAtIndex:[sender tag]];
        NSArray * reviewMovieArray = [[GMRAppState sharedState].movieReviewRateDictionary objectForKey:[NSString stringWithFormat:@"%@_Review_Data",[movieInfo objectForKey:@"movie_id"]]];
        if (reviewMovieArray)
        {
            sectionData = reviewMovieArray;
        }else
        {
        sectionData =[[GMRCoreDataModelManager sharedManager] getReviewsForMovie:[[movieInfo objectForKey:@"movie_id"] intValue]];
        [[GMRAppState sharedState].movieReviewRateDictionary setObject:sectionData forKey:[NSString stringWithFormat:@"%@_Review_Data",[movieInfo objectForKey:@"movie_id"]]];
        }
        [self sectionOpened:[sender tag]];
        
    }else
    {
        [self sectionClosed:[sender tag]];
    }
    prevSection = [sender tag];
    prevCategory = 1;
}

-(void)groupPressed:(id)sender
{
    if ((!(([sender tag] == prevSection)&&(prevCategory == 2)))||(!isOpen))
    {
        prevSectionData = sectionData;
        currentSection = [sender tag];
        currentCategory = 2;
        NSDictionary * movieInfo = [movieInfoArray objectAtIndex:[sender tag]];
        NSArray * rateMovieArray = [[GMRAppState sharedState].movieReviewRateDictionary objectForKey:[NSString stringWithFormat:@"%@_Rate_Data",[movieInfo objectForKey:@"movie_id"]]];
        if (rateMovieArray)
        {
            sectionData = rateMovieArray;
        }else
        {
            sectionData =[[GMRCoreDataModelManager sharedManager] getRatingsForMovie:[[movieInfo objectForKey:@"movie_id"] intValue]];
            [[GMRAppState sharedState].movieReviewRateDictionary setObject:sectionData forKey:[NSString stringWithFormat:@"%@_Rate_Data",[movieInfo objectForKey:@"movie_id"]]];
        }
        [self sectionOpened:[sender tag]];
        
    }else if (isOpen)
    {
        [self sectionClosed:[sender tag]];
    }
    prevSection = [sender tag];
    prevCategory = 2;
    
}

@end
