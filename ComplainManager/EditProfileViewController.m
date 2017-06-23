//
//  EditProfileViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 29/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "EditProfileViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UserService.h"

@interface EditProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,BSKeyboardControlsDelegate,UINavigationControllerDelegate>
{
    NSArray *textFieldArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *propertyTextField;
@property (weak, nonatomic) IBOutlet UITextField *mcstNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit Profile";
    //Adding textfield to array
    textFieldArray = @[_nameTextField,_emailTextField,_phoneNumberTextField,_addressTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    //UI customisation
    [self displayProfileData];
    //Add back button
    [self addBackButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end

#pragma mark - Display data
- (void)displayProfileData {
    [_signUpButton setCornerRadius:3];
    // profile image url
    NSString *tempImageString = [UserDefaultManager getValue:@"userImage"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tempImageString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [_userProfileImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"userPlaceholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self displayUserImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    _userProfileImage.layer.cornerRadius = _userProfileImage.frame.size.width / 2;
    _userProfileImage.layer.masksToBounds = YES;
    _nameTextField.text = [UserDefaultManager getValue:@"name"];
    _emailTextField.text = [UserDefaultManager getValue:@"email"];
    _phoneNumberTextField.text = [UserDefaultManager getValue:@"contactNumber"];
}
#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    if (textField.frame.origin.y+textField.frame.size.height+15<([UIScreen mainScreen].bounds.size.height-64)-256) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, ((textField.frame.origin.y+textField.frame.size.height+15)- ([UIScreen mainScreen].bounds.size.height-64-256))+5) animated:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Show actionsheet method
- (void)showActionSheet {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select Image"                                                                   message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) { AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];                                                             if(authStatus == AVAuthorizationStatusAuthorized) {                                                                 [self openDefaultCamera];}else if(authStatus == AVAuthorizationStatusDenied){
        [self showAlertCameraAccessDenied];
    }
                                                         else if(authStatus == AVAuthorizationStatusRestricted){                                                                 [self showAlertCameraAccessDenied];
                                                         }
                                                         else if(authStatus == AVAuthorizationStatusNotDetermined) {
                                                             [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                                                                 if(granted){
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         [self openDefaultCamera];
                                                                     });
                                                                 }
                                                             }];
                                                         }
                                                         }];
    
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction * defaultAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {[alert dismissViewControllerAnimated:YES completion:nil];}];
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
    [self displayUserImage:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)displayUserImage:(UIImage *)image {
    _userProfileImage.layer.cornerRadius=_userProfileImage.frame.size.width/2;
    _userProfileImage.clipsToBounds=YES;
    _userProfileImage.image = image;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Register validation
- (BOOL)performValidationsForEditProfile {
    if ([_emailTextField isEmpty] || [_nameTextField isEmpty] || [_addressTextField isEmpty] || [_phoneNumberTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all fields." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        if ([_emailTextField isValidEmail]) {
            if (_nameTextField.text.length < 6) {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert showWarning:self title:@"Alert" subTitle:@"Your password must be atleast 6 characters long." closeButtonTitle:@"Done" duration:0.0f];
                return NO;
            }
            else if ((_phoneNumberTextField.text.length<8)||(_phoneNumberTextField.text.length>12)) {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert showWarning:self title:@"Alert" subTitle:@"The provided mobile number is incorrect." closeButtonTitle:@"Done" duration:0.0f];
                return NO;
            }
            else {
                return YES;
            }
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter a valid email address." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)selectImageButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    [self showActionSheet];
}

- (IBAction)registerAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if([self performValidationsForEditProfile]) {
        //        [myDelegate showIndicator];
        //        [self performSelector:@selector(editUserProfile) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Webservice
- (void)editUserProfile {
    [[UserService sharedManager] editProfile:_nameTextField.text email:_emailTextField.text address:_addressTextField.text mobileNumber:_phoneNumberTextField.text unitNo:_unitNoTextField.text company:_companyTextField.text property:_propertyTextField.text mcstNumber:_mcstNumberTextField.text success:^(id responseObject){
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
