//
//  UserProfileViewController.h
//  ComplainManager
//
//  Created by Monika Sharma on 17/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : GlobalViewController
@property (nonatomic) BOOL isTenantDetailScreen;
@property (nonatomic) BOOL isProfileDetailScreen;
@property (nonatomic,strong) NSString * tenantUserId;

@end
