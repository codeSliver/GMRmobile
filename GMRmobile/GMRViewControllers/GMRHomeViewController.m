//
//  GMRHomeViewController.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRHomeViewController.h"
#import "GMRHomeCell.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRHomeCellView.h"
#import "GMRGroupUserView.h"
#import "GMRUserProfileViewController.h"
#import "GMRCoreDataModelManager.h"
#import "GMRReviewViewController.h"
#import "GMRCollapsableTableViewController.h"
#import "GMRAppState.h"

@interface GMRHomeViewController ()

@end

@implementation GMRHomeViewController
@synthesize movieTableView;

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
    
    [self setMoviesInfo];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIImage *image = [UIImage imageNamed:@"home-logo-bar.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
    
    previousIndex = -1;
}


-(void)setUpAccordianView
{
    for (int i = 0;i<[movieInfoArray count];i++)
    {
        NSDictionary * feedInfo = (NSDictionary*)[movieInfoArray objectAtIndex:i];
        
        
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GMRHomeCellView" owner:self options:nil];
        GMRHomeCellView * headerView = (GMRHomeCellView*)[subviewArray objectAtIndex:0];
        [headerView setViews];
        [headerView setFeedDictionary:feedInfo];
        
        
        subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GMRGroupUserView" owner:self options:nil];
        GMRGroupUserView * myView = (GMRGroupUserView*)[subviewArray objectAtIndex:0];

        int rand = [self getRandomBTWLow:1 andMax:4];
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myView.frame.size.width, myView.frame.size.height*rand)];
        for (int i = 0; i< rand; i++)
        {
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GMRGroupUserView" owner:self options:nil];
            GMRGroupUserView * myView1 = (GMRGroupUserView*)[subviewArray objectAtIndex:0];
            [myView1 setFrame:CGRectMake(0, i*myView.frame.size.height, myView.frame.size.width, myView.frame.size.height)];
            [view1 addSubview:myView1];
        }
        
        [accordianView addHeader:headerView withView:view1];

    }
}
-(void)setMoviesInfo
{
    if ([[GMRAppState sharedState].feedArray count]>0)
    {
        movieInfoArray = [[NSMutableArray alloc] init];
        for (int i=0;i<[[GMRAppState sharedState].feedArray count];i++)
        {
            if (i>50)
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
    if (!accordianView)
    {
        accordianView = [[AccordionView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:accordianView];
        [accordianView setBackgroundColor:[UIColor whiteColor]];
        accordianView.delegate=self;
        [self setUpAccordianView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(int)getRandomBTWLow:(int)min andMax:(int)max
{
    int randNum = rand() % (max - min) + min; //create the random number.
    
    return randNum;
}

- (void)accordion:(AccordionView *)accordion didChangeSelection:(NSIndexSet *)selection;
{
    if ([selection count]>0)
    {
        int index = [selection firstIndex];
        
        if (previousIndex == index)
            return;
        previousIndex = index;
        if (index == [movieInfoArray count] - 1 )
        {
            
            [accordianView moveLastScrollItem];
        }
    }
}

-(void)userProfilePressed:(int)userID
{
    NSDictionary * feedInfo = (NSDictionary*)[movieInfoArray objectAtIndex:userID];
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

-(void)moviePressed:(int)movieID
{
    NSDictionary * feedInfo = (NSDictionary*)[movieInfoArray objectAtIndex:movieID];
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
@end
