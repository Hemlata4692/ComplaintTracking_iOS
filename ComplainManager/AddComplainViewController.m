//
//  AddComplainViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 17/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "AddComplainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AddComplainCell.h"
#import "ComplainService.h"
#import "AddComplainModel.h"
#import "ImagePreviewViewController.h"

@interface AddComplainViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BSKeyboardControlsDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSArray *textArray;
    NSMutableArray *imagesArray;
    NSMutableArray *imagesNameArray;
    NSArray *categoryArray;
    NSArray *locationArray;
    AddComplainModel *complainModel;
    NSString *selectedCategoryId;
    NSString *selectedLocationId;
    BOOL isCategoryPicker;
}

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailSeparatorLabel;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *addComplainCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *categorypickerContainerView;
@property (weak, nonatomic) IBOutlet UILabel *categorySeparatorLabel;
@property (weak, nonatomic) IBOutlet UIView *locationPickerContainerView;
@property (weak, nonatomic) IBOutlet UILabel *locationSeaparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailNotesLabel;

@end

@implementation AddComplainViewController
@synthesize complainVC;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Add Complaint";
    //Array initialisation
    imagesArray = [NSMutableArray new];
    categoryArray = [NSMutableArray new];
    locationArray = [NSMutableArray new];
    //Adding textview to array
    textArray = @[_detailTextView];
    //Add BSKeyboard
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textArray]];
    [self.keyboardControls setDelegate:self];
    //UI customisation
    [self customiseView];
    //Add backButton
    [self addBackButton];
    //Get complaint categories
    [myDelegate showIndicator];
    [self performSelector:@selector(getCategories) withObject:nil afterDelay:.1];
    //Set text view offset
    CGPoint offset = _detailTextView.contentOffset;
    [_detailTextView setContentOffset:offset];
    //    _detailTextView.textContainerInset = UIEdgeInsetsZero;
    //    _detailTextView.textContainer.lineFragmentPadding = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark - UI customisation
- (void)setViewFrames {
    _detailSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _pickerView.translatesAutoresizingMaskIntoConstraints = YES;
    _toolBar.translatesAutoresizingMaskIntoConstraints = YES;
    _detailNotesLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _addComplainCollectionView.translatesAutoresizingMaskIntoConstraints = YES;
    _registerButton.translatesAutoresizingMaskIntoConstraints = YES;
    _detailSeparatorLabel.frame = CGRectMake(10, _detailTextView.frame.origin.y+_detailTextView.frame.size.height+5, self.view.frame.size.width - 20, 1);
    _detailNotesLabel.frame = CGRectMake(10, _detailTextView.frame.origin.y +_detailTextView.frame.size.height+10, self.view.frame.size.width - 20, _detailNotesLabel.frame.size.height);
    _addComplainCollectionView.frame = CGRectMake(10, _detailNotesLabel.frame.origin.y +_detailNotesLabel.frame.size.height+20, self.view.frame.size.width - 20, _addComplainCollectionView.frame.size.height);
    _registerButton.frame = CGRectMake(30, _addComplainCollectionView.frame.origin.y +_addComplainCollectionView.frame.size.height+20, self.view.frame.size.width - 60, _registerButton.frame.size.height);
}

- (void)customiseView {
    [_detailTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
    [_registerButton setCornerRadius:2];
}
#pragma mark - end

#pragma mark - Textview delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if (textView == _detailTextView) {
        if (range.length > 0 && [string length] == 0) {
            return YES;
        }
        if (textView.text.length >= 500 && range.length == 0) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.keyboardControls setActiveField:textView];
    [self hidePickerWithAnimation];
    [textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _detailTextView) {
        _detailTextView.translatesAutoresizingMaskIntoConstraints = YES;
        if (([_detailTextView sizeThatFits:_detailTextView.frame.size].height < 90) && ([_detailTextView sizeThatFits:_detailTextView.frame.size].height > 40)) {
            NSLog(@"%f",[_detailTextView sizeThatFits:_detailTextView.frame.size].height);
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x,_detailLabel.frame.origin.y + _detailLabel.frame.size.height + 1, _detailTextView.frame.size.width, [_detailTextView sizeThatFits:_detailTextView.frame.size].height);
            [self setViewFrames];
        }
        else if([_detailTextView sizeThatFits:_detailTextView.frame.size].height <= 40) {
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailLabel.frame.origin.y + _detailLabel.frame.size.height + 1, _detailTextView.frame.size.width, 40);
            _detailSeparatorLabel.frame = CGRectMake(10, _detailTextView.frame.origin.y+_detailTextView.frame.size.height+5, self.view.frame.size.width - 20, 1);
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView layoutIfNeeded];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Collection view methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //Max image selection 5
    if (imagesArray.count < 5) {
        return imagesArray.count + 1;
    } else {
        return imagesArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier;
    AddComplainCell *cell;
    if (indexPath.row != imagesArray.count) {
        identifier = @"complainImage";
        cell = [_addComplainCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.deleteImageButton.tag = indexPath.item;
        [cell.deleteImageButton addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell displayData:(int)indexPath.row data:imagesArray isAddComplainScreen:true];
    }
    else {
        identifier = @"addMoreImages";
        cell = [_addComplainCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.selectImageButton.tag = indexPath.item;
        [cell.selectImageButton addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImagePreviewViewController *imagePreviewView =[storyboard instantiateViewControllerWithIdentifier:@"ImagePreviewViewController"];
    imagePreviewView.selectedIndex=(int)indexPath.row;
    imagePreviewView.attachmentArray=[imagesArray mutableCopy];
    [self.navigationController pushViewController:imagePreviewView animated:YES];
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
    [imagesArray addObject:fixedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_addComplainCollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - IBActions
-(IBAction)deleteImageAction:(id)sender {
    [imagesArray removeObjectAtIndex:[sender tag]];
    [_addComplainCollectionView reloadData];
}

-(IBAction)selectImageAction:(id)sender {
    [self showActionSheet];
    [_addComplainCollectionView reloadData];
}

- (IBAction)registerButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    imagesNameArray = [NSMutableArray new];
    if([self performValidationsForAddComplain]) {
        if (imagesArray.count < 1) {
            [myDelegate showIndicator];
            [self performSelector:@selector(addComplaint) withObject:nil afterDelay:.1];
        } else {
            [myDelegate showIndicator];
            [self performSelector:@selector(uploadImage) withObject:nil afterDelay:.1];
        }
    }
}

- (IBAction)showPickerAction:(id)sender {
    [_keyboardControls.activeField resignFirstResponder];
    if ([sender tag] == 1) {
        if (locationArray.count < 1 ) {
            [self.view makeToast:@"No locations found."];
        } else {
            [self showPickerWithAnimation];
        }
        isCategoryPicker = false;
    } else {
        if (categoryArray.count < 1 ) {
            [self.view makeToast:@"No categories found."];
        } else {
            [self showPickerWithAnimation];
        }
        isCategoryPicker = true;
    }
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:0 inComponent:0 animated:YES];
}

- (IBAction)pickerCancelAction:(id)sender {
    [self hidePickerWithAnimation];
}

- (IBAction)pickerDoneAction:(id)sender {
    NSInteger index = [_pickerView selectedRowInComponent:0];
    if (isCategoryPicker) {
        if (categoryArray.count >= 1) {
            complainModel=[categoryArray objectAtIndex:index];
            _categoryTextField.text=complainModel.categoryName;
            selectedCategoryId=complainModel.categoryId;
        }
    } else {
        if (locationArray.count >= 1) {
            complainModel=[locationArray objectAtIndex:index];
            _locationTextField.text=complainModel.locationName;
            selectedLocationId=complainModel.locationId;
        }
    }
    [self hidePickerWithAnimation];
}
#pragma mark - end

#pragma mark - Picker View methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,40)];
        pickerLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
        pickerLabel.textColor = [UIColor colorWithRed:147/255.0 green:148/255.0 blue:153/255.0 alpha:1.0];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    if (isCategoryPicker) {
        if (categoryArray.count >= 1) {
            complainModel=[categoryArray objectAtIndex:row];
            pickerLabel.text=complainModel.categoryName;
        }
    } else {
        if (locationArray.count >= 1) {
            complainModel=[locationArray objectAtIndex:row];
            pickerLabel.text=complainModel.locationName;
        }
    }
    return pickerLabel;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (isCategoryPicker) {
        return categoryArray.count;
    } else {
        return locationArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [_keyboardControls.activeField resignFirstResponder];
    if (isCategoryPicker) {
        complainModel=[categoryArray objectAtIndex:row];
        return complainModel.categoryName;
    } else {
        complainModel=[locationArray objectAtIndex:row];
        return complainModel.locationName;
    }
}

- (void)showPickerWithAnimation {
    [UIView animateWithDuration:0.5f animations:^{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [_pickerView reloadAllComponents];
        _pickerView.frame = CGRectMake(_pickerView.frame.origin.x, self.view.bounds.size.height-_pickerView.frame.size.height , self.view.bounds.size.width, _pickerView.frame.size.height);
        _toolBar.frame = CGRectMake(_toolBar.frame.origin.x, _pickerView.frame.origin.y-44, self.view.bounds.size.width, _toolBar.frame.size.height);
        [UIView commitAnimations];
    }];
}

- (void)hidePickerWithAnimation {
    [UIView animateWithDuration:0.5f animations:^{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        _pickerView.frame = CGRectMake(_pickerView.frame.origin.x, 1000, self.view.bounds.size.width, _pickerView.frame.size.height);
        _toolBar.frame = CGRectMake(_toolBar.frame.origin.x, 1000, self.view.bounds.size.width, _toolBar.frame.size.height);
        [UIView commitAnimations];
    }];
}
#pragma mark - end

#pragma mark - Register validation
- (BOOL)performValidationsForAddComplain {
    if ([_categoryTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please select Category." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    } else  if ([_locationTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please select Location." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }else  if ([_detailTextView.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill the Details." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Webservices
//Get complain categories
- (void)getCategories {
    [[ComplainService sharedManager] getCategories:YES success:^(NSMutableArray *dataArray){
        categoryArray = dataArray;
        [self getLocations];
        //        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:nil duration:0.0f];
    }] ;
}

- (void)getLocations {
    [[ComplainService sharedManager] getCategories:NO success:^(NSMutableArray *dataArray){
        locationArray = dataArray;
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
    }] ;
}

//Upload image
- (void)uploadImage {
    for (int i = 0; i < imagesArray.count; i++) {
        [[ComplainService sharedManager] uploadImage:[imagesArray objectAtIndex:i] screenName:@"COMPLAIN" success:^(id responseObject){
            [imagesNameArray addObject:[responseObject objectForKey:@"list"]];
            NSLog(@"imagesNameArray.count = %lu",(unsigned long)imagesNameArray.count);
            if (imagesArray.count == imagesNameArray.count) {
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
    [[ComplainService sharedManager] addComplait:_detailTextView.text categoryId:selectedCategoryId imageNameArray:imagesNameArray PropertyLocationId:selectedLocationId success:^(id responseObject) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            complainVC.refreshComplainScreen = true;
            if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"]) {
                myDelegate.screenName = @"myFeedback";
                myDelegate.selectedMenuIndex = 2;
            } else {
                myDelegate.screenName = @"dashboard";
                myDelegate.selectedMenuIndex = 0;
            }
            [self.navigationController popViewControllerAnimated:YES];
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
