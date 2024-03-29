//
//  ForgotPasswordViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 12/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UserService.h"

@interface ForgotPasswordViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendPasswordButton;

@end

@implementation ForgotPasswordViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Forgot Password";
    //UI customisation
    [self customiseView];
    //AddBackButton
    [self addBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end

#pragma mark - UI customisation
- (void)customiseView {
    [_sendPasswordButton setCornerRadius:3];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)forgotPasswordAction:(id)sender {
    [_emailTextField resignFirstResponder];
    if([self performValidationsForForgotPassword]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(forgotPassword) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([[UIScreen mainScreen] bounds].size.height<=568) {
        [UIView animateWithDuration:0.5f animations:^{
            _mainView.frame = CGRectOffset(_mainView.frame, 0, -30);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([[UIScreen mainScreen] bounds].size.height<=568) {
        [UIView animateWithDuration:0.5f animations:^{
            _mainView.frame = CGRectOffset(_mainView.frame, 0, 30);
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Email validation
- (BOOL)performValidationsForForgotPassword {
    if ([_emailTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill the email address." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    else {
        if (![_emailTextField isValidEmail]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Please fill the valid email address." closeButtonTitle:@"OK" duration:0.0f];
            return NO;
        }
        else {
            return YES;
        }
    }
}
#pragma mark - end

#pragma mark - Webservice
- (void)forgotPassword {
    [[UserService sharedManager] forgotPassword:_emailTextField.text success:^(id responseObject) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showWarning:nil title:@"" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:nil duration:0.0f];
    } failure:^(NSError *error) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
    }] ;
}
#pragma mark - end

@end
