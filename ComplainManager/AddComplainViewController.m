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
}
@property (weak, nonatomic) IBOutlet UICollectionView *addComplainCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *separatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation AddComplainViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Add Complaint";
    imagesArray = [NSMutableArray new];
    //Adding textfield to array
    textFieldArray = @[_titleTextField,_detailTextView];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    //UI customisation
    [self customiseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - UI customisation
- (void)setViewFrames {
    _separatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _addComplainCollectionView.translatesAutoresizingMaskIntoConstraints = YES;
    _registerButton.translatesAutoresizingMaskIntoConstraints = YES;
    _separatorLabel.frame = CGRectMake(10, _detailTextView.frame.origin.y+_detailTextView.frame.size.height-1, self.view.frame.size.width - 20, _separatorLabel.frame.size.height);
    _addComplainCollectionView.frame = CGRectMake(10, _detailTextView.frame.origin.y +_detailTextView.frame.size.height+20, self.view.frame.size.width - 20, _addComplainCollectionView.frame.size.height);
    _registerButton.frame = CGRectMake(30, _addComplainCollectionView.frame.origin.y +_addComplainCollectionView.frame.size.height+20, self.view.frame.size.width - 60, _registerButton.frame.size.height);
}
- (void)customiseView {
    [_detailTextView setPlaceholder:@"Details"];
    [_detailTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [_titleTextField setBottomBorder:_titleTextField color:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]];
    
    
}
#pragma mark - end

#pragma mark - Textview delegates
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}
#pragma mark - end

#pragma mark - Textfield delegates
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        CGSize size = CGSizeMake(_detailTextView.frame.size.height,150);
        text = [NSString stringWithFormat:@"%@%@",_detailTextView.text,text];
        CGRect textRect=[text
                         boundingRectWithSize:size
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]}
                         context:nil];
        
        if ((textRect.size.height < 150) && (textRect.size.height > 37)) {
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, textRect.size.height);
        }
        else if(textRect.size.height <= 40) {
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 40);
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (([_detailTextView sizeThatFits:_detailTextView.frame.size].height < 150) && ([_detailTextView sizeThatFits:_detailTextView.frame.size].height > 37)) {
        _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, [_detailTextView sizeThatFits:_detailTextView.frame.size].height);
            [self setViewFrames];

    }
    else if([_detailTextView sizeThatFits:_detailTextView.frame.size].height <= 37) {
        _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 40);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    //    if([[UIScreen mainScreen] bounds].size.height<=568) {
    //        if (textField==_emailTextField) {
    //            [_registerScrollView setContentOffset:CGPointMake(0, 20) animated:YES];
    //        } else if (textField==_passwordTextField) {
    //            [_registerScrollView setContentOffset:CGPointMake(0, 68) animated:YES];
    //        } else if (textField==_phoneNumberTextField) {
    //            [_registerScrollView setContentOffset:CGPointMake(0, 115) animated:YES];
    //        }
    //    }
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
    //    [_registerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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

- (IBAction)registerButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

@end
