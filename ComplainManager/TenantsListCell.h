//
//  TenantsListCell.h
//  ComplainManager
//
//  Created by Monika Sharma on 16/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TenantsListModel.h"

@interface TenantsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tenantsImageView;
@property (weak, nonatomic) IBOutlet UILabel *tenantsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenantsEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenantsContactLabel;
- (void)displayTenantsListData :(TenantsListModel *)dataModel indexPath:(int)indexPath rectSize:(CGSize)rectSize;

@end
