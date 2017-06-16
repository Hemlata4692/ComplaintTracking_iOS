//
//  ProfileTableCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ProfileTableCell.h"

@implementation ProfileTableCell
@synthesize infoLabel, infoDetailLabel;

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

#pragma mark - Display data
- (void)displayProfileData:(NSMutableDictionary *)profileData {
        NSArray *infoArray = [NSArray arrayWithObjects:@"Contact Number",@"Email",@"Address",@"Unit No",@"Complany",@"Property",@"MCST Number",@"MCST Council Number", nil];
    
 
}
#pragma mark - end

@end
