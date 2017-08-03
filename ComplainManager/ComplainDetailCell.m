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
@synthesize commentsLabel,commentsTimeLabel,commentAddedByLabel;

#pragma mark - Load nib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - end

#pragma mark - Display data in cell
- (void)displayCommentsListData :(CommentsModel *)commentList indexPath:(long)indexPath rectSize:(CGSize)rectSize {
    CGRect textRect;
    CGSize size;
    commentsLabel.translatesAutoresizingMaskIntoConstraints = YES;
    size = CGSizeMake(rectSize.width,1000);
    textRect=[self setDynamicHeight:size textString:commentList.commnts];
    commentsLabel.numberOfLines = 0;
    commentsLabel.frame =CGRectMake(0, 5, rectSize.width, textRect.size.height+2);
    commentsLabel.text = commentList.commnts;
    commentsTimeLabel.text = commentList.time;
    NSAttributedString * attrString = [[NSString stringWithFormat:@"Added By %@",commentList.CommmentsBy] setAttributrdString:@"Added By" stringFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0] selectedColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
    commentAddedByLabel.attributedText = attrString;

}
#pragma mark - end

#pragma mark - Set dynamic height
- (CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:16]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

@end
