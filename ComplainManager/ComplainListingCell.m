//
//  ComplainListingCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplainListingCell.h"

@implementation ComplainListingCell
@synthesize userImageView, userNameLabel, complainDescriptionLabel, feedbackCategory,dateContainerView,dateLabel,monthLabel,yearLabel,complainTimeLabel;

#pragma mark - Load nib
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - end

#pragma mark - Display data in cell
- (void)removeAutolayouts {
    userNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    complainDescriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    complainTimeLabel.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)displayComplainListData :(ComplainListDataModel *)complainList indexPath:(int)indexPath rectSize:(CGSize)rectSize {
    [self viewCustomisation];
    //UI customisation
    [self removeAutolayouts];
    if ([self checkIfTenant]) {
        [self tenantListingFrames:complainList rectSize:rectSize];
    } else {
        [self staffMemberFrames:complainList rectSize:rectSize];
    }
    complainTimeLabel.frame =CGRectMake(90, complainDescriptionLabel.frame.origin.y + complainDescriptionLabel.frame.size.height + 10,rectSize.width - 100, 20);
    [userImageView setImageWithURL:[NSURL URLWithString:complainList.complainImageString] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    complainTimeLabel.text=complainList.complainTime;
}

- (void)tenantListingFrames:(ComplainListDataModel *)complainList rectSize:(CGSize)rectSize {
    CGSize size = CGSizeMake(rectSize.width-100,150);
    NSAttributedString * categoryStr = [[NSString stringWithFormat:@"Category - %@",complainList.feedbackCategory] setAttributrdString:@"Category - " stringFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    userNameLabel.attributedText = categoryStr;
    CGSize constrainedSize = CGSizeMake(rectSize.width - 100  , 150);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Roboto-Medium" size:18.0], NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Category - %@",complainList.feedbackCategory] attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGRect newFrame = self.userNameLabel.frame;
    newFrame.size.height = requiredHeight.size.height;
    self.userNameLabel.frame = CGRectMake(90,15, rectSize.width - 100, requiredHeight.size.height);
    CGRect textRectDesc=[self setDynamicHeight:size textString:complainList.complainDescription textSize:17];
    complainDescriptionLabel.numberOfLines = 2;
    if (textRectDesc.size.height < 40) {
        complainDescriptionLabel.frame =CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 6,rectSize.width - 100, textRectDesc.size.height+5);
    } else {
        complainDescriptionLabel.frame =CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 5,rectSize.width - 100, 45);
    }
    complainDescriptionLabel.text=complainList.complainDescription;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSDate *date = [dateFormatter dateFromString:complainList.complainTime];
    [dateFormatter setDateFormat:@"MMM"];
    monthLabel.text=[[dateFormatter stringFromDate:date] capitalizedString];
    [dateFormatter setDateFormat:@"dd"];
    dateLabel.text=[dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"yyyy"];
    yearLabel.text=[dateFormatter stringFromDate:date];
}

- (void)staffMemberFrames:(ComplainListDataModel *)complainList rectSize:(CGSize)rectSize {
    CGSize size = CGSizeMake(rectSize.width-100,150);
    NSAttributedString * nameStr = [[NSString stringWithFormat:@"%@ filed a feedback",complainList.userName] setAttributrdString:complainList.userName stringFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    userNameLabel.attributedText = nameStr;
    CGSize constrainedSize = CGSizeMake(rectSize.width - 100  , 150);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Roboto-Medium" size:18.0], NSFontAttributeName,
                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ filed a feedback",complainList.userName] attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGRect newFrame = self.userNameLabel.frame;
    newFrame.size.height = requiredHeight.size.height;
    self.userNameLabel.frame = CGRectMake(90,8, rectSize.width - 100, requiredHeight.size.height);
    CGRect textRectDesc=[self setDynamicHeight:size textString:complainList.complainDescription textSize:17.0];
    complainDescriptionLabel.text = complainList.complainDescription;
    if (textRectDesc.size.height < 40) {
        complainDescriptionLabel.frame = CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 10,rectSize.width - 100, textRectDesc.size.height);
    } else {
        complainDescriptionLabel.frame =CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 10,rectSize.width - 100, 45);
    }
}
#pragma mark - end

#pragma mark - UI customisation
- (void)viewCustomisation {
    dateContainerView.layer.cornerRadius = dateContainerView.frame.size.width / 2;
    dateContainerView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
    userImageView.layer.masksToBounds = YES;
}
#pragma mark - end

#pragma mark - Set dynamic height
- (CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString textSize:(int)textSize{
    CGRect textHeight = [textString boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:textSize]} context:nil];
    return textHeight;
}
#pragma mark - end

#pragma mark - User role
- (BOOL)checkIfTenant {
    if (([[UserDefaultManager getValue:@"role"] isEqualToString:@"t"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"cm"]) && ![myDelegate.currentViewController isEqualToString:@"propertyFeedback"]) {
        return YES;
    } else if (([[UserDefaultManager getValue:@"role"] isEqualToString:@"ic"] || [[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) && [myDelegate.screenName isEqualToString:@"myFeedback"]) {
        return YES;
    }
    else {
        return NO;
    }
}
#pragma mark - end
@end
