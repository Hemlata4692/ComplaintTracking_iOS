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
{
    CGRect textRect;
    CGSize size;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *userEmailAddress;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@end

@implementation UserProfileViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"My Profile";
    // Do any additional setup after loading the view.
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
    _userEmailAddress.translatesAutoresizingMaskIntoConstraints=YES;
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width / 2;
    _profileImageView.layer.masksToBounds = YES;
    size = CGSizeMake(self.view.frame.size.width-125,60);
    //    textRect=[self setDynamicHeight:size textString:@"shivendra.singh@ranosys.com"];
    textRect=[self setDynamicHeight:size textString:[UserDefaultManager getValue:@"email"]];
    _userEmailAddress.numberOfLines = 0;
    _userEmailAddress.frame =CGRectMake(125, _userContactNumber.frame.origin.y + _userContactNumber.frame.size.height + 10, _userEmailAddress.frame.size.width, textRect.size.height+3);
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
    _userName.text = [UserDefaultManager getValue:@"name"];
    _userContactNumber.text = [UserDefaultManager getValue:@"contactNumber"];
    _userEmailAddress.text = [UserDefaultManager getValue:@"email"];
}
#pragma mark - end

#pragma mark - Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"ProfileCell";
    ProfileTableCell *profileCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (profileCell == nil) {
        profileCell = [[ProfileTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
        //Display data on cells
//        ProfileDataModel * data=[tenantsListingArray objectAtIndex:indexPath.row];
//        [profileCell displayTenantsListData:data indexPath:(int)indexPath.row rectSize:_tenantsTableView.frame.size];
    return profileCell;
}
#pragma mark - end

@end
