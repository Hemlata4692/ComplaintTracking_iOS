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
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
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
    textFieldArray = @[_usernameTextField,_passwordTextField];
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
    [_usernameTextField addTextFieldPadding:_usernameTextField];
    [_passwordTextField addTextFieldPadding:_passwordTextField];
    [_usernameTextField setBottomBorder:_usernameTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
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
    if ([_usernameTextField isEmpty] || [_passwordTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter your email and password." closeButtonTitle:@"Done" duration:0.0f];
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
    [[UserService sharedManager] userLogin:_usernameTextField.text password:_passwordTextField.text role:role success:^(id responseObject){
        [myDelegate stopIndicator];
        [UserDefaultManager setValue:[responseObject objectForKey:@"user_id"] key:@"userId"];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"ComplainListing"];
        [myDelegate.window setRootViewController:loginView];
        [myDelegate.window makeKeyAndVisible];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
