//
//  GMRCollapsableTableViewController.h
//
//  Created by    on 05/11/2013.
//  Copyright (c) 2013 DraftKings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRBaseViewController.h"
#import "GMRCoreDataModelManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface GMRWallFeedViewController : GMRBaseViewController 
{
    NSMutableArray * movieInfoArray;
    IBOutlet UITableView *feedTableView;
    
    NSArray * sectionData;
    NSArray * prevSectionData;
    int prevCategory;
    int currentCategory;
    int prevSection;
    int currentSection;
    
    BOOL isOpen;
    
    UIRefreshControl * refreshControl;
    
    NSMutableArray * headerViewData;
    
}



@end
