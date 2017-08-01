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

@property (weak, nonatomic) IBOutlet UILabel *feedbackCategory;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *complainDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *complainTimeLabel;
- (void)displayComplainListData :(ComplainListDataModel *)complainList indexPath:(int)indexPath rectSize:(CGSize)rectSize;
@property (weak, nonatomic) IBOutlet UIView *dateContainerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end
