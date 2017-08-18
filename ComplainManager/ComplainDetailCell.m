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
    commentAddedByLabel.translatesAutoresizingMaskIntoConstraints = YES;
    size = CGSizeMake(rectSize.width,1000);
    textRect=[self setDynamicHeight:size textString:commentList.commnts];
    commentsLabel.numberOfLines = 0;
    commentsLabel.frame =CGRectMake(0, 5, rectSize.width, textRect.size.height+2);
    commentsLabel.text = commentList.commnts;
    commentsTimeLabel.text = [NSString stringWithFormat:@"Added On \n%@",commentList.time];
    
    commentAddedByLabel.numberOfLines = 0;
    CGSize constrainedSize = CGSizeMake(rectSize.width - 120  , 300);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Roboto-Bold" size:14.0], NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:commentList.CommmentsBy attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGRect newFrame = self.commentAddedByLabel.frame;
    newFrame.size.height = requiredHeight.size.height;
    self.commentAddedByLabel.frame = CGRectMake(0,commentsLabel.frame.origin.y+commentsLabel.frame.size.height+6, rectSize.width - 120, requiredHeight.size.height+20);
    NSAttributedString * attrString = [[NSString stringWithFormat:@"Added By \n%@",commentList.CommmentsBy] setAttributrdString:@"Added By" stringFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0] selectedColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
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
