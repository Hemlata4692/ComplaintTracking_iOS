//
//  NSString+CustomString.h
//  Adogo
//
//  Created by Ranosys on 26/04/16.
//  Copyright © 2016 Sumit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CustomString)
- (NSMutableAttributedString *)setAttributrdString:(NSString *)selectedString stringFont:(UIFont*)stringFont selectedColor:(UIColor *)selectedColor;
- (NSString *)generateRandomNumber;
- (NSMutableAttributedString *)setNestedAttributrdString:(NSString *)selectedString secondSelectedString:(NSString *)secondSelectedString stringFont:(UIFont*)stringFont selectedColor:(UIColor *)selectedColor;
- (NSString *)checkIsStringNull;
@end
