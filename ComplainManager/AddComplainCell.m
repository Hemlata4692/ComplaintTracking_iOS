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

- (void)displayData:(int)index data:(NSMutableArray *)imageArray {
    complainImageView.image = [imageArray objectAtIndex:index];
}

@end
