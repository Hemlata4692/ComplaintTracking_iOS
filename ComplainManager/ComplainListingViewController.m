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

@interface ComplainListingViewController ()
{
    NSMutableArray *complainListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *complainListingTable;

@end

@implementation ComplainListingViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"My Complaints";
    complainListArray=[[NSMutableArray alloc]init];
//    [myDelegate.superViewController addMenuButtonWithImage];
    [self addMenuButtonWithImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //call misison list data
    //    [myDelegate showIndicator];
    //    [self performSelector:@selector(getComplainListing) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
//Get complain list data from webservice
- (void)getComplainListing {
    //    ComplainListDataModel *complainModel = [ComplainListDataModel new];
    //    [missionModel getMissionListOnSuccess:^(id dataArray) {
    //        self.missionListDataArray=[dataArray mutableCopy];
    //        //if no result found
    //        if (0==self.missionListDataArray.count || nil==self.missionListDataArray) {
    //            self.noResultFoundLabel.hidden=NO;
    //            self.missionTableView.hidden=YES;
    //            self.noResultFoundLabel.text=@"No mission assign to you yet.";
    //        }
    //        [missionTableView reloadData];
    //
    //    } onfailure:^(NSError *error) {
    //        //webservice faliure fetch data from database
    //        NSMutableArray *dataArray=[NSMutableArray new];
    //        dataArray = [MissionListDatabase getMisionsList];
    //        self.missionListDataArray=[dataArray mutableCopy];
    //        //if no result found
    //        if (0==self.missionListDataArray.count || nil==self.missionListDataArray) {
    //            self.noResultFoundLabel.hidden=NO;
    //            self.missionTableView.hidden=YES;
    //            self.noResultFoundLabel.text=@"No mission assign to you yet.";
    //        }
    //        [missionTableView reloadData];
    //    }];
    
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
    complainCell.complainTitleLabel.attributedText = [complainCell.complainTitleLabel.text setAttributrdString:@"John Doe" stringFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0] selectedColor:[UIColor blackColor]];
    
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
    
    //display data on cells
    ComplainListDataModel *data=[complainListArray objectAtIndex:indexPath.row];
    [complainCell displayComplainListData:data indexPath:(int)indexPath.row rectSize:_complainListingTable.frame.size];
    return complainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - end

@end
