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
    BOOL notification, email;
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
    [self uiCustomisation];
    //Get status
    [myDelegate showIndicator];
    [self performSelector:@selector(getNotificationStatus) withObject:nil afterDelay:.1];
}
- (void) uiCustomisation {
    [_notificationView setViewBorder:_notificationView color:[UIColor lightGrayColor]];
    [_emailView setViewBorder:_emailView color:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Switch actions
- (IBAction)notificationChangeAction:(id)sender {
    if([sender isOn]){
        notification = true;
    } else{
        notification = false;
    }
}
- (IBAction)emailChangeAction:(id)sender {
    if([sender isOn]){
        email = true;
    } else{
        email = false;
    }
}
- (void) callService {
    [myDelegate showIndicator];
    [self performSelector:@selector(updateNotificationStatus) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getNotificationStatus {
    [[UserService sharedManager] getNotificationSettings:^(id responseObject) {
        [myDelegate stopIndicator];
      
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
        if (error.localizedDescription !=  nil) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }
    }] ;
  
}
#pragma mark - end

@end
