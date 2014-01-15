//
//  GMRHomeViewController.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "AccordionView.h"
#import "GMRSearchView.h"

@interface GMRHomeViewController : GMRBaseViewController<UITableViewDataSource,UITabBarDelegate,AccordionViewDelegate,HeaderSearchViewDelegate>
{
    NSMutableArray * movieInfoArray;
    AccordionView * accordianView;
    int previousIndex;
}
@property (nonatomic,strong) IBOutlet UITableView *movieTableView;
@end
