//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRWriteReviewViewController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRMovieLikeCell.h"
#import "GMRWallFeedViewController.h"
#import "GMRCoreDataModelManager.h"
#import "GMRReviewViewController.h"
#import "GMRAppState.h"

@interface GMRWriteReviewViewController ()

@end

@implementation GMRWriteReviewViewController

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
    
    searchAutoCompleteArray = [[NSMutableArray alloc] init];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    UILabel * navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [navigationLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0f]];
    [navigationLabel setText:@"Write Review"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD hide:YES];
    
    searchString = @"";
    
    titleLabel = [[UILabel alloc] initWithFrame:titleView.frame];
    titleLabel.text = @"What movie would you like to review?";
    titleLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Lato-Light" size:14.0];
    [titleView.superview addSubview:titleLabel];

    movieTableView.hidden = NO;
    if (IS_IOS7)
        [movieTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [movieTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self.centerNavigationController changeBackButton:@"side_menu_button.png"];
    [self.centerNavigationController addSearchButton];
//    movieTableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    [movieTableView setBounces:NO];
    
    [self performSelector:@selector(setUpComments) withObject:self afterDelay:0.2f];
    searchAutoCompleteArray = [[NSMutableArray alloc] init];
    movieTableView.dataSource = self;
    movieTableView.delegate = self;

}

-(void)setUpComments
{    
    topReviewedArray = [[GMRCoreDataModelManager sharedManager] getTopReviewedMoviesToday];
    if ([searchString length] == 0)
    {
        searchAutoCompleteArray =[topReviewedArray mutableCopy];
        [movieTableView reloadData];
    }
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"GMRMovieLikeCell"];
    
    GMRMovieLikeCell * cell = (GMRMovieLikeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GMRMovieLikeCell class]])
                
                cell = (GMRMovieLikeCell *)oneObject;
        
        [cell setViews];
    }
    
    NSDictionary * movieInfo = [searchAutoCompleteArray objectAtIndex:indexPath.row];
    [cell setMovieInfo:movieInfo];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (headerView)
        return headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f]];
    
    NSString * headerMessage = [NSString stringWithFormat:@"Top reviewed movies today"];
    if ([searchString length]>0)
        headerMessage = [NSString stringWithFormat:@"Search movies results.."];
    
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (headerView.frame.size.height-15)/2, 300, 15)];
    [_titleLabel setFont:boldItalicFont];
    [_titleLabel setText:headerMessage];
    _titleLabel.tag = 100;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:_titleLabel];
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * movieInfo = [searchAutoCompleteArray objectAtIndex:indexPath.row];
    
    GMRReviewViewController *  loginVc ;
    if ([GMRAppState sharedState].IS_IPHONE_5)
    {
        loginVc= [[GMRReviewViewController alloc] initWithNibName:@"GMRReviewViewController" bundle:nil];
    }else
    {
        loginVc= [[GMRReviewViewController alloc] initWithNibName:@"GMRReviewViewController_iPhone4" bundle:nil];
    }
    loginVc.centerNavigationController = self.centerNavigationController;
    loginVc.movieID = [[movieInfo objectForKey:@"movie_id"] intValue];
    [self.centerNavigationController pushViewController:loginVc animated:YES];
    [searchField resignFirstResponder];
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}



-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchAutoCompleteArray count];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * prevString = searchString;
    
    searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (([searchString length]>0)&&([searchString length]<3))
    {
        searchString = prevString;
        return YES;
    }
    [searchAutoCompleteArray removeAllObjects];
    
    textChangingDate = [NSDate date];
    

    [self performSelector:@selector(searchMoviesWithDelay) withObject:self afterDelay:2.0f];

    return YES;
}

-(void)searchMoviesWithDelay
{
    if ([[NSDate date] timeIntervalSinceDate:textChangingDate]>=2.0f)
    {
        [HUD show:YES];
        [self performSelector:@selector(searchMovies) withObject:self];
    }else
    {
        [self performSelector:@selector(searchMoviesWithDelay) withObject:self afterDelay:1.0f];
    }
}

-(void)searchMovies
{
    if ([searchString isEqualToString:@""])
    {
        searchAutoCompleteArray =[topReviewedArray mutableCopy];
        UILabel * headerLabel = (UILabel*)[headerView viewWithTag:100];
        [headerLabel setText:@"Top reviewed movies today"];
        [movieTableView reloadData];
        [HUD hide:YES];
        return;
    }
    NSArray * moviesArray = [[GMRCoreDataModelManager sharedManager] getMoviesForString:searchString];
    if (!moviesArray)
    {
        [movieTableView reloadData];
        UILabel * headerLabel = (UILabel*)[headerView viewWithTag:100];
        [headerLabel setText:@"Search movies results.."];
        [HUD hide:YES];
        return;
    }
    searchAutoCompleteArray = [moviesArray mutableCopy];
    if ([searchAutoCompleteArray count]>0)
        movieTableView.hidden = NO;
    else
        movieTableView.hidden = YES;
    
    UILabel * headerLabel = (UILabel*)[headerView viewWithTag:100];
    [headerLabel setText:@"Search movies results.."];
    [movieTableView reloadData];
    [HUD hide:YES];
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-215,self.view.frame.size.width,self.view.frame.size.height)];
    
    [UIView commitAnimations];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                    self.view.frame.origin.y+215,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
