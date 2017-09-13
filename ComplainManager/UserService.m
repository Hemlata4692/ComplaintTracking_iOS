//
//  UserService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.requestDict
//

#import "UserService.h"
#import "TenantsListModel.h"
#import "ProfileDataModel.h"

#define kUrlLogin                       @"Login"
#define kUrlLogout                      @"Logout"
#define kUrlForgotPassword              @"ForgotPassword"
#define kUrlRegister                    @"register"
#define kUrlChangePassword              @"ChangePassword"
#define kUrlTenantsList                 @"UserList"
#define kUrlGetProfile                  @"ViewProfile"
#define kUrlDeviceToken                 @"SendNotification"
#define kUrlEditProfile                 @"UpdateProfile"
#define kUrlGetSettings                 @"NotificationEmailConfiguration"
#define kUrlUpdateSettings              @"ChangeNotificationEmailStatus"
#define kUrlUpdateReminderDay           @"ChangeReminderDays"

@implementation UserService

#pragma mark - Singleton instance
+ (id)sharedManager {
    static UserService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)init {
    if (self = [super init])
    {
        
    }
    return self;
}
#pragma mark - end

#pragma mark- Login
//Login
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure {
     NSDictionary *requestDict = @{@"email":email,@"password":password,@"deviceId":myDelegate.deviceToken,@"devicetype":@"iOS"};
    NSLog(@"login %@",requestDict);
    [[Webservice sharedManager] post:kUrlLogin parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

#pragma mark- Forgot password
//Forgot Password
- (void)forgotPassword:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"email":email};
    [[Webservice sharedManager] post:kUrlForgotPassword parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

#pragma mark- Edit user profile
- (void)editProfile:(NSString *)name address:(NSString *)address mobileNumber:(NSString *)mobileNumber image:(NSString *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"Name":name,@"Phone":mobileNumber, @"AddressBlock":address,@"Image":image};
    [[Webservice sharedManager] post:kUrlEditProfile parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
    
}
#pragma mark- end

#pragma mark- Change password
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"oldPassword":oldPassword,@"newPassword":newPassword};
    [[Webservice sharedManager] post:kUrlChangePassword parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

#pragma mark- Tenants Listing
- (void)getTenantsListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"PropertyId":[[UserDefaultManager getValue:@"propertyId"] objectAtIndex:0]};
    [[Webservice sharedManager] post:kUrlTenantsList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            id array =[responseObject objectForKey:@"list"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * tenantsListArray = [responseObject objectForKey:@"list"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<tenantsListArray.count; i++) {
                    TenantsListModel *dataModel = [[TenantsListModel alloc]init];
                    NSDictionary * complainDict =[tenantsListArray objectAtIndex:i];
                    dataModel.tenantsImageString =[complainDict objectForKey:@"UserImage"];
                    dataModel.tenantsName =[complainDict objectForKey:@"Name"];
                    dataModel.tenantsEmail =[complainDict objectForKey:@"Email"];
                    dataModel.tenantsContact =[complainDict objectForKey:@"Phone"];
                    dataModel.tenantId =[complainDict objectForKey:@"Id"];
                    [dataArray addObject:dataModel];
                }
                success(dataArray);
            }
        }
        else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

#pragma mark- Profile details
- (void)getProfileDetail:(BOOL)isTenantDetailScreen userId:(NSString *)userId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict;
    if (isTenantDetailScreen) {
        requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"], @"userprofileid":userId,@"ProfileType":@"TProfile"};
    } else {
        requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"ProfileType":@"UProfile"};
    }
    [[Webservice sharedManager] post:kUrlGetProfile parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

#pragma mark- logout
- (void)logout:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"deviceId":myDelegate.deviceToken};
    [[Webservice sharedManager] post:kUrlLogout parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

#pragma mark- Get notification settings
- (void)getNotificationSettings:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    NSDictionary *requestDict = @{@"Id":[UserDefaultManager getValue:@"userId"]};
    [[Webservice sharedManager] post:kUrlGetSettings parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end


#pragma mark- Update notification settings
- (void)updateNotificationSettings:(BOOL)notification email:(BOOL)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSString *eString = (email) ? @"True" : @"False";
    NSString *nString = (notification) ? @"True" : @"False";
    NSDictionary *requestDict = @{@"Id":[UserDefaultManager getValue:@"userId"],@"EmailNotification":eString ,@"WebNotification":nString};
    [[Webservice sharedManager] post:kUrlUpdateSettings parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end
#pragma mark- Update notification status
- (void)updateReminderDaySettings:(NSString *)reminderday success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"Id":[UserDefaultManager getValue:@"userId"],@"Reminderday":reminderday};
    [[Webservice sharedManager] post:kUrlUpdateReminderDay parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        } else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error) {
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

@end
