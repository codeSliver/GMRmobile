//
//  GMRRegistraionViewController.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRRegistraionViewController.h"
#import "GMRBaseViewController.h"
#import "GMRWallFeedViewController.h"
#import "GMRAppDelegate.h"
#import "UserLoginInfoObject.h"
#import "GMRCoreDataModelManager.h"
#import "UserAccountObject.h"
#import "GMRAppState.h"
#import "GMRLocationCell.h"

#define scrolUpOffset 150

@interface GMRRegistraionViewController ()

@end

@implementation GMRRegistraionViewController

@synthesize locationTableView = _locationTableView;

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
    
    [self initializeHeader:@"GMRDefaultHeader"];
    self.header.titleLabel.text = @"Register Account";
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initializeLabels];
    _locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(40, 335, 240, 150)];
    [self.view addSubview:_locationTableView];
    _locationTableView.delegate = self;
    _locationTableView.dataSource = self;
    [_locationTableView setHidden:YES];
    
    if (IS_IOS7)
    {
        [_locationTableView setSeparatorInset:UIEdgeInsetsZero];

        
    }
    [_locationTableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0 green:160.0/255.0 blue:16.0/255.0 alpha:1.0f]];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"citiesInfo" ofType:@"plist"];

    citiesArray = [NSArray arrayWithContentsOfFile:plistPath];
    searchCitiesArray = [citiesArray mutableCopy];
    // Do any additional setup after loading the view from its nib.
}


-(void)initializeLabels
{
    int paddingY =0;
    if (!IS_IOS7)
        paddingY = -14;
    nameField = [[SSTextField alloc] initWithFrame:CGRectMake(nameFieldView.frame.origin.x, nameFieldView.frame.origin.y+paddingY, nameFieldView.frame.size.width, nameFieldView.frame.size.height)];
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    nameField.placeholder = @"Name Surname";
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.keyboardType = UIKeyboardTypeDefault;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.textAlignment = NSTextAlignmentCenter;
    [nameField setReturnKeyType:UIReturnKeyDone];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameField setBackgroundColor:[UIColor clearColor]];
    [nameField setTextColor:[UIColor colorWithRed:254.0/255.0 green:197.0/255.0 blue:67.0/255.0 alpha:1.0f]];
    nameField.delegate = self;
    [nameField setPlaceholderTextColor:[UIColor colorWithRed:254.0/255.0 green:197.0/255.0 blue:67.0/255.0 alpha:0.7f]];
    [nameFieldView.superview addSubview:nameField];
    
    
    locationField = [[SSTextField alloc] initWithFrame:CGRectMake(locationFieldView.frame.origin.x, locationFieldView.frame.origin.y+paddingY, locationFieldView.frame.size.width, locationFieldView.frame.size.height)];
    locationField.borderStyle = UITextBorderStyleNone;
    locationField.font = [UIFont fontWithName:@"Lato-Light" size:18];
    locationField.placeholder = @"Location  ";
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.keyboardType = UIKeyboardTypeDefault;
    locationField.returnKeyType = UIReturnKeyDone;
    locationField.textAlignment = NSTextAlignmentCenter;
    locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [locationField setBackgroundColor:[UIColor clearColor]];
    [locationField setTextColor:[UIColor blackColor]];
        locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    locationField.delegate = self;
    [locationField setPlaceholderTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [locationFieldView.superview addSubview:locationField];
    
    usernameField = [[SSTextField alloc] initWithFrame:CGRectMake(userNameFieldView.frame.origin.x, userNameFieldView.frame.origin.y+paddingY, userNameFieldView.frame.size.width, userNameFieldView.frame.size.height)];
    usernameField.borderStyle = UITextBorderStyleNone;
    usernameField.font = [UIFont fontWithName:@"Lato-Light" size:18];
    usernameField.placeholder = @"Username  ";
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.keyboardType = UIKeyboardTypeDefault;
    usernameField.returnKeyType = UIReturnKeyDone;
    usernameField.textAlignment = NSTextAlignmentCenter;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [usernameField setBackgroundColor:[UIColor clearColor]];
    [usernameField setTextColor:[UIColor blackColor]];
    usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameField.delegate = self;
    [usernameField setPlaceholderTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [userNameFieldView.superview addSubview:usernameField];

    
    passwordField = [[SSTextField alloc] initWithFrame:CGRectMake(passwordFieldView.frame.origin.x, passwordFieldView.frame.origin.y+paddingY, passwordFieldView.frame.size.width, passwordFieldView.frame.size.height)];
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.font = [UIFont fontWithName:@"Lato-Light" size:18];
    passwordField.placeholder = @"Password  ";
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.textAlignment = NSTextAlignmentCenter;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordField setBackgroundColor:[UIColor clearColor]];
    [passwordField setTextColor:[UIColor blackColor]];
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordField.delegate = self;
    [passwordField setPlaceholderTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [passwordFieldView.superview addSubview:passwordField];

    
    emailField = [[SSTextField alloc] initWithFrame:CGRectMake(emailFieldView.frame.origin.x, emailFieldView.frame.origin.y+paddingY, emailFieldView.frame.size.width, emailFieldView.frame.size.height)];
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.font = [UIFont fontWithName:@"Lato-Light" size:18];
    emailField.placeholder = @"Email  ";
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.keyboardType = UIKeyboardTypeDefault;
    emailField.returnKeyType = UIReturnKeyDone;
    emailField.textAlignment = NSTextAlignmentCenter;
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [emailField setBackgroundColor:[UIColor clearColor]];
    [emailField setTextColor:[UIColor blackColor]];
    emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailField.delegate = self;
    [emailField setPlaceholderTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [emailFieldView.superview addSubview:emailField];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Custom Methods
-(IBAction)cameraBtnPressed:(id)sender
{
    
}
-(IBAction)RegisterBtnPressed:(id)sender
{
    if ([self validateFeilds] == -1) {
        // username feild empty
        [self showAlertWithMessage:@"Please provide your name"];
        nameField.text = @"";
    }
    else if ([self validateFeilds] == -2) {
        // password feild empty
        [self showAlertWithMessage:@"Please provide your location"];
        locationField.text = @"";
    }
    else if ([self validateFeilds] == -3) {
        // username feild empty
        [self showAlertWithMessage:@"Please provide a username"];
        usernameField.text = @"";
    }
    else if ([self validateFeilds] == -4) {
        // password feild empty
        [self showAlertWithMessage:@"Please provide a password"];
        passwordField.text = @"";
    }
    else if ([self validateFeilds] == -5) {
        // password feild empty
        [self showAlertWithMessage:@"Please provide your email"];
        emailField.text = @"";
    }
    else if ([[GMRCoreDataModelManager sharedManager] checkUserNameAlreadyExists:usernameField.text])
    {
        [self showAlertWithMessage:@"User Name already exists. Please try a different user name"];
        usernameField.text = @"";
    }else if (![self NSStringIsValidEmail:emailField.text])
    {
        [self showAlertWithMessage:@"Invalid email. Please provide a valid email"];
        emailField.text = @"";
    }
    else
    {
        
        MBProgressHUD * hud =[[GMRAppState sharedState] showGlobalProgressHUDWithTitle:@"Registering user!"];
        [hud showAnimated:YES whileExecutingBlock:^{
            UserLoginInfoObject * loginUser = [[UserLoginInfoObject alloc] init];
            loginUser.user_complete_name = nameField.text;
            loginUser.user_email = emailField.text;
            loginUser.user_name = usernameField.text;
            loginUser.location = locationField.text;
            loginUser.user_password = passwordField.text;
            NSString * imageName = [NSString stringWithFormat:@"%@.jpg",[loginUser.user_name stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            
            [[GMRCoreDataModelManager sharedManager] uploadImage:userImage andName:imageName];
            
            loginUser.user_image_url= [NSString stringWithFormat:@"%@",imageName];
            
            NSString * userJSONString = [loginUser ToJSON];
            
            NSString * responseString = [[GMRCoreDataModelManager sharedManager] registerUserViaLogin:userJSONString];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            
            if (responseString)
            {
                NSDictionary * respDict = [responseString JSONValue];
                NSString * respString = [NSString stringWithFormat:@"%@",[respDict objectForKey:@"response"]];
                if ([respString isEqualToString:@"success"])
                {
                    loginUser.login_id = [[respDict objectForKey:@"login_id"] intValue];
                    [GMRAppState sharedState].userMNLoginInfo = loginUser;
                    [GMRAppState sharedState].userLoginType = USER_LOGIN_MANUAL;
                    
                    UserAccountObject * userAccount = [[UserAccountObject alloc] init];
                    userAccount.login_type =[NSString stringWithFormat:@"manual"];
                    userAccount.login_type_id = loginUser.login_id;
                    
                    NSString * userAccountJSON = [userAccount ToJSON];
                    NSString * userAccountResponseString = [[GMRCoreDataModelManager sharedManager] registerUserViaLogin:userAccountJSON];
                    if (userAccountResponseString)
                    {
                        NSDictionary * respDict1 = [userAccountResponseString JSONValue];
                        NSString * respString1 = [NSString stringWithFormat:@"%@",[respDict1 objectForKey:@"response"]];
                        if ([respString1 isEqualToString:@"success"])
                        {
                            userAccount.login_id = [[respDict1 objectForKey:@"login_id"] intValue];
                            [GMRAppState sharedState].userAccountInfo = userAccount;
                            [[GMRAppState sharedState] loadHistoryForUser:userAccount.login_id];
                            [[GMRAppState sharedState] loadRecommendationsForUser:userAccount.login_id];
                            userAccountJSON = [userAccount ToJSON];
                            [defaults setObject:userAccountJSON forKey:GMR_USER_LOGIN_ACCOUNT];
                            
                        }
                    }
                    NSString * loginUserJSONString = [loginUser ToJSON];
                    [defaults setObject:loginUserJSONString forKey:GMR_USER_LOGIN_MN];
                    [defaults setObject:[NSNumber numberWithInt:[GMRAppState sharedState].userLoginType] forKey:GMR_USER_LOGIN_TYPE];
                    [defaults synchronize];
                    
                    [[GMRAppState sharedState] dismissGlobalHUD];
                    
                    GMRAppDelegate *delegate = (GMRAppDelegate*)[[UIApplication sharedApplication] delegate];
                    [delegate showHomeScreen];
                }
            }

        } completionBlock:^{
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
    
    if (nameField.text == nil || [[self trimString:nameField.text] isEqualToString:@""]){
        i=-1;
        
    }
    else if (locationField.text == nil || [[self trimString:locationField.text] isEqualToString:@""]){
        i=-2;
        
    }
    else if (usernameField.text == nil || [[self trimString:usernameField.text] isEqualToString:@""]) {
        i=-3;
    }
    else if (passwordField.text == nil || [[self trimString:passwordField.text] isEqualToString:@""]){
        i=-4;
        
    }
    else if (emailField.text == nil || [[self trimString:emailField.text] isEqualToString:@""]){
        i=-5;
        
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField != locationField)
        return YES;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [searchCitiesArray removeAllObjects];
    
    for(NSString * city in citiesArray) {
        
        NSRange substringRangeLowerCase = [[city lowercaseString] rangeOfString:newString];
        
        if (substringRangeLowerCase.length !=0)
        {
            
            [searchCitiesArray addObject:city];
        }
    }
    
    if ([searchCitiesArray count] > 0)
    {
        [_locationTableView setHidden:NO];
        
        int rowsHeight = [searchCitiesArray count];
        if (rowsHeight > 5)
            rowsHeight = 5;
        CGFloat height = rowsHeight * 30;
        
        CGRect tableFrame = _locationTableView.frame;
        tableFrame.size.height = height;
        _locationTableView.frame = tableFrame;
        [_locationTableView setNeedsDisplay];
        [_locationTableView reloadData];
    }else if ([newString isEqualToString:@""])
    {
        [_locationTableView setHidden:NO];
        searchCitiesArray = [citiesArray mutableCopy];
        int rowsHeight = [searchCitiesArray count];
        if (rowsHeight > 5)
            rowsHeight = 5;
        CGFloat height = rowsHeight * 30;
        
        CGRect tableFrame = _locationTableView.frame;
        tableFrame.size.height = height;
        _locationTableView.frame = tableFrame;
        [_locationTableView setNeedsDisplay];
        [_locationTableView reloadData];
    }else
    {
        [_locationTableView setHidden:YES];
    }

    return YES;
}

#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!isScrolledUP && (textField == usernameField || textField == passwordField || textField == emailField || textField == locationField)) {
        [self animateViewByYValue:-scrolUpOffset];
    }
    if (textField == locationField)
    {
        [_locationTableView setHidden:NO];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (isScrolledUP && (textField == usernameField || textField == passwordField || textField == emailField || textField == locationField)) {
        [self animateViewByYValue:scrolUpOffset];
    }
    if (textField == locationField)
    {
        [_locationTableView setHidden:YES];
    }
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
	return [searchCitiesArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"GMRLocationCell"];
    
    GMRLocationCell *cell = (GMRLocationCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GMRLocationCell class]])
                
                cell = (GMRLocationCell *)oneObject;
        
    }
    [cell setViews];
    NSString * cityName = [NSString stringWithFormat:@"%@",[searchCitiesArray objectAtIndex:indexPath.row]];
    [cell setTitle:cityName];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cityName = [NSString stringWithFormat:@"%@",[searchCitiesArray objectAtIndex:indexPath.row]];
    [locationField setText:cityName];
    [_locationTableView setHidden:YES];
    [locationField resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(IBAction)imageSelectPressed:(id)sender
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Photo Source"
                                                          message:@"Please select Photo Source!"
                                                         delegate:nil
                                                cancelButtonTitle:@"Camera"
                                                otherButtonTitles: @"Gallery", nil];
    myAlertView.tag = 1;
    myAlertView.delegate = self;
    [myAlertView show];
    return;

    
}

-(void)capturePicture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                              message:@"Device has no Camera!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
        
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)galleryPicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Camera"])
    {
        [self capturePicture];
    }
    else if([title isEqualToString:@"Gallery"])
    {
        [self galleryPicture];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    userImage = chosenImage;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, userImageView.frame.size.width, userImageView.frame.size.height)];
    
    CALayer * l = [imageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:68.0];
    
    // You can even add a border
    [l setBorderWidth:5.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [imageView setImage:userImage];
    [userImageView addSubview:imageView];
    [userImageView setHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
