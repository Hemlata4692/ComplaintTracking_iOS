//
//  ComplaintDetailViewController.h
//  ComplainManager
//
//  Created by Monika Sharma on 26/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainListingViewController.h"

@interface ComplaintDetailViewController : GlobalViewController
@property(nonatomic,retain)NSString * complainId;
@property (strong, nonatomic)ComplainListingViewController *complainVC;
@end
