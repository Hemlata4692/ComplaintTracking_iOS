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
//    [tableView setSeparatorColor:[UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0]];
//    UIImageView *sideBarIcon = (UIImageView *)[self viewWithTag:index];
    
    if (index == myDelegate.selectedMenuIndex) {
        self.backgroundColor= [UIColor colorWithRed:5/255.0 green:122/255.0 blue:165/255.0 alpha:1.0];
        label.textColor = [UIColor whiteColor];
        if ([label.text isEqualToString:@"Dashboard"]) {
            dashboardIcon.image = [UIImage imageNamed:@"dashboard icon_selected"];
        } else if ([label.text isEqualToString:@"My Profile"]) {
            myProfileIcon.image = [UIImage imageNamed:@"profile icon_selected"];
        } else if ([label.text isEqualToString:@"My Feedback"]) {
            _myFeedBackIcon.image = [UIImage imageNamed:@"my feedback icon_selected"];
        } else if ([label.text isEqualToString:@"Property Feedback"]) {
            propertyIcon.image = [UIImage imageNamed:@"property icon_selected"];
        } else if ([label.text isEqualToString:@"Tenants"]) {
            tenantsIcon.image = [UIImage imageNamed:@"tenants icon_selected"];
        } else if ([label.text isEqualToString:@"Change Password"]) {
            changePasswordIcon.image = [UIImage imageNamed:@"change password icon_selected"];
        } else if ([label.text isEqualToString:@"Logout"]) {
            logoutIcon.image = [UIImage imageNamed:@"logout icon_selected"];
        }
    }
    else {
        self.backgroundColor= [UIColor whiteColor];
        label.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
        if ([label.text isEqualToString:@"Dashboard"]) {
            dashboardIcon.image = [UIImage imageNamed:@"dashboard icon"];
        } else if ([label.text isEqualToString:@"My Profile"]) {
            myProfileIcon.image = [UIImage imageNamed:@"profile icon"];
        } else if ([label.text isEqualToString:@"My Feedback"]) {
            _myFeedBackIcon.image = [UIImage imageNamed:@"my feedback icon"];
        } else if ([label.text isEqualToString:@"Property Feedback"]) {
            propertyIcon.image = [UIImage imageNamed:@"property icon"];
        } else if ([label.text isEqualToString:@"Tenants"]) {
            tenantsIcon.image = [UIImage imageNamed:@"tenants icon"];
        } else if ([label.text isEqualToString:@"Change Password"]) {
            changePasswordIcon.image = [UIImage imageNamed:@"change password icon"];
        } else if ([label.text isEqualToString:@"Logout"]) {
            logoutIcon.image = [UIImage imageNamed:@"logout icon"];
        }
    }

}

@end
