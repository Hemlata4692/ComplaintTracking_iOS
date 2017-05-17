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
- (void)getComplainListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

@end
