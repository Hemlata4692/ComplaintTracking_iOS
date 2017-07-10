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
    self.navigationItem.title = @"Change Password";
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
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all the fields." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    else  if (_oldPasswordText.text.length<6 || _changePasswordText.text.length<6 || _confirmPasswordText.text.length<6) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"The password must have at least 6 characters." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    //Password confirmation for new password entered
    else if ([_oldPasswordText.text isEqualToString:_changePasswordText.text]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please type new password in order to change old password." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    else if (![_changePasswordText.text isEqualToString:_confirmPasswordText.text]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"New and Confirm Password doesn't match." closeButtonTitle:@"OK" duration:0.0f];
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
    [[UserService sharedManager] changePassword:_oldPasswordText.text newPassword:_changePasswordText.text success:^(id responseObject){
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            myDelegate.screenName = @"dashboard";
            myDelegate.selectedMenuIndex = 0;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 1) {
                [UserDefaultManager removeValue:@"name"];
                [UserDefaultManager removeValue:@"userId"];
                [UserDefaultManager removeValue:@"AuthenticationToken"];
                [UserDefaultManager removeValue:@"contactNumber"];
                [UserDefaultManager removeValue:@"isFirsttime"];
                [UserDefaultManager removeValue:@"role"];
                [UserDefaultManager removeValue:@"email"];
                [UserDefaultManager removeValue:@"propertyId"];
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                myDelegate.window.rootViewController = myDelegate.navigationController;
            } else {
                UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                [myDelegate.window setRootViewController:objReveal];
                [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
                [myDelegate.window makeKeyAndVisible];
            }
        }];
        [alert showWarning:nil title:@"" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:nil duration:0.0f];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
