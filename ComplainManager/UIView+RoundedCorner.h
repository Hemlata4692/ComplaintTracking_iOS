//
//  UIView+RoundedCorner.h
//  WheelerButler
//
//  Created by Ashish A. Solanki on 24/01/15.
//
//

#import <UIKit/UIKit.h>

@interface UIView (RoundedCorner)
- (void)setCornerRadius:(CGFloat)radius;
- (void)setTextBorder:(UITextField *)textField color:(UIColor *)color;
- (void)setViewBorder: (UIView *)view color:(UIColor *)color;
- (void)setImageViewBorder: (UIView *)view  color:(UIColor *)color;
- (void)setTextViewBorder:(UITextView *)textView color:(UIColor *)color;
- (void)setBottomBorder: (UIView *)view;
- (void)addShadow: (UIView *)view color:(UIColor *)color;
- (void)addShadowWithCornerRadius: (UIView *)view color:(UIColor *)color;
- (void)setLabelBorder: (UIView *)view  color:(UIColor *)color;
- (void)addShadowWithCornerRadius: (UIView *)_myView color:(UIColor *)color borderColor:(UIColor *)borderColor radius:(CGFloat)radius;

@end
