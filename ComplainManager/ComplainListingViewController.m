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
    NSMutableArray *complainListArray, *filteredComplainListArray ,*searchArray;
    BOOL isSearch;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *complainListingTable;
@property (weak, nonatomic) IBOutlet UILabel *noComplaintsLabel;

@end

@implementation ComplainListingViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    filteredComplainListArray=[[NSMutableArray alloc]init];
    complainListArray=[[NSMutableArray alloc]init];
    searchArray=[[NSMutableArray alloc]init];
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

#pragma mark - IBActions
- (IBAction)addComplainAction:(id)sender {
    
}

- (IBAction)statusChangeAction:(id)sender {
    [self filterStatusArray:(int)[sender tag]];
}

#pragma mark - end

#pragma mark - Filter status data
- (void)filterStatusArray:(int)buttonTag {
    [filteredComplainListArray removeAllObjects];
    for (int i = 0; i < complainListArray.count; i++) {
        ComplainListDataModel *data=[complainListArray objectAtIndex:i];
        if (buttonTag == 0 && [data.complainStatus isEqualToString:@"Pending"]) {
            [filteredComplainListArray addObject:data];
        } else if (buttonTag == 2 && [data.complainStatus isEqualToString:@"Complete"]) {
            [filteredComplainListArray addObject:data];
            
        } else if (buttonTag == 1 && [data.complainStatus isEqualToString:@"In process"]) {
            [filteredComplainListArray addObject:data];
        }
        [_complainListingTable reloadData];
    }
}
#pragma mark - end

#pragma mark - Text field delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //Search functioning
    NSString *searchKey;
    if([string isEqualToString:@"\n"]) {
        searchKey = textField.text;
    }
    else if(string.length) {
        isSearch = YES;
        searchKey = [textField.text stringByAppendingString:string];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"complainTitle CONTAINS[cd] %@", searchKey];
        searchArray = [[filteredComplainListArray filteredArrayUsingPredicate:filter] mutableCopy];
    }
    else if((textField.text.length-1)!=0) {
        searchKey = [textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"complainTitle CONTAINS[cd] %@", searchKey];
        searchArray = [[filteredComplainListArray filteredArrayUsingPredicate:filter] mutableCopy];
    }
    else {
        searchKey = @"";
        isSearch = NO;
    }
    [_complainListingTable reloadData];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Table view delegate and datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return searchArray.count;
    } else {
        return filteredComplainListArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"ComplainCell";
    ComplainListingCell *complainCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (complainCell == nil) {
        complainCell = [[ComplainListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //Display data on cells
    ComplainListDataModel *data;
    if (isSearch) {
        data=[searchArray objectAtIndex:indexPath.row];
    } else {
        data=[filteredComplainListArray objectAtIndex:indexPath.row];
    }
    [complainCell displayComplainListData:data indexPath:(int)indexPath.row rectSize:_complainListingTable.frame.size];
    return complainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ComplainListDataModel *data=[filteredComplainListArray objectAtIndex:indexPath.row];
    ComplaintDetailViewController * complainDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComplaintDetailViewController"];
    complainDetail.complainId = data.complainId;
    [self.navigationController pushViewController:complainDetail animated:YES];
}
#pragma mark - end

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
        [self filterStatusArray:0];
        //        [_complainListingTable reloadData];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
