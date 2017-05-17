//
//  RegisterViewController.m
//  ComplainManager
//
//  Created by Monika Sharma on 15/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserService.h"
@interface RegisterViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *textFieldArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *registerScrollView;
@property (weak, nonatomic) IBOutlet UIView *registerContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation RegisterViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Register";
    //Adding textfield to array
    textFieldArray = @[_nameTextField,_emailTextField,_passwordTextField,_phoneNumberTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    //UI customisation
    [self customiseView];
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

#pragma mark - UI customisation
- (void)customiseView {
    [_nameTextField addTextFieldPadding:_nameTextField];
    [_emailTextField addTextFieldPadding:_emailTextField];
    [_passwordTextField addTextFieldPadding:_passwordTextField];
    [_phoneNumberTextField addTextFieldPadding:_phoneNumberTextField];
    [_signUpButton setCornerRadius:3];
    [_nameTextField setBottomBorder:_nameTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
    [_emailTextField setBottomBorder:_emailTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
    [_passwordTextField setBottomBorder:_passwordTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
    [_phoneNumberTextField setBottomBorder:_phoneNumberTextField color:[UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
}
#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [_registerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    if([[UIScreen mainScreen] bounds].size.height<=568) {
        if (textField==_emailTextField) {
            [_registerScrollView setContentOffset:CGPointMake(0, 20) animated:YES];
        } else if (textField==_passwordTextField) {
            [_registerScrollView setContentOffset:CGPointMake(0, 68) animated:YES];
        } else if (textField==_phoneNumberTextField) {
            [_registerScrollView setContentOffset:CGPointMake(0, 115) animated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_registerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            [myAlertView show];
        }
        else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    if ([buttonTitle isEqualToString:@"Choose from Gallery"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - end

#pragma mark - Image picker controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    _userProfileImage.layer.cornerRadius=_userProfileImage.frame.size.width/2;
    _userProfileImage.clipsToBounds=YES;
    _userProfileImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Register validation
- (BOOL)performValidationsForRegister {
    if ([_emailTextField isEmpty] || [_passwordTextField isEmpty] || [_nameTextField isEmpty] || [_phoneNumberTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please fill in all fields." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        if ([_emailTextField isValidEmail]) {
            if (_passwordTextField.text.length < 6) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showWarning:self title:@"Alert" subTitle:@"Your password must be atleast 6 characters long." closeButtonTitle:@"Done" duration:0.0f];
                return NO;
            }
            else if ((_phoneNumberTextField.text.length<8)||(_phoneNumberTextField.text.length>12)) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showWarning:self title:@"Alert" subTitle:@"The provided mobile number is incorrect." closeButtonTitle:@"Done" duration:0.0f];
                return NO;
            }
            else {
                return YES;
            }
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter a valid email address." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)selectImageButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Gallery", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)registerAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    [_registerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if([self performValidationsForRegister]) {
        //        [myDelegate showIndicator];
        //        [self performSelector:@selector(registerUser) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Webservice
- (void)registerUser {
    [[UserService sharedManager] userRegisteration:_nameTextField.text email:_emailTextField.text password:_passwordTextField.text mobileNumber:_phoneNumberTextField.text success:^(id responseObject){
        [myDelegate stopIndicator];
    } failure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
