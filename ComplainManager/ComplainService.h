//
//  ComplainService.h
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplainService : NSObject
//Singleton instance
+ (id)sharedManager;
//end

//Conference Listing
- (void)getComplainListing:(NSString *)screenName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Upload image
- (void)uploadImage:(UIImage *)image screenName:(NSString *)screenName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure ;
//end

//Category listing
- (void)getCategories:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Add complaint
- (void)addComplait:(NSString *)complainTitle complainDescription:(NSString *)complainDescription categoryId:(NSString *)categoryId complainId:(NSString *)complainId imageNameArray:(NSMutableArray *)imageNameArray success:(void (^)(id data))success failure:(void (^)(NSError *error))failure ;
//end

//Complaint detail
- (void)getComplaitDetail:(NSString *)complainId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure ;
//end


//Job status
- (void)changeJobStatus:(NSString *)complainId jobStatus:(NSString *)jobStatus success:(void (^)(id data))success failure:(void (^)(NSError *error))failure ;
//end

@end
