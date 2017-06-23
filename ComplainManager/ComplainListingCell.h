//
//  ComplainListingCell.h
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainListDataModel.h"
@interface ComplainListingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *complainDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *complainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *complainStatusLabel;
- (void)displayComplainListData :(ComplainListDataModel *)complainList indexPath:(int)indexPath rectSize:(CGSize)rectSize;

@end
