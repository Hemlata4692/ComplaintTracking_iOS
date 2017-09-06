//
//  SettingsViewController.m
//  ComplainManager
//
//  Created by Monika on 8/21/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserService.h"

@interface SettingsViewController ()<BSKeyboardControlsDelegate>
{
    BOOL  notification, email;
    BOOL isEmail;
    NSString *previousDayValue;
}
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UITextField *setReminderDayText;
@property (weak, nonatomic) IBOutlet UIView *reminderDayValueView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *reminderSetButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation SettingsViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Settings";
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_setReminderDayText]]];
    [self.keyboardControls setDelegate:self];
    // Ad menu button
    [self addMenuButton];
    [_reminderSetButton setCornerRadius:4];
    //Get status
    email = false;
    notification = false;
    if (![[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
        _reminderDayValueView.hidden = YES;
    }
    [myDelegate showIndicator];
    [self performSelector:@selector(getNotificationStatus) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Switch actions
- (IBAction)notificationChangeAction:(id)sender {
    isEmail = false;
    if([sender isOn]){
        notification = true;
    } else{
        notification = false;
    }
    [myDelegate showIndicator];
    [self performSelector:@selector(updateNotificationStatus) withObject:nil afterDelay:.1];
}

- (IBAction)emailChangeAction:(id)sender {
    isEmail = true;
    if([sender isOn]){
        email = true;
    } else{
        email = false;
    }
    [myDelegate showIndicator];
    [self performSelector:@selector(updateNotificationStatus) withObject:nil afterDelay:.1];
}

- (IBAction)setReminderDayAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    if([self performValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(updateReminderDayStatus) withObject:nil afterDelay:.1];
    }
}

#pragma mark - end

#pragma mark - Set notification/email status
- (void)setStatus {
    if (email) {
        [_emailSwitch setOn:YES animated:YES];
    } else {
        [_emailSwitch setOn:NO animated:YES];
    }
    if (notification) {
        [_notificationSwitch setOn:YES animated:YES];
    } else {
        [_notificationSwitch setOn:NO animated:YES];
    }
    _setReminderDayText.text = previousDayValue;
}
#pragma mark - end

#pragma mark - Webservice
- (void)getNotificationStatus {
    [[UserService sharedManager] getNotificationSettings:^(id responseObject) {
        [myDelegate stopIndicator];
        notification = [[responseObject objectForKey:@"WebNotification"] boolValue];
        email = [[responseObject objectForKey:@"EmailNotification"] boolValue];
        previousDayValue =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ReminderDay"]] ;
        [self setStatus];
    } failure:^(NSError *error) {
        if (error.localizedDescription !=  nil) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }
    }] ;
}

- (void)updateNotificationStatus {
    [[UserService sharedManager] updateNotificationSettings:notification email:email success:^(id responseObject) {
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        if (isEmail) {
            if (email) {
                [_emailSwitch setOn:NO animated:YES];
                email = false;
            } else {
                [_emailSwitch setOn:YES animated:YES];
                email = true;
            }
        } else {
            if (notification) {
                [_notificationSwitch setOn:NO animated:YES];
                notification = false;
            } else {
                [_notificationSwitch setOn:YES animated:YES];
                notification = true;
            }
        }
        if (error.localizedDescription !=  nil) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }
    }] ;
}

- (void)updateReminderDayStatus {
    [[UserService sharedManager] updateReminderDaySettings:_setReminderDayText.text success:^(id responseObject) {
        previousDayValue = _setReminderDayText.text;
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
    } failure:^(NSError *error) {
        if (error.localizedDescription !=  nil) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }
    }] ;
}
#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length > 0 && [string length] == 0) {
        return YES;
    }
    if (string.length > 1) {
        if (textField.text.length + string.length >= 2) {
            //Remove string greater then 16 characters
            _setReminderDayText.text = [string substringToIndex:2];
            return NO;
        }
    } else {
        if (textField.text.length >= 2 && range.length == 0) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    [UIView animateWithDuration:0.5f animations:^{
        if([[UIScreen mainScreen] bounds].size.height<=568) {
            _mainView.frame = CGRectOffset(_mainView.frame, 0, -140);
        } else if ([[UIScreen mainScreen] bounds].size.height==667) {
            _mainView.frame = CGRectOffset(_mainView.frame, 0, -45);
        }
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5f animations:^{
        if([[UIScreen mainScreen] bounds].size.height<=568) {
            _mainView.frame = CGRectOffset(_mainView.frame, 0, 140);
        } else if ([[UIScreen mainScreen] bounds].size.height==667) {
            _mainView.frame = CGRectOffset(_mainView.frame, 0, 45);
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Validation
- (BOOL)performValidations{
    if ([_setReminderDayText isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Reminder days should be between 1 to 99." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    } else if ([_setReminderDayText.text isEqualToString:@"00"] || [_setReminderDayText.text isEqualToString:@"000"] || [_setReminderDayText.text isEqualToString:@"0"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Reminder days should be between 1 to 99." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    
    else if ([_setReminderDayText.text isEqualToString:previousDayValue]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please update the value to proceed." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - end

@end
