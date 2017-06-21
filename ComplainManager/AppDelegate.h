//
//  AppDelegate.h
//  ComplainManager
//
//  Created by Monika Sharma on 12/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "GlobalViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic,strong)  NSString *screenName;
@property (nonatomic)  long selectedMenuIndex;
//Show/Stop indicator
- (void)showIndicator;
- (void)stopIndicator;
//end
@end

