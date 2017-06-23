//
//  SidebarCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 22/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "SidebarCell.h"

@implementation SidebarCell
@synthesize dashboardIcon,myProfileIcon,propertyIcon,tenantsIcon,changePasswordIcon,logoutIcon;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)displayCellData:(NSArray *)menuItems index:(int)index {
    //Side bar customisation - chage selected cell backround color
    CGSize size = self.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, size.width, size.height)];
    label.text = [menuItems objectAtIndex:index];
    [self.contentView addSubview:label];
    label.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    if (index == myDelegate.selectedMenuIndex) {
        self.backgroundColor= [UIColor colorWithRed:29/255.0 green:141/255.0 blue:179/255.0 alpha:1.0];
        label.textColor = [UIColor whiteColor];
        if ([label.text isEqualToString:@"Dashboard"]) {
            dashboardIcon.image = [UIImage imageNamed:@"dashboardIconSelected"];
        } else if ([label.text isEqualToString:@"My Profile"]) {
            myProfileIcon.image = [UIImage imageNamed:@"profileIconSelected"];
        } else if ([label.text isEqualToString:@"My Feedback"]) {
            _myFeedBackIcon.image = [UIImage imageNamed:@"myFeedbackIconSelected"];
        } else if ([label.text isEqualToString:@"Property Feedback"]) {
            propertyIcon.image = [UIImage imageNamed:@"propertyIconSelected"];
        } else if ([label.text isEqualToString:@"Tenants"]) {
            tenantsIcon.image = [UIImage imageNamed:@"tenantsIconSelected"];
        } else if ([label.text isEqualToString:@"Change Password"]) {
            changePasswordIcon.image = [UIImage imageNamed:@"changePasswordIconSelected"];
        } else if ([label.text isEqualToString:@"Logout"]) {
            logoutIcon.image = [UIImage imageNamed:@"logoutIconSelected"];
        }
    }
    else {
        self.backgroundColor= [UIColor whiteColor];
        label.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1.0];
        if ([label.text isEqualToString:@"Dashboard"]) {
            dashboardIcon.image = [UIImage imageNamed:@"dashboardIcon"];
        } else if ([label.text isEqualToString:@"My Profile"]) {
            myProfileIcon.image = [UIImage imageNamed:@"profileIcon"];
        } else if ([label.text isEqualToString:@"My Feedback"]) {
            _myFeedBackIcon.image = [UIImage imageNamed:@"myFeedbackIcon"];
        } else if ([label.text isEqualToString:@"Property Feedback"]) {
            propertyIcon.image = [UIImage imageNamed:@"propertyIcon"];
        } else if ([label.text isEqualToString:@"Tenants"]) {
            tenantsIcon.image = [UIImage imageNamed:@"tenantsIcon"];
        } else if ([label.text isEqualToString:@"Change Password"]) {
            changePasswordIcon.image = [UIImage imageNamed:@"changePasswordIcon"];
        } else if ([label.text isEqualToString:@"Logout"]) {
            logoutIcon.image = [UIImage imageNamed:@"logoutIcon"];
        }
    }
}

@end
