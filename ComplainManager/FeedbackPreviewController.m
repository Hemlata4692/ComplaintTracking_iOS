//
//  FeedbackPreviewController.m
//  ComplainManager
//
//  Created by Monika on 8/18/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "FeedbackPreviewController.h"
#import "AddComplainCell.h"
#import "ComplainService.h"

@interface FeedbackPreviewController ()
{
    NSMutableArray *imageArray;
    NSMutableArray *imagesNameArray;
}
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *dataContainerView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UIView *confirmationView;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

@end

@implementation FeedbackPreviewController
@synthesize feedbackData;
@synthesize complainVC;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self displayFeedbackData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Display data
- (void)displayFeedbackData {
    imageArray = [NSMutableArray new];
    imageArray = feedbackData[@"imageArray"];
    _categoryLabel.text = feedbackData[@"category"];
    _locationLabel.text = feedbackData[@"location"];
    _descriptionLabel.text = feedbackData[@"description"];
    [self setViewFrames];
}
#pragma mark - end

#pragma mark - Set frames
- (void) removeAutolayouts {
    _popupView.translatesAutoresizingMaskIntoConstraints = YES;
    _dataContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void) setViewFrames {
    [self removeAutolayouts];
    [_popupView setCornerRadius:5];
    [_yesButton setCornerRadius:5];
    [_noButton setCornerRadius:5];
    CGSize size = CGSizeMake(self.view.frame.size.width - 60,500);
    CGRect textRect=[self setDynamicHeight:size textString:_descriptionLabel.text];
    _descriptionLabel.numberOfLines = 0;
    if (textRect.size.height < 40) {
        _descriptionLabel.frame =CGRectMake(10, _locationLabel.frame.origin.y + _locationLabel.frame.size.height+30,  self.view.frame.size.width - 60, 40);
    } else {
        _descriptionLabel.frame =CGRectMake(10, _locationLabel.frame.origin.y + _locationLabel.frame.size.height+30,  self.view.frame.size.width - 60, textRect.size.height+5);
    }
    float dataContainerHeight;
    if (imageArray.count > 0) {
        dataContainerHeight = 110 + _descriptionLabel.frame.size.height + 10 + _imageCollectionView.frame.size.height + 70;
    } else {
        dataContainerHeight = 110 + _descriptionLabel.frame.size.height + 70;
    }
    _dataContainerView.frame = CGRectMake(_dataContainerView.frame.origin.x, _dataContainerView.frame.origin.y, self.view.frame.size.width - 40, dataContainerHeight);
    if (dataContainerHeight + 140 >= self.view.frame.size.height) {
        _popupView.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height-40);
    } else {
        _popupView.frame = CGRectMake(20, self.view.frame.size.height/2 - (dataContainerHeight+100)/2, self.view.frame.size.width - 40, dataContainerHeight+100);
    }
    _scrollView.contentSize = CGSizeMake(0,dataContainerHeight+20);
}
#pragma mark - end

#pragma mark - Set dynamic height
- (CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:18]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - Collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier;
    identifier = @"complainImage";
    AddComplainCell *cell = [_imageCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell displayData:indexPath.row data:imageArray isAddComplainScreen:true isAddMoreCell:NO];
    return cell;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)addFeedbackAction:(id)sender {
    imagesNameArray = [NSMutableArray new];
    if (imageArray.count < 1) {
        [myDelegate showIndicator];
        [self performSelector:@selector(addComplaint) withObject:nil afterDelay:.1];
    } else {
        [myDelegate showIndicator];
        [self performSelector:@selector(uploadImage) withObject:nil afterDelay:.1];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
#pragma mark - Webservices
//Upload image
- (void)uploadImage {
    for (int i = 0; i < imageArray.count; i++) {
        [[ComplainService sharedManager] uploadImage:[imageArray objectAtIndex:i] screenName:@"COMPLAIN" success:^(id responseObject){
            [imagesNameArray addObject:[responseObject objectForKey:@"list"]];
            NSLog(@"imagesNameArray.count = %lu",(unsigned long)imagesNameArray.count);
            if (imageArray.count == imagesNameArray.count) {
                [self performSelector:@selector(addComplaint) withObject:nil afterDelay:.1];
            }
        } failure:^(NSError *error) {
            [myDelegate stopIndicator];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }] ;
    }
}

//Add complaint
- (void)addComplaint {
    [[ComplainService sharedManager] addComplait:_descriptionLabel.text categoryId:feedbackData[@"selectedCategoryId"] imageNameArray:imagesNameArray PropertyLocationId:feedbackData[@"selectedLocationId"] success:^(id responseObject) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"]) {
                myDelegate.screenName = @"myFeedback";
                myDelegate.selectedMenuIndex = 2;
            } else {
                myDelegate.screenName = @"dashboard";
                myDelegate.selectedMenuIndex = 0;
            }
            [self dismissViewControllerAnimated:NO completion:^{
                complainVC.refreshComplainScreen = true;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                [myDelegate.window setRootViewController:objReveal];
                [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
                [myDelegate.window makeKeyAndVisible];
                
            }];
        }];
        [alert showWarning:nil title:@"" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:nil duration:0.0f];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        if (error.localizedDescription !=  nil) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }
    }] ;
}
#pragma mark - end

@end
