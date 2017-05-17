//
//  ComplainListDataModel.h
//  ComplainManager
//
//  Created by Monika Sharma on 16/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplainListDataModel : NSObject

@property(nonatomic,retain)NSString * complainImageString;
@property(nonatomic,retain)NSString * complainTitle;
@property(nonatomic,retain)NSString * complainDescription;
@property(nonatomic,retain)NSString * complainStatus;

@end
