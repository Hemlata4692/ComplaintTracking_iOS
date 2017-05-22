//
//  ChangePasswordViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 19/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserService.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textfieldArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation ChangePasswordViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //Adding textfield to array
    textfieldArray = @[_oldPasswordText,_changePasswordText,_confirmPasswordText];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textfieldArray]];
    [self.keyboardControls setDelegate:self];
    //Add menu button
    [self addMenuButton];
    //UI customisation
    [self customiseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - UI customisation
- (void)customiseView {
    [_changePasswordButton setCornerRadius:3];
    [_oldPasswordText setBottomBorder:_oldPasswordText color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
    [_changePasswordText setBottomBorder:_changePasswordText color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
    [_confirmPasswordText setBottomBorder:_confirmPasswordText color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
}
#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    if ([[UIDevice currentDevice].systemVersion floatValue]< 7.0) {
        view = field.superview.superview;
    } else {
        view = field.superview.superview.superview;
    }
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _scrollView.scrollEnabled = NO;
    [self.keyboardControls setActiveField:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _scrollView.scrollEnabled = YES;
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
#pragma mark - end

#pragma mark - Validations
- (BOOL)performValidationsForChangePassword {
    if ([_oldPasswordText isEmpty] || [_changePasswordText isEmpty] || [_confirmPasswordText isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all fields." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else  if (_oldPasswordText.text.length<8 || _changePasswordText.text.length<8 || _confirmPasswordText.text.length<8) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Password with minimum 8 characters are required." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    //Password confirmation for new password entered
    else if (![_changePasswordText.text isEqualToString:_confirmPasswordText.text]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Your passwords do not match. Kindly provide a correct password." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)changePasswordAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    if([self performValidationsForChangePassword])    {
        [myDelegate showIndicator];
        [self performSelector:@selector(changePassword) withObject:nil afterDelay:.1];
    }
    
}
#pragma mark - end

#pragma mark - Web services
-(void)changePassword {
    //    [[UserService sharedManager] userRegisteration:_nameTextField.text email:_emailTextField.text password:_passwordTextField.text mobileNumber:_phoneNumberTextField.text success:^(id responseObject){
    //        [myDelegate stopIndicator];
    //    } failure:^(NSError *error) {
    //
    //    }] ;
}
#pragma mark - end

@end
