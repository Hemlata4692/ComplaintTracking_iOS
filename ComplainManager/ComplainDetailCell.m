//
//  ComplainDetailCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 22/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplainDetailCell.h"
#
@implementation ComplainDetailCell
@synthesize commentsTextView,commentsTimeLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)displayCommentsListData :(CommentsModel *)commentList indexPath:(long)indexPath {
    commentsTextView.text = commentList.commnts;
     NSString *dateString = commentList.time;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    commentsTimeLabel.text = newDateString;
}

@end
