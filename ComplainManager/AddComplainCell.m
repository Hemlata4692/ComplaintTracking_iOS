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

- (void)displayData:(long)index data:(NSMutableArray *)imageArray {
//    complainImageView.image = [imageArray objectAtIndex:index];
    
    for (int i = 0; i < imageArray.count; i ++) {
            NSString *tempImageString = [imageArray objectAtIndex:index];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tempImageString]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        [complainImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"sideBarPlaceholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            complainImageView.contentMode = UIViewContentModeScaleAspectFill;
            complainImageView.clipsToBounds = YES;
            complainImageView.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];

    }

}

@end
