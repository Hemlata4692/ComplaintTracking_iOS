//
//  TenantsListViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "TenantsListViewController.h"
#import "TenantsListCell.h"
#import "UserService.h"
#import "UserProfileViewController.h"

@interface TenantsListViewController ()
{
    NSMutableArray *tenantsListingArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tenantsTableView;
@property (weak, nonatomic) IBOutlet UILabel *noTenantsLabel;

@end

@implementation TenantsListViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialise array
    tenantsListingArray = [[NSMutableArray alloc]init];
    self.navigationItem.title=@"Tenants";
    //Add menu button
    [self addMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [myDelegate showIndicator];
    [self performSelector:@selector(getTenantsListing) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tenantsListingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"TenantsCell";
    TenantsListCell *tenantsCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (tenantsCell == nil) {
        tenantsCell = [[TenantsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //Display data on cells
    TenantsListModel * data=[tenantsListingArray objectAtIndex:indexPath.row];
    [tenantsCell displayTenantsListData:data indexPath:(int)indexPath.row rectSize:_tenantsTableView.frame.size];
    return tenantsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserProfileViewController * detailView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    TenantsListModel *dataModel = [tenantsListingArray objectAtIndex:indexPath.row];
    detailView.tenantUserId = dataModel.tenantId;
    detailView.isTenantDetailScreen = YES;
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - end

#pragma mark - Webservice
//Get complain list data from webservice
- (void)getTenantsListing {
    [[UserService sharedManager] getTenantsListing:^(NSMutableArray *dataArray){
        tenantsListingArray = dataArray;
        if (tenantsListingArray.count<1) {
            _noTenantsLabel.hidden = NO;
        } else {
            _noTenantsLabel.hidden = YES;
        }
        [_tenantsTableView reloadData];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        if ([error.localizedDescription containsString:@"Internet"] || [error.localizedDescription containsString:@"network connection"]) {
            _noTenantsLabel.text = @"No Internet Connection.";
        }
        if (tenantsListingArray.count < 1) {
            _noTenantsLabel.hidden = NO;
        }
    }] ;
}
#pragma mark - end

@end
