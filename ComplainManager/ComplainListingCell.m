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
    //    NSString * titleTextStr = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ";
    //    CGRect textRect;
    //    CGSize size;
    //    complainTitleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    //    size = CGSizeMake([[UIScreen mainScreen] bounds].size.width-userImageView.frame.origin.x+20,80);
    //    textRect=[self setDynamicHeight:size textString:titleTextStr];
    //    complainTitleLabel.numberOfLines = 0;
    //    complainTitleLabel.frame =CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+20, 5, [[UIScreen mainScreen] bounds].size.width - (userImageView.frame.size.width+30), textRect.size.height+3);
    //    complainTitleLabel.text=titleTextStr;
    //    complainTitleLabel.backgroundColor = [UIColor redColor];
    //
    
    //    UI customisation
    NSAttributedString * nameStr = [[NSString stringWithFormat:@"%@ filed a feedback",complainList.userName] setAttributrdString:complainList.userName stringFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0] selectedColor:[UIColor blackColor]];
    userNameLabel.attributedText = nameStr;
    [userImageView setImageWithURL:[NSURL URLWithString:complainList.complainImageString] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    
    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
    userImageView.layer.masksToBounds = YES;
    NSString *dateString = complainList.complainTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    _complainTimeLabel.text=newDateString;
    complainDescriptionLabel.text = complainList.complainDescription;
}

//Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString {
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13]}
                         context:nil];
    return textHeight;
}
#pragma mark - end

@end
