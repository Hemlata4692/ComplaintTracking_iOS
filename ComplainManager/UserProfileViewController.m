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
#import "UserService.h"
#import "EditProfileViewController.h"

@interface UserProfileViewController ()
{
    NSDictionary *userData;
    NSArray *infoDetailArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;

@end

@implementation UserProfileViewController
@synthesize isTenantDetailScreen;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    userData = [[NSDictionary alloc]init];
    infoDetailArray = [[NSArray alloc]init];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (isTenantDetailScreen) {
        self.navigationItem.title=@"Tenant Details";
        _editProfileButton.hidden = YES;
        [self addBackButton];
    } else {
        self.navigationItem.title=@"My Profile";
        _editProfileButton.hidden = NO;
        [self addMenuButton];
        [myDelegate showIndicator];
        [self performSelector:@selector(getProfileDetail) withObject:nil afterDelay:.1];
    }
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
    [_editProfileButton addShadow:_editProfileButton color:[UIColor grayColor]];
}
#pragma mark - end

#pragma mark - Set profile data
- (void)setProfileData {
    NSString *tempImageString = [UserDefaultManager getValue:@"userImage"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tempImageString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [_profileImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"userPlaceholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _profileImageView.contentMode = UIViewContentModeScaleAspectFill;
        _profileImageView.clipsToBounds = YES;
        _profileImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width / 2;
    _profileImageView.layer.masksToBounds = YES;
    [_profileImageView setImageViewBorder:_profileImageView color:[UIColor whiteColor]];
    _userName.text = [UserDefaultManager getValue:@"name"];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)editProfileAction:(id)sender {
    EditProfileViewController * editProfile = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
//    editProfile.userData = userData;
    [self.navigationController pushViewController:editProfile animated:YES];
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (userData.count > 1) {
        return  infoDetailArray.count;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"ProfileCell";
    ProfileTableCell *profileCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (profileCell == nil) {
        profileCell = [[ProfileTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    // Display data on cells
    [profileCell displayProfileData:indexPath.row userData:userData infoString:[infoDetailArray objectAtIndex:indexPath.row]];
    return profileCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect textRect;
    NSString * titleTextStr = [infoDetailArray objectAtIndex:indexPath.row];
    CGSize size;
    size = CGSizeMake(_profileTableView.frame.size.width-20,150);
    textRect=[self setDynamicHeight:size textString:titleTextStr];
    return 35+textRect.size.height;
}
#pragma mark - end

#pragma mark - Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:17]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - Web services
- (void)getProfileDetail {
    [[UserService sharedManager] getProfileDetail:^(id responseObject){
        userData = [responseObject objectForKey:@"data"];
        [UserDefaultManager setValue:[userData objectForKey:@"userimage"] key:@"userImage"];
        [UserDefaultManager setValue:[userData objectForKey:@"name"] key:@"name"];
        [self setProfileData];
        if (!([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"])) {
            if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
                infoDetailArray = [NSArray arrayWithObjects:[userData objectForKey:@"email"],[userData objectForKey:@"contactNumber"],[userData objectForKey:@"address"],[userData objectForKey:@"unitnumber"],[userData objectForKey:@"company"],[userData objectForKey:@"property"],[userData objectForKey:@"mcstnumber"],@"", nil];
            } else {
                infoDetailArray = [NSArray arrayWithObjects:[userData objectForKey:@"email"],[userData objectForKey:@"contactNumber"],[userData objectForKey:@"address"],[userData objectForKey:@"unitnumber"],[userData objectForKey:@"company"],[userData objectForKey:@"property"],[userData objectForKey:@"mcstnumber"], nil];
            }
        } else {
            infoDetailArray = [NSArray arrayWithObjects:[userData objectForKey:@"email"],[userData objectForKey:@"contactNumber"],[userData objectForKey:@"property"],[userData objectForKey:@"mcstnumber"], nil];
        }
        [_profileTableView reloadData];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
    }] ;
}
#pragma mark - end

@end
