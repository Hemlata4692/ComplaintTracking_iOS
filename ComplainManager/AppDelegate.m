//
//  AppDelegate.m
//  ComplainManager
//
//  Created by Monika Sharma on 12/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "AppDelegate.h"
#import "MMMaterialDesignSpinner.h"
#import "UncaughtExceptionHandler.h"
#import "UserService.h"
#import "ComplainListingViewController.h"
#import "ComplaintDetailViewController.h"
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate () {
    UIView *loaderView;
    UIImageView *logoImage;
}

@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;

@end

@implementation AppDelegate
@synthesize navigationController,screenName,selectedMenuIndex,deviceToken,isDetailJobStarted,feedbackId,detailNotification;

#pragma mark - Global indicator view
- (void)showIndicator {
    logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 50, 50)];
    logoImage.backgroundColor=[UIColor whiteColor];
    logoImage.layer.cornerRadius=25.0f;
    logoImage.clipsToBounds=YES;
    logoImage.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    loaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    loaderView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:0.3];
    [loaderView addSubview:logoImage];
    self.spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.spinnerView.tintColor = [UIColor colorWithRed:0/255.0 green:141/255.0 blue:200.0/255.0 alpha:1.0];
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    self.spinnerView.lineWidth=3.0f;
    [self.window addSubview:loaderView];
    [self.window addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
}

- (void)stopIndicator {
    [loaderView removeFromSuperview];
    [self.spinnerView removeFromSuperview];
    [self.spinnerView stopAnimating];
}
#pragma mark - end

#pragma mark - Logout
- (void)logoutUser {
    [[UserService sharedManager] logout:^(id responseObject){
        [myDelegate stopIndicator];
        [UserDefaultManager removeValue:@"name"];
        [UserDefaultManager removeValue:@"userId"];
        [UserDefaultManager removeValue:@"AuthenticationToken"];
        [UserDefaultManager removeValue:@"contactNumber"];
        [UserDefaultManager removeValue:@"isFirsttime"];
        [UserDefaultManager removeValue:@"role"];
        [UserDefaultManager removeValue:@"propertyId"];
        screenName= @"dashboard";
        selectedMenuIndex = 0;
        isDetailJobStarted = false;
        detailNotification = false;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        self.window.rootViewController = self.navigationController;
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
    }] ;
}
#pragma mark - end

#pragma mark - Crashlatycs
- (void)installUncaughtExceptionHandler {
    InstallUncaughtExceptionHandler();
}
#pragma mark - end

#pragma mark - Notification Registration
- (void)registerForRemoteNotification {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
#pragma mark - end

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    [self notificationRecivedDictionary:response.notification.request.content.userInfo];
}
#pragma mark - end

#pragma mark - PushNotification delegate
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)token {
    NSString *tokenString = [[token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = tokenString;
    NSLog(@"My device token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Received notification: %@", userInfo);
    [self notificationRecivedDictionary:userInfo];
}

- (void)notificationRecivedDictionary:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSDictionary *dict = [userInfo objectForKey:@"aps"] ;
    NSLog(@"dict === %@",dict);
    if ([[userInfo objectForKey:@"notifactionTag"] containsString:@"Detail"]) {
        detailNotification = true;
        feedbackId = [userInfo objectForKey:@"feedbackId"];
        NSLog(@"feedbackId %@",feedbackId);
    } else {
        detailNotification = false;
    }
    //If app is in active state
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (detailNotification) {
            if ([myDelegate.currentViewController isEqualToString:@"FeedbackDetail"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFeedbackDetails" object:nil];
            }
            else {
                detailNotification = false;
                [self showNotificationAlert:[dict objectForKey:@"alert"]];
            }
        } else {
            if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
                if ([myDelegate.currentViewController isEqualToString:@"propertyFeedback"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadComplainListing" object:nil];
                } else {
                    [self showNotificationAlert:[dict objectForKey:@"alert"]];
                }
            } else {
                if ([myDelegate.currentViewController isEqualToString:@"dashboard"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadComplainListing" object:nil];
                } else {
                    [self showNotificationAlert:[dict objectForKey:@"alert"]];
                }
            }
        }
    } else {
        //If user is building manager -  Navigate to propert feedback screen
        if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
            screenName = @"propertyFeedback";
            selectedMenuIndex = 3;
        } else {
            screenName = @"dashboard";
            selectedMenuIndex = 0;
        }
        if (([[myDelegate.currentViewController lowercaseString] isEqualToString:[@"dashboard" lowercaseString]] || [[myDelegate.currentViewController lowercaseString] isEqualToString:[@"propertyFeedback" lowercaseString]]) &&(!detailNotification)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadComplainListing" object:nil];
        } else {
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [myDelegate.window setRootViewController:objReveal];
            [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
            [myDelegate.window makeKeyAndVisible];
        }
    }
}
- (void)showNotificationAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}
#pragma mark - end

#pragma mark - Appdelegate methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Navigation bar customisation
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1/255.0 green:152/255.0 blue:207/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Regular" size:20.0], NSFontAttributeName, nil]];
    //Push notification
    deviceToken = @"";
    [self registerForRemoteNotification];
    //Call crashlytics method
    [self performSelector:@selector(installUncaughtExceptionHandler) withObject:nil afterDelay:0];
    //Check internet connectivity
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    isDetailJobStarted = false;
    detailNotification = false;
    //Navigation to view
    NSLog(@"userId %@",[UserDefaultManager getValue:@"userId"]);
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]!=nil) {
        myDelegate.currentViewController=@"dashboard";
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [myDelegate.window setRootViewController:objReveal];
        [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
        [myDelegate.window makeKeyAndVisible];
    }
    else {
        UIViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                             animated: YES];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - end

@end
