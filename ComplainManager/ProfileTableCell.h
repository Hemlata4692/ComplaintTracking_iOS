//
//  ProfileTableCell.h
//  ComplainManager
//
//  Created by Monika Sharma on 16/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;
- (void)displayProfileData:(long)index;

@end
