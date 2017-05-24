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
    [_emailTextField addTextFieldPaddingWithoutImages:_emailTextField];
    [_emailTextField setBottomBorder:_emailTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
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
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter your email address." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        if (![_emailTextField isValidEmail]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter a valid email address." closeButtonTitle:@"Done" duration:0.0f];
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
        [alert showSuccess:@"Success" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
