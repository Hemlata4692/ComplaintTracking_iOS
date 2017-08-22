//
//  SettingsViewController.m
//  ComplainManager
//
//  Created by Monika on 8/21/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserService.h"

@interface SettingsViewController ()
{
    BOOL  notification, email;
    BOOL isEmail;
}
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;

@end

@implementation SettingsViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Settings";
    // Ad menu button
    [self addMenuButton];
    //Get status
    email = false;
    notification = false;
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
}
#pragma mark - end

#pragma mark - Webservice
- (void)getNotificationStatus {
    [[UserService sharedManager] getNotificationSettings:^(id responseObject) {
        [myDelegate stopIndicator];
        notification = [[responseObject objectForKey:@"WebNotification"] boolValue];
        email = [[responseObject objectForKey:@"EmailNotification"] boolValue];
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
#pragma mark - end

@end
