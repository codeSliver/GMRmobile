//
//  GMRCollapsableTableViewController.h
//
//  Created by    on 05/11/2013.
//  Copyright (c) 2013 DraftKings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRSectionView.h"
#import "GMRBaseViewController.h"
#import "GMRCoreDataModelManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GMRCommentPopUp.h"
#import <Social/Social.h>
#import "GMRRateMovieView.h"


typedef NS_ENUM(NSInteger, GMRCollapsibleTableViewControllerType){
    GMRCollapsibleTableViewControllerTypeNone=0
};
@interface GMRCollapsableTableViewController : GMRBaseViewController <GMRSectionView,RateMovieViewDelegate>
{
    IBOutlet UIView * tapFriendView;
    UILabel * tapLabel;
    
    MovieBasicInfo * currentMovieInfo;
    MovieDetailedInfo * currentMovieDetailedInfo;
    NSArray * currentMovieRatings;
    GMRCommentPopUp * commentPopUp;
    
    NSString * movieDescription;
    NSArray * castArray;
    double userRatings;
    
    int prevSection;
    int currentSection;
    
    BOOL isOpen;
}
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSString *helpString;
@property(nonatomic,assign) GMRCollapsibleTableViewControllerType viewControllerType;
@property (nonatomic) int movieID;

-(IBAction)movieSharePressed:(id)sender;
-(void)incrementComment;
-(IBAction)facebookPressed:(id)sender;
-(IBAction)twitterPressed:(id)sender;
-(void)sendComment:(NSString*)commnetString;

@end
