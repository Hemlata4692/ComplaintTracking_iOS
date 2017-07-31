//
//  UIPlaceHolderTextView.m
//  Matrix
//
//  Created by Justin on 12-9-18.
//  Copyright (c) 2012年 apple.inc. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView
{
    NSLayoutConstraint *heightConstraint;
    CGRect height;
}

#pragma mark - Accessors

@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

#pragma mark - Set text
- (void)setText:(NSString *)string {
    [super setText:string];
    [self setNeedsDisplay];
}
#pragma mark - end

#pragma mark - Insert text
- (void)insertText:(NSString *)string {
    [super insertText:string];
    [self setNeedsDisplay];
}
#pragma mark - end

#pragma mark - Set attributed text
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
#pragma mark - end

#pragma mark - Set placeholder text
- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder])
    {
        return;
    }
    _placeholder = string;
    [self setNeedsDisplay];
}
#pragma mark - end

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}
#pragma mark - NSObject
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}
#pragma mark - UIView
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self _initialize];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self _initialize];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.text.length == 0 && self.placeholder)
    {
        // Inset the rect
        rect = UIEdgeInsetsInsetRect(rect, self.contentInset);
        
        // TODO: This is hacky. Not sure why 8 is the magic number
        if (self.contentInset.left == 10.0f)
        {
            rect.origin.x += 10.0f;
        }
        rect.origin.y += 10.0f;
        
        // Draw the text
        [_placeholderTextColor set];
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        //Multi line placeholder
//        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        [_placeholder drawInRect:rect withAttributes: @{NSFontAttributeName: self.font,
                                                        NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0] }];
#else
        [_placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
#endif
    }
}
#pragma mark - end

#pragma mark - Private
- (void)_initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    self.placeholderTextColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
}
#pragma mark - end

#pragma mark - resize text view
- (void)_textChanged:(NSNotification *)notification {
    [self setNeedsDisplay];
}
#pragma mark - end

@end
