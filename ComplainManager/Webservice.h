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
//#define BASE_URL                          @"http://ranosys.info/complianttracking/api/ComplaintsManager/"
//#define BASE_URL                          @"http://ranosys.info/feedbacktrackingqa/api/ComplaintsManager/"
#define BASE_URL                            @"http://www.snapnfix.com/api/ComplaintsManager/"
//com.dev.snapnfix - Live
//com.ranosys.ComplaintsTracking - Testing
@interface Webservice : NSObject

@property(nonatomic,retain) AFHTTPSessionManager *manager;

//Singleton instance
+ (id)sharedManager;
//end

//Request with parameters
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Check response success
- (BOOL)isStatusOK:(id)responseObject;
//end

@end
