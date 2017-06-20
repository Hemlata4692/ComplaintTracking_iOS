//
//  UserProfileViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 17/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ProfileDataModel.h"
#import "ProfileTableCell.h"

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@end

@implementation UserProfileViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"My Profile";
    [self addMenuButton];
    [self viewCustomisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View customisation
- (void)viewCustomisation {
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width / 2;
    _profileImageView.layer.masksToBounds = YES;
    [self setProfileData];
}
#pragma mark - end

#pragma mark - Set profile data
- (void)setProfileData {
    NSString *tempImageString = [UserDefaultManager getValue:@"userImage"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tempImageString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [_profileImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"sideBarPlaceholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _profileImageView.contentMode = UIViewContentModeScaleAspectFill;
        _profileImageView.clipsToBounds = YES;
        _profileImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width / 2;
    _profileImageView.layer.masksToBounds = YES;
    [_profileImageView setViewBorder:_profileImageView color:[UIColor whiteColor]];
    _userName.text = [UserDefaultManager getValue:@"name"];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)editProfileAction:(id)sender {
    UIViewController * complainDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    [self.navigationController pushViewController:complainDetail animated:YES];
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"ProfileCell";
    ProfileTableCell *profileCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (profileCell == nil) {
        profileCell = [[ProfileTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if([[UIScreen mainScreen] bounds].size.height>568) {
        _profileTableView.scrollEnabled = NO;
    }
    // Display data on cells
    [profileCell displayProfileData:indexPath.row];
    return profileCell;
}
#pragma mark - end

@end
