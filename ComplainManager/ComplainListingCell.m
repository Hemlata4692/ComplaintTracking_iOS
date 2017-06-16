//
//  ComplainListingCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplainListingCell.h"

@implementation ComplainListingCell
@synthesize userImageView, complainTitleLabel, complainDescriptionLabel, complainStatusLabel;

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
    
    //UI customisation
    //        complainTitleLabel.attributedText = [complainTitleLabel.text setAttributrdString:@"John Doe" stringFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0] selectedColor:[UIColor blackColor]];
    //    set complain image
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:complainList.complainImageString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    __weak UIImageView *weakRef = userImageView;
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    NSString *dateString = complainList.complainTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    _complainTimeLabel.text=newDateString;
    complainTitleLabel.text=complainList.complainTitle;
    complainDescriptionLabel.text = complainList.complainDescription;
//    complainStatusLabel.text = complainList.complainStatus;
//    if ([complainList.complainStatus isEqualToString:@"Resolved"]) {
//        complainStatusLabel.textColor=[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
//    } else  if ([complainList.complainStatus isEqualToString:@"InProcess"]) {
//        complainStatusLabel.textColor=[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];
//    }
//    else {
//        complainStatusLabel.textColor=[UIColor greenColor];
//    }
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
