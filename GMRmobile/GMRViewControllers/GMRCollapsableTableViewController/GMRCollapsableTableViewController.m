//
//  GMRCollapsableTableViewController.m
//
//  Created by    on 01/10/2013.
//  Copyright (c) 2013 DraftKings, Inc. All rights reserved.
//

#import "GMRCollapsableTableViewController.h"
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

@interface GMRCollapsableTableViewController ()

@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, strong) NSMutableArray *collapsibleSections;
@end

@implementation GMRCollapsableTableViewController

@synthesize helpString = _helpString;
@synthesize openSectionIndex;
@synthesize collapsibleSections;
@synthesize viewControllerType = _viewControllerType;
@synthesize tableView;
@synthesize movieID = _movieID;

- (id)init
{
    self = [super init];
    if (self) {
        _viewControllerType = GMRCollapsibleTableViewControllerTypeNone;
    }
    return self;
}
#pragma mark - Custom Methods

-(NSMutableArray*)createSectionsData{
    
    NSMutableArray *collSections = [NSMutableArray array];
    
    currentMovieInfo = [[GMRCoreDataModelManager sharedManager] getMovieForID:self.movieID];
//    currentMovieDetailedInfo = [[GMRCoreDataModelManager sharedManager] getMovieDetailedForMovieID:currentMovieInfo.movie_detailed_id];
    
    if (!currentMovieInfo)
    {
        [self.centerNavigationController drawerButtonPressed:nil];
    }
    
    userRatings = 0.0f;
    movieDescription = @"";
    NSString * jsonCast = @"";
    
    if (currentMovieRatings)
    {
        for (NSDictionary * movieRate in currentMovieRatings)
        {
            int userID = [[movieRate objectForKey:@"user_id"] intValue];
            if (userID == [GMRAppState sharedState].userAccountInfo.login_id)
            {
                userRatings = [[movieRate objectForKey:@"movie_rating"] doubleValue];
            }
        }
        movieDescription = [NSString stringWithFormat:@"%@",currentMovieInfo.movie_description];
        movieDescription = [movieDescription stringByReplacingOccurrencesOfString:@"/n/n" withString:@"'"];
        movieDescription = [movieDescription stringByReplacingOccurrencesOfString:@"/m/m" withString:@"\""];
        
        jsonCast = currentMovieInfo.movie_cast;
        jsonCast = [jsonCast stringByReplacingOccurrencesOfString:@"/n/n" withString:@"'"];
        jsonCast = [jsonCast stringByReplacingOccurrencesOfString:@"/m/m" withString:@"\""];
        castArray = [jsonCast JSONValue];
    }

    for (int i =0; i< 6; i++) {
        NSMutableDictionary *sectionsDict = [NSMutableDictionary dictionary];
        [sectionsDict setObject:currentMovieInfo.movie_genre forKey:@"m_genere"];
        [sectionsDict setObject:currentMovieInfo.movie_released_date forKey:@"m_year"];
        [sectionsDict setObject:[NSString stringWithFormat:@"%0.1f",userRatings] forKey:@"ppl_rating"];
        [sectionsDict setObject:[NSString stringWithFormat:@"%0.1f",currentMovieInfo.movie_rating ] forKey:@"celeb_rating"];
        [sectionsDict setObject:[NSString stringWithFormat:@"%i",currentMovieInfo.movie_comments_count ] forKey:@"comments"];
        [sectionsDict setObject:[NSNumber numberWithInt:i] forKey:@"sectionIndex"];
        
        GMRSectionInfo *section = [[GMRSectionInfo alloc] initWithTitle:[NSString stringWithFormat:@"%i",i] isOpen:NO];
        section.sectionData = sectionsDict;
        section.sectionCategory = [NSMutableArray arrayWithObjects:@"1", nil];
        [collSections addObject:section];
        
    }
    
    return collSections;
}
-(void)setupView{
    self.collapsibleSections = [self createSectionsData];
    [self setTableViewHeader];
    [self.tableView reloadData];
}
-(void)setupCollapsibleViewControllerWithSelectedType{
    
    switch (_viewControllerType) {
        case GMRCollapsibleTableViewControllerTypeNone:
            [self setupView];
            break;
    }
    
    [self.tableView reloadData];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.navigationItem.hidesBackButton = TRUE;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIImage *image = [UIImage imageNamed:@"home-logo-bar.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image] ;
    
    
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorColor=[UIColor clearColor];
    tableView.sectionFooterHeight = 0.0;

    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [tableView setBounces:NO];
    self.openSectionIndex = NSNotFound;
    
    [self setupCollapsibleViewControllerWithSelectedType];
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    
    [self performSelector:@selector(loadRatings) withObject:self afterDelay:0.2f];
}
-(void)loadRatings
{
    currentMovieRatings = [[GMRAppState sharedState].movieReviewRateDictionary objectForKey:[NSString stringWithFormat:@"%i_Rate_Data",currentMovieInfo.movie_id]];
    
    if (!currentMovieRatings)
    {
        currentMovieRatings = [[GMRCoreDataModelManager sharedManager] getRatingsForMovie:currentMovieInfo.movie_id];
        [[GMRAppState sharedState].movieReviewRateDictionary setObject:currentMovieRatings forKey:[NSString stringWithFormat:@"%i_Rate_Data",currentMovieInfo.movie_id]];
    }
    self.collapsibleSections = [self createSectionsData];
    [self.tableView reloadData];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.collapsibleSections = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.centerNavigationController addSearchButton];
    if (!tapLabel)
    {
        UIFont *boldItalicFont = [UIFont fontWithName:@"MyriadPro-BoldIt" size:11.0];
        UIFont *regularFont = [UIFont fontWithName:@"MyriadPro-Regular" size:11.0];
        
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               boldItalicFont, NSFontAttributeName, nil];
        
        NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  regularFont, NSFontAttributeName, nil];
        const NSRange range = NSMakeRange(16,20);
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Tap your friend to share this movie."]
                                               attributes:attrs];
        [attributedText setAttributes:subAttrs range:range];
        
        
        tapLabel = [[UILabel alloc] initWithFrame:tapFriendView.frame];
        [tapLabel setAttributedText:attributedText];
        tapLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0f];
        tapLabel.textAlignment = NSTextAlignmentCenter;
        tapLabel.backgroundColor = [UIColor clearColor];
        [tapFriendView.superview addSubview:tapLabel];
        [tapLabel.superview bringSubviewToFront:tapLabel];
    }
}

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
    int value = 0;
    GMRSectionInfo *collSect = [self.collapsibleSections objectAtIndex:section];
    NSInteger rows = [collSect.sectionCategory count];
    
    if (!collSect.open)
        return 0;
    
    if ((section == 1)|| (section == 2))
    {
        value = (collSect.open) ? 1 : 0;
    }else if (section == 4)
    {
        value = (collSect.open) ? ceil([currentMovieRatings count]/5.0f) : 0;
    }
    
    return value;
}

- (UITableViewCell *)tableView:(UITableView *)senderTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.section == 4)
    {
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
        if ([currentMovieRatings count] > currentIndex)
        {
            NSDictionary * currentRating = [currentMovieRatings objectAtIndex:currentIndex];
            [ratingInfo setObject:[currentRating objectForKey:@"user_id"] forKey:@"user_id"];
            [ratingInfo setObject:[currentRating objectForKey:@"movie_rating"] forKey:@"rating"];
        }else
        {
            [ratingInfo setObject:[NSNumber numberWithInt:-1] forKey:@"user_id"];
 //           [ratingInfo setObject:[currentRating objectForKey:@"movie_rating"] forKey:@"rating"];
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
    }else if (indexPath.section == 1)
    {
        CGSize size = [movieDescription sizeWithFont:[UIFont fontWithName:@"Lato-Light" size:11]
                                 constrainedToSize:CGSizeMake(280, 10000)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        static NSString *CellIdentifier = @"DescriptionCell";
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
            UITextView * titleLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, cell.frame.size.width-40, size.height+40)];
            [titleLabel setFont:[UIFont fontWithName:@"Lato-Light" size:11]];
            [titleLabel setUserInteractionEnabled:NO];
            [titleLabel setEditable:NO];
            titleLabel.tag = 100;
            [titleLabel setText:movieDescription];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            titleLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0f];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:titleLabel];

    }else if (indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"CastCell";
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
        if (castArray)
        {
            for (int i =0 ; i< [castArray count]; i++)
            {
                NSDictionary * castDict = [castArray objectAtIndex:i];
                NSString * castName = [NSString stringWithFormat:@"%@",[castDict objectForKey:@"name"]];
                NSArray * castRoles = (NSArray*)[castDict objectForKey:@"characters"];
                NSString * castRolesString = [castRoles componentsJoinedByString:@","];
                
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + i*20, cell.frame.size.width-40, 20)];
                [titleLabel setFont:[UIFont fontWithName:@"Lato-Light" size:11]];
                [titleLabel setUserInteractionEnabled:NO];
                [titleLabel setText:[NSString stringWithFormat:@"%@    %@",castName,castRolesString]];
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                titleLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0f];
                titleLabel.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:titleLabel];
            }
        }
    }
    else
    {
        CGSize size = [movieDescription sizeWithFont:[UIFont fontWithName:@"Lato-Light" size:11]
                                   constrainedToSize:CGSizeMake(280, 10000)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        static NSString *CellIdentifier = @"Cell";
        
    
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
            UITextView * titleLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, cell.frame.size.width-40, size.height+40)];
            [titleLabel setFont:[UIFont fontWithName:@"Lato-Light" size:11]];
            [titleLabel setUserInteractionEnabled:NO];
            [titleLabel setEditable:NO];
            titleLabel.tag = 100;
            [titleLabel setText:movieDescription];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            titleLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0f];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:titleLabel];
            
      

    }
    
    [cell setAlpha:0.0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1];
    cell.alpha = 1;
    [UIView commitAnimations];
    
    return cell;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    int section = indexPath.section;
    
    float value = 0;
    GMRSectionInfo *collSect = [self.collapsibleSections objectAtIndex:section];

    if (!collSect.open)
        return 0;
    
    if (section == 4)
    {
        value = 69.0f;
    }else if (section == 1)
    {
        CGSize size = [movieDescription sizeWithFont:[UIFont fontWithName:@"Lato-Light" size:11]
                                   constrainedToSize:CGSizeMake(280, 10000)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        value = size.height+40;
        
    }else if (section == 2)
    {
        if (castArray)
        {
            
        value =  (20* [castArray count])+40;
            
        }else
        {
            value = 40;
        }
    }
        
        
    
    return value;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GMRSectionInfo *collSect = [self.collapsibleSections objectAtIndex:section];
    if (!collSect.sectionView)
    {
        GMRSectionInfo *sectionInfo = (GMRSectionInfo*)[self.collapsibleSections objectAtIndex:section];
        
        collSect.sectionView = [[GMRSectionView alloc] initWithFrame:CGRectMake(25, 0, self.tableView.bounds.size.width - 50, 28) WithSectionDict:sectionInfo.sectionData Section:section delegate:self];
    }
    return collSect.sectionView;
}

-(void) setTableViewHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 116)];
    UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 116)];
    headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [headerImgView setClipsToBounds:YES];
    //    NSString * completeURL = [NSString stringWithFormat:@"%@%@",URLPREFIXIMAGES,currentMovieInfo.movie_image_url];
    [headerImgView setImageWithURL:[NSURL URLWithString:currentMovieInfo.movie_image_url] placeholderImage:[UIImage imageNamed:@"poster.png"] options:SDWebImageRetryFailed];
    
    [headerView addSubview:headerImgView];
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 250, 50)];
    labelView.textAlignment = NSTextAlignmentLeft;
    labelView.font = [UIFont fontWithName:@"Lato-Regular" size:22.0f];
    labelView.text = currentMovieInfo.movie_name;
    labelView.textColor = [UIColor colorWithRed:248.0f/255.0f green:200.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    labelView.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:labelView];
    
    self.tableView.tableHeaderView = headerView;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)senderTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [senderTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void) sectionClosed : (NSInteger) section{
    GMRSectionInfo *collSect = [self.collapsibleSections objectAtIndex:section];
	
    collSect.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:section];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

- (void) sectionOpened : (NSInteger) section
{
    GMRSectionInfo *collSect = [self.collapsibleSections objectAtIndex:section];
 
    int count =0;
    if (section == 4)
        count = ceil([currentMovieRatings count]/5.0f);
    else if ((section == 1)||(section == 2))
        count = 1;
    
    if ((count == 0)&&(section != 4))
        return;
    
    collSect.open = YES;

    NSMutableArray *indexPathToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<count;i++)
    {
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenIndex = self.openSectionIndex;
    
    if (previousOpenIndex != NSNotFound)
    {
        GMRSectionInfo *collSect = [self.collapsibleSections objectAtIndex:previousOpenIndex];
        collSect.open = NO;
        int counts = 0;
        
        if (previousOpenIndex == 4)
            counts = ceil([currentMovieRatings count]/5.0f);
        else if ((previousOpenIndex == 1)||(previousOpenIndex == 2))
            counts = 1;
        [collSect.sectionView toggleButtonPressed:FALSE];
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
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    self.openSectionIndex = section;
    [self.tableView reloadData];
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(void)commentPressed
{
    GMRReviewViewController *  loginVc ;
    if ([GMRAppState sharedState].IS_IPHONE_5)
    {
        loginVc= [[GMRReviewViewController alloc] initWithNibName:@"GMRReviewViewController" bundle:nil];
    }else
    {
        loginVc= [[GMRReviewViewController alloc] initWithNibName:@"GMRReviewViewController_iPhone4" bundle:nil];
    }
    loginVc.centerNavigationController = self.centerNavigationController;
    loginVc.parentController = self;
    loginVc.movieID = self.movieID;
    [self.centerNavigationController pushViewController:loginVc animated:YES];
    
}
-(void)incrementComment
{
    GMRSectionInfo *collSect = [self.collapsibleSections objectAtIndex:5];
    collSect.sectionView.commentsNo++;
    [collSect.sectionView.sectionTitle setText:[NSString stringWithFormat:@"%i comments",collSect.sectionView.commentsNo]];
}

-(void)ratePressed
{
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GMRRateMovieView" owner:self options:nil];
    GMRRateMovieView * rateMovieView = (GMRRateMovieView*)[subviewArray objectAtIndex:0];
    rateMovieView.parent = self;
    rateMovieView.tag = 100;
    [self.view addSubview:rateMovieView];
    [rateMovieView setMovieID:currentMovieInfo.movie_id];
    [rateMovieView initialize];
    rateMovieView.delegate = self;
}

-(void)rateMovieChanged
{
    currentMovieRatings = [[GMRCoreDataModelManager sharedManager] getRatingsForMovie:currentMovieInfo.movie_id ];
    [[GMRAppState sharedState].movieReviewRateDictionary setObject:currentMovieRatings forKey:[NSString stringWithFormat:@"%i_Rate_Data",currentMovieInfo.movie_id]];
    self.collapsibleSections = [self createSectionsData];
    [self.tableView reloadData];
}
-(IBAction)facebookPressed:(id)sender
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GMRCommentPopUp" owner:self options:nil];
    commentPopUp = (GMRCommentPopUp*)[subviewArray objectAtIndex:0];
    commentPopUp.parent = self;
    commentPopUp.tag = 100;
    [self.view addSubview:commentPopUp];
    [commentPopUp initialize];
    //    newCommentFB.parent = self;
    //    [newCommentFB initializeWithPhotoDictionary:photoDictionary];
    
    
    
}

-(IBAction)twitterPressed:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@""];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Account not configured" message:@"Please setup twitter account to tweet!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)sendComment:(NSString*)commnetString
{
    if (commentPopUp.tag == 100)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:commnetString, @"message",
                                       /*@"picture" : [UIImage imageNamed:@"Default"],*/
                                       nil];
        [FBRequestConnection startWithGraphPath:@"me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (error)
                                  {
                                      NSLog(@"Error: %@", [error localizedDescription]);
                                      [[GMRAppState sharedState] checkInternetConnectivity];
                                  }
                                  else
                                  {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Posted to your facebook wall successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                      [alert show];
                                  }
                              }];
    }
}

-(IBAction)movieSharePressed:(id)sender
{
    GMRSuggestMovieController *cVC = [[GMRSuggestMovieController alloc] initWithNibName:@"GMRSuggestMovieController" bundle:nil];
    cVC.centerNavigationController = self.centerNavigationController;
    cVC.backButtonType = [NSString stringWithFormat:@"back-arrow.png"];
    [self.centerNavigationController pushViewController:cVC animated:YES];
    [cVC setMovieID:self.movieID];

}
@end
