//
//  Webservice.m
//  Finder_iPhoneApp
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//


#import "Webservice.h"
@implementation Webservice
@synthesize manager;

#pragma mark - Singleton instance
+ (id)sharedManager {
    static Webservice *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return self;
}
#pragma mark - end

#pragma mark - AFNetworking method
//Request with parameters
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([UserDefaultManager getValue:@"AuthenticationToken"] != NULL) {
        [manager.requestSerializer setValue:[UserDefaultManager getValue:@"AuthenticationToken"] forHTTPHeaderField:@"AuthenticationToken"];
    }
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
        NSLog(@"error.localizedDescription %@",error.localizedDescription);
        [myDelegate stopIndicator];
        if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                 options:kNilOptions error:&error];
            NSLog(@"json %@",json);
            if (myDelegate.isDetailJobStarted) {
                failure(error);
            } else {
                [self isStatusOK:json];
            }
        } else {
            failure(error);
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        }
    }];
}

//Check response success
- (BOOL)isStatusOK:(id)responseObject {
    NSNumber *number = responseObject[@"status"];
    NSString *msg;
    switch (number.integerValue) {
        case 400: {
            msg = responseObject[@"message"];
            if ([msg containsString:@"Your account has been deactivated."]) {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert addButton:@"OK" actionBlock:^(void) {
                    [myDelegate showIndicator];
                    [myDelegate performSelector:@selector(logoutUser) withObject:nil afterDelay:.1];                }];
                [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:nil duration:0.0f];
            } else {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
            }
            return NO;
        }
        case 404: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
            return NO;
        }
        case 200:
            return YES;
            break;
        case 401: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"OK" actionBlock:^(void) {
                [myDelegate showIndicator];
                [myDelegate performSelector:@selector(logoutUser) withObject:nil afterDelay:.1];            }];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:nil duration:0.0f];
        }
            return NO;
            break;
        default: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
        }
            return NO;
            break;
    }
}
#pragma mark - end

//#pragma mark - Remove default values
//- (void)removeDefaultValues {
//    [[UserService sharedManager] logout:^(id responseObject){
//        [myDelegate stopIndicator];
//        [UserDefaultManager removeValue:@"name"];
//        [UserDefaultManager removeValue:@"userId"];
//        [UserDefaultManager removeValue:@"AuthenticationToken"];
//        [UserDefaultManager removeValue:@"contactNumber"];
//        [UserDefaultManager removeValue:@"isFirsttime"];
//        [UserDefaultManager removeValue:@"role"];
//        [UserDefaultManager removeValue:@"propertyId"];
//        myDelegate.screenName= @"dashboard";
//        myDelegate.selectedMenuIndex = 0;
//        myDelegate.isDetailJobStarted = false;
//        myDelegate.detailNotification = false;
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
//        myDelegate.window.rootViewController = myDelegate.navigationController;
//    } failure:^(NSError *error) {
//    }] ;
//}
#pragma mark - end

@end
