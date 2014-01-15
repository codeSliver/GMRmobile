//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRReviewViewController.h"
#import "GMRCenterNavigationControllerViewController.h"
#import "GMRReviewCell.h"
#import "GMRCoreDataModelManager.h"
#import "MovieReviewInfoObject.h"
#import "GMRAppState.h"
#import "GMRCollapsableTableViewController.h"
#import "GMRUserProfileViewController.h"

@interface GMRReviewViewController ()

@end

@implementation GMRReviewViewController

@synthesize movieID = _movieID;
@synthesize parentController = _parentController;

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
    
    beginEditing= NO;

    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIImage *image = [UIImage imageNamed:@"home-logo-bar.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    [self.centerNavigationController addSearchButton];
    if (IS_IOS7)
        [reviewTableView setSeparatorInset:UIEdgeInsetsZero];
    [reviewTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    [self loadMovieData];
    
    if (!IS_IOS7)
    {
        [self performSelector:@selector(arrangeViews) withObject:self afterDelay:0.2f];
    }
}
-(void)arrangeViews
{
    [bottomView setFrame:CGRectMake(bottomView.frame.origin.x,
                                    bottomView.frame.origin.y,
                                    bottomView.frame.size.width,
                                    bottomView.frame.size.height)];
}
-(void)loadMovieData
{
    MovieBasicInfo * movieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:self.movieID];
    if (!movieInfo)
    {
        [self.centerNavigationController drawerButtonPressed:nil];
    }
//    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,movieInfo.movie_image_url];
    [movieImageView setHidden:YES];
    UIImageView * movieImage = [[UIImageView alloc] initWithFrame:movieImageView.frame];
    [movieImage setContentMode:UIViewContentModeScaleAspectFill];
    [movieImage setClipsToBounds:YES];
    [movieImageView.superview addSubview:movieImage];
    [movieImage setImageWithURL:[NSURL URLWithString:movieInfo.movie_image_url] placeholderImage:[UIImage imageNamed:@"poster.png"] options:SDWebImageRetryFailed];
    
    int paddingY = 0;
    if (!IS_IOS7)
        paddingY = -10;
    movieNameLabel= [[UILabel alloc] initWithFrame:CGRectMake(movieNameView.frame.origin.x, movieNameView.frame.origin.y+paddingY, movieNameView.frame.size.width, movieNameView.frame.size.height)];
    movieNameLabel.textAlignment = NSTextAlignmentLeft;
    movieNameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:25.0f];
    movieNameLabel.text = movieInfo.movie_name;
    movieNameLabel.textColor = [UIColor colorWithRed:248.0f/255.0f green:200.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    
    [movieNameView.superview addSubview:movieNameLabel];
    [self performSelector:@selector(setUpComments) withObject:self afterDelay:0.2f];
    commentsArray = [[NSMutableArray alloc] init];
    reviewTableView.dataSource = self;
    reviewTableView.delegate = self;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    [self.centerNavigationController addSearchButton];
    


}

-(void)refreshPropertyList:(id)sender
{
    
}
-(void)setUpComments
{
    commentsArray = [[[GMRCoreDataModelManager sharedManager] getReviewsForMovie:self.movieID] mutableCopy];

    [reviewTableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * commentInfo = [commentsArray objectAtIndex:indexPath.row];
    NSString * commentsString = [NSString stringWithFormat:@"%@",[commentInfo objectForKey:@"user_review"]];
    CGSize size = [commentsString sizeWithFont:[UIFont fontWithName:@"Lato-Light" size:11]
                             constrainedToSize:CGSizeMake(280, 10000)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height+ 105+10;

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"GMRReviewCell"];
    
    GMRReviewCell * cell = (GMRReviewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GMRReviewCell class]])
                
                cell = (GMRReviewCell *)oneObject;
        
        [cell setLabels];
    }
    
    NSDictionary * commentInfo = [commentsArray objectAtIndex:indexPath.row];
    [cell setComment:commentInfo];
    
    cell.userImage.tag = indexPath.row;
    [cell.userImage addTarget:self action:@selector(userProfilePressed:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentsArray count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)userProfilePressed:(id)sender
{
    int commentID = ((UIButton*)sender).tag;
    NSDictionary * commentInfo = [commentsArray objectAtIndex:commentID];

    NSDictionary * userInfo = [[GMRCoreDataModelManager sharedManager] getUserAccountDictionaryForID:[[commentInfo objectForKey:@"user_id"] intValue]];
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [bottomView setFrame:CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y-215,bottomView.frame.size.width,bottomView.frame.size.height)];
    
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
   
        [bottomView setFrame:CGRectMake(bottomView.frame.origin.x,
                                         bottomView.frame.origin.y+215,
                                         bottomView.frame.size.width,
                                         bottomView.frame.size.height)];
    
    [UIView commitAnimations];
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setMovieID:(int)movieID
{
    _movieID = movieID;
}

-(IBAction)sendComment:(id)sender
{
    if ([commentField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter any text to comment!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    MovieReviewInfoObject * newComment = [[MovieReviewInfoObject alloc] init];
    
    newComment.user_id = [GMRAppState sharedState].userAccountInfo.login_id;
    newComment.movie_id = self.movieID;
    newComment.user_review = commentField.text;
    
    NSString * newCommentJSON = [newComment ToJSON];
    
    MBProgressHUD * hud =[[GMRAppState sharedState] showGlobalProgressHUDWithTitle:@"Posting Comment!"];
    [hud showAnimated:YES whileExecutingBlock:^{
        NSString * commentResponseString = [[GMRCoreDataModelManager sharedManager] postComment:newCommentJSON];
        if (commentResponseString)
        {
            NSDictionary * respDict = [commentResponseString JSONValue];
            NSString * respString = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
            if ([respString isEqualToString:@"success"])
            {
                commentsArray = [[GMRCoreDataModelManager sharedManager] getReviewsForMovie:self.movieID];
                if (commentsArray)
                {
                    [[GMRAppState sharedState].movieReviewRateDictionary setObject:commentsArray forKey:[NSString stringWithFormat:@"%i_Review_Data",self.movieID]];
                }
                [reviewTableView reloadData];
                [[GMRCoreDataModelManager sharedManager] incrementCommentCountForMovieID:self.movieID];
                NSMutableDictionary * historyDictionary = [[NSMutableDictionary alloc] init];
                [historyDictionary setObject:[NSNumber numberWithInt:self.movieID] forKey:@"subjectID"];
                [historyDictionary setObject:@"review" forKey:@"historyType"];
                [[GMRAppState sharedState] addDataToHistory:historyDictionary];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Comment Successfully Posted!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [commentField setText:@""];
                if (_parentController)
                    [_parentController incrementComment];
            }
        }
        
        [commentField resignFirstResponder];
        
        
    } completionBlock:^{
        [[GMRAppState sharedState] dismissGlobalHUD];
    }];

    
}
@end
