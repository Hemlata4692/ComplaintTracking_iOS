//
//  Webservice.h
//  Finder_iPhoneApp
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//testing link
#define BASE_URL                          @"http://ranosys.info/complianttracking/api/ComplaintsManager/"

@interface Webservice : NSObject

@property(nonatomic,retain) AFHTTPSessionManager *manager;

//Singleton instance
+ (id)sharedManager;
//end

//Request with parameters
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Request with profile image
- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Request with image array (multiple images)
- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters imageArray:(NSMutableArray *)imageArray success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Check response success
- (BOOL)isStatusOK:(id)responseObject;
//end

@end
