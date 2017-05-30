//
//  AddComplainCell.h
//  ComplainManager
//
//  Created by Monika Sharma on 18/05/17.
//  Copyright © 2017 Monika Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddComplainCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *complainImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
- (void)displayData:(long)index data:(NSMutableArray *)imageArray isAddComplainScreen:(bool)isAddComplainScreen;

@end
