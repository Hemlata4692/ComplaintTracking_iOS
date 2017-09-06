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
    NSDictionary *userData;
    float mainContainerHeight;
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
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mcstNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIView *unitContainerView;
@property (weak, nonatomic) IBOutlet UIView *propertyContainerView;
@property (weak, nonatomic) IBOutlet UILabel *addressSeparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertySeparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *mcstNoSeparatorLabel;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set text view offset
    self.navigationItem.title = @"Edit Profile";
    //Adding textfield to array
    textFieldArray = @[_nameTextField,_phoneNumberTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    //Add back button
    [self addBackButton];
    [myDelegate showIndicator];
    [self performSelector:@selector(getProfileDetail) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"]) {
    //        _scrollView.scrollEnabled = NO;
    //    }
}
#pragma mark - end

#pragma mark - Display data
- (void)displayProfileData {
    _mainContainerView.hidden = NO;
    [_signUpButton setCornerRadius:3];
    userImageName = @"";
    // profile image url
    NSString *tempImageString = [UserDefaultManager getValue:@"userImage"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[tempImageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
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
        } else {
            _addressTextView.frame = CGRectMake(_addressTextView.frame.origin.x,_phoneNumberTextField.frame.origin.y + _phoneNumberTextField.frame.size.height + 10, self.view.frame.size.width - 20, textRect.size.height +5);
        }
        if ([[userData objectForKey:@"unitnumber"] isEqualToString:@""]) {
            _unitNoTextField.text = @"NA";
        } else {
            _unitNoTextField.text=[userData objectForKey:@"unitnumber"];
        }
        if ([[userData objectForKey:@"company"] isEqualToString:@""]) {
            _companyTextField.text = @"NA";
        } else {
            _companyTextField.text=[userData objectForKey:@"company"];
        }
    } else {
        _addressTextView.translatesAutoresizingMaskIntoConstraints = YES;
        _unitContainerView.translatesAutoresizingMaskIntoConstraints = YES;
        _propertyContainerView.translatesAutoresizingMaskIntoConstraints = YES;
        _addressSeparatorLabel.hidden = YES;
        _addressTextView.frame = CGRectMake(10, _phoneNumberTextField.frame.origin.y+_phoneNumberTextField.frame.size.height+10, self.view.frame.size.width - 20, 0);
        _unitContainerView.frame = CGRectMake(10, _addressTextView.frame.origin.y+_addressTextView.frame.size.height, self.view.frame.size.width - 20, 0);
        _propertyContainerView.frame = CGRectMake(10, _unitContainerView.frame.origin.y+_unitContainerView.frame.size.height , self.view.frame.size.width - 20, _propertyContainerView.frame.size.height);
    }
    NSArray *propertyArray = [userData objectForKey:@"property"];
    NSArray *mcstNoArray = [userData objectForKey:@"mcstnumber"];
    NSString * propertyStr = [propertyArray componentsJoinedByString:@", "];
    NSString * mcstNoStr = [mcstNoArray componentsJoinedByString:@", "];
    if ([propertyStr isEqualToString:@""]) {
        _propertyLabel.text = @"NA";
    } else {
        _propertyLabel.translatesAutoresizingMaskIntoConstraints = YES;
        _propertySeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
        CGRect textRect;
        CGSize size;
        size = CGSizeMake([[UIScreen mainScreen] bounds].size.width-20,500);
        textRect=[self setDynamicHeight:size textString:propertyStr];
        if (textRect.size.height <= 35) {
            _propertyLabel.frame = CGRectMake(_propertyLabel.frame.origin.x,0, self.view.frame.size.width - 20, 40);
            _propertySeparatorLabel.frame = CGRectMake(_propertySeparatorLabel.frame.origin.x,_propertyLabel.frame.origin.y+_propertyLabel.frame.size.height+1, self.view.frame.size.width - 20, 1);
        } else {
            _propertyLabel.frame = CGRectMake(_propertyLabel.frame.origin.x,0, self.view.frame.size.width - 20, textRect.size.height +5);
            _propertySeparatorLabel.frame = CGRectMake(_propertySeparatorLabel.frame.origin.x,_propertyLabel.frame.origin.y+_propertyLabel.frame.size.height+5, self.view.frame.size.width - 20, 1);
        }
        _propertyLabel.text=propertyStr;
    }
    if ([mcstNoStr isEqualToString:@""]) {
        _mcstNoLabel.text = @"NA";
    } else {
        _mcstNoLabel.translatesAutoresizingMaskIntoConstraints = YES;
        _mcstNoSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
        CGRect textRect;
        CGSize size;
        size = CGSizeMake([[UIScreen mainScreen] bounds].size.width-20,500);
        textRect=[self setDynamicHeight:size textString:mcstNoStr];
        if (textRect.size.height <= 35) {
            _mcstNoLabel.frame = CGRectMake(_mcstNoLabel.frame.origin.x,_propertyLabel.frame.origin.y+_propertyLabel.frame.size.height+ 10, self.view.frame.size.width - 20, 40);
            _mcstNoSeparatorLabel.frame = CGRectMake(_mcstNoSeparatorLabel.frame.origin.x,_mcstNoLabel.frame.origin.y+_mcstNoLabel.frame.size.height+1, self.view.frame.size.width - 20, 1);
        } else {
            _mcstNoLabel.frame = CGRectMake(_mcstNoLabel.frame.origin.x,_propertyLabel.frame.origin.y+_propertyLabel.frame.size.height+10, self.view.frame.size.width - 20, textRect.size.height +5);
            _mcstNoSeparatorLabel.frame = CGRectMake(_mcstNoSeparatorLabel.frame.origin.x,_mcstNoLabel.frame.origin.y+_mcstNoLabel.frame.size.height+5, self.view.frame.size.width - 20, 1);
        }
        _mcstNoLabel.text=mcstNoStr;
    }
    _mainContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    float propertyContainerHeight = _propertyLabel.frame.size.height + _propertyLabel.frame.size.height + 90;
    _propertyContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _propertyContainerView.frame = CGRectMake(10, _unitContainerView.frame.origin.y+_unitContainerView.frame.size.height , self.view.frame.size.width - 20, propertyContainerHeight);
    if (!([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"ltc"])) {
        mainContainerHeight = propertyContainerHeight + 20 + _userProfileImage.frame.size.height + 180 + _addressTextView.frame.size.height + 92 +20;
    } else {
        mainContainerHeight = propertyContainerHeight + 20 + _userProfileImage.frame.size.height + 200;
    }
    _mainContainerView.frame = CGRectMake(_mainContainerView.frame.origin.x, _mainContainerView.frame.origin.y, self.view.frame.size.width, mainContainerHeight);
    _scrollView.contentSize = CGSizeMake(0,mainContainerHeight+20);
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneNumberTextField) {
        if (range.length > 0 && [string length] == 0) {
            return YES;
        }
        if (string.length > 1) {
            if (textField.text.length + string.length >= 16) {
                //Remove string greater then 16 characters
                _phoneNumberTextField.text = [string substringToIndex:16];
                return NO;
            }
        } else {
            if (textField.text.length >= 16 && range.length == 0) {
                return NO;
            }
            else {
                return YES;
            }
        }
        //        if (range.length > 0 && [string length] == 0) {
        //            return YES;
        //        }
        //        if (textField.text.length >= 16 && range.length == 0) {
        //            return NO;
        //        }
        //        else {
        //            return YES;
        //        }
    } else if (textField == _nameTextField) {
        if (range.length > 0 && [string length] == 0) {
            return YES;
        }
        if (string.length > 1) {
            if (textField.text.length + string.length >= 60) {
                //Remove string greater then 60 characters
                _nameTextField.text = [string substringToIndex:60];
                return NO;
            }
        } else {
            if (textField.text.length >= 60 && range.length == 0) {
                return NO;
            }
            else {
                return YES;
            }
        }
        //        if (range.length > 0 && [string length] == 0){
        //            return YES;
        //        }
        //        if (textField.text.length >= 60 && range.length == 0) {
        //            return NO;
        //        }
        //        else {
        //            return YES;
        //        }
    }
    return YES;
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
        picker.allowsEditing = YES;
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
    picker.allowsEditing = YES;
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
    UIImage *profileImage = [image fixOrientation];
    userImage = profileImage;
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
    if ([_nameTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill the Contact Name." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    } else if ([_phoneNumberTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill the Phone Number." closeButtonTitle:@"OK" duration:0.0f];
        return NO;
    } else {
        if ((_phoneNumberTextField.text.length<8)) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Phone Number should be between 8 to 16 digits." closeButtonTitle:@"OK" duration:0.0f];
            return NO;
        } else {
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
- (void)getProfileDetail {
    [[UserService sharedManager] getProfileDetail:NO userId:[UserDefaultManager getValue:@"userId"] success:^(id responseObject){
        userData = [responseObject objectForKey:@"data"];
        [UserDefaultManager setValue:[userData objectForKey:@"userimage"] key:@"userImage"];
        [UserDefaultManager setValue:[userData objectForKey:@"name"] key:@"name"];
        //UI customisation
        [self displayProfileData];
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:nil duration:0.0f];
    }] ;
}

//Upload image
- (void)uploadImage {
    [[ComplainService sharedManager] uploadImage:userImage screenName:@"USER" success:^(id responseObject){
        userImageName = [responseObject objectForKey:@"list"];
        [self editUserProfile];
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        if (error.localizedDescription !=  nil) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }
    }] ;
}

- (void)editUserProfile {
    if ([_addressTextView.text isEqualToString:@""]) {
        _addressTextView.text = @"";
    }
    [[UserService sharedManager] editProfile:_nameTextField.text address:_addressTextView.text mobileNumber:_phoneNumberTextField.text image:userImageName success:^(id responseObject){
        [myDelegate stopIndicator];
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"OK" actionBlock:^(void) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
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
