//
//  ComplainService.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplainService.h"
#define kUrlComplainList                  @"getcomplainlisting"

@implementation ComplainService

#pragma mark - Singleton instance
+ (id)sharedManager {
    static ComplainService *sharedMyManager = nil;
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

#pragma mark - Conference Listing
- (void)getComplainListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"]};
    [[Webservice sharedManager] post:kUrlComplainList parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"complainListing response %@",responseObject);
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
#pragma mark - end
@end
