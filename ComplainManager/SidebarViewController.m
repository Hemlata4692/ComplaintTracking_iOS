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
#import <UIImageView+AFNetworking.h>

@interface SidebarViewController (){
    NSArray *menuItems;
    long selectedIndex;
}

@end

@implementation SidebarViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex = 0;
    //Set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0];
    [self.view addSubview:statusBarView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    menuItems = @[@"Dashboard", @"My Profile", @"My Complaints", @"Change Password", @"Logout"];
    //    menuItems = @[@"Dashboard", @"My Profile", @"Change Password", @"Logout"];
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
    if (indexPath.row == selectedIndex) {
        cell.backgroundColor= [UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor= [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([[UIScreen mainScreen] bounds].size.height > 570) {
        float aspectHeight = 186.0/480.0;
        return (tableView.bounds.size.height * aspectHeight - 40);
    }
    else{
        return 170;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSLog(@"table size %f",tableView.bounds.size.width);
    float aspectHeight, profileViewHeight,welcomeHeight, nameHeight;
    welcomeHeight = 16;
    nameHeight = 23;
    aspectHeight = 186.0/480.0;
    profileViewHeight = 80;
    if([[UIScreen mainScreen] bounds].size.height > 570) {
        aspectHeight = (tableView.bounds.size.height * aspectHeight - 20);
    }
    else {
        aspectHeight = 170;
    }
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
    NSString *tempImageString = [[NSUserDefaults standardUserDefaults]objectForKey:@"profileImageUrl"];
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
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ProfileImgView.frame.origin.y + ProfileImgView.frame.size.height + (welcomeHeight - 6), tableView.bounds.size.width - 20, welcomeHeight)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
    nameLabel.text=@"John Doe";
    //Email label
    UILabel *emailLabel;
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y + (nameHeight), tableView.bounds.size.width - 20, nameHeight)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.textAlignment=NSTextAlignmentCenter;
    emailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    emailLabel.numberOfLines = 1;
    emailLabel.textColor=[UIColor whiteColor];
    emailLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    emailLabel.text = @"monika@ranosys.com";
    [headerView addSubview:nameLabel];
    [headerView addSubview:emailLabel];
    [headerView addSubview:ProfileImgView];
    return headerView;   // return headerLabel;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
}
#pragma mark - end
@end
