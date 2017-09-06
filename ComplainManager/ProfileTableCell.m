//
//  ProfileTableCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ProfileTableCell.h"

@implementation ProfileTableCell
@synthesize infoLabel, infoDetailLabel;

#pragma mark - Load nib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - end

#pragma mark - Display data
- (void)displayProfileData:(long)index userData:(NSDictionary *)userData infoString:(NSString *)infoString showUserRole:(BOOL)showUserRole {
    NSArray *infoArray;
    if (([[userData objectForKey:@"userroleid"] intValue] == 4 || [[userData objectForKey:@"userroleid"] intValue] == 3)) {
        infoArray = [NSArray arrayWithObjects:@"Email",@"Phone Number",@"Property",@"MCST Number", nil];
    } else  if ([[userData objectForKey:@"userroleid"] intValue] == 2 || [[userData objectForKey:@"userroleid"] intValue] == 1) {
        infoArray = [NSArray arrayWithObjects:@"Email",@"Phone Number",@"Role", nil];
    } else {
        if (showUserRole) {
            infoArray = [NSArray arrayWithObjects:@"Email",@"Phone Number",@"Address",@"Unit No",@"Company Name",@"Property",@"MCST Number",@"MCST Council Member", nil];
            
        } else {
            infoArray = [NSArray arrayWithObjects:@"Email",@"Phone Number",@"Address",@"Unit No",@"Company Name",@"Property",@"MCST Number", nil];
        }
    }
    CGRect textRect;
    CGSize size;
    infoDetailLabel.translatesAutoresizingMaskIntoConstraints = YES;
    size = CGSizeMake([[UIScreen mainScreen] bounds].size.width-20,150);
    textRect=[self setDynamicHeight:size textString:infoString];
    infoDetailLabel.numberOfLines = 0;
    infoDetailLabel.frame =CGRectMake(10, infoLabel.frame.origin.y + infoLabel.frame.size.height+2, [[UIScreen mainScreen] bounds].size.width - 20, textRect.size.height+5);
    infoLabel.text = [infoArray objectAtIndex:index];
    if ([infoString isEqualToString:@""] && (![infoLabel.text isEqualToString:@"MCST Council Member"])) {
        infoDetailLabel.text = @"NA";
    } else {
        infoDetailLabel.text=infoString;
    }
}
#pragma mark - end

#pragma mark - Set dynamic height
- (CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:17]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

@end
