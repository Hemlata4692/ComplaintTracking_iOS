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
    NSString *role;
}

@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIView *loginContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *staffButton;
@property (weak, nonatomic) IBOutlet UIButton *registerUserButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *orView;

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
    //Set user selected
    [_userButton setSelected:YES];
    role = @"user";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //Hide navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
#pragma mark - end

#pragma mark - UI customisation
- (void)customiseView {
    [_emailTextField addTextFieldPadding:_emailTextField];
    [_passwordTextField addTextFieldPadding:_passwordTextField];
    [_emailTextField setBottomBorder:_emailTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
    [_passwordTextField setBottomBorder:_passwordTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
    [_registerUserButton setCornerRadius:3];
    [_registerUserButton setViewBorder:_registerUserButton color:[UIColor colorWithRed:237/255.0 green:236/255.0 blue:237/255.0 alpha:1.0]];
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
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter your email and password." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    } else if (![_emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter a valid email address." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else  if (_passwordTextField.text.length < 6) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Your password must be atleast 6 characters long." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
    
}
#pragma mark - end

#pragma mark - IBActions

- (IBAction)selectUserRoleAction:(id)sender {
    switch ([sender tag ]) {
        case 0:
            //If user is selected
            if (![_userButton isSelected]) {
                [_userButton setSelected:YES];
                [_staffButton setSelected:NO];
                _registerUserButton.hidden = NO;
                _orView.hidden = NO;
                role = @"user";
                NSLog(@"role = %@",role);
            }
            else {
            }
            break;
        case 1:
            //If staff is selected
            if (![_staffButton isSelected]) {
                [_staffButton setSelected:YES];
                [_userButton setSelected:NO];
                _registerUserButton.hidden = YES;
                _orView.hidden = YES;
                role = @"staff";
                NSLog(@"role = %@",role);
            }
            else{
            }
            break;
        default:
            break;
    }
}

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

- (IBAction)registerUserAction:(id)sender {
    
}
#pragma mark - end

#pragma mark - Webservice
- (void)loginUser {
    [[UserService sharedManager] userLogin:_emailTextField.text password:_passwordTextField.text success:^(id responseObject){
        [myDelegate stopIndicator];
        NSDictionary *data = [responseObject objectForKey:@"data"];
        [UserDefaultManager setValue:_emailTextField.text key:@"email"];
        [UserDefaultManager setValue:[data objectForKey:@"userId"] key:@"userId"];
        [UserDefaultManager setValue:[data objectForKey:@"name"] key:@"name"];
        [UserDefaultManager setValue:[data objectForKey:@"contactNumber"] key:@"contactNumber"];
        [UserDefaultManager setValue:[data objectForKey:@"isFirsttime"] key:@"isFirstTime"];
        [UserDefaultManager setValue:[data objectForKey:@"AuthenticationToken"] key:@"AuthenticationToken"];
        
        if ([[data objectForKey:@"RoleId"] intValue] == 5 ) {
            [UserDefaultManager setValue:@"t" key:@"role"];
        } else {
            [UserDefaultManager setValue:@"s" key:@"role"];
        }
        
        NSLog(@"AuthenticationToken %@",[UserDefaultManager getValue:@"AuthenticationToken"]);
        NSLog(@"role %@",[UserDefaultManager getValue:@"role"]);
        NSLog(@"userId %@",[UserDefaultManager getValue:@"userId"]);
        NSLog(@"name %@",[UserDefaultManager getValue:@"name"]);
        NSLog(@"contactNumber %@",[UserDefaultManager getValue:@"contactNumber"]);
        NSLog(@"isFirstTime %@",[UserDefaultManager getValue:@"isFirstTime"]);
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [myDelegate.window setRootViewController:objReveal];
        [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
        [myDelegate.window makeKeyAndVisible];
        
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
