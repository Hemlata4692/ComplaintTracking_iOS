//
//  TenantsComplaintDetailsViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 22/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "TenantsComplaintDetailsViewController.h"
#import "ComplainDetailCell.h"
#import "AddComplainCell.h"

@interface TenantsComplaintDetailsViewController ()
{
    CGRect textRect;
    CGSize size;
    CGFloat messageHeight;
    float mainContainerHeight;
    NSArray *imageArray;
    BOOL isJobStarted;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailSeparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
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

@end

@implementation TenantsComplaintDetailsViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationItem.title=@"Complaint Details";
    [UserDefaultManager setValue:@"t" key:@"role"];
    isJobStarted = true;
    imageArray = [NSArray arrayWithObjects:@"clean swimming pool",@"pipeline issue",@"cleaning", nil];
    [self setViewFrames];
    //        imageArray = [[NSArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark - View customisation
- (void)setViewFrames {
    _mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
    _titleLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _detailsTextView.translatesAutoresizingMaskIntoConstraints = YES;
    _detailSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _categoryLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _imageCollectionView.translatesAutoresizingMaskIntoConstraints = YES;
    _startJobButton.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    //Remove comments container view autolayouts
    _commentsContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsCountLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _addCommentContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _addCommentTextView.translatesAutoresizingMaskIntoConstraints = YES;
    _sendCommentButton.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsTableView.translatesAutoresizingMaskIntoConstraints = YES;
    _completeJobAction.translatesAutoresizingMaskIntoConstraints = YES;
    _UserStatusView.translatesAutoresizingMaskIntoConstraints = YES;
    float commentsViewHeight;
    //Set title text frame
    size = CGSizeMake(self.view.frame.size.width-20,90);
    NSString * titleTextStr = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ";
    NSString * detailTextStr = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt Lorem ipsu";
    textRect=[self setDynamicHeight:size textString:titleTextStr];
    _titleLabel.numberOfLines = 0;
    _titleLabel.frame =CGRectMake(10, 10, self.view.frame.size.width-20, textRect.size.height+3);
    _titleLabel.text=titleTextStr;
    [_titleLabel setBottomBorder:_titleLabel color:[UIColor clearColor]];
    //Detail text view frame
    textRect=[self setDynamicHeight:size textString:detailTextStr];
    if ((textRect.size.height < 90) && (textRect.size.height > 37)) {
        _detailsTextView.frame = CGRectMake(_detailsTextView.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height + 20, self.view.frame.size.width-20, textRect.size.height+5);
    }
    else if(textRect.size.height < 40) {
        _detailsTextView.frame = CGRectMake(_detailsTextView.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height + 20, self.view.frame.size.width-20, 40);
    }
    _detailsTextView.text = detailTextStr;
    _detailSeparatorLabel.frame = CGRectMake(_detailsTextView.frame.origin.x, _detailsTextView.frame.origin.y+_detailsTextView.frame.size.height + 5, self.view.frame.size.width-20, 1);
    //Set category label frame
    _categoryLabel.frame = CGRectMake(_categoryLabel.frame.origin.x, _detailsTextView.frame.origin.y+_detailsTextView.frame.size.height + 15, self.view.frame.size.width-20, _categoryLabel.frame.size.height);
    [_categoryLabel setBottomBorder:_categoryLabel color:[UIColor clearColor]];
    //Set image collection view frame
    if (imageArray.count<1) {
        _imageCollectionView.frame = CGRectMake(_imageCollectionView.frame.origin.x, _categoryLabel.frame.origin.y+_categoryLabel.frame.size.height, self.view.frame.size.width-20, 0);
    } else {
        _imageCollectionView.frame = CGRectMake(_imageCollectionView.frame.origin.x, _categoryLabel.frame.origin.y+_categoryLabel.frame.size.height + 20, self.view.frame.size.width-20, _imageCollectionView.frame.size.height);
    }
    //Start job button frame
    _startJobButton.frame = CGRectMake(_startJobButton.frame.origin.x, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 20, self.view.frame.size.width-60, _startJobButton.frame.size.height);
    if (isJobStarted) {
        _commentsContainerView.hidden = NO;
        _startJobButton.hidden = YES;
        _scrollView.scrollEnabled= YES;
    } else {
        _commentsContainerView.hidden = YES;
        _startJobButton.hidden = NO;
        _scrollView.scrollEnabled= NO;
    }
    //Comments container view frame
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"t"]) {
        _addCommentContainerView.hidden=YES;
        _startJobButton.hidden=YES;
        _completeJobAction.hidden=YES;
        _UserStatusView.frame = CGRectMake(10,10, self.view.frame.size.width-20, _UserStatusView.frame.size.height);
        [_UserStatusView setBottomBorder:_UserStatusView color:[UIColor clearColor]];
        _statusLabel.frame = CGRectMake(10,0, _UserStatusView.frame.size.width-150, _statusLabel.frame.size.height);
        _complaintStatusLabel.frame = CGRectMake(150,0, _UserStatusView.frame.size.width-160, _complaintStatusLabel.frame.size.height);
        _commentsCountLabel.frame = CGRectMake(10, _UserStatusView.frame.origin.y + _UserStatusView.frame.size.height + 10, self.view.frame.size.width-20, _commentsCountLabel.frame.size.height);
        _commentsTableView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width-20, _commentsTableView.frame.size.height+80);
        commentsViewHeight = _UserStatusView.frame.size.height+20+_commentsCountLabel.frame.size.height+20+_commentsTableView.frame.size.height;
    } else {
        _UserStatusView.hidden=YES;
        _commentsCountLabel.frame = CGRectMake(10,10, self.view.frame.size.width-20, _commentsCountLabel.frame.size.height);
        _addCommentTextView.text = @"";
        [_addCommentTextView setPlaceholder:@" Add Comment"];
        [_addCommentTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:13.0]];
        messageHeight = 40;
        _addCommentContainerView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width-20, messageHeight + 10);
        _addCommentTextView.frame = CGRectMake(0, 2, _addCommentContainerView.frame.size.width - 30, messageHeight);
        [_addCommentTextView setViewBorder:_addCommentTextView color:[UIColor clearColor]];
        [_addCommentTextView setCornerRadius:3];
        _sendCommentButton.frame = CGRectMake(_addCommentTextView.frame.origin.x+_addCommentTextView.frame.size.width+5, 5, 25, 30);
        if ([_addCommentTextView.text isEqualToString:@""] || _addCommentTextView.text.length == 0) {
            _sendCommentButton.enabled = NO;
        }
        else {
            _sendCommentButton.enabled = YES;
        }
        _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 10,self.view.frame.size.width-20, _commentsTableView.frame.size.height);
        _completeJobAction.frame = CGRectMake(30, _commentsTableView.frame.origin.y + _commentsTableView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
        [_completeJobAction setCornerRadius:3];
        commentsViewHeight = 20+_addCommentContainerView.frame.size.height+20+_commentsTableView.frame.size.height+20+_startJobButton.frame.size.height+30;
    }
    _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 20, self.view.frame.size.width,commentsViewHeight);
    mainContainerHeight = _titleLabel.frame.origin.y+20+_titleLabel.frame.size.height+20+_detailsTextView.frame.size.height+21+_categoryLabel.frame.size.height+20+_imageCollectionView.frame.size.height +20 +_commentsContainerView.frame.size.height;
    _mainContainerView.frame = CGRectMake(_mainContainerView.frame.origin.x, _mainContainerView.frame.origin.y, self.view.frame.size.width, mainContainerHeight);
    _scrollView.contentSize = CGSizeMake(0,_mainContainerView.frame.size.height);
}

//Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == _addCommentTextView) {
        if([[UIScreen mainScreen] bounds].size.height==568) {
            if (imageArray.count>1) {
                [_scrollView setContentOffset:CGPointMake(0, self.view.frame.size.height - 280) animated:YES];
            } else {
                [_scrollView setContentOffset:CGPointMake(0, self.view.frame.size.height - 400) animated:YES];
            }
        }
        if (imageArray.count>1) {
            if([[UIScreen mainScreen] bounds].size.height==667) {
                [_scrollView setContentOffset:CGPointMake(0, self.view.frame.size.height - 480) animated:YES];
            } else if([[UIScreen mainScreen] bounds].size.height==736) {
                [_scrollView setContentOffset:CGPointMake(0, self.view.frame.size.height - 600) animated:YES];
            }
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _addCommentTextView) {
        if ([text isEqualToString:[UIPasteboard generalPasteboard].string]) {
            size = CGSizeMake(_addCommentTextView.frame.size.height,80);
            NSString *string = textView.text;
            NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            text = [NSString stringWithFormat:@"%@%@",_addCommentTextView.text,text];
            textRect=[self setDynamicHeight:size textString:text];
            if ((textRect.size.height < 80) && (textRect.size.height > 50)) {
                _addCommentTextView.frame = CGRectMake(0, 2, _addCommentContainerView.frame.size.width - 30, textRect.size.height+8);
                messageHeight = textRect.size.height + 8;
                _addCommentContainerView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width-20, messageHeight +10 );
                _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 10,self.view.frame.size.width-20, _commentsTableView.frame.size.height);
                _completeJobAction.frame = CGRectMake(30, _commentsTableView.frame.origin.y + _commentsTableView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
                _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 20, self.view.frame.size.width, _completeJobAction.frame.origin.y +_completeJobAction.frame.size.height+10);
            }
            else if(textRect.size.height <= 50) {
                messageHeight = 40;
                _addCommentTextView.frame = CGRectMake(0, 2, _addCommentContainerView.frame.size.width - 30, messageHeight);
                _addCommentContainerView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width-20, messageHeight + 10);
                _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 10,self.view.frame.size.width-20, _commentsTableView.frame.size.height);
                _completeJobAction.frame = CGRectMake(30, _commentsTableView.frame.origin.y + _commentsTableView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
                _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 20, self.view.frame.size.width, _completeJobAction.frame.origin.y +_completeJobAction.frame.size.height+10);
            }
            if (textView.text.length>=1) {
                if (trimmedString.length>=1) {
                    _sendCommentButton.enabled=YES;
                }
                else {
                    _sendCommentButton.enabled=NO;
                }
            }
            else if (textView.text.length==0) {
                _sendCommentButton.enabled=NO;
            }
        }
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _addCommentTextView) {
        if (([_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height < 80) && ([_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height > 50)) {
            _addCommentTextView.frame = CGRectMake(0, 2, _addCommentContainerView.frame.size.width - 30, [_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height+8);
            messageHeight = [_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height + 8;
            _addCommentContainerView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width-20, messageHeight +10 );
            _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 10,self.view.frame.size.width-20, _commentsTableView.frame.size.height);
            _completeJobAction.frame = CGRectMake(30, _commentsTableView.frame.origin.y + _commentsTableView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
            _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 20, self.view.frame.size.width, _completeJobAction.frame.origin.y +_completeJobAction.frame.size.height+10);
        }
        else if([_addCommentTextView sizeThatFits:_addCommentTextView.frame.size].height <= 50) {
            messageHeight = 40;
            _addCommentTextView.frame = CGRectMake(0, 2, _addCommentContainerView.frame.size.width - 30, messageHeight);
            _addCommentContainerView.frame = CGRectMake(10, _commentsCountLabel.frame.origin.y + _commentsCountLabel.frame.size.height + 10,self.view.frame.size.width-20, messageHeight + 10);
            _commentsTableView.frame = CGRectMake(10, _addCommentContainerView.frame.origin.y + _addCommentContainerView.frame.size.height + 10,self.view.frame.size.width-20, _commentsTableView.frame.size.height);
            _completeJobAction.frame = CGRectMake(30, _commentsTableView.frame.origin.y + _commentsTableView.frame.size.height + 10,self.view.frame.size.width-60, _completeJobAction.frame.size.height);
            _commentsContainerView.frame = CGRectMake(0, _imageCollectionView.frame.origin.y+_imageCollectionView.frame.size.height + 20, self.view.frame.size.width, _completeJobAction.frame.origin.y +_completeJobAction.frame.size.height+10);
            
            
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
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier;
    AddComplainCell *cell;
    identifier = @"complainImage";
    cell = [_imageCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.deleteImageButton.hidden = YES;
    return cell;
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"ComplainCell";
    ComplainDetailCell *complainCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (complainCell == nil) {
        complainCell = [[ComplainDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    return complainCell;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)startJobAction:(id)sender {
}

- (IBAction)completeJobAction:(id)sender {
}
#pragma mark - end

@end
