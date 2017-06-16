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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 1) {
        if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"s"]) {
            myDelegate.selectedMenuIndex = 3;
        }
        else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
            myDelegate.selectedMenuIndex = 4;
        } else {
            myDelegate.selectedMenuIndex = 2;
        }
    }
    /*
     MCST staff (s) - Dashboard, My profile, My feedback,Change password, Logout
     MCST staff (s-bm/ic) - Dashboard, My profile, My feedback, Property feedback,Change password, Logout
     tenants (t) - Dashboard, My profile,Change password, Logout
     council member (cm) - Dashboard, My profile, Property feedback, Tenants, Change password, Logout
     long term contractor (ltc) - Dashboard, My profile, Change password, Logout
     */
    
    //If user role is MCST staff member
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"s"]) {
        menuItems = @[@"Dashboard", @"My Profile", @"My Feedback", @"Change Password", @"Logout"];
    }
    //If user role is MCST building manager and MCST In charger
    else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"]) {
        menuItems = @[@"Dashboard", @"My Profile", @"My Feedback",@"Property Feedback", @"Change Password", @"Logout"];
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

-(void)viewWillDisappear:(BOOL)animated {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //Side bar customisation
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    [tableView setSeparatorColor:[UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0]];
    if (indexPath.row == myDelegate.selectedMenuIndex) {
        cell.backgroundColor= [UIColor colorWithRed:5/255.0 green:122/255.0 blue:165/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor= [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSLog(@"table size %f",tableView.bounds.size.width);
    float aspectHeight, profileViewHeight, nameHeight;
    nameHeight = 18;
    aspectHeight = 186.0/480.0;
    profileViewHeight = 80;
    aspectHeight = 180;
    //Header view frame
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, aspectHeight)];
    headerView.backgroundColor=[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0];
    //Profile image view
    UIImageView *ProfileImgView = [[UIImageView alloc] initWithFrame:CGRectMake((tableView.bounds.size.width/2)-(profileViewHeight/2), 15, profileViewHeight, profileViewHeight)];
    ProfileImgView.contentMode = UIViewContentModeScaleAspectFill;
    ProfileImgView.clipsToBounds = YES;
    ProfileImgView.backgroundColor=[UIColor whiteColor];
    // profile image url
    __weak UIImageView *weakRef = ProfileImgView;
    NSString *tempImageString = [UserDefaultManager getValue:@"userImage"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tempImageString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [ProfileImgView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"sideBarPlaceholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    ProfileImgView.layer.cornerRadius = ProfileImgView.frame.size.width / 2;
    ProfileImgView.layer.masksToBounds = YES;
    //Name label
    UILabel * nameLabel;
    UILabel *emailLabel;
    CGSize size = CGSizeMake(self.view.frame.size.width-10,50);
    CGRect textRect = [self setDynamicHeight:size textString:[UserDefaultManager getValue:@"name"]];
    
    if (textRect.size.height < 40){
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ProfileImgView.frame.origin.y + ProfileImgView.frame.size.height + 15, tableView.bounds.size.width - 10, textRect.size.height+1)];
        emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLabel.frame.origin.y + nameLabel.frame.size.height +10, tableView.bounds.size.width - 10, nameHeight)];
    }
    else {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ProfileImgView.frame.origin.y + ProfileImgView.frame.size.height + 5, tableView.bounds.size.width - 10, textRect.size.height+1)];
        emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLabel.frame.origin.y + nameLabel.frame.size.height +1, tableView.bounds.size.width - 10, nameHeight)];
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
    emailLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    emailLabel.text = [UserDefaultManager getValue:@"email"];
    [headerView addSubview:nameLabel];
    [headerView addSubview:emailLabel];
    [headerView addSubview:ProfileImgView];
    
    return headerView;   // return headerLabel;
}

//Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:18]}
                         context:nil];
    return textHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    myDelegate.selectedMenuIndex = indexPath.row;
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"s"]) {
        if (indexPath.row == 0) {
            myDelegate.isMyComplaintScreen = false;
        } else if (indexPath.row == 2) {
            myDelegate.isMyComplaintScreen = true;
        } else if (indexPath.row == 4) {
            [self logoutUser];
        }
    }
    else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
        if (indexPath.row == 5) {
            [self logoutUser];
        }
    } else {
        if (indexPath.row == 3) {
            [self logoutUser];
        }
    }
}

- (void)logoutUser {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Yes" actionBlock:^(void) {
        [self removeDefaultValues];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }];
    [alert showWarning:nil title:@"Alert" subTitle:@"Are you sure, you want to logout" closeButtonTitle:@"No" duration:0.0f];
    
}

- (void)removeDefaultValues {
    [UserDefaultManager removeValue:@"name"];
    [UserDefaultManager removeValue:@"userId"];
    [UserDefaultManager removeValue:@"AuthenticationToken"];
    [UserDefaultManager removeValue:@"contactNumber"];
    [UserDefaultManager removeValue:@"isFirsttime"];
    [UserDefaultManager removeValue:@"role"];
    [UserDefaultManager removeValue:@"email"];
    myDelegate.isMyComplaintScreen= NO;
    myDelegate.selectedMenuIndex = 0;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 1) {
        if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"s"]) {
            if ([sender tag] == 0 || [sender tag] == 1 || [sender tag] == 2 ||[sender tag] == 3){
                [self.view makeToast:@"Please login."];
                return NO;
            }
        }
        else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
            if ([sender tag] == 0 || [sender tag] == 1 || [sender tag] == 2 ||[sender tag] == 3 ||[sender tag] == 4){
                [self.view makeToast:@"Please login."];
                return NO;
            }
        } else {
            if ([sender tag] == 0 || [sender tag] == 1 || [sender tag] == 2){
                [self.view makeToast:@"Please login."];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - end
@end
