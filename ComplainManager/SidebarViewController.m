//
//  SidebarViewController.m
//  SidebarDemoApp
//
//  Created by Ranosys on 06/02/15.
//  Copyright (c) 2015 Shivendra. All rights reserved.
//



#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"
#import "SidebarCell.h"
#import "UserService.h"

@interface SidebarViewController (){
    NSArray *menuItems;
}

@end

@implementation SidebarViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //Set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0];
    [self.view addSubview:statusBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //If user logged in first time?Navigate to chnage password:Dashboard
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 1) {
        if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
            myDelegate.selectedMenuIndex = 4;
        } else   if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"]) {
            myDelegate.selectedMenuIndex = 3;
        } else {
            myDelegate.selectedMenuIndex = 2;
        }
    }
    //If user role is MCST building manager and MCST In charger
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
        menuItems = @[@"Dashboard", @"My Profile", @"My Feedback",@"Property Feedback", @"Change Password", @"Logout"];
    }
    else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"]) {
        menuItems = @[@"Dashboard", @"My Profile", @"My Feedback", @"Change Password", @"Logout"];
    }
    //If user role is council member
    else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
        menuItems = @[@"Dashboard", @"My Profile",@"Property Feedback",@"Tenants", @"Change Password", @"Logout"];
    }
    //If user role is tenants/long term contractor
    else {
        menuItems = @[@"Dashboard", @"My Profile", @"Change Password", @"Logout"];
    }
    self.tableView.scrollEnabled=NO;
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}
#pragma mark - end

#pragma mark - Table view delegate/data-source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    SidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //Display data on cells
    [cell displayCellData:menuItems index:(int)indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([UIScreen mainScreen].bounds.size.height < 590) {
        CGSize size = CGSizeMake(self.view.frame.size.width-10,80);
        CGRect textRect = [self setDynamicHeight:size textString:[UserDefaultManager getValue:@"name"]];
        if (textRect.size.height < 30){
            return 180;
        } else {
            return 195;
        }
    } else {
        return 180;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    float aspectHeight, profileViewHeight, nameHeight;
    nameHeight = 18;
    aspectHeight = 186.0/480.0;
    profileViewHeight = 100;
    aspectHeight = 180;
    //Header view frame
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, aspectHeight)];
    headerView.backgroundColor=[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0];
    //Profile image view
    UIImageView *ProfileImgView = [[UIImageView alloc] initWithFrame:CGRectMake((tableView.bounds.size.width/2)- (profileViewHeight/2), 15, profileViewHeight, profileViewHeight)];
    ProfileImgView.contentMode = UIViewContentModeScaleAspectFill;
    ProfileImgView.clipsToBounds = YES;
    ProfileImgView.backgroundColor=[UIColor whiteColor];
    [ProfileImgView setImageWithURL:[NSURL URLWithString:[UserDefaultManager getValue:@"userImage"]] placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
    ProfileImgView.layer.cornerRadius = ProfileImgView.frame.size.width / 2;
    ProfileImgView.layer.masksToBounds = YES;
    //Name labeluserPlaceholder
    UILabel * nameLabel;
    UILabel *emailLabel;
    CGSize size = CGSizeMake(self.view.frame.size.width-10,80);
    CGRect textRect = [self setDynamicHeight:size textString:[UserDefaultManager getValue:@"name"]];
    if (textRect.size.height < 30){
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ProfileImgView.frame.origin.y + ProfileImgView.frame.size.height + 8, tableView.bounds.size.width - 10, textRect.size.height)];
        emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLabel.frame.origin.y + nameLabel.frame.size.height + 1, tableView.bounds.size.width - 10, nameHeight)];
    }
    else {
        if ([UIScreen mainScreen].bounds.size.height < 590) {
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ProfileImgView.frame.origin.y + ProfileImgView.frame.size.height + 2, tableView.bounds.size.width - 10, textRect.size.height)];
            emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLabel.frame.origin.y + nameLabel.frame.size.height +1, tableView.bounds.size.width - 10, nameHeight)];
        } else {
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ProfileImgView.frame.origin.y + ProfileImgView.frame.size.height + 5, tableView.bounds.size.width - 10, 30)];
            emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLabel.frame.origin.y + nameLabel.frame.size.height +1, tableView.bounds.size.width - 10, nameHeight)];
        }
    }
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.numberOfLines = 2;
    nameLabel.text=[UserDefaultManager getValue:@"name"];
    //Email label
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.textAlignment=NSTextAlignmentCenter;
    emailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    emailLabel.numberOfLines = 1;
    emailLabel.textColor=[UIColor whiteColor];
    emailLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"t"]) {
        emailLabel.text = @"Tenant";
    } else  if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
        emailLabel.text = @"Council Member";
    } else  if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"]) {
        emailLabel.text = @"Incharge";
    } else  if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
        emailLabel.text = @"Building Manager";
    } else  if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"]) {
        emailLabel.text = @"Long Term Contractor";
    }
    [headerView addSubview:nameLabel];
    [headerView addSubview:emailLabel];
    [headerView addSubview:ProfileImgView];
    return headerView;   // return headerLabel;
}

//Set dynamic height
- (CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:19]}
                         context:nil];
    return textHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != (menuItems.count-1)) {
        myDelegate.selectedMenuIndex = indexPath.row;
    }
    if (indexPath.row == 0) {
        myDelegate.screenName = @"dashboard";
    }
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
        if (indexPath.row == 2) {
            myDelegate.screenName = @"myFeedback";
        }
        else if (indexPath.row == 3) {
            myDelegate.screenName = @"propertyFeedback";
        }
        else if (indexPath.row == 5) {
            [self logoutUser];
        }
    } else  if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
        if (indexPath.row == 2) {
            myDelegate.screenName = @"propertyFeedback";
        }
        else if (indexPath.row == 5) {
            [self logoutUser];
        }
    }
    else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"]) {
        if (indexPath.row == 2) {
            myDelegate.screenName = @"myFeedback";
        } else if (indexPath.row == 4) {
            [self logoutUser];
        }
    }
    else {
        if (indexPath.row == 3) {
            [self logoutUser];
        }
    }
    
    if (indexPath.row != (menuItems.count-1)) {
        myDelegate.selectedMenuIndex = indexPath.row;
    }
}
#pragma mark - end

#pragma mark - Logout user
- (void)logoutUser {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Yes" actionBlock:^(void) {
        [myDelegate showIndicator];
        [myDelegate performSelector:@selector(logoutUser) withObject:nil afterDelay:.1];
    }];
    [alert showWarning:nil title:@"Alert" subTitle:@"Are you sure you want to logout?" closeButtonTitle:@"No" duration:0.0f];
}

#pragma mark - end

#pragma mark - Segue method
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //If first time user clicks other tabs
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 1) {
        if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
            if ([sender tag] == 0 || [sender tag] == 1 || [sender tag] == 2 ||[sender tag] == 3 ||[sender tag] == 4){
                [self.view makeToast:@"Please change the password before entering into other fields."];
                return NO;
            }
        } else {
            if ([sender tag] == 0 || [sender tag] == 1 || [sender tag] == 2){
                [self.view makeToast:@"Please change the password before entering into other fields."];
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark - end
@end
