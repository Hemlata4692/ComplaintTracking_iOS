//
//  NSString+CustomString.m
//  Adogo
//
//  Created by Ranosys on 26/04/16.
//  Copyright © 2016 Sumit. All rights reserved.
//

#import "NSString+CustomString.h"

@implementation NSString (CustomString)

- (NSMutableAttributedString *)setAttributrdString:(NSString *)selectedString stringFont:(UIFont*)stringFont selectedColor:(UIColor *)selectedColor {
    
    NSRange range = [self rangeOfString:selectedString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:stringFont
                       range:NSMakeRange(range.location, [selectedString length])];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:selectedColor
                       range:NSMakeRange(range.location, [selectedString length])];
    [attrString endEditing];
    return attrString;
}

- (NSString *)generateRandomNumber {

    //create the random number.
    float low_bound = 10000;
    float high_bound = 99999;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    return [NSString stringWithFormat:@"%d", (int)(rndValue + 0.5)];
    //end
}

- (NSMutableAttributedString *)setNestedAttributrdString:(NSString *)selectedString secondSelectedString:(NSString *)secondSelectedString stringFont:(UIFont*)stringFont selectedColor:(UIColor *)selectedColor {
    
    NSRange range = [self rangeOfString:selectedString];
    NSRange secondRange = [self rangeOfString:secondSelectedString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:stringFont
                       range:NSMakeRange(range.location, [selectedString length])];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:selectedColor
                       range:NSMakeRange(range.location, [selectedString length])];
    
    [attrString addAttribute:NSFontAttributeName
                       value:stringFont
                       range:NSMakeRange(secondRange.location, [secondSelectedString length])];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:selectedColor
                       range:NSMakeRange(secondRange.location, [secondSelectedString length])];
    [attrString endEditing];
    return attrString;
}

- (NSString *)checkIsStringNull {
    
    NSString *string=self;
    if ((self==NULL)||(self==nil)||[self isEqualToString:@""]) {
        string=@"";
    }
    return string;
}
@end
