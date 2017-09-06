//
//  UserService.h
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserService : NSObject

//Singleton instance
+ (id)sharedManager;
//end

//Login screen method
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Forgot password method
- (void)forgotPassword:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Edit user profile
- (void)editProfile:(NSString *)name address:(NSString *)address mobileNumber:(NSString *)mobileNumber image:(NSString *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Change password
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Tenants Listing
- (void)getTenantsListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Profile details
- (void)getProfileDetail:(BOOL)isTenantDetailScreen userId:(NSString *)userId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//logout
- (void)logout:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Get notification settings
- (void)getNotificationSettings:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Update notification settings
- (void)updateNotificationSettings:(BOOL)notification email:(BOOL)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Update notification status
- (void)updateReminderDaySettings:(NSString *)reminderday success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

@end
