//
//  GMRReviewViewController.m
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRNewsFeedWebController.h"
#import "RSSEntry.h"
#import "GMRCenterNavigationControllerViewController.h"

@interface GMRNewsFeedWebController ()

@end

@implementation GMRNewsFeedWebController

@synthesize webView = _webView;
@synthesize entry = _entry;

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
    [navigationLabel setText:@"NewsFeed"];
    [navigationLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:200/255.0 blue:13.0/255.0 alpha:1.0f]];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = navigationLabel;
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString:_entry.articleUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.centerNavigationController changeBackButton:@"back-arrow.png"];
    [self.centerNavigationController addSearchButton];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
}


@end
