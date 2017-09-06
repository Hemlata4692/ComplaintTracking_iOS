//
//  SidebarCell.h
//  ComplainManager
//
//  Created by Monika Sharma on 22/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *dashboardIcon;
@property (weak, nonatomic) IBOutlet UIImageView *myFeedBackIcon;
@property (weak, nonatomic) IBOutlet UIImageView *myProfileIcon;
@property (weak, nonatomic) IBOutlet UIImageView *propertyIcon;
@property (weak, nonatomic) IBOutlet UIImageView *tenantsIcon;
@property (weak, nonatomic) IBOutlet UIImageView *changePasswordIcon;
@property (weak, nonatomic) IBOutlet UIImageView *settingIcon;
@property (weak, nonatomic) IBOutlet UIImageView *logoutIcon;
- (void)displayCellData:(NSArray *)menuItems index:(int)index;
@end
