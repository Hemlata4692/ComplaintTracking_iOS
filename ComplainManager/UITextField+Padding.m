//
//  UITextField+Padding.m
//  Sure
//
//  Created by Hema on 25/03/15.
//  Copyright (c) 2015 Shivendra. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)

#pragma mark - Text field padding
- (void)addTextFieldPadding: (UITextField *)textfield {
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
    textfield.leftView = leftPadding;
    textfield.leftViewMode = UITextFieldViewModeAlways;

}
#pragma mark - end

#pragma mark - Text field with images padding
- (void)addTextFieldPaddingWithoutImages: (UITextField *)textfield {
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textfield.leftView = leftPadding;
    textfield.leftViewMode = UITextFieldViewModeAlways;    
}
#pragma mark - end
@end
