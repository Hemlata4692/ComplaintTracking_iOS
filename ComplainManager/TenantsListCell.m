//
//  TenantsListCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/06/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "TenantsListCell.h"

@implementation TenantsListCell
@synthesize tenantsImageView, tenantsNameLabel, tenantsEmailLabel, tenantsContactLabel;

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

#pragma mark - Display cell data
- (void)displayTenantsListData :(TenantsListModel *)dataModel indexPath:(int)indexPath rectSize:(CGSize)rectSize {
    //Display tenants image
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[dataModel.tenantsImageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    __weak UIImageView *weakRef = tenantsImageView;
    [tenantsImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"userPlaceholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    tenantsImageView.layer.cornerRadius = tenantsImageView.frame.size.width / 2;
    tenantsImageView.layer.masksToBounds = YES;
    //Display data
    tenantsNameLabel.text = dataModel.tenantsName;
    tenantsEmailLabel.text = dataModel.tenantsEmail;
    tenantsContactLabel.text = dataModel.tenantsContact;
}
#pragma mark - end

@end
