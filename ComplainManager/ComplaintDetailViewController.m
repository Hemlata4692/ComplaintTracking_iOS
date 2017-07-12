//
//  ComplaintDetailViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 26/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplaintDetailViewController.h"
#import "ComplainDetailCell.h"
#import "AddComplainCell.h"
#import "ComplainService.h"
#import <AVFoundation/AVFoundation.h>
#import "CommentsModel.h"

@interface ComplaintDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGRect textRect;
    CGSize size;
    CGFloat messageHeight;
    float mainContainerHeight;
    NSMutableArray *staffImageArray;
    NSMutableArray *complainImageArray;
    NSMutableArray *imagesNameArray;
    NSMutableArray *commentsArray;
    NSArray *userCategoriesArray;
    NSMutableDictionary *detailDict;
    float commentsViewHeight;
    float commentsCellHeight;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailSeparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *categorySeparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationSeparatorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *startJobButton;
@property (weak, nonatomic) IBOutlet UIView *commentsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UIView *addCommentContainerView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *addCommentTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendCommentButton;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UIButton *completeJobAction;
//User comment view
@property (weak, nonatomic) IBOutlet UIView *UserStatusView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *complaintStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *reonpenJobButton;

@end

@implementation ComplaintDetailViewController

@synthesize complainId;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationItem.title=@"Complaint Details";
    staffImageArray = [[NSMutableArray alloc]init];
    complainImageArray = [[NSMutableArray alloc]init];
    imagesNameArray = [[NSMutableArray alloc]init];
    detailDict = [[NSMutableDictionary alloc]init];
    userCategoriesArray = [[NSArray alloc]init];
    [_addCommentTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    [myDelegate showIndicator];
    [self performSelector:@selector(getComplaintDetails) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}
#pragma mark - end

#pragma mark - View customisation
- (void)setViewFrames: (NSDictionary *)data {
    _mainContainerView.hidden = NO;
    _mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
    _categoryLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _categorySeparatorLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _locationLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _locationSeparatorLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _detailSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _imageCollectionView.translatesAutoresizingMaskIntoConstraints = YES;
    _startJobButton.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsCountLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _addCommentContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _addCommentTextView.translatesAutoresizingMaskIntoConstraints = YES;
    _sendCommentButton.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsTableView.translatesAutoresizingMaskIntoConstraints = YES;
    _completeJobAction.translatesAutoresizingMaskIntoConstraints = YES;
    _UserStatusView.translatesAutoresizingMaskIntoConstraints = YES;
    _reonpenJobButton.translatesAutoresizingMaskIntoConstraints = YES;
    //Set category label frame
    NSAttributedString * categoryString = [[NSString stringWithFormat:@"Category - %@",[data objectForKey:@"CategoryName"]] setAttributrdString:@"Category -" stringFont:[UIFont fontWithName:@"Roboto-Regular" size:18.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.9]];
    _categoryLabel.attributedText = categoryString;
    _categoryLabel.frame = CGRectMake(_categoryLabel.frame.origin.x, 20, self.view.frame.size.width-20, _categoryLabel.frame.size.height);
    _categorySeparatorLabel.frame = CGRectMake(_categorySeparatorLabel.frame.origin.x, _categoryLabel.frame.origin.y+_categoryLabel.frame.size.height + 1, self.view.frame.size.width-20, 1);
    //Set location label frame
    NSAttributedString * locationString = [[NSString stringWithFormat:@"Location - %@",[data objectForKey:@"PropertyLocationName"]] setAttributrdString:@"Location -" stringFont:[UIFont fontWithName:@"Roboto-Regular" size:18.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.9]];
    _locationLabel.attributedText = locationString;
    _locationLabel.frame = CGRectMake(_locationLabel.frame.origin.x, _categoryLabel.frame.origin.y+_categoryLabel.frame.size.height + 15, self.view.frame.size.width-20, _locationLabel.frame.size.height);
    _locationSeparatorLabel.frame = CGRectMake(_locationSeparatorLabel.frame.origin.x, _locationLabel.frame.origin.y+_locationLabel.frame.size.height + 1, self.view.frame.size.width-20, 1);
    size = CGSizeMake(self.view.frame.size.width-20,500);
    //Detail text view frame
    _descriptionLabel.numberOfLines = 0;
    textRect=[self setDynamicHeight:size textString:[data objectForKey:@"FullDescription"] textSize:18];
    if(textRect.size.height < 40) {
        _descriptionLabel.frame = CGRectMake(10, _locationLabel.frame.origin.y+_locationLabel.frame.size.height + 15, self.view.frame.size.width-20, 40);
        _detailSeparatorLabel.frame = CGRectMake(10, _descriptionLabel.frame.origin.y+_descriptionLabel.frame.size.height + 1, self.view.frame.size.width-20, 1);
    } else {
        _descriptionLabel.frame = CGRectMake(10, _locationLabel.frame.origin.y+_locationLabel.frame.size.height + 15, self.view.frame.size.width-20, textRect.size.height+5);
        _detailSeparatorLabel.frame = CGRectMake(10, _descriptionLabel.frame.origin.y+_descriptionLabel.frame.size.height + 5, self.view.frame.size.width-20, 1);
    }
    _descriptionLabel.text = [data objectForKey:@"FullDescription"];
    complainImageArray = [data objectForKey:@"ImageName"];
    [_imageCollectionView reloadData];
    //Set image collection view frame
    if (complainImageArray.count<1) {
        _imageCollectionView.frame = CGRectMake(_imageCollectionView.frame.origin.x, _descriptionLabel.frame.origin.y+_descriptionLabel.frame.size.height, self.view.frame.size.width-20, 0);
    } else {
        _imageCollectionView.frame = CGRectMake(_imageCollectionView.frame.origin.x, _descriptionLabel.frame.origin.y+_descriptionLabel.frame.size.height + 15, self.view.frame.size.width-20, _imageCollectionView.frame.size.height);
    }
    if (commentsArray.count < 1) {
        _commentsCountLabel.hidden = YES;
        _commentsCountLabel.frame = CGRectMake(10,0, self.view.frame.size.width-20,0);
    } else {
        _commentsCountLabel.hidden = NO;
        if (commentsArray.count == 1) {
            _commentsCountLabel.text = [NSString stringWithFormat:@"%lu comment",(unsigned long)commentsArray.count];
        } else {
            _commentsCountLabel.text = [NSString stringWithFormat:@"%lu comments",(unsigned long)commentsArray.count];
        }
    }
    if ([[data objectForKey:@"ComplainStatus"] containsString:@"process"]) {
        _complaintStatusLabel.text = @"In Progress";
        _complaintStatusLabel.textColor = [UIColor colorWithRed:0/255.0 green:152/255.0 blue:206/255.0 alpha:1.0];
    } else if ([[data objectForKey:@"ComplainStatus"] containsString:@"Complete"]){
        _complaintStatusLabel.text = [data objectForKey:@"ComplainStatus"];
        _complaintStatusLabel.textColor = [UIColor colorWithRed:3/255.0 green:207/255.0 blue:4/255.0 alpha:1.0];
    } else {
        _complaintStatusLabel.text = [data objectForKey:@"ComplainStatus"];
        _complaintStatusLabel.textColor = [UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0];
    }
    //Comments container view frame
    if ([[data objectForKey:@"ComplainStatus"] isEqualToString:@"Complete"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"t"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) {
        [self setCommonUserStatusViewFrames];
        _commentsCountLabel.frame = CGRectMake(10, _UserStatusView.frame.origin.y + _UserStatusView.frame.size.height + 10, self.view.frame.size.width-20, _commentsCountLabel.frame.size.height);
        if (commentsArray.count < 1) {
            _commentsTableView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 5,self.view.frame.size.width-20, 0);
        }
        else {
            _commentsTableView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 5,self.view.frame.size.width-20, commentsCellHeight + 20);
        }
        commentsViewHeight = _UserStatusView.frame.size.height+20+_commentsCountLabel.frame.size.height+20+_commentsTableView.frame.size.height+10;
    } // Show start job view
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"]) {
        if ([[data objectForKey:@"ComplainStatus"] isEqualToString:@"Pending"]) {
            //Start job button frame
            _startJobButton.frame = CGRectMake(30, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 20, self.view.frame.size.width-60, _startJobButton.frame.size.height);
            _commentsContainerView.hidden = YES;
            if ([userCategoriesArray containsObject:[detailDict objectForKey:@"CategoryId"]]) {
                _startJobButton.hidden = NO;
                _commentsContainerView.hidden = YES;
            } else {
                [self setCommonUserStatusViewFrames];
            }
        } else if ([[data objectForKey:@"ComplainStatus"] isEqualToString:@"In process"] || ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] && [[data objectForKey:@"ComplainStatus"] isEqualToString:@"Complete"])) {
            // Show In progress view if feedback assigned to user
            if ([[data objectForKey:@"ComplainStatus"] isEqualToString:@"In process"]) {
                if ([[detailDict objectForKey:@"AssignTo"] isEqualToString:[UserDefaultManager getValue:@"userId"]]) {
                    [self setCommonStatusFrames];
                    _reonpenJobButton.hidden = YES;
                    _completeJobAction.hidden = NO;
                    [self commonAddCommentsTextViewFrames];
                    [_completeJobAction setCornerRadius:3];
                    commentsViewHeight = 20+_addCommentContainerView.frame.size.height+20+_commentsTableView.frame.size.height+20+_completeJobAction.frame.size.height+20;
                }
                else {
                    if ([userCategoriesArray containsObject:[detailDict objectForKey:@"CategoryId"]]) {
                        if ([myDelegate.screenName isEqualToString:@"dashboard"]) {
                            //Show assigned alert if feedback asssigned to other.
                            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                            [alert showWarning:nil title:@"Alert" subTitle:@"Feedback already assigned to other staff member." closeButtonTitle:@"OK" duration:0.0f];
                        }
                    }
                    //Show informatory view
                    [self setCommonUserStatusViewFrames];
                    _complaintStatusLabel.frame = CGRectMake(150,0, _UserStatusView.frame.size.width-160, _complaintStatusLabel.frame.size.height);
                    _commentsCountLabel.frame = CGRectMake(10, _UserStatusView.frame.origin.y + _UserStatusView.frame.size.height + 10, self.view.frame.size.width-20, _commentsCountLabel.frame.size.height);
                    if (commentsArray.count < 1) {
                        _commentsTableView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 5,self.view.frame.size.width-20, 0);
                    }
                    else {
                        _commentsTableView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 5,self.view.frame.size.width-20, commentsCellHeight + 20);
                    }
                    commentsViewHeight = _UserStatusView.frame.size.height+20+_commentsCountLabel.frame.size.height+20+_commentsTableView.frame.size.height+10;
                }
            } else if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] && [[data objectForKey:@"ComplainStatus"] isEqualToString:@"Complete"]) {
                // If feedback status is completed
                [self setCommonStatusFrames];
                _completeJobAction.hidden = YES;
                _reonpenJobButton.hidden = NO;
                [self commonAddCommentsTextViewFrames];
                [_reonpenJobButton setCornerRadius:3];
                commentsViewHeight = 20+_addCommentContainerView.frame.size.height+20+_commentsTableView.frame.size.height+20+_reonpenJobButton.frame.size.height+20;
            }
        }
    }
    _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 10, self.view.frame.size.width,commentsViewHeight + 20);
    mainContainerHeight = 20 + _descriptionLabel.frame.size.height+21+_categoryLabel.frame.size.height+21+_locationLabel.frame.size.height+21+_imageCollectionView.frame.size.height +20 +_commentsContainerView.frame.size.height + 20;
    _mainContainerView.frame = CGRectMake(_mainContainerView.frame.origin.x, _mainContainerView.frame.origin.y, self.view.frame.size.width, mainContainerHeight);
    _scrollView.contentSize = CGSizeMake(0,mainContainerHeight+20);
}
//Set common frames for informatory view
-(void)setCommonUserStatusViewFrames {
    _UserStatusView.hidden=NO;
    _commentsContainerView.hidden = NO;
    _addCommentContainerView.hidden=YES;
    _startJobButton.hidden=YES;
    _completeJobAction.hidden=YES;
    _UserStatusView.frame = CGRectMake(10,0, self.view.frame.size.width-20, _UserStatusView.frame.size.height);
    [_UserStatusView setBottomBorder:_UserStatusView];
    _statusLabel.frame = CGRectMake(10,0, _UserStatusView.frame.size.width-150, _statusLabel.frame.size.height);
    _complaintStatusLabel.frame = CGRectMake(150,0, _UserStatusView.frame.size.width-160, _complaintStatusLabel.frame.size.height);
}
//Show informatory view
- (void)setCommonStatusFrames {
    _startJobButton.hidden = YES;
    _UserStatusView.hidden=YES;
    _commentsContainerView.hidden=NO;
    _addCommentContainerView.hidden=NO;
    _commentsCountLabel.frame = CGRectMake(10,0, self.view.frame.size.width-20, 30);
    _addCommentTextView.text = @"";
    [_addCommentTextView setPlaceholder:@" Add Comment"];
    [_addCommentTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
    messageHeight = 40;
    if (commentsArray.count < 1) {
        _commentsCountLabel.frame = CGRectMake(10,-10, self.view.frame.size.width-20,0);
    }
    _addCommentContainerView.frame = CGRectMake(0, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width, messageHeight + 10);
    _addCommentTextView.frame = CGRectMake(10, 2, _addCommentContainerView.frame.size.width - 48, messageHeight);
    [_addCommentTextView setViewBorder:_addCommentTextView color:[UIColor clearColor]];
    [_addCommentTextView setCornerRadius:3];
    _sendCommentButton.frame = CGRectMake(_addCommentTextView.frame.origin.x+_addCommentTextView.frame.size.width+0.5, 0, 40, 40);
    if ([_addCommentTextView.text isEqualToString:@""] || _addCommentTextView.text.length == 0) {
        _sendCommentButton.enabled = NO;
    }
    else {
        _sendCommentButton.enabled = YES;
    }
    if (commentsArray.count < 1) {
        _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 5,self.view.frame.size.width-20, 0);
    } else {
        _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 5,self.view.frame.size.width-20, commentsCellHeight + 20);
    }
}

//Set comments text frames
- (void)commonAddCommentsTextViewFrames {
    if (commentsArray.count < 1) {
        _commentsTableView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 5,self.view.frame.size.width-20, 0);
        if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]  && [[detailDict objectForKey:@"ComplainStatus"] isEqualToString:@"Complete"]) {
            _reonpenJobButton.frame = CGRectMake(30, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
        } else {
            _completeJobAction.frame = CGRectMake(30, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
        }
    }
    else {
        _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 5,self.view.frame.size.width-20, commentsCellHeight + 20);
        if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]  && [[detailDict objectForKey:@"ComplainStatus"] isEqualToString:@"Complete"]) {
            _reonpenJobButton.frame = CGRectMake(30, _commentsTableView.frame.origin.y + _commentsTableView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
        } else {
            _completeJobAction.frame = CGRectMake(30, _commentsTableView.frame.origin.y + _commentsTableView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
        }
    }
}

//Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString textSize:(int)textSize{
    CGRect textHeight = [textString boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:textSize]} context:nil];
    return textHeight;
}

// Get dynamic height of table view
- (void)getCommentsTableHeight {
    commentsCellHeight = 0;
    for (int i = 0; i < commentsArray.count; i++) {
        CGRect textRectHeight;
        CommentsModel *commentsModel = [commentsArray objectAtIndex:i];
        NSString * titleTextStr = commentsModel.commnts;
        CGSize commentsSize;
        commentsSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width-20,500);
        textRectHeight=[self setDynamicHeight:commentsSize textString:titleTextStr];
        float height = 30+textRectHeight.size.height;
        commentsCellHeight = commentsCellHeight + height;
    }
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ((_commentsContainerView.frame.origin.y +textView.frame.origin.y)+textView.frame.size.height+15<([UIScreen mainScreen].bounds.size.height-64)-256) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, (((_commentsContainerView.frame.origin.y +textView.frame.origin.y)+textView.frame.size.height+15)- ([UIScreen mainScreen].bounds.size.height-64-256))+5) animated:NO];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _addCommentTextView) {
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            return NO;
        }
    }
    if (range.length > 0 && [text length] == 0)
    {
        return YES;
    }
    if (textView.text.length >= 500 && range.length == 0)
    {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _addCommentTextView) {
        if (([_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height < 80) && ([_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height > 50)) {
            _addCommentTextView.frame = CGRectMake(10, 2, _addCommentContainerView.frame.size.width - 48, [_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height+8);
            messageHeight = [_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height + 8;
            _addCommentContainerView.frame = CGRectMake(0, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width, messageHeight +10 );
            [self commonAddCommentsTextViewFrames ];
            _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 10, self.view.frame.size.width, _completeJobAction.frame.origin.y +_completeJobAction.frame.size.height+10);
        }
        else if ([_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height <= 50) {
            messageHeight = 40;
            _addCommentTextView.frame = CGRectMake(10, 2, _addCommentContainerView.frame.size.width - 48, messageHeight);
            _addCommentContainerView.frame = CGRectMake(0, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width, messageHeight + 10);
            [self commonAddCommentsTextViewFrames ];
            _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 10, self.view.frame.size.width, _completeJobAction.frame.origin.y +_completeJobAction.frame.size.height+10);
        }
        if ((_commentsContainerView.frame.origin.y +textView.frame.origin.y)+textView.frame.size.height+15<([UIScreen mainScreen].bounds.size.height-64)-256) {
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else {
            [_scrollView setContentOffset:CGPointMake(0, (((_commentsContainerView.frame.origin.y +textView.frame.origin.y)+textView.frame.size.height+10)- ([UIScreen mainScreen].bounds.size.height-64-256))+15) animated:NO];
        }
        NSString *string = textView.text;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (textView.text.length>=1) {
            if (trimmedString.length>=1) {
                _sendCommentButton.enabled=YES;
            }
            else if (trimmedString.length==0) {
                _sendCommentButton.enabled=NO;
            }
        }
        else if (textView.text.length==0) {
            _sendCommentButton.enabled=NO;
        }
    }
}
#pragma mark - end

#pragma mark - Collection view methds
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([[detailDict objectForKey:@"ComplainStatus"] isEqualToString:@"In process"] || ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] && [[detailDict objectForKey:@"ComplainStatus"] isEqualToString:@"Complete"])) {
        if (myDelegate.isDetailJobStarted) {
            return complainImageArray.count;
        } else {
            if  (staffImageArray.count < 3){
                return complainImageArray.count + 1;
            } else {
                return complainImageArray.count;
            }
        }
    } else {
        return complainImageArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier;
    AddComplainCell *cell;
    if (indexPath.row != complainImageArray.count) {
        identifier = @"complainImage";
        cell = [_imageCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.deleteImageButton.tag = indexPath.item;
        [cell.deleteImageButton addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell displayData:(int)indexPath.row data:complainImageArray isAddComplainScreen:false];
    }
    else {
        identifier = @"addMoreImages";
        cell = [_imageCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.selectImageButton.tag = indexPath.item;
        [cell.selectImageButton addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"ComplainCell";
    ComplainDetailCell *complainCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (complainCell == nil) {
        complainCell = [[ComplainDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    CommentsModel *commentsModel = [commentsArray objectAtIndex:indexPath.row];
    [complainCell displayCommentsListData:commentsModel indexPath:indexPath.row];
    return complainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect textRectHeight;
    CommentsModel *commentsModel = [commentsArray objectAtIndex:indexPath.row];
    NSString * titleTextStr = commentsModel.commnts;
    CGSize commentsSize;
    commentsSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width-20,500);
    textRectHeight=[self setDynamicHeight:commentsSize textString:titleTextStr];
    return 30+textRectHeight.size.height;
}
#pragma mark - end

#pragma mark - Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - IBActions
-(IBAction)deleteImageAction:(id)sender {
    if ([staffImageArray containsObject:[complainImageArray objectAtIndex:[sender tag]]]) {
        [staffImageArray removeObject:[complainImageArray objectAtIndex:[sender tag]]];
    }
    [complainImageArray removeObjectAtIndex:[sender tag]];
    [_imageCollectionView reloadData];
}

-(IBAction)selectImageAction:(id)sender {
    [self showActionSheet];
}

- (IBAction)startJobAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Yes" actionBlock:^(void) {
        [myDelegate showIndicator];
        [self performSelector:@selector(changeComplainStatus:) withObject:@"In process" afterDelay:.1];
    }];
    [alert showWarning:nil title:@"Alert" subTitle:@"Are you sure you want to start the job?" closeButtonTitle:@"No" duration:0.0f];
}

- (IBAction)completeJobAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Yes" actionBlock:^(void) {
        [myDelegate showIndicator];
        if (staffImageArray.count >= 1) {
            [self performSelector:@selector(uploadImage:) withObject:staffImageArray afterDelay:.1];
            
        } else {
            [self performSelector:@selector(changeComplainStatus:) withObject:@"Complete" afterDelay:.1];
        }
    }];
    [alert showWarning:nil title:@"Alert" subTitle:@"Are you sure you have completed the job?" closeButtonTitle:@"No" duration:0.0f];
}

- (IBAction)sendCommentAction:(id)sender {
    [myDelegate showIndicator];
    [self performSelector:@selector(addComments) withObject:nil afterDelay:.1];
}

- (IBAction)reopenJobAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Yes" actionBlock:^(void) {
        [myDelegate showIndicator];
        if (staffImageArray.count >= 1) {
            [self performSelector:@selector(uploadImage:) withObject:staffImageArray afterDelay:.1];
            
        } else {
            [self performSelector:@selector(changeComplainStatus:) withObject:@"Reopen" afterDelay:.1];
        }
    }];
    [alert showWarning:nil title:@"Alert" subTitle:@"Are you sure you want to reopen the job?" closeButtonTitle:@"No" duration:0.0f];
}
#pragma mark - end

#pragma mark - Show actionsheet method
- (void)showActionSheet {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select Image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            [self openDefaultCamera];
        }
        else if(authStatus == AVAuthorizationStatusDenied) {
            [self showAlertCameraAccessDenied];
        }
        else if(authStatus == AVAuthorizationStatusRestricted){
            [self showAlertCameraAccessDenied];
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self openDefaultCamera];
                    });
                }
            }];
        }
    }];
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction * defaultAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:cameraAction];
    [alert addAction:galleryAction];
    [alert addAction:defaultAct];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openDefaultCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)showAlertCameraAccessDenied {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Settings" actionBlock:^(void) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }];
    [alert showWarning:nil title:@"Camera Access" subTitle:@"Without permission to use your camera, you won't be able to take photo.\nGo to your device settings and then Privacy to grant permission." closeButtonTitle:@"Cancel" duration:0.0f];
    
}
#pragma mark - end

#pragma mark - ImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    UIImage *fixedImage = [image fixOrientation];
    [staffImageArray addObject:fixedImage];
    [complainImageArray addObject:fixedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_imageCollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Web services
//Get complaint details
- (void)getComplaintDetails {
    myDelegate.isDetailJobStarted = false;
    [[ComplainService sharedManager] getComplaitDetail:complainId success:^(NSMutableDictionary * responseObject){
        [myDelegate stopIndicator];
        detailDict = responseObject;
        commentsArray = [[NSMutableArray alloc]init];
        commentsArray = [responseObject objectForKey:@"comments"];
        userCategoriesArray = [responseObject objectForKey:@"userCategoryArray"];
        [self getCommentsTableHeight];
        [self setViewFrames:detailDict];
        [_commentsTableView reloadData];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
    }] ;
}

//Change complain status
- (void)changeComplainStatus:(NSString *)complainStatus {
    if ([complainStatus isEqualToString:@"In process"]) {
        myDelegate.isDetailJobStarted = true;
    }
    [[ComplainService sharedManager] changeJobStatus:complainId jobStatus:complainStatus imageNameArray:imagesNameArray success:^(id responseObject) {
        myDelegate.isDetailJobStarted = false;
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            if ([complainStatus isEqualToString:@"In process"]) {
                [detailDict removeObjectForKey:@"ComplainStatus"];
                [detailDict setObject:@"In process" forKey:@"ComplainStatus"];
                [detailDict setObject:[UserDefaultManager getValue:@"userId"] forKey:@"AssignTo"];
                [self setViewFrames:detailDict];
            } else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                [myDelegate.window setRootViewController:objReveal];
                [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
                [myDelegate.window makeKeyAndVisible];
            }
        }];
        [alert showWarning:nil title:@"Alert" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:nil duration:0.0f];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        if (myDelegate.isDetailJobStarted) {
            if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions error:&error];
                NSLog(@"json %@",json);
                [self isStatusOK:json];
            }
        }
    }] ;
}

//Check response success
- (BOOL)isStatusOK:(id)responseObject {
    NSNumber *number = responseObject[@"status"];
    NSString *msg;
    switch (number.integerValue) {
        case 400: {
            msg = responseObject[@"message"];
            if ([msg containsString:@"Your account has been deactivated."]) {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert addButton:@"OK" actionBlock:^(void) {
                    [self removeDefaultValues];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                    myDelegate.window.rootViewController = myDelegate.navigationController;
                }];
                [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:nil duration:0.0f];
            } else  if ([msg containsString:@"assign"]) {
                [myDelegate showIndicator];
                [self performSelector:@selector(getComplaintDetails) withObject:nil afterDelay:.1];
            }
            else {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
            }
            return NO;
        }
        case 404: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
            return NO;
        }
        case 200:
            return YES;
            break;
        case 401: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"OK" actionBlock:^(void) {
                [self removeDefaultValues];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                myDelegate.window.rootViewController = myDelegate.navigationController;
            }];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:nil duration:0.0f];
        }
            return NO;
            break;
        default: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
        }
            return NO;
            break;
    }
}

//Remove default values
- (void)removeDefaultValues {
    [UserDefaultManager removeValue:@"name"];
    [UserDefaultManager removeValue:@"userId"];
    [UserDefaultManager removeValue:@"AuthenticationToken"];
    [UserDefaultManager removeValue:@"contactNumber"];
    [UserDefaultManager removeValue:@"isFirsttime"];
    [UserDefaultManager removeValue:@"role"];
    [UserDefaultManager removeValue:@"email"];
    [UserDefaultManager removeValue:@"propertyId"];
    myDelegate.screenName= @"dashboard";
    myDelegate.selectedMenuIndex = 0;
}

//Upload image
- (void)uploadImage:(NSMutableArray *)imagesArray {
    for (int i = 0; i < imagesArray.count; i++) {
        [[ComplainService sharedManager] uploadImage:[imagesArray objectAtIndex:i] screenName:@"COMPLAIN" success:^(id responseObject){
            [imagesNameArray addObject:[responseObject objectForKey:@"list"]];
            NSLog(@"imagesNameArray.count = %lu",(unsigned long)imagesNameArray.count);
            if (imagesArray.count == imagesNameArray.count) {
                [self performSelector:@selector(changeComplainStatus:) withObject:@"Complete" afterDelay:.1];
            }
        } failure:^(NSError *error) {
            [myDelegate stopIndicator];
        }] ;
    }
}

//Add comments
- (void)addComments {
    [_addCommentTextView resignFirstResponder];
    [[ComplainService sharedManager] addComment:complainId comments:_addCommentTextView.text success:^(id responseObject){
        [myDelegate stopIndicator];
        CommentsModel *commentModel = [[CommentsModel alloc]init];
        NSDictionary * commentDict =[responseObject objectForKey:@"Comments"];
        commentModel.commnts = [commentDict objectForKey:@"comments"];
        commentModel.time =[commentDict objectForKey:@"SubmittedOn"];
        [commentsArray insertObject:commentModel atIndex:0];
        [self getCommentsTableHeight];
        [_commentsTableView reloadData];
        [self setViewFrames:detailDict];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
    }] ;
}
#pragma mark - end
@end
