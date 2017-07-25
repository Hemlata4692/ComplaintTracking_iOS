//
//  ComplainDetailCell.h
//  ComplainManager
//
//  Created by Monika Sharma on 22/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"

@interface ComplainDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentsTimeLabel;
- (void)displayCommentsListData :(CommentsModel *)commentList indexPath:(long)indexPath;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentAddedByLabel;

@end
