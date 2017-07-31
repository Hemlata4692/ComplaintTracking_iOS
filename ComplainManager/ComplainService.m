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
#import "CommentsModel.h"

#define kUrlComplainList                  @"ComplainList"
#define kUrlUploadImage                   @"UploadImage"
#define kUrlCategoryListing               @"ComplainCategoryList"
#define kUrlLocationListing               @"ComplainLocationList"
#define kUrlAddComplain                   @"AddComplain"
#define kUrlGetComplainDetail             @"GetComplainDetails"
#define kUrlJobStatus                     @"JobStatus"
#define kUrlAddComments                   @"AddComments"

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
    NSString * isBuildingManager;
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
        isBuildingManager = @"true";
    } else {
        isBuildingManager = @"false";
    }
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"DisplayBoard":screenName,@"UserRoleId":[UserDefaultManager getValue:@"RoleId"],@"PropertyId":[UserDefaultManager getValue:@"propertyId"],@"IsBuildingManager":isBuildingManager};
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
                    complainDataModel.userName =[complainDict objectForKey:@"Title"];
                    complainDataModel.complainDescription =[complainDict objectForKey:@"FullDescription"];
                    complainDataModel.complainStatus =[complainDict objectForKey:@"ComplainStatus"];
                    complainDataModel.complainImageString =[complainDict objectForKey:@"UserImage"];
                    complainDataModel.complainId =[complainDict objectForKey:@"Id"];
                    complainDataModel.categoryName =[complainDict objectForKey:@"CategoryName"];
                    complainDataModel.complainTime =[complainDict objectForKey:@"SubmittedOn"];
                    complainDataModel.userName =[complainDict objectForKey:@"UserName"];
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
- (void)getCategories:(BOOL)isCategoryService success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"propertyId":[UserDefaultManager getValue:@"propertyId"]};
    NSLog(@"Categories requestDict %@",requestDict);
    NSString *method;
    if (isCategoryService) {
        method = kUrlCategoryListing;
    } else {
        method = kUrlLocationListing;
    }
    [[Webservice sharedManager] post:method parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"Categories response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            id array =[responseObject objectForKey:@"list"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * categoryArray = [responseObject objectForKey:@"list"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<categoryArray.count; i++) {
                    AddComplainModel *categoryModel = [[AddComplainModel alloc]init];
                    if (isCategoryService) {
                        NSDictionary * complainDict =[categoryArray objectAtIndex:i];
                        categoryModel.categoryId =[complainDict objectForKey:@"Id"];
                        categoryModel.categoryName =[complainDict objectForKey:@"Name"];
                    } else {
                        NSDictionary * complainDict =[categoryArray objectAtIndex:i];
                        categoryModel.locationId =[complainDict objectForKey:@"Id"];
                        categoryModel.locationName =[complainDict objectForKey:@"Name"];
                    }
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
- (void)addComplait:(NSString *)complainDescription categoryId:(NSString *)categoryId imageNameArray:(NSMutableArray *)imageNameArray PropertyLocationId:(NSString *)PropertyLocationId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"fullDescription":complainDescription,@"categoryId":categoryId,@"imageName":imageNameArray,@"PropertyLocationId":PropertyLocationId,@"propertyId":[UserDefaultManager getValue:@"propertyId"]};
    NSLog(@"add feedback requestDict %@",requestDict);
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
    NSString *isBuildingManager;
    if ([[UserDefaultManager getValue:@"role"] isEqualToString:@"bm"]) {
        isBuildingManager = @"true";
    } else {
        isBuildingManager = @"false";
    }
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"complainId":complainId,@"propertyId":[UserDefaultManager getValue:@"propertyId"],@"IsBuildingManager":isBuildingManager};
    NSLog(@"complain requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetComplainDetail parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            NSMutableDictionary *detailDict = [NSMutableDictionary new];
            detailDict = [responseObject objectForKey:@"Details"];
            id array =[[responseObject objectForKey:@"Details"] objectForKey:@"Comments"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * categoryArray = [[responseObject objectForKey:@"Details"] objectForKey:@"Comments"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<categoryArray.count; i++) {
                    CommentsModel *commentModel = [[CommentsModel alloc]init];
                    NSDictionary * commentDict =[categoryArray objectAtIndex:i];
                    commentModel.commnts =[commentDict objectForKey:@"comments"];
                    commentModel.time =[commentDict objectForKey:@"SubmittedOn"];
                    commentModel.CommmentsBy =[commentDict objectForKey:@"CommmentsBy"];
                    [dataArray addObject:commentModel];
                }
                [detailDict setObject:dataArray forKey:@"comments"];
            }
            id userCategoryArray =[[responseObject objectForKey:@"Details"] objectForKey:@"UserFeedbackCategory"];
            if (([userCategoryArray isKindOfClass:[NSArray class]])) {
                [detailDict setObject:userCategoryArray forKey:@"userCategoryArray"];
            }
            success(detailDict);
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
- (void)changeJobStatus:(NSString *)complainId jobStatus:(NSString *)jobStatus imageNameArray:(NSMutableArray *)imageNameArray success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict;
    if ([jobStatus isEqualToString:@"Complete"]) {
        requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"complainId":complainId,@"complainStatus":jobStatus, @"ImageName":imageNameArray};
        
    } else {
        requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"complainId":complainId,@"complainStatus":jobStatus};
    }
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

#pragma mark - Add comment
- (void)addComment:(NSString *)complainId comments:(NSString *)comments success:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"complainId":complainId,@"commments":comments};
    NSLog(@"complain requestDict %@",requestDict);
    [[Webservice sharedManager] post:kUrlAddComments parameters:requestDict success:^(id responseObject) {
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
