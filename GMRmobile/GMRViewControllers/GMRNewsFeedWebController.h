//
//  GMRReviewViewController.h
//  GMRmobile
//
//  Created by   on 6/11/13.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"

@class RSSEntry;

@interface GMRNewsFeedWebController : GMRBaseViewController
{
    UIWebView *_webView;
    RSSEntry *_entry;
    
    UIView * headerView;
}


@property (retain) IBOutlet UIWebView *webView;
@property (retain) RSSEntry *entry;

@end
