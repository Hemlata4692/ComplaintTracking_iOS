//
//  ComplainListingCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplainListingCell.h"

@implementation ComplainListingCell
@synthesize userImageView, userNameLabel, complainDescriptionLabel, complainStatusLabel;

#pragma mark - Load nib
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - end

#pragma mark - Display data in cell
- (void)displayComplainListData :(ComplainListDataModel *)complainList indexPath:(int)indexPath rectSize:(CGSize)rectSize {
    //UI customisation
    NSAttributedString * nameStr = [[NSString stringWithFormat:@"%@ filed a feedback",complainList.userName] setAttributrdString:complainList.userName stringFont:[UIFont fontWithName:@"Roboto-Medium" size:16.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    userNameLabel.attributedText = nameStr;
    [userImageView setImageWithURL:[NSURL URLWithString:complainList.complainImageString] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
    userImageView.layer.masksToBounds = YES;
//    NSString *dateString = complainList.complainTime;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:dateString];
//    // Convert date object into desired format
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFormatter setDateFormat:@"dd-mm-yyyy HH:mm a"];
//    NSString *newDateString = [dateFormatter stringFromDate:date];
    _complainTimeLabel.text=complainList.complainTime;
    complainDescriptionLabel.text = complainList.complainDescription;
}
#pragma mark - end

@end
