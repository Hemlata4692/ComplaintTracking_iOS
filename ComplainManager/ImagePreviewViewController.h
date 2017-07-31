//
//  ImagePreviewViewController.h
//  MyTake
//
//  Created by Hema on 12/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewViewController : GlobalViewController

@property (strong, nonatomic) NSMutableArray *attachmentArray;
@property(nonatomic,assign)int selectedIndex;

@end
