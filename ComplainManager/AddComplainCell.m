//
//  AddComplainCell.m
//  ComplainManager
//
//  Created by Monika Sharma on 18/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "AddComplainCell.h"

@implementation AddComplainCell
@synthesize complainImageView,deleteImageButton;

#pragma mark - Load nib
- (void)displayData:(long)index data:(NSMutableArray *)imageArray isAddComplainScreen:(bool)isAddComplainScreen {
    if (isAddComplainScreen) {
        complainImageView.image = [imageArray objectAtIndex:index];
    } else {
        if ([[imageArray objectAtIndex:index] isKindOfClass:[NSString class]]) {
            deleteImageButton.hidden = YES;
            NSString *tempImageString = [imageArray objectAtIndex:index];
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tempImageString]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            [complainImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholderListing"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                complainImageView.contentMode = UIViewContentModeScaleAspectFill;
                complainImageView.clipsToBounds = YES;
                complainImageView.image = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            }];
        } else {
            deleteImageButton.hidden = NO;
            complainImageView.image = [imageArray objectAtIndex:index];
        }
    }
}
#pragma mark - end
@end
