//
//  ComplainService.m
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import "ComplainService.h"
#import "ComplainListDataModel.h"
#import "AddComplainModel.h"

#define kUrlComplainList                  @"ComplainList"
#define kUrlUploadImage                   @"UploadImage"
#define kUrlCategoryListing               @"ComplainCategoryList"
#define kUrlAddComplain                   @"AddComplain"
#define kUrlGetComplainDetail             @"GetComplainDetails"
#define kUrlJobStatus                     @"JobStatus"

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
- (void)getComplainListing:(NSString *)screenName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"DisplayBoard":screenName};
    NSLog(@"complainListing requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlComplainList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"complainListing response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            [UserDefaultManager setValue:[responseObject objectForKey:@"userImage"] key:@"userImage"];
            id array =[responseObject objectForKey:@"list"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * complainArray = [responseObject objectForKey:@"list"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<complainArray.count; i++) {
                    ComplainListDataModel *complainDataModel = [[ComplainListDataModel alloc]init];
                    NSDictionary * complainDict =[complainArray objectAtIndex:i];
                    complainDataModel.complainTitle =[complainDict objectForKey:@"Title"];
                    complainDataModel.complainDescription =[complainDict objectForKey:@"FullDescription"];
                    complainDataModel.complainStatus =[complainDict objectForKey:@"ComplainStatus"];
                    complainDataModel.complainImageString =[complainDict objectForKey:@"UserImage"];
                    complainDataModel.complainId =[complainDict objectForKey:@"Id"];
                    complainDataModel.categoryName =[complainDict objectForKey:@"CategoryName"];
                    complainDataModel.complainTime =[complainDict objectForKey:@"SubmittedOn"];
                    [dataArray addObject:complainDataModel];
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
#pragma mark - end

#pragma mark - UploadImage
- (void)uploadImage:(UIImage *)image screenName:(NSString *)screenName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *  encodedImage = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"ImageType":screenName,@"Images":encodedImage};
    NSLog(@"image requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlUploadImage parameters:requestDict success:^(id responseObject) {
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

#pragma mark - Category listing
- (void)getCategories:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"]};
    NSLog(@"Categories requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlCategoryListing parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"Categories response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            id array =[responseObject objectForKey:@"list"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * categoryArray = [responseObject objectForKey:@"list"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<categoryArray.count; i++) {
                    AddComplainModel *categoryModel = [[AddComplainModel alloc]init];
                    NSDictionary * complainDict =[categoryArray objectAtIndex:i];
                    categoryModel.categoryId =[complainDict objectForKey:@"Id"];
                    categoryModel.categoryName =[complainDict objectForKey:@"Name"];
                    [dataArray addObject:categoryModel];
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
#pragma mark - end

#pragma mark - Add complaint
- (void)addComplait:(NSString *)complainTitle complainDescription:(NSString *)complainDescription categoryId:(NSString *)categoryId complainId:(NSString *)complainId imageNameArray:(NSMutableArray *)imageNameArray success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"title":complainTitle,@"fullDescription":complainDescription,@"categoryId":categoryId,@"imageName":imageNameArray};
    NSLog(@"complain requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlAddComplain parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"response %@",responseObject);
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

#pragma mark - Complaint detail
- (void)getComplaitDetail:(NSString *)complainId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"complainId":complainId};
    NSLog(@"complain requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetComplainDetail parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"response %@",responseObject);
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

#pragma mark - Job status
- (void)changeJobStatus:(NSString *)complainId jobStatus:(NSString *)jobStatus success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"complainId":complainId,@"complainStatus":jobStatus};
    NSLog(@"complain requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlJobStatus parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"response %@",responseObject);
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
