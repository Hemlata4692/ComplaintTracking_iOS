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
#import "ComplainService.h"

@interface EditProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,BSKeyboardControlsDelegate,UINavigationControllerDelegate>
{
    NSArray *textFieldArray;
    UIImage *userImage;
    NSString *userImageName;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *unitNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *propertyTextField;
@property (weak, nonatomic) IBOutlet UITextField *mcstNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIView *unitContainerView;
@property (weak, nonatomic) IBOutlet UIView *propertyContainerView;
@property (weak, nonatomic) IBOutlet UILabel *addressSeparatorLabel;

@end

@implementation EditProfileViewController
@synthesize userData;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set text view offset
    self.navigationItem.title = @"Edit Profile";
    //Adding textfield to array
    textFieldArray = @[_nameTextField,_phoneNumberTextField,_addressTextView];
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
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"]) {
        _scrollView.scrollEnabled = NO;
    }
}
#pragma mark - end

#pragma mark - Display data
- (void)displayProfileData {
    [_signUpButton setCornerRadius:3];
    userImageName = @"";
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
    _nameTextField.text = [userData objectForKey:@"name"];
    _emailTextField.text = [userData objectForKey:@"email"];
    _phoneNumberTextField.text = [userData objectForKey:@"contactNumber"];
    if (!([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"])) {
        [_addressTextView setPlaceholder:@"Address"];
        _addressTextView.text = [userData objectForKey:@"address"];
        _addressTextView.translatesAutoresizingMaskIntoConstraints = YES;
        _addressTextView.textContainerInset = UIEdgeInsetsZero;
        CGRect textRect;
        CGSize size;
        size = CGSizeMake([[UIScreen mainScreen] bounds].size.width-20,150);
        textRect=[self setDynamicHeight:size textString:[userData objectForKey:@"address"]];
        if (textRect.size.height <= 35) {
            _addressTextView.textContainerInset = UIEdgeInsetsMake(8, 0, 0, 0);
            _addressTextView.frame = CGRectMake(_addressTextView.frame.origin.x, _phoneNumberTextField.frame.origin.y + _phoneNumberTextField.frame.size.height + 10, self.view.frame.size.width - 20, 40);
            
        } else if (textRect.size.height <= 90) {
            _addressTextView.frame = CGRectMake(_addressTextView.frame.origin.x,_phoneNumberTextField.frame.origin.y + _phoneNumberTextField.frame.size.height + 10, self.view.frame.size.width - 20, textRect.size.height +5);
        } else {
            _addressTextView.frame = CGRectMake(_addressTextView.frame.origin.x,_phoneNumberTextField.frame.origin.y + _phoneNumberTextField.frame.size.height + 10, self.view.frame.size.width - 20, 75);
        }
        _unitNoTextField.text = [userData objectForKey:@"unitnumber"];
        _companyTextField.text = [userData objectForKey:@"company"];
    } else {
        _addressTextView.translatesAutoresizingMaskIntoConstraints = YES;
        _unitContainerView.translatesAutoresizingMaskIntoConstraints = YES;
        _propertyContainerView.translatesAutoresizingMaskIntoConstraints = YES;
        _addressSeparatorLabel.hidden = YES;
        _addressTextView.frame = CGRectMake(10, _phoneNumberTextField.frame.origin.y+_phoneNumberTextField.frame.size.height+10, self.view.frame.size.width - 20, 0);
        _unitContainerView.frame = CGRectMake(10, _addressTextView.frame.origin.y+_addressTextView.frame.size.height, self.view.frame.size.width - 20, 0);
        _propertyContainerView.frame = CGRectMake(10, _unitContainerView.frame.origin.y+_unitContainerView.frame.size.height , self.view.frame.size.width - 20, _propertyContainerView.frame.size.height);    }
    _propertyTextField.text = [userData objectForKey:@"property"];
    _mcstNumberTextField.text = [userData objectForKey:@"mcstnumber"];
}
#pragma mark - end

#pragma mark - Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:18]}
                         context:nil];
    return textHeight;
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

#pragma mark - Textview delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.keyboardControls setActiveField:textView];
    if (textView.frame.origin.y+textView.frame.size.height+15<([UIScreen mainScreen].bounds.size.height-64)-256) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, ((textView.frame.origin.y+textView.frame.size.height+15)- ([UIScreen mainScreen].bounds.size.height-64-256))+5) animated:NO];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _addressTextView) {
        _addressTextView.translatesAutoresizingMaskIntoConstraints = YES;
        if (([_addressTextView sizeThatFits:_addressTextView.frame.size].height < 80) && ([_addressTextView sizeThatFits:_addressTextView.frame.size].height > 40)) {
            _addressTextView.textContainerInset = UIEdgeInsetsZero;
            _addressTextView.frame = CGRectMake(_addressTextView.frame.origin.x,_phoneNumberTextField.frame.origin.y + _phoneNumberTextField.frame.size.height + 10, self.view.frame.size.width - 20, [_addressTextView sizeThatFits:_addressTextView.frame.size].height);
            if (textView.frame.origin.y+textView.frame.size.height+15<([UIScreen mainScreen].bounds.size.height-64)-256) {
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else {
                [_scrollView setContentOffset:CGPointMake(0, ((textView.frame.origin.y+textView.frame.size.height+10)- ([UIScreen mainScreen].bounds.size.height-64-256))+15) animated:NO];
            }
        }
        else if([_addressTextView sizeThatFits:_addressTextView.frame.size].height <= 40) {
            textView.textContainerInset = UIEdgeInsetsMake(8, 0, 0, 0);
            _addressTextView.frame = CGRectMake(_addressTextView.frame.origin.x, _phoneNumberTextField.frame.origin.y + _phoneNumberTextField.frame.size.height + 10, self.view.frame.size.width - 20, 40);
            if (textView.frame.origin.y+textView.frame.size.height+15<([UIScreen mainScreen].bounds.size.height-64)-256) {
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else {
                [_scrollView setContentOffset:CGPointMake(0, ((textView.frame.origin.y+textView.frame.size.height+15)- ([UIScreen mainScreen].bounds.size.height-64-256))+5) animated:NO];
            }
        }
    }
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
    userImage = image;
    [self displayUserImage:userImage];
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
    if ([_nameTextField isEmpty] || [_phoneNumberTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all fields." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        if ((_phoneNumberTextField.text.length<8)||(_phoneNumberTextField.text.length>12)) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"The provided mobile number is incorrect." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
        else {
            return YES;
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
        if (userImage != nil) {
            [myDelegate showIndicator];
            [self performSelector:@selector(uploadImage) withObject:nil afterDelay:.1];
        } else {
            [myDelegate showIndicator];
            [self performSelector:@selector(editUserProfile) withObject:nil afterDelay:.1];
        }
    }
}
#pragma mark - end

#pragma mark - Webservice
//Upload image
- (void)uploadImage {
    [[ComplainService sharedManager] uploadImage:userImage screenName:@"USER" success:^(id responseObject){
        userImageName = [responseObject objectForKey:@"list"];
        [self editUserProfile];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
    }] ;
}

- (void)editUserProfile {
    if ([_addressTextView.text isEqualToString:@""]) {
        _addressTextView.text = @"";
    }
    [[UserService sharedManager] editProfile:_nameTextField.text address:_addressTextView.text mobileNumber:_phoneNumberTextField.text image:userImageName success:^(id responseObject){
        [myDelegate stopIndicator];
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"Ok" actionBlock:^(void) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }];
        [alert showWarning:nil title:@"Alert" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:nil duration:0.0f];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
