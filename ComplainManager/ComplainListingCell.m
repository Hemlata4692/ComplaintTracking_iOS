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
    
    //UI customisation
    complainTitleLabel.attributedText = [complainTitleLabel.text setAttributrdString:@"John Doe" stringFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0] selectedColor:[UIColor blackColor]];
    //set complain image
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
    complainTitleLabel.text=complainList.complainTitle;
    complainDescriptionLabel.text = complainList.complainDescription;
    complainStatusLabel.text = complainList.complainStatus;
    if ([complainList.complainStatus isEqualToString:@"Read"]) {
        complainStatusLabel.textColor=[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
    } else  if ([complainList.complainStatus isEqualToString:@"Completed"]) {
        complainStatusLabel.textColor=[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];
    }
    else {
        complainStatusLabel.textColor=[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];
    }
}
#pragma mark - end

@end
