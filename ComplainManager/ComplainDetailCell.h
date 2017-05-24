//
//  ComplainDetailCell.h
//  ComplainManager
//
//  Created by Monika Sharma on 22/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplainDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentsTimeLabel;

@end
