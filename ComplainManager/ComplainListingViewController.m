//
//  ComplainListingViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplainListingViewController.h"
#import "ComplainListingCell.h"
#import "ComplainListDataModel.h"
#import "ComplainService.h"
#import "ComplaintDetailViewController.h"

@interface ComplainListingViewController ()
{
    NSMutableArray *complainListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *complainListingTable;
@property (weak, nonatomic) IBOutlet UILabel *noComplaintsLabel;

@end

@implementation ComplainListingViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    complainListArray=[[NSMutableArray alloc]init];
    [self addMenuButton];
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 1) {
        UIViewController * complainDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        [self.navigationController pushViewController:complainDetail animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (myDelegate.isMyComplaintScreen) {
        self.navigationItem.title=@"My Feedback";
        myDelegate.selectedMenuIndex = 2;
    } else {
        self.navigationItem.title=@"Dashboard";
        myDelegate.selectedMenuIndex = 0;
    }
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //call complain listing list data
    
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 0) {
        [myDelegate showIndicator];
        [self performSelector:@selector(getComplainListing) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Table view delegate and datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return complainListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"ComplainCell";
    ComplainListingCell *complainCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (complainCell == nil) {
        complainCell = [[ComplainListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //    complainCell.complainTitleLabel.attributedText = [complainCell.complainTitleLabel.text setAttributrdString:@"John Doe" stringFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0] selectedColor:[UIColor blackColor]];
    
    //    //hide separator if result is only 1 mission
    //    if (self.complainListArray.count==1) {
    //        complainCell.topSeparator.hidden=YES;
    //        complainCell.bottomSeparator.hidden=YES;
    //    }
    //    if (indexPath.row==0) {
    //        complainCell.topSeparator.hidden=YES;
    //    }
    //    else {
    //        complainCell.topSeparator.hidden=NO;
    //    }
    
    //    display data on cells
    ComplainListDataModel *data=[complainListArray objectAtIndex:indexPath.row];
    [complainCell displayComplainListData:data indexPath:(int)indexPath.row rectSize:_complainListingTable.frame.size];
    return complainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ComplainListDataModel *data=[complainListArray objectAtIndex:indexPath.row];
    ComplaintDetailViewController * complainDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComplaintDetailViewController"];
    complainDetail.complainId = data.complainId;
    [self.navigationController pushViewController:complainDetail animated:YES];
}
#pragma mark - end
- (IBAction)addComplainAction:(id)sender {
    
}

#pragma mark - Webservice
//Get complain list data from webservice
- (void)getComplainListing {
    NSString *previousScreen;
    if (myDelegate.isMyComplaintScreen) {
        previousScreen = @"MYCOMPLAIN";
    } else {
        previousScreen = @"DASHBOARD";
    }
    [[ComplainService sharedManager] getComplainListing:previousScreen success:^(NSMutableArray *dataArray){
        complainListArray = dataArray;
        if (complainListArray.count<1) {
            _noComplaintsLabel.hidden = NO;
        } else {
            _noComplaintsLabel.hidden = YES;
        }
        [_complainListingTable reloadData];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
