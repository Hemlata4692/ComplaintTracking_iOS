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
    BOOL showUserRole;
}
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@end

@implementation UserProfileViewController
@synthesize isTenantDetailScreen,isProfileDetailScreen,tenantUserId;

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
        _callButton.hidden = YES;
        [self addBackButton];
    } else if (isProfileDetailScreen) {
        self.navigationItem.title=@"User Details";
        if ([[UserDefaultManager getValue:@"userId"] isEqualToString:tenantUserId]) {
            _editProfileButton.hidden = YES;
            _callButton.hidden = YES;
        } else {
            _editProfileButton.hidden = YES;
            _callButton.hidden = NO;
        }
        [self addBackButton];
    } else {
        self.navigationItem.title=@"My Profile";
        _editProfileButton.hidden = NO;
        [self addMenuButton];
    }
    [myDelegate showIndicator];
    [self performSelector:@selector(getProfileDetail) withObject:nil afterDelay:.1];
    [self viewCustomisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark - View customisation
- (void)viewCustomisation {
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width / 2;
    _profileImageView.layer.masksToBounds = YES;
    //    [self setProfileData];
    [_editProfileButton addShadow:_editProfileButton color:[UIColor grayColor]];
}
#pragma mark - end

#pragma mark - Set profile data
- (void)setProfileData {
    NSString *tempImageString = [userData objectForKey:@"userimage"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[tempImageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
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
    _userName.text = [userData objectForKey:@"name"];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)editProfileAction:(id)sender {
    EditProfileViewController * editProfile = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    [self.navigationController pushViewController:editProfile animated:YES];
}

- (IBAction)callAction:(id)sender {
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[userData objectForKey:@"contactNumber"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
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
    [profileCell displayProfileData:indexPath.row userData:userData infoString:[infoDetailArray objectAtIndex:indexPath.row] showUserRole:[self showUserRole]];
    return profileCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect textRect;
    NSString * titleTextStr = [infoDetailArray objectAtIndex:indexPath.row];
    CGSize size;
    size = CGSizeMake(_profileTableView.frame.size.width-20,150);
    textRect=[self setDynamicHeight:size textString:titleTextStr];
    return 40+textRect.size.height;
}
#pragma mark - end

#pragma mark - Set dynamic height
- (CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
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
    NSString *userId;
    if (isTenantDetailScreen || isProfileDetailScreen) {
        userId = tenantUserId;
    } else {
        userId = @"";
    }
    [[UserService sharedManager] getProfileDetail:(isTenantDetailScreen || isProfileDetailScreen) userId:userId success:^(id responseObject){
        userData = [responseObject objectForKey:@"data"];
        [self setProfileData];
        //Set profile detail data
        if ([[userData objectForKey:@"contactNumber"] isEqualToString:@""]) {
            _callButton.hidden = YES;
        }
        if (([[userData objectForKey:@"userroleid"] intValue] == 4 || [[userData objectForKey:@"userroleid"] intValue] == 3)) {
            infoDetailArray = [NSArray arrayWithObjects:[userData objectForKey:@"email"],[userData objectForKey:@"contactNumber"],[userData objectForKey:@"property"],[userData objectForKey:@"mcstnumber"], nil];
        } else {
            if ([self showUserRole]) {
                infoDetailArray = [NSArray arrayWithObjects:[userData objectForKey:@"email"],[userData objectForKey:@"contactNumber"],[userData objectForKey:@"address"],[userData objectForKey:@"unitnumber"],[userData objectForKey:@"company"],[userData objectForKey:@"property"],[userData objectForKey:@"mcstnumber"],@"", nil];
            } else {
                infoDetailArray = [NSArray arrayWithObjects:[userData objectForKey:@"email"],[userData objectForKey:@"contactNumber"],[userData objectForKey:@"address"],[userData objectForKey:@"unitnumber"],[userData objectForKey:@"company"],[userData objectForKey:@"property"],[userData objectForKey:@"mcstnumber"], nil];
            }
        }
        [_profileTableView reloadData];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        if (isTenantDetailScreen || isProfileDetailScreen) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"OK" actionBlock:^(void) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:nil duration:0.0f];
        } else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
            if ([error.localizedDescription containsString:@"Internet"] || [error.localizedDescription containsString:@"network connection"]) {
                _noRecordLabel.text = @"No Internet Connection.";
            } else  {
                _noRecordLabel.text = @"No Records Found.";
            }
            if (infoDetailArray.count < 1) {
                _noRecordLabel.hidden = NO;
                _profileView.hidden = YES;
                _editProfileButton.hidden = YES;
                _profileTableView.hidden = YES;
            }
        }
    }] ;
}
#pragma mark - end

#pragma mark - Check if user is council member
- (BOOL)showUserRole {
    if ([[userData objectForKey:@"userroleid"] intValue] == 5 && ( isTenantDetailScreen || isProfileDetailScreen)) {
        showUserRole = YES ;
    } else {
        showUserRole = NO ;
    }
    return showUserRole;
}
#pragma mark - end
@end
