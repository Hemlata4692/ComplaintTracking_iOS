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

@interface AddComplainViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BSKeyboardControlsDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSArray *textFieldArray;
    NSMutableArray *imagesArray;
    NSArray *categoryArray;
}
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleSeparatorLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailSeparatorLabel;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *addComplainCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *categoryToolBar;
@property (weak, nonatomic) IBOutlet UIView *categorypickerContainerView;

@end

@implementation AddComplainViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Add Complaint";
    imagesArray = [NSMutableArray new];
    categoryArray = [NSArray arrayWithObjects:@"clean swimming pool",@"pipeline issue",@"cleaning", nil];
    //Adding textfield to array
    textFieldArray = @[_titleTextView,_detailTextView];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    //UI customisation
    [self customiseView];
    //Add backButton
    [self addBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - UI customisation
- (void)setViewFrames {
    _titleSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _detailSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _categoryPickerView.translatesAutoresizingMaskIntoConstraints = YES;
    _addComplainCollectionView.translatesAutoresizingMaskIntoConstraints = YES;
    _registerButton.translatesAutoresizingMaskIntoConstraints = YES;
    _titleSeparatorLabel.frame = CGRectMake(10, _titleTextView.frame.origin.y+_titleTextView.frame.size.height-1, self.view.frame.size.width - 20, 1);
    _detailSeparatorLabel.frame = CGRectMake(10, _detailTextView.frame.origin.y+_detailTextView.frame.size.height-1, self.view.frame.size.width - 20, 1);
    _categorypickerContainerView.frame = CGRectMake(10, _detailSeparatorLabel.frame.origin.y +_detailSeparatorLabel.frame.size.height+15, self.view.frame.size.width - 20, _categorypickerContainerView.frame.size.height);
    _addComplainCollectionView.frame = CGRectMake(10, _categorypickerContainerView.frame.origin.y +_categorypickerContainerView.frame.size.height+20, self.view.frame.size.width - 20, _addComplainCollectionView.frame.size.height);
    _registerButton.frame = CGRectMake(30, _addComplainCollectionView.frame.origin.y +_addComplainCollectionView.frame.size.height+20, self.view.frame.size.width - 60, _registerButton.frame.size.height);
}

- (void)customiseView {
    [_detailTextView setPlaceholder:@"Details"];
    [_detailTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:13.0]];
    [_titleTextView setPlaceholder:@"Title"];
    [_titleTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:13.0]];
}
#pragma mark - end

#pragma mark - Textview delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.keyboardControls setActiveField:textView];
    [self hidePickerWithAnimation];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView == _titleTextView) {
        if(textView.text.length>=85 && range.length == 0)
        {
            NSLog(@"You have reached 140 characters limit.");
            //            [self.view makeToast:@"You have reached 140 characters limit."];
            [textView resignFirstResponder];
            return NO;
        }
        return YES;
        
    } else {
        if ([text isEqualToString:[UIPasteboard generalPasteboard].string]) {
            CGSize size = CGSizeMake(_detailTextView.frame.size.height,120);
            text = [NSString stringWithFormat:@"%@%@",_detailTextView.text,text];
            CGRect textRect=[text
                             boundingRectWithSize:size
                             options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13]}
                             context:nil];
            _detailTextView.translatesAutoresizingMaskIntoConstraints = YES;
            if ((textRect.size.height < 120) && (textRect.size.height > 37)) {
                _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, textRect.size.height);
            }
            else if(textRect.size.height <= 40) {
                _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 40);
            }
        }
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _titleTextView) {
        if (([_titleTextView sizeThatFits:_titleTextView.frame.size].height < 42) && ([_titleTextView sizeThatFits:_titleTextView.frame.size].height > 37)) {
            _titleTextView.translatesAutoresizingMaskIntoConstraints = YES;
            _titleTextView.frame = CGRectMake(_titleTextView.frame.origin.x, _titleTextView.frame.origin.y, _titleTextView.frame.size.width, [_titleTextView sizeThatFits:_titleTextView.frame.size].height);
            [self setViewFrames];
            
        }
        else if([_titleTextView sizeThatFits:_titleTextView.frame.size].height <= 37) {
            _titleTextView.frame = CGRectMake(_titleTextView.frame.origin.x, _titleTextView.frame.origin.y, _titleTextView.frame.size.width, 40);
        }
    } else {
        if (([_detailTextView sizeThatFits:_detailTextView.frame.size].height < 120) && ([_detailTextView sizeThatFits:_detailTextView.frame.size].height > 37)) {
            _detailTextView.translatesAutoresizingMaskIntoConstraints = YES;
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, [_detailTextView sizeThatFits:_detailTextView.frame.size].height);
            [self setViewFrames];
            
        }
        else if([_detailTextView sizeThatFits:_detailTextView.frame.size].height <= 37) {
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 40);
        }
    }
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

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Collection view methds
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //Max image selection 5
    if (imagesArray.count < 5) {
        return imagesArray.count + 1;
    }
    return imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier;
    AddComplainCell *cell;
    if (indexPath.row != imagesArray.count) {
        identifier = @"complainImage";
        cell = [_addComplainCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.deleteImageButton.tag = indexPath.item;
        [cell.deleteImageButton addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell displayData:(int)indexPath.row data:imagesArray];
    }
    else {
        identifier = @"addMoreImages";
        cell = [_addComplainCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.selectImageButton.tag = indexPath.item;
        [cell.selectImageButton addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
#pragma mark - end

#pragma mark - Show actionsheet method
- (void)showActionSheet {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select Image"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             
                                                             AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                                                             if(authStatus == AVAuthorizationStatusAuthorized) {
                                                                 
                                                                 [self openDefaultCamera];
                                                                 
                                                             }
                                                             else if(authStatus == AVAuthorizationStatusDenied){
                                                                 
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
    
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.delegate = self;
                                                              picker.allowsEditing = NO;
                                                              picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              picker.navigationBar.tintColor = [UIColor whiteColor];
                                                              
                                                              [self presentViewController:picker animated:YES completion:NULL];
                                                          }];
    
    UIAlertAction * defaultAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                        }];
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
- (NSString *)getImageName:(UIImage*)image {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"ddMMYYhhmmss"];
    NSString * datestr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpeg",datestr,[UserDefaultManager getValue:@"userId"]];
    NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:fileName];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.1);
    [imageData writeToFile:filePath atomically:YES];
    return fileName;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    [imagesArray addObject:image];
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
- (IBAction)selectComplaintCategoryAction:(id)sender {
    [_keyboardControls.activeField resignFirstResponder];
    if([[UIScreen mainScreen] bounds].size.height<=568) {
        [UIView animateWithDuration:0.5f animations:^{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [_categoryPickerView reloadAllComponents];
            _categoryPickerView.frame = CGRectMake(_categoryPickerView.frame.origin.x, self.view.bounds.size.height-_categoryPickerView.frame.size.height , self.view.bounds.size.width, _categoryPickerView.frame.size.height);
            _categoryToolBar.frame = CGRectMake(_categoryToolBar.frame.origin.x, _categoryPickerView.frame.origin.y-44, self.view.bounds.size.width, _categoryToolBar.frame.size.height);
            [UIView commitAnimations];
        }];
    }
}

- (IBAction)registerButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    if([self performValidationsForRegister]) {
        //        [myDelegate showIndicator];
        //        [self performSelector:@selector(addComplaint) withObject:nil afterDelay:.1];
    }
}

- (IBAction)pickerCancelAction:(id)sender {
    [self hidePickerWithAnimation];
}

- (IBAction)selectCategoryPickerDoneAction:(id)sender {
    NSInteger index = [_categoryPickerView selectedRowInComponent:0];
    _categoryTextField.text=[categoryArray objectAtIndex:index];
    [self hidePickerWithAnimation];
}
#pragma mark - end
#pragma mark - Picker View methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
        pickerLabel.textColor = [UIColor colorWithRed:147/255.0 green:148/255.0 blue:153/255.0 alpha:1.0];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    pickerLabel.text=[categoryArray objectAtIndex:row];
    return pickerLabel;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return categoryArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [_keyboardControls.activeField resignFirstResponder];
    NSString *str=[categoryArray objectAtIndex:row];
    return str;
}

-(void)hidePickerWithAnimation {
    if([[UIScreen mainScreen] bounds].size.height<=568) {
        [UIView animateWithDuration:0.5f animations:^{
//            self.view.frame = CGRectOffset(self.view.frame, 0, 0);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            _categoryPickerView.frame = CGRectMake(_categoryPickerView.frame.origin.x, 1000, self.view.bounds.size.width, _categoryPickerView.frame.size.height);
            _categoryToolBar.frame = CGRectMake(_categoryToolBar.frame.origin.x, 1000, self.view.bounds.size.width, _categoryToolBar.frame.size.height);
            [UIView commitAnimations];
        }];
    }
}

#pragma mark - end

#pragma mark - Register validation
- (BOOL)performValidationsForRegister {
    if ([_titleTextView.text isEqualToString:@""] || [_detailTextView.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all fields." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Webservices
- (void)addComplaint {
    
}
#pragma mark - end

@end
