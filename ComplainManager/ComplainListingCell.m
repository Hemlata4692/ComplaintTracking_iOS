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
- (void)displayComplainListData :(ComplainListDataModel *)complainList indexPath:(int)indexPath rectSize:(CGSize)rectSize {
    
    NSLog(@"%d",indexPath);
    [self viewCustomisation];
    //UI customisation
    CGRect textRectName;
    CGRect textRectDesc;
    CGSize size;
    userNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    complainDescriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;

    size = CGSizeMake([[UIScreen mainScreen] bounds].size.width-100,150);
    
    if ([self checkIfTenant]) {
        textRectName=[self setDynamicHeight:size textString:[NSString stringWithFormat:@"Category - %@",complainList.category] textSize:18];
        NSAttributedString * categoryStr = [[NSString stringWithFormat:@"Category - %@",complainList.category] setAttributrdString:@"Category - " stringFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        userNameLabel.attributedText = categoryStr;
        userNameLabel.numberOfLines = 0;
        userNameLabel.frame =CGRectMake(90, 15,[[UIScreen mainScreen] bounds].size.width - 100, textRectName.size.height+2);
        textRectDesc=[self setDynamicHeight:size textString:complainList.complainDescription textSize:17];
        complainDescriptionLabel.numberOfLines = 2;
        if (textRectDesc.size.height < 40) {
            complainDescriptionLabel.frame =CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 6,[[UIScreen mainScreen] bounds].size.width - 100, textRectDesc.size.height+5);
        } else {
            complainDescriptionLabel.frame =CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 5,[[UIScreen mainScreen] bounds].size.width - 100, 45);
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        NSDate *date = [dateFormatter dateFromString:complainList.complainTime];
        [dateFormatter setDateFormat:@"MMM"];
        monthLabel.text=[[dateFormatter stringFromDate:date] capitalizedString];
        [dateFormatter setDateFormat:@"dd"];
        dateLabel.text=[dateFormatter stringFromDate:date];
        [dateFormatter setDateFormat:@"yyyy"];
        yearLabel.text=[dateFormatter stringFromDate:date];
        
    } else {
        complainTimeLabel.translatesAutoresizingMaskIntoConstraints = YES;

//        textRectName=[self setDynamicHeight:size textString:[NSString stringWithFormat:@"%@ filed a feedback",complainList.userName] textSize:18];
        NSAttributedString * nameStr = [[NSString stringWithFormat:@"%@ filed a feedback",complainList.userName] setAttributrdString:complainList.userName stringFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0] selectedColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        userNameLabel.attributedText = nameStr;
        userNameLabel.numberOfLines = 0;
        [userNameLabel sizeToFit];
        userNameLabel.frame =CGRectMake(90, 8,[[UIScreen mainScreen] bounds].size.width - 100, userNameLabel.frame.size.height);
//        userNameLabel.backgroundColor = [UIColor redColor];
//        userNameLabel.frame =CGRectMake(90, 8,[[UIScreen mainScreen] bounds].size.width - 100, textRectName.size.height+2);
        textRectDesc=[self setDynamicHeight:size textString:complainList.complainDescription textSize:17];
        complainDescriptionLabel.text = complainList.complainDescription;
        complainDescriptionLabel.numberOfLines = 2;
        
//        [complainDescriptionLabel sizeToFit];
        if (textRectDesc.size.height < 40) {
            complainDescriptionLabel.frame = CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 10,[[UIScreen mainScreen] bounds].size.width - 100, textRectDesc.size.height);
        } else {
            complainDescriptionLabel.frame =CGRectMake(90, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 10,[[UIScreen mainScreen] bounds].size.width - 100, 45);
        }
    }
    
    complainTimeLabel.frame =CGRectMake(90, complainDescriptionLabel.frame.origin.y + complainDescriptionLabel.frame.size.height + 10,[[UIScreen mainScreen] bounds].size.width - 100, 20);

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
    complainTimeLabel.text=complainList.complainTime;
}
#pragma mark - end

#pragma mark - UI customisation
- (void)viewCustomisation {
    dateContainerView.layer.cornerRadius = dateContainerView.frame.size.width / 2;
    dateContainerView.layer.masksToBounds = YES;
    
}
#pragma mark - end

#pragma mark - Set dynamic height
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString textSize:(int)textSize{
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
