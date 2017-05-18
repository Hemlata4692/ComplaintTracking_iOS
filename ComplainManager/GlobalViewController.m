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
    [self addBackButtonWithImage:[UIImage imageNamed:@"back.png"]];
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
@end
