//
//  FeedbackPreviewController.h
//  ComplainManager
//
//  Created by Monika on 8/18/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainListingViewController.h"

@interface FeedbackPreviewController : GlobalViewController

@property (nonatomic,strong) NSDictionary *feedbackData;
@property (strong, nonatomic)ComplainListingViewController *complainVC;

@end
