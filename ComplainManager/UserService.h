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

//User registeration
- (void)userRegisteration:(NSString *)name email:(NSString *)email password:(NSString *)password mobileNumber:(NSString *)mobileNumber success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Change password
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

@end
