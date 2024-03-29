//
//  LoginViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 12/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "LoginViewController.h"
#import "UserService.h"

@interface LoginViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textFieldArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIView *loginContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //Adding textfield to array
    textFieldArray = @[_emailTextField,_passwordTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    // UI customisation
    [self customiseView];
    _emailTextField.text = [UserDefaultManager getValue:@"email"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //Hide navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
#pragma mark - end

#pragma mark - UI customisation
- (void)customiseView {
    [_loginButton setCornerRadius:2];
}
#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [_loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    if (textField.frame.origin.y+textField.frame.size.height+15<([UIScreen mainScreen].bounds.size.height)-256) {
        [_loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_loginScrollView setContentOffset:CGPointMake(0, ((textField.frame.origin.y+textField.frame.size.height+15)- ([UIScreen mainScreen].bounds.size.height-256))+5) animated:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Login validation
- (BOOL)performValidationsForLogin{
    if ([_emailTextField isEmpty] || [_passwordTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all the fields." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    } else if (![_emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill the valid email address." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    else  if (_passwordTextField.text.length < 6) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"The password must have at least 6 characters." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)loginAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    [_loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if([self performValidationsForLogin]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(loginUser) withObject:nil afterDelay:.1];
    }
}

- (IBAction)forgotPasswordAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Webservice
- (void)loginUser {
    [[UserService sharedManager] userLogin:_emailTextField.text password:_passwordTextField.text success:^(id responseObject){
        [myDelegate stopIndicator];
        //Set login info
        NSDictionary *data = [responseObject objectForKey:@"data"];
        [UserDefaultManager setValue:_emailTextField.text key:@"email"];
        [UserDefaultManager setValue:[data objectForKey:@"userId"] key:@"userId"];
        [UserDefaultManager setValue:[data objectForKey:@"name"] key:@"name"];
        [UserDefaultManager setValue:[data objectForKey:@"contactNumber"] key:@"contactNumber"];
        [UserDefaultManager setValue:[data objectForKey:@"isFirsttime"] key:@"isFirstTime"];
        [UserDefaultManager setValue:[data objectForKey:@"AuthenticationToken"] key:@"AuthenticationToken"];
        [UserDefaultManager setValue:[data objectForKey:@"propertyId"] key:@"propertyId"];
        [UserDefaultManager setValue:[data objectForKey:@"RoleId"] key:@"RoleId"];
        //Set user roles
        if ([[data objectForKey:@"RoleId"] intValue] == 6 ) {
            [UserDefaultManager setValue:@"t" key:@"role"];
        } else  if ([[data objectForKey:@"RoleId"] intValue] == 5 ) {
            [UserDefaultManager setValue:@"cm" key:@"role"];
        } else  if ([[data objectForKey:@"RoleId"] intValue] == 4 ) {
            if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"IsBuildingManager"]] isEqualToString:@"1"]) {
                [UserDefaultManager setValue:@"bm" key:@"role"];
            } else {
                [UserDefaultManager setValue:@"ic" key:@"role"];
            }
        } else  if ([[data objectForKey:@"RoleId"] intValue] == 3 ) {
            [UserDefaultManager setValue:@"ltc" key:@"role"];
        }
        NSLog(@"AuthenticationToken %@",[UserDefaultManager getValue:@"AuthenticationToken"]);
        NSLog(@"role %@",[UserDefaultManager getValue:@"role"]);
        NSLog(@"userId %@",[UserDefaultManager getValue:@"userId"]);
        NSLog(@"name %@",[UserDefaultManager getValue:@"name"]);
        NSLog(@"contactNumber %@",[UserDefaultManager getValue:@"contactNumber"]);
        NSLog(@"isFirstTime %@",[UserDefaultManager getValue:@"isFirstTime"]);
        //Navigate to dashboard
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [myDelegate.window setRootViewController:objReveal];
        [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
        [myDelegate.window makeKeyAndVisible];
    } failure:^(NSError *error) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
    }] ;
}
#pragma mark - end
@end
