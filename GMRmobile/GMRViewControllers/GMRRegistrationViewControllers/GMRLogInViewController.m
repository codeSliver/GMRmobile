//
//  GMRLogInViewController.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 02/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRLogInViewController.h"
#import "GMRRegistraionViewController.h"
#import "GMRWallFeedViewController.h"
#import "GMRAppDelegate.h"
#import "GMRCoreDataModelManager.h"
#import "GMRAppState.h"
#import "UserFBLoginInfoObject.h"
#import "MBProgressHUD.h"
#define scrolUpOffset 145
@interface GMRLogInViewController ()

@end

@implementation GMRLogInViewController
@synthesize usernameField,passwordField,logoImageView,orLineImageView;
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
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:3];
    UIColor *color = nil;
    
    color = [UIColor colorWithRed:251.0f/255 green:197.0f/255 blue:50.0f/255 alpha:1.0f];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:245.0f/255 green:187.0f/255 blue:40.0f/255 alpha:1.0f];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:243.0f/255 green:175.0f/255 blue:30.0f/255 alpha:1.0f];
    [colors addObject:(id)[color CGColor]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = colors;
    [gradient setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.8], nil]];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [self initializeLabels];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initializeLabels
{
    loginConnectLabel = [[UILabel alloc] initWithFrame:loginConnectLabelView.frame];
    loginConnectLabel.text = @"You need to Login to connect with movie fans.";
    loginConnectLabel.textColor = [UIColor whiteColor];
    loginConnectLabel.textAlignment = NSTextAlignmentCenter;
    loginConnectLabel.backgroundColor = [UIColor clearColor];
    loginConnectLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0];
    [loginConnectLabelView.superview addSubview:loginConnectLabel];
    
    loginConnectGMRLabel = [[UILabel alloc] initWithFrame:loginConnectGMRLabelView.frame];
    loginConnectGMRLabel.text = @"login with your GMR account.";
    loginConnectGMRLabel.textColor = [UIColor whiteColor];
    loginConnectGMRLabel.textAlignment = NSTextAlignmentCenter;
    loginConnectGMRLabel.backgroundColor = [UIColor clearColor];
    loginConnectGMRLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0];
    [loginConnectGMRLabelView.superview addSubview:loginConnectGMRLabel];
    
    [facebookButton setHidden:YES];
    loginView = [[FBLoginView alloc] initWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream",@"publish_actions", nil] defaultAudience:FBSessionDefaultAudienceEveryone];
    
    loginView.frame = facebookButton.frame;
    loginView.delegate = self;
    
    for (id obj in loginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"login_fb_button.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateSelected];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
    [facebookButton.superview addSubview:loginView];
    
    //    [loginView sizeToFit];
    
    
    UIFont *boldItalicFont = [UIFont fontWithName:@"MyriadPro-BoldIt" size:12.0];
    UIFont *regularFont = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldItalicFont, NSFontAttributeName, nil];
    
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, nil];
    const NSRange range = NSMakeRange(0,14);
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Not a member? Register your GMR account"]
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    if (IS_IOS7)
        registerGMRLabel = [[UILabel alloc] initWithFrame:registerLabelView.frame];
    else
        registerGMRLabel = [[UILabel alloc] initWithFrame:CGRectMake(registerLabelView.frame.origin.x, registerLabelView.frame.origin.y-14, registerLabelView.frame.size.width, registerLabelView.frame.size.height)];
    
    [registerGMRLabel setAttributedText:attributedText];
    registerGMRLabel.textColor = [UIColor whiteColor];
    registerGMRLabel.textAlignment = NSTextAlignmentCenter;
    registerGMRLabel.backgroundColor = [UIColor clearColor];
    [registerGMRLabel setUserInteractionEnabled:YES];
    [registerLabelView.superview addSubview:registerGMRLabel];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerUserPressed)];
    
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    oneFingerTwoTaps.delegate = self;
    // Add the gesture to the view
    [registerGMRLabel addGestureRecognizer:oneFingerTwoTaps];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if ([GMRAppState sharedState].loggedInFBUser)
        return;
    MBProgressHUD * hud =[[GMRAppState sharedState] showGlobalProgressHUDWithTitle:@"Loading Facebook Data"];
    [hud show:YES];
//    [hud showAnimated:YES whileExecutingBlock:^{
//      
//	} completionBlock:^{
//	}];
    [GMRAppState sharedState].loggedInFBUser = user;
    NSString * facebookUserID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
    NSString * graphFacebookUserInfo = [NSString stringWithFormat:@"%@?fields=address,birthday,id,name,first_name,email,username,picture.width(300).height(300)",facebookUserID];
    [self sendRequestsWithGraphRequest:graphFacebookUserInfo];
    
    
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    //    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Custom Method
-(IBAction)facebookConnectPressed:(id)sender
{
    
}
-(void)registerUserPressed
{
    GMRRegistraionViewController *rVC ;
    
    if ([GMRAppState sharedState].IS_IPHONE_5)
    {
        rVC = [[GMRRegistraionViewController alloc] initWithNibName:@"GMRRegistraionViewController_iPhone5" bundle:nil];
    }else
    {
        rVC = [[GMRRegistraionViewController alloc] initWithNibName:@"GMRRegistraionViewController" bundle:nil];
    }
    [self.navigationController pushViewController:rVC animated:YES];
}
-(void)login
{
    if ([self validateFeilds] == -1) {
        // username feild empty
        [self showAlertWithMessage:@"Please provide your username"];
        usernameField.text = @"";
    }
    else if ([self validateFeilds] == -2) {
        // password feild empty
        [self showAlertWithMessage:@"Please provide your password"];
        passwordField.text = @"";
    }
    else
    {
        __block UserLoginInfoObject * loginUser;
        MBProgressHUD * hud =[[GMRAppState sharedState] showGlobalProgressHUDWithTitle:@"Checking User Information"];
        [hud showAnimated:YES whileExecutingBlock:^{
            loginUser =  [[GMRCoreDataModelManager sharedManager] getUserInfoWithUser:usernameField.text andPassword:passwordField.text];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            
            if (loginUser)
            {
                [GMRAppState sharedState].userMNLoginInfo = loginUser;
                [GMRAppState sharedState].userLoginType = USER_LOGIN_MANUAL;
                
                NSString * loginUserJSONString = [loginUser ToJSON];
                
                [defaults setObject:loginUserJSONString forKey:GMR_USER_LOGIN_MN];
                [defaults setObject:[NSNumber numberWithInt:[GMRAppState sharedState].userLoginType] forKey:GMR_USER_LOGIN_TYPE];
                
                UserAccountObject * accountUser =  [[GMRCoreDataModelManager sharedManager] getUserAccountForID:loginUser.login_id andType:@"manual"];
                NSString * accountUserJSON = [accountUser ToJSON];
                [defaults setObject:accountUserJSON forKey:GMR_USER_LOGIN_ACCOUNT];
                [GMRAppState sharedState].userAccountInfo = accountUser;
                [[GMRAppState sharedState] loadHistoryForUser:accountUser.login_id];
                [[GMRAppState sharedState] loadRecommendationsForUser:accountUser.login_id];
                [defaults synchronize];
            }else
            {
                if ([[GMRAppState sharedState] checkInternetConnectivity])
                {
                    [self showAlertWithMessage:@"Username or password incorrect. Please try again!"];
                }
            }

        } completionBlock:^{

            if (loginUser)
            {
                GMRAppDelegate *delegate = (GMRAppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate showHomeScreen];
            }
            [[GMRAppState sharedState] dismissGlobalHUD];

        }];
        
    }
}
-(void) showAlertWithMessage:(NSString*)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}
-(int) validateFeilds
{
    int i=1;
    if (usernameField.text == nil || [[self trimString:usernameField.text] isEqualToString:@""]) {
        i=-1;
    }
    else if (passwordField.text == nil || [[self trimString:passwordField.text] isEqualToString:@""]){
        i=-2;
        
    }
    return i;
}
-(NSString*) trimString:(NSString*)str
{
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}

- (void) animateViewByYValue: (float) pixels {
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += pixels;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.4];
    [UIView setAnimationDelay:0];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    isScrolledUP = pixels < 0;
}

#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!isScrolledUP) {
        [self animateViewByYValue:-scrolUpOffset];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (isScrolledUP) {
        [self animateViewByYValue:scrolUpOffset];
    }
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == passwordField) {
        [self login];
    }
    return YES;
}

- (void)sendRequestsWithGraphRequest:(NSString*)graphRequest {
    // extract the id's for which we will request the profile
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    // for each fbid in the array, we create a request object to fetch
    // the profile, along with a handler to respond to the results of the request
    
    // create a handler block to handle the results of the request for fbid's profile
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection forFbID:[GMRAppState sharedState].loggedInFBUser result:result error:error];
    };
    
    
    // create the request object, using the fbid as the graph path
    // as an alternative the request* static methods of the FBRequest class could
    // be used to fetch common requests, such as /me and /me/friends
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:graphRequest];
    
    // add the request to the connection object, if more than one request is added
    // the connection object will compose the requests as a batch request; whether or
    // not the request is a batch or a singleton, the handler behavior is the same,
    // allowing the application to be dynamic in regards to whether a single or multiple
    // requests are occuring
    [newConnection addRequest:request completionHandler:handler];
    
    
    // if there's an outstanding connection, just cancel
    [self.requestConnection cancel];
    
    // keep track of our connection, and start it
    self.requestConnection = newConnection;
    [newConnection start];
}

// FBSample logic
// Report any results.  Invoked once for each request we make.
- (void)requestCompleted:(FBRequestConnection *)connection
                 forFbID:fbID
                  result:(id)result
                   error:(NSError *)error {
    if (self.requestConnection &&
        connection != self.requestConnection) {
        [[GMRAppState sharedState] dismissGlobalHUD];
        return;
    }
    
    self.requestConnection = nil;
    
    NSString *text;
    if (error) {
        text = error.localizedDescription;
    } else {
        NSDictionary * userInfo = (NSDictionary *)result;
        [GMRAppState sharedState].FBUserDictionary = userInfo;
        NSString * facebookUserID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
        
        UserFBLoginInfoObject * FBObject = [[GMRCoreDataModelManager sharedManager] getFacebookUserInfoForID:facebookUserID];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        UserFBLoginInfoObject * FBloginUser = [[UserFBLoginInfoObject alloc] init];
        FBloginUser.facebook_id = facebookUserID;
        FBloginUser.user_complete_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
        FBloginUser.user_image_url = [NSString stringWithFormat:@"%@",[[[userInfo objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
        FBloginUser.location = [NSString stringWithFormat:@"%@",[[[GMRAppState sharedState].loggedInFBUser objectForKey:@"location"] objectForKey:@"name"]];
        NSString * userJSONString;
        if (FBObject)
        {
            FBloginUser.fb_login_id = FBObject.fb_login_id;
            userJSONString = [FBloginUser ToJSONWithID:YES];
        }else
        {
            userJSONString = [FBloginUser ToJSONWithID:NO];
        }
        
        NSString * responseString = [[GMRCoreDataModelManager sharedManager] registerUserViaFB:userJSONString];
        
        if (responseString)
        {
            NSDictionary * respDict = [responseString JSONValue];
            NSString * respString = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
            if ([respString isEqualToString:@"success"])
            {
                if (!FBObject)
                {
                    FBloginUser.fb_login_id = [NSNumber numberWithInt:[[respDict objectForKey:@"login_id"] intValue]];
                }
                [GMRAppState sharedState].userFBLoginInfo = FBloginUser;
                [GMRAppState sharedState].userLoginType = USER_LOGIN_FB;
                
                UserAccountObject * accountUser =  [[GMRCoreDataModelManager sharedManager] getUserAccountForID:[FBloginUser.facebook_id intValue] andType:@"facebook"];
                
                if (!accountUser)
                {
                    UserAccountObject * userAccount = [[UserAccountObject alloc] init];
                    userAccount.login_type =[NSString stringWithFormat:@"facebook"];
                    userAccount.login_type_id = [FBloginUser.facebook_id intValue];
                    
                    NSString * userAccountJSON = [userAccount ToJSON];
                    NSString * userAccountResponseString = [[GMRCoreDataModelManager sharedManager] registerUserViaLogin:userAccountJSON];
                    if (userAccountResponseString)
                    {
                        NSDictionary * respDict1 = [responseString JSONValue];
                        NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
                        if ([respString1 isEqualToString:@"success"])
                        {
                            userAccount.login_id = [[respDict1 objectForKey:@"login_id"] intValue];
                            [GMRAppState sharedState].userAccountInfo = userAccount;
                            [[GMRAppState sharedState] loadHistoryForUser:accountUser.login_id];
                            [[GMRAppState sharedState] loadRecommendationsForUser:accountUser.login_id];
                            userAccountJSON = [userAccount ToJSON];
                            [defaults setObject:userAccountJSON forKey:GMR_USER_LOGIN_ACCOUNT];
                            
                        }
                    }else
                    {
                        [[GMRAppState sharedState] dismissGlobalHUD];
                        return;
                    }
                    
                }else
                {
                    
                    [GMRAppState sharedState].userAccountInfo = accountUser;
                    [[GMRAppState sharedState] loadHistoryForUser:accountUser.login_id];
                    [[GMRAppState sharedState] loadRecommendationsForUser:accountUser.login_id];
                    NSString * userAccountJSON = [accountUser ToJSON];
                    [defaults setObject:userAccountJSON forKey:GMR_USER_LOGIN_ACCOUNT];
                    
                }
                NSString * loginUserJSONString = [FBloginUser ToJSONWithID:NO];
                
                [defaults setObject:loginUserJSONString forKey:GMR_USER_LOGIN_FB];
                [defaults setObject:[NSNumber numberWithInt:[GMRAppState sharedState].userLoginType] forKey:GMR_USER_LOGIN_TYPE];
                [defaults synchronize];
                GMRAppDelegate *delegate = (GMRAppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate showHomeScreen];
            }
        }
        
        
        //        }
        
    }
    [[GMRAppState sharedState] dismissGlobalHUD];
    
}

@end
