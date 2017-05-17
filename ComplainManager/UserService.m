//
//  UserService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "UserService.h"

#define kUrlLogin                       @"login"
#define kUrlForgotPassword              @"forgotpassword"
#define kUrlRegister                    @"register"

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
- (void)userLogin:(NSString *)username password:(NSString *)password role:(NSString *)role success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"username":username,@"password":password};
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

#pragma mark- User registeration
//User registeration
- (void)userRegisteration:(NSString *)name email:(NSString *)email password:(NSString *)password mobileNumber:(NSString *)mobileNumber success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"name":name,@"email":email,@"password":password,@"mobile":mobileNumber};
    [[Webservice sharedManager] post:kUrlRegister parameters:requestDict success:^(id responseObject) {
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
