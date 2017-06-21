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
@property (weak, nonatomic) IBOutlet UILabel *assignedCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeProgressLabel;
@property (weak, nonatomic) IBOutlet UIView *assignedView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *completeView;
@property (weak, nonatomic) IBOutlet UIButton *assignedButton;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *addComplaintButton;

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
    //Set assigned view UI
    [self setStatusViewDesign:[UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0] assignedTextColor:[UIColor whiteColor] progressBackgroundColor:[UIColor whiteColor] progressTextColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0] complteBackgroundColor:[UIColor whiteColor] completeTextColor:[UIColor colorWithRed:8/255.0 green:207/255.0 blue:8/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([myDelegate.screenName isEqualToString:@"myFeedback"]) {
        self.navigationItem.title=@"My Feedback";
    } else  if ([myDelegate.screenName isEqualToString:@"propertyFeedback"]) {
        self.navigationItem.title=@"Property Feedback";
    } else {
        self.navigationItem.title=@"Dashboard";
    }
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //call complain listing list data
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 0) {
        [myDelegate showIndicator];
        [self performSelector:@selector(getComplainListing) withObject:nil afterDelay:.1];
    }
    //If user is long term contractor
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"]) {
        _addComplaintButton.hidden= YES;
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
    //Show feedback listing with different status
    [filteredComplainListArray removeAllObjects];
    for (int i = 0; i < complainListArray.count; i++) {
        ComplainListDataModel *data=[complainListArray objectAtIndex:i];
        if (buttonTag == 0) {
            if ([data.complainStatus isEqualToString:@"Pending"]) {
                [filteredComplainListArray addObject:data];
            }
            //Set assigned view UI
            [self setStatusViewDesign:[UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0] assignedTextColor:[UIColor whiteColor] progressBackgroundColor:[UIColor whiteColor] progressTextColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0] complteBackgroundColor:[UIColor whiteColor] completeTextColor:[UIColor colorWithRed:8/255.0 green:207/255.0 blue:8/255.0 alpha:1.0]];
        } else if (buttonTag == 2) {
            if ([data.complainStatus isEqualToString:@"Complete"]) {
                [filteredComplainListArray addObject:data];
            }
            //Set complete view UI
            [self setStatusViewDesign:[UIColor whiteColor] assignedTextColor:[UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0] progressBackgroundColor:[UIColor whiteColor] progressTextColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0] complteBackgroundColor:[UIColor colorWithRed:8/255.0 green:207/255.0 blue:8/255.0 alpha:1.0] completeTextColor:[UIColor whiteColor]];
        } else if (buttonTag == 1) {
            if ([data.complainStatus isEqualToString:@"In process"]) {
                [filteredComplainListArray addObject:data];
            }
            //Set progress view UI
            [self setStatusViewDesign:[UIColor whiteColor] assignedTextColor:[UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0] progressBackgroundColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0] progressTextColor:[UIColor whiteColor] complteBackgroundColor:[UIColor whiteColor] completeTextColor:[UIColor colorWithRed:8/255.0 green:207/255.0 blue:8/255.0 alpha:1.0]];
        }
        [_complainListingTable reloadData];
    }
}
- (void)setStatusViewDesign:(UIColor *)assignedBackgroundColor assignedTextColor:(UIColor *)assignedTextColor  progressBackgroundColor:(UIColor *)progressBackgroundColor progressTextColor:(UIColor *)progressTextColor complteBackgroundColor:(UIColor *)complteBackgroundColor completeTextColor:(UIColor *)completeTextColor {
    //Assigned UI
    _assignedView.backgroundColor = assignedBackgroundColor;
    _assignedCounterLabel.textColor = assignedTextColor;
    [_assignedButton setTitleColor:assignedTextColor forState:UIControlStateNormal];
    //Progress UI
    _progressView.backgroundColor = progressBackgroundColor;
    _progressCounterLabel.textColor = progressTextColor;
    [_progressButton setTitleColor:progressTextColor forState:UIControlStateNormal];
    //Complete UI
    _completeView.backgroundColor = complteBackgroundColor;
    _completeProgressLabel.textColor = completeTextColor;
    [_completeButton setTitleColor:completeTextColor forState:UIControlStateNormal];
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
    if ([myDelegate.screenName isEqualToString:@"myFeedback"]) {
        previousScreen = @"MYCOMPLAIN";
    } else {
        previousScreen = @"DASHBOARD";
    }
    [[ComplainService sharedManager] getComplainListing:previousScreen success:^(NSMutableArray *dataArray){
        complainListArray = dataArray;
        //Show feedback status counts
        NSMutableArray *pendingArray = [[NSMutableArray alloc]init];
        NSMutableArray *progressArray = [[NSMutableArray alloc]init];
        NSMutableArray *completeArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < complainListArray.count; i++) {
            ComplainListDataModel *data=[complainListArray objectAtIndex:i];
            if ([data.complainStatus isEqualToString:@"Pending"]) {
                [pendingArray addObject:data];
                _assignedCounterLabel.text = [NSString stringWithFormat:@"%lu",pendingArray.count] ;
            } else if ([data.complainStatus isEqualToString:@"Complete"]) {
                [progressArray addObject:data];
                _completeProgressLabel.text = [NSString stringWithFormat:@"%lu",progressArray.count] ;
            } else if ([data.complainStatus isEqualToString:@"In process"]) {
                [completeArray addObject:data];
                _progressCounterLabel.text = [NSString stringWithFormat:@"%lu",completeArray.count] ;
            }
        }
        //If no feedbacks
        if (complainListArray.count<1) {
            _noComplaintsLabel.hidden = NO;
        } else {
            _noComplaintsLabel.hidden = YES;
        }
        //Filter array
        [self filterStatusArray:0];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
