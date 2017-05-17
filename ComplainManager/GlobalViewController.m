//
//  GlobalViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "GlobalViewController.h"

@interface GlobalViewController ()
{
    UIBarButtonItem *backButton;
    UIBarButtonItem *logoutButton;
}
@end

@implementation GlobalViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myDelegate.superViewController=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Add back button
- (void)addBackButtonWithImage:(UIImage *)buttonImage {
    //    CGRect framing = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    CGRect framing = CGRectMake(0, 0, 20, 20);
    UIButton *button = [[UIButton alloc] initWithFrame:framing];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    backButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButton;
    [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

//Logout button action
-(void)backButtonAction :(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

#pragma mark - Add logout button
- (void)addLogoutButtonWithImage:(UIImage *)logoutImage {
    //    CGRect framing = CGRectMake(0, 0, logoutImage.size.width, logoutImage.size.height);
    CGRect framing = CGRectMake(0, 0, 20, 20);
    UIButton *button = [[UIButton alloc] initWithFrame:framing];
    [button setBackgroundImage:logoutImage forState:UIControlStateNormal];
    logoutButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:logoutButton, nil];
}

//Logout button action
- (void)logoutButtonAction :(id)sender{
    [UserDefaultManager removeValue:@"userId"];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                         animated: NO];
}
#pragma mark - end

@end
