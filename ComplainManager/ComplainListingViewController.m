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
#import "AddComplainViewController.h"

@interface ComplainListingViewController ()
{
    NSMutableArray *complainListArray, *filteredComplainListArray;
    NSArray *searchArray;
    BOOL isSearch;
    int selectedButtonTag;
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
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;
//Pull to refresh
@property (nonatomic, strong)UIRefreshControl *refreshControl;

@end

@implementation ComplainListingViewController

@synthesize refreshComplainScreen;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    filteredComplainListArray=[[NSMutableArray alloc]init];
    complainListArray=[[NSMutableArray alloc]init];
    searchArray=[[NSArray alloc]init];
    [self addMenuButton];
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 1) {
        UIViewController * complainDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        [self.navigationController pushViewController:complainDetail animated:YES];
        return;
    }
    refreshComplainScreen = true;
    // Pull To Refresh
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(160, 0, 20, 20)];
    [_complainListingTable addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    _complainListingTable.alwaysBounceVertical = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification) name:@"ReloadComplainListing" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_refreshControl endRefreshing];
    myDelegate.currentViewController=@"other";
    refreshComplainScreen = false;
    [_searchTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadComplainListing" object:nil];
}

- (void)receivedNotification {
    [self loadAppearMethod];
    [myDelegate showIndicator];
    [self performSelector:@selector(getComplainListing) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title=@"";
    [self loadAppearMethod];
    //call complain listing list data
    if ([[UserDefaultManager getValue:@"isFirstTime"] intValue] == 0 && !myDelegate.detailNotification) {
        _searchTextField.text = @"";
        isSearch = NO;
        [myDelegate showIndicator];
        [self performSelector:@selector(getComplainListing) withObject:nil afterDelay:.1];
    }  if (myDelegate.detailNotification) {
        ComplaintDetailViewController * complainDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComplaintDetailViewController"];
        [self.navigationController pushViewController:complainDetail animated:YES];
        return;
    }
}

- (void)loadAppearMethod {
    if ([myDelegate.screenName isEqualToString:@"myFeedback"]) {
        self.navigationItem.title=@"My Feedback";
        myDelegate.currentViewController=@"other";
    } else  if ([myDelegate.screenName isEqualToString:@"propertyFeedback"]) {
        self.navigationItem.title=@"Property Feedback";
        myDelegate.currentViewController= @"propertyFeedback";
    } else {
        self.navigationItem.title=@"Dashboard";
        myDelegate.currentViewController=@"dashboard";
    }
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (refreshComplainScreen) {
        [self changeButtonState:0];
    }
    //If user is long term contractor
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"]) {
        _addComplaintButton.hidden= YES;
    }
    //Add button shadow
    [_addComplaintButton addShadow:_addComplaintButton color:[UIColor grayColor]];
    
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)addComplainAction:(id)sender {
    //    Milestone 2 features
    AddComplainViewController * addComplain = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddComplainViewController"];
    addComplain.complainVC = self;
    [self.navigationController pushViewController:addComplain animated:YES];
}

- (IBAction)statusChangeAction:(id)sender {
    [self changeButtonState:(int)[sender tag]];
}
#pragma mark - end

#pragma mark - Filter status data
- (void)changeButtonState:(int)buttonTag {
    if (buttonTag == 0) {
        //Set assigned view UI
        [self setStatusViewDesign:[UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0] assignedTextColor:[UIColor whiteColor] progressBackgroundColor:[UIColor whiteColor] progressTextColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0] complteBackgroundColor:[UIColor whiteColor] completeTextColor:[UIColor colorWithRed:8/255.0 green:207/255.0 blue:8/255.0 alpha:1.0]];
    } else if (buttonTag == 2) {
        //Set complete view UI
        [self setStatusViewDesign:[UIColor whiteColor] assignedTextColor:[UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0] progressBackgroundColor:[UIColor whiteColor] progressTextColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0] complteBackgroundColor:[UIColor colorWithRed:8/255.0 green:207/255.0 blue:8/255.0 alpha:1.0] completeTextColor:[UIColor whiteColor]];
    } else if (buttonTag == 1) {
        //Set progress view UI
        [self setStatusViewDesign:[UIColor whiteColor] assignedTextColor:[UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0] progressBackgroundColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0] progressTextColor:[UIColor whiteColor] complteBackgroundColor:[UIColor whiteColor] completeTextColor:[UIColor colorWithRed:8/255.0 green:207/255.0 blue:8/255.0 alpha:1.0]];
    }
    [self filterStatusArray:buttonTag];
}

- (void)filterStatusArray:(int)buttonTag {
    _searchTextField.text = @"";
    isSearch = NO;
    [_searchTextField resignFirstResponder];
    //Show feedback listing with different status
    [filteredComplainListArray removeAllObjects];
    for (int i = 0; i < complainListArray.count; i++) {
        ComplainListDataModel *data=[complainListArray objectAtIndex:i];
        if (buttonTag == 0) {
            selectedButtonTag = 0;
            if ([data.complainStatus isEqualToString:@"Pending"]) {
                _noComplaintsLabel.hidden = YES;
                [filteredComplainListArray addObject:data];
            } else {
                if (filteredComplainListArray.count < 1) {
                    _noComplaintsLabel.hidden = NO;
                    _noComplaintsLabel.text = @"No Records Found.";
                }
            }
        } else if (buttonTag == 2) {
            selectedButtonTag = 2;
            if ([data.complainStatus isEqualToString:@"Complete"]) {
                _noComplaintsLabel.hidden = YES;
                [filteredComplainListArray addObject:data];
            }
            else {
                if (filteredComplainListArray.count < 1) {
                    _noComplaintsLabel.hidden = NO;
                    _noComplaintsLabel.text = @"No Records Found.";
                }
            }
            
        } else if (buttonTag == 1) {
            selectedButtonTag = 1;
            if ([data.complainStatus isEqualToString:@"In process"]) {
                _noComplaintsLabel.hidden = YES;
                [filteredComplainListArray addObject:data];
            }  else {
                if (filteredComplainListArray.count < 1) {
                    _noComplaintsLabel.hidden = NO;
                    _noComplaintsLabel.text = @"No Records Found.";
                }
            }
        }
        [_complainListingTable reloadData];
    }
}
- (void)setStatusViewDesign:(UIColor *)assignedBackgroundColor assignedTextColor:(UIColor *)assignedTextColor  progressBackgroundColor:(UIColor *)progressBackgroundColor progressTextColor:(UIColor *)progressTextColor complteBackgroundColor:(UIColor *)complteBackgroundColor completeTextColor:(UIColor *)completeTextColor {
    //Assigned UI
    _assignedView.backgroundColor = assignedBackgroundColor;
    _assignedCounterLabel.textColor = assignedTextColor;
    [_assignedButton setTitleColor:assignedTextColor forState:UIControlStateNormal];
    [_assignedView addShadowWithCornerRadius:_assignedView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:2.0];
    //Progress UI
    _progressView.backgroundColor = progressBackgroundColor;
    _progressCounterLabel.textColor = progressTextColor;
    [_progressButton setTitleColor:progressTextColor forState:UIControlStateNormal];
    [_progressView addShadowWithCornerRadius:_progressView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:2.0];
    //Complete UI
    _completeView.backgroundColor = complteBackgroundColor;
    _completeProgressLabel.textColor = completeTextColor;
    [_completeButton setTitleColor:completeTextColor forState:UIControlStateNormal];
    [_completeView addShadowWithCornerRadius:_completeView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:2.0];
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
        NSPredicate *filterName;
        if ([self checkIfTenant]) {
            filterName = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", searchKey];
        } else {
            filterName = [NSPredicate predicateWithFormat:@"userName CONTAINS[cd] %@", searchKey];
        }
        NSPredicate *filterDescription = [NSPredicate predicateWithFormat:@"complainDescription CONTAINS[cd] %@", searchKey];
        NSArray *subPredicates = [NSArray arrayWithObjects:filterName,filterDescription, nil];
        NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        searchArray = [filteredComplainListArray filteredArrayUsingPredicate:orPredicate];
    }
    else if((textField.text.length-1)!=0) {
        searchKey = [textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
        NSPredicate *filterName;
        if ([self checkIfTenant]) {
            filterName = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", searchKey];
        } else {
            filterName = [NSPredicate predicateWithFormat:@"userName CONTAINS[cd] %@", searchKey];
        }
        NSPredicate *filterDescription = [NSPredicate predicateWithFormat:@"complainDescription CONTAINS[cd] %@", searchKey];
        NSArray *subPredicates = [NSArray arrayWithObjects:filterName,filterDescription, nil];
        NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        searchArray = [filteredComplainListArray filteredArrayUsingPredicate:orPredicate];
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

- (BOOL)checkIfTenant {
    if (([[UserDefaultManager getValue:@"role"] isEqualToString:@"t"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) && ![myDelegate.currentViewController isEqualToString:@"propertyFeedback"]) {
        return YES;
    } else if (([[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) && [myDelegate.screenName isEqualToString:@"myFeedback"]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if ([self checkIfTenant]) {
        simpleTableIdentifier = @"TenantCell";
    } else {
        simpleTableIdentifier = @"ComplainCell";
    }
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
    ComplainListDataModel *data;
    if (isSearch) {
        data=[searchArray objectAtIndex:indexPath.row];
    } else {
        data=[filteredComplainListArray objectAtIndex:indexPath.row];
    }
    ComplaintDetailViewController * complainDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComplaintDetailViewController"];
    complainDetail.complainId = data.complainId;
    complainDetail.complainVC = self;
    [self.navigationController pushViewController:complainDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if ([self checkIfTenant]) {
        simpleTableIdentifier = @"TenantCell";
    } else {
        simpleTableIdentifier = @"ComplainCell";
    }
    ComplainListingCell *complainCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (complainCell == nil) {
        complainCell = [[ComplainListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    ComplainListDataModel *data;
    if (isSearch) {
        data=[searchArray objectAtIndex:indexPath.row];
    } else {
        data=[filteredComplainListArray objectAtIndex:indexPath.row];
    }
    float cellHeight;
    float totalCellHeight;
    CGRect textRectName;
    CGRect textRectDesc;
    CGSize size;
    size = CGSizeMake(_complainListingTable.frame.size.width-90,150);
    if ([self checkIfTenant]) {
        cellHeight = 25;
        textRectName=[self setDynamicHeight:size textString:[NSString stringWithFormat:@"Category - %@",data.category] textSize:18];
        textRectDesc=[self setDynamicHeight:size textString:data.complainDescription textSize:17];
        if (textRectDesc.size.height < 45) {
            totalCellHeight = cellHeight+textRectName.size.height+textRectDesc.size.height+20;
        } else {
            totalCellHeight = cellHeight+textRectName.size.height+65;
        }
        if (totalCellHeight <= 110) {
            return 110;
        } else {
            return totalCellHeight;
        }
    }
    
    else {
        //        cellHeight = 30;
//        complainCell.userNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
        //        complainCell.complainDescriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
        //        complainCell.complainTimeLabel.translatesAutoresizingMaskIntoConstraints = YES;
        
        NSAttributedString * nameStr = [[NSString stringWithFormat:@"%@ filed a feedback",data.userName] setAttributrdString:data.userName stringFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        complainCell.userNameLabel .attributedText = nameStr;
        [complainCell.userNameLabel sizeToFit];
        
        //        complainCell.complainDescriptionLabel.text = data.complainDescription;
        //        [complainCell.complainDescriptionLabel sizeToFit];
        
        //        textRectName=[self setDynamicHeight:size textString:[NSString stringWithFormat:@"%@ filed a feedback",data.userName] textSize:18];
        textRectDesc=[self setDynamicHeight:size textString:data.complainDescription textSize:17];
        //        complainCell.dateLabel.frame =CGRectMake(90, complainCell.complainDescriptionLabel.frame.origin.y + complainCell.complainDescriptionLabel.frame.size.height + 5,[[UIScreen mainScreen] bounds].size.width - 100, 20);
        
        //        if (textRectDesc.size.height < 45) {
        totalCellHeight = complainCell.contentView.frame.origin.y+8 +complainCell.userNameLabel.frame.origin.y +complainCell.userNameLabel.frame.size.height+10+complainCell.complainDescriptionLabel.frame.origin.y+25+10 +complainCell.complainTimeLabel.frame.origin.y +complainCell.complainTimeLabel.frame.size.height;
        //        } else {
        //            totalCellHeight = complainCell.contentView.frame.origin.y+8 +complainCell.userNameLabel.frame.origin.y +complainCell.userNameLabel.frame.size.height+10+complainCell.complainDescriptionLabel.frame.origin.y +45+10 +complainCell.complainTimeLabel.frame.origin.y +complainCell.complainTimeLabel.frame.size.height;
        //        NSLog(@" return %f",totalCellHeight);
        //        }
        return 8+complainCell.userNameLabel.frame.origin.y+complainCell.userNameLabel.frame.size.height+10 + complainCell.complainDescriptionLabel.frame.origin.y + 20 + complainCell.complainTimeLabel.frame.origin.y + complainCell.frame.size.height;
    }
}
#pragma mark - end

#pragma mark - Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString textSize:(int)textSize{
    CGRect textHeight = [textString boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:textSize]} context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - Pull to refresh
- (void)refershControlAction {
    _searchTextField.text = @"";
    isSearch = NO;
    [self performSelector:@selector(getComplainListing) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
//Get complain list data from webservice
- (void)getComplainListing {
    NSString *previousScreen;
    if ([myDelegate.screenName isEqualToString:@"myFeedback"]) {
        previousScreen = @"MYCOMPLAIN";
    } else if ([myDelegate.screenName isEqualToString:@"propertyFeedback"]) {
        previousScreen = @"PROPERTYFEEDBACK";
    }
    else {
        previousScreen = @"DASHBOARD";
    }
    [[ComplainService sharedManager] getComplainListing:previousScreen success:^(NSMutableArray *dataArray){
        [complainListArray removeAllObjects];
        complainListArray = dataArray;
        //Show feedback status counts
        NSMutableArray *pendingArray = [[NSMutableArray alloc]init];
        NSMutableArray *progressArray = [[NSMutableArray alloc]init];
        NSMutableArray *completeArray = [[NSMutableArray alloc]init];
        _assignedCounterLabel.text = @"0";
        _progressCounterLabel.text = @"0";
        _completeProgressLabel.text = @"0";
        for (int i = 0; i < complainListArray.count; i++) {
            ComplainListDataModel *data=[complainListArray objectAtIndex:i];
            if ([data.complainStatus isEqualToString:@"Pending"]) {
                [pendingArray addObject:data];
                _assignedCounterLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)pendingArray.count] ;
            } else if ([data.complainStatus isEqualToString:@"Complete"]) {
                [progressArray addObject:data];
                _completeProgressLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)progressArray.count] ;
            } else if ([data.complainStatus isEqualToString:@"In process"]) {
                [completeArray addObject:data];
                _progressCounterLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)completeArray.count] ;
            }
        }
        //If no feedbacks
        if (complainListArray.count<1) {
            _noComplaintsLabel.hidden = NO;
        } else {
            _noComplaintsLabel.hidden = YES;
        }
        //Filter array
        [self filterStatusArray:selectedButtonTag];
        [_refreshControl endRefreshing];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        if ([error.localizedDescription containsString:@"Internet"] || [error.localizedDescription containsString:@"network connection"]) {
            _noComplaintsLabel.text = @"No Internet Connection.";
        } else  {
            _noComplaintsLabel.text = @"No Records Found.";
        }
        [_refreshControl endRefreshing];
        if (complainListArray.count < 1) {
            _noComplaintsLabel.hidden = NO;
        }
        [self changeButtonState:selectedButtonTag];
    }] ;
}
#pragma mark - end

@end
