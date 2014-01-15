//
//  Created by   on 04/11/2013.
//

#import "GMRCenterNavigationControllerViewController.h"
#import "UIViewController+GMRDrawerController.h"
#import "GMRSearchView.h"
#import "GMRSearchCell.h"
#import "GMRCoreDataModelManager.h"
#import "GMRCollapsableTableViewController.h"
#import "GMRWallFeedViewController.h"
#import "GMRAppState.h"

@interface GMRCenterNavigationControllerViewController ()

@end

@implementation GMRCenterNavigationControllerViewController

@synthesize searchView = _searchView;
@synthesize searchButton = _searchButton;
@synthesize searchTableView = _searchTableView;



-(void)initialize
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD hide:YES];
}
-(void)toggleLeftDrawer{
    [self.gmr_drawerController toggleDrawerSide:GMRDrawerSideLeft animated:YES completion:nil];
}
-(void)drawerButtonPressed:(id)sender{
    if (self.viewControllers.count == 1) {
        [self toggleLeftDrawer];
    }else{
        [self popViewControllerAnimated:YES];
    }
}
-(void)removeLeftBarButtonItems{
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void)removeRightBarButtonItems{
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
}

-(void)addBackButton{
    
    UIButton *drawerBtn = (UIButton*)[self.navigationBar viewWithTag:GMR_CENTER_NAVIGATION_CONTROLLER_DRAWER_BUTTON_TAG];
    
    if (drawerBtn) {
        return;
    }
    
    drawerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [drawerBtn setBackgroundColor:[UIColor clearColor]];
//    [drawerBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0f]];
//    [drawerBtn setTitle:@"Menu" forState:UIControlStateNormal];
    [drawerBtn setImage:[UIImage imageNamed:@"side_menu_button.png"] forState:UIControlStateNormal];
    
//    [drawerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [drawerBtn setFrame:CGRectMake(-3,0,44,44)];
    drawerBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 0.0f);
    [drawerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [drawerBtn addTarget:self action:@selector(drawerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [drawerBtn setTag:GMR_CENTER_NAVIGATION_CONTROLLER_DRAWER_BUTTON_TAG];
    [self.navigationBar addSubview:drawerBtn];
        
    [self removeLeftBarButtonItems];
}

-(void)addSearchButton{
    
    UIButton *drawerBtn = (UIButton*)[self.navigationBar viewWithTag:GMR_CENTER_NAVIGATION_CONTROLLER_SEARCH_BUTTON_TAG];
    
    if (drawerBtn) {
        [drawerBtn removeFromSuperview];
        drawerBtn = nil;
    }
    
    drawerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [drawerBtn setBackgroundColor:[UIColor clearColor]];
    //    [drawerBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0f]];
    //    [drawerBtn setTitle:@"Menu" forState:UIControlStateNormal];
    [drawerBtn setImage:[UIImage imageNamed:@"searchicon.png"] forState:UIControlStateNormal];
    
    //    [drawerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [drawerBtn setFrame:CGRectMake(274,0,44,44)];
    drawerBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 0.0f);
    [drawerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [drawerBtn addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [drawerBtn setTag:GMR_CENTER_NAVIGATION_CONTROLLER_SEARCH_BUTTON_TAG];
    [self.navigationBar addSubview:drawerBtn];
    
    [self removeRightBarButtonItems];
}

-(void)searchButtonPressed:(id)sender
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GMRSearchView" owner:self options:nil];
    _searchView = (GMRSearchView*)[subviewArray objectAtIndex:0];
    [_searchView.cancelButton addTarget:self action:@selector(searchFieldCancelled:) forControlEvents:UIControlEventTouchUpInside];
    _searchView.delegate = self;
    [_searchView.searchTextField becomeFirstResponder];
    [self.navigationBar addSubview:_searchView];
    
    [searchAutoCompleteArray removeAllObjects];
    int searchViewY = 0;
    if (IS_IOS7)
        searchViewY = 44;
    _searchTableView = [[UITableView alloc] initWithFrame:
                             CGRectMake(0, searchViewY, 320, 120) style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.scrollEnabled = YES;
    _searchTableView.hidden = YES;
    if (IS_IOS7)
        [_searchTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [_searchTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self.topViewController.view addSubview:_searchTableView];
    
}
-(void)searchFieldCancelled:(id)sender
{
    [_searchView removeFromSuperview];
    _searchView = nil;
    [_searchTableView removeFromSuperview];
    _searchTableView = nil;
}

-(void)updateBackButtonTitleForController:(UIViewController*)viewController{
    UIButton *drawerBtn = (UIButton*)[self.navigationBar viewWithTag:GMR_CENTER_NAVIGATION_CONTROLLER_DRAWER_BUTTON_TAG];
    
    if (OSVersionIsAtLeastiOS7()) {
        if (self.viewControllers.count == 1) {
            [drawerBtn setTitle:@"Menu" forState:UIControlStateNormal];
            [drawerBtn setImage:nil forState:UIControlStateNormal];
        }else{
            UIImage *drawerBtnImage = [UIImage imageNamed:@"back_drawer.png"];
            
            UIViewController *prevController = [self.viewControllers objectAtIndex:[self.viewControllers indexOfObject:viewController] - 1];
            
            if (prevController) {
                [drawerBtn setImage:drawerBtnImage forState:UIControlStateNormal];
                [drawerBtn setTitle:[NSString stringWithFormat:@"%@",prevController.title] forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        UIImage *drawerBtnImage = [UIImage imageNamed:@"drawer.png"];
        [drawerBtn setImage:drawerBtnImage forState:UIControlStateNormal];
        [drawerBtn setTitle:nil forState:UIControlStateNormal];
    }

}

-(UIButton*)changeBackButton:(NSString*)buttonImage
{
    UIButton *drawerBtn = (UIButton*)[self.navigationBar viewWithTag:GMR_CENTER_NAVIGATION_CONTROLLER_DRAWER_BUTTON_TAG];
    
    if (drawerBtn) {
        [drawerBtn setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
        return drawerBtn;
        [drawerBtn removeFromSuperview];
        drawerBtn = nil;
    }
    
    drawerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [drawerBtn setBackgroundColor:[UIColor clearColor]];
    //    [drawerBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0f]];
    [drawerBtn setTitle:@"" forState:UIControlStateNormal];
    [drawerBtn setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    
    //    [drawerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [drawerBtn setFrame:CGRectMake(-3,0,44,44)];
    drawerBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 0.0f);

    [drawerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [drawerBtn addTarget:self action:@selector(drawerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [drawerBtn setTag:GMR_CENTER_NAVIGATION_CONTROLLER_DRAWER_BUTTON_TAG];
    [self.navigationBar addSubview:drawerBtn];
    
    [self removeLeftBarButtonItems];
    
    return drawerBtn;

}

-(UIButton*)changeRightButton:(NSString*)buttonImage
{
    UIButton *drawerBtn = (UIButton*)[self.navigationBar viewWithTag:GMR_CENTER_NAVIGATION_CONTROLLER_SEARCH_BUTTON_TAG];
    
    if (drawerBtn) {
        [drawerBtn removeFromSuperview];
        drawerBtn = nil;
    }
    
    drawerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [drawerBtn setBackgroundColor:[UIColor clearColor]];
    //    [drawerBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0f]];
    [drawerBtn setTitle:@"" forState:UIControlStateNormal];
    [drawerBtn setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    
    //    [drawerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [drawerBtn setFrame:CGRectMake(274,0,44,44)];
    drawerBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 0.0f);
    [drawerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [drawerBtn addTarget:self action:@selector(drawerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [drawerBtn setTag:GMR_CENTER_NAVIGATION_CONTROLLER_SEARCH_BUTTON_TAG];
    [self.navigationBar addSubview:drawerBtn];
    
    [self removeRightBarButtonItems];
    
    return drawerBtn;
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
 //   [self updateBackButtonTitleForController:self.topViewController];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    
//    [self updateBackButtonTitleForController:self.topViewController];
    
    return viewController;
}
-(void)setViewControllers:(NSArray *)viewControllers{
    [super setViewControllers:viewControllers];
//    [self updateBackButtonTitleForController:self.topViewController];
}
-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated{
    [super setViewControllers:viewControllers animated:animated];
//    [self updateBackButtonTitleForController:self.topViewController];
}
-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {

        searchAutoCompleteArray = [[NSMutableArray alloc] init];
        searchMovieData = [[GMRCoreDataModelManager sharedManager] getMoviesWithLimit:-1 andPriority:NO];
        if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
            UIImage *image = [UIImage imageNamed:@"header-upper-bar.png"];
            [self.navigationBar setBackgroundColor:[UIColor clearColor]];
            [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
              [self addBackButton];
             [self addSearchButton];
    }
    
    return self;
}

-(void)headerSearchTextChanged:(NSString *)searchText
{
    searchString = searchText;
    
    [searchAutoCompleteArray removeAllObjects];
    
    textChangingDate = [NSDate date];
    
    
    [self performSelector:@selector(searchMoviesWithDelay) withObject:self afterDelay:2.0f];
//    for(MovieBasicInfo *movieInfo in searchMovieData) {
//        
//        NSRange substringRangeLowerCase = [[movieInfo.movie_name lowercaseString] rangeOfString:searchText];
//        
//        if (substringRangeLowerCase.length !=0)
//        {
//            [searchAutoCompleteArray addObject:movieInfo];
//        }
//    }
//    
//    if ([searchAutoCompleteArray count]>0)
//        _searchTableView.hidden = NO;
//    else
//        _searchTableView.hidden = YES;
//    
//    CGFloat height = [searchAutoCompleteArray count] * 30;
//    
//    CGRect tableFrame = self.searchTableView.frame;
//    tableFrame.size.height = height;
//    self.searchTableView.frame = tableFrame;
//    
//    //then the tableView must be redrawn
//    [self.searchTableView setNeedsDisplay];
//    
//    [self.searchTableView reloadData];
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
        searchAutoCompleteArray =[[NSMutableArray alloc] init];
        [_searchTableView reloadData];
        [HUD hide:YES];
        return;
    }
    NSArray * moviesArray = [[GMRCoreDataModelManager sharedManager] getMoviesForString:searchString];
    if (!moviesArray)
    {
        [_searchTableView reloadData];
        [HUD hide:YES];
        return;
    }
    searchAutoCompleteArray = [moviesArray mutableCopy];
    if ([searchAutoCompleteArray count]>0)
        _searchTableView.hidden = NO;
    else
        _searchTableView.hidden = YES;
    
    CGFloat height = [searchAutoCompleteArray count] * 30;
    
    CGRect tableFrame = self.searchTableView.frame;
    tableFrame.size.height = height;
    self.searchTableView.frame = tableFrame;
    
    [self.searchTableView setNeedsDisplay];
    [self.searchTableView reloadData];
    
    [HUD hide:YES];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
	return [searchAutoCompleteArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"GMRSearchCell"];
    
    GMRSearchCell *cell = (GMRSearchCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GMRSearchCell class]])
                
                cell = (GMRSearchCell *)oneObject;
        
    }
    [cell setViews];
    NSDictionary * movieInfo = [searchAutoCompleteArray objectAtIndex:indexPath.row];
    [cell setMovieDictionary:movieInfo];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * movieInfo = [searchAutoCompleteArray objectAtIndex:indexPath.row];
    
    GMRCollapsableTableViewController *  reviewController ;
    reviewController= [[GMRCollapsableTableViewController alloc] initWithNibName:@"GMRCollapsableTableViewController" bundle:nil];
    [reviewController setMovieID:[[movieInfo objectForKey:@"movie_id"] intValue]];
    reviewController.centerNavigationController = self;
    [self pushViewController:reviewController animated:YES];
    [self searchFieldCancelled:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

-(void)goHome
{
    [[GMRAppState sharedState].sideController pressHome];
}

-(void)goBack
{
    
    [self performSelector:@selector(drawerButtonPressed:) withObject:self afterDelay:1.0f];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
