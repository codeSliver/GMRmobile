//
//  GMRBaseViewController.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 02/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseViewController.h"
#import "GMRCenterNavigationControllerViewController.h"

@interface GMRBaseViewController ()

@end

@implementation GMRBaseViewController

@synthesize header = _header;
@synthesize headerView = _headerView;
@synthesize centerNavigationController = _centerNavigationController;

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
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
    
}
-(void)initializeHeader:(NSString *)headerType
{
    if (!_headerView)
        return;
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:headerType owner:self options:nil];
    self.header = (GMRDefaultHeader*)[subviewArray objectAtIndex:0];
    [self.header initialize];
    self.header.delegate = self;
    [self.headerView addSubview:self.header];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate
{
    return NO;
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
@end
