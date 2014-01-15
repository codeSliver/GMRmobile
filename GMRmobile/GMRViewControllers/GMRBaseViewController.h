//
//  GMRBaseViewController.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 02/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRDefaultHeader.h"

@class GMRCenterNavigationControllerViewController;

@interface GMRBaseViewController : UIViewController <HeaderViewDelegate>
{

}

@property (nonatomic,strong) GMRDefaultHeader * header;
@property (nonatomic,strong) IBOutlet UIView * headerView;
@property (nonatomic,strong) GMRCenterNavigationControllerViewController * centerNavigationController;
-(void)initializeHeader:(NSString *)headerType;

@end
