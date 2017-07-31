//
//  ImagePreviewViewController.m
//  MyTake
//
//  Created by Hema on 12/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ImagePreviewViewController ()<UIGestureRecognizerDelegate> {
    UIImage *resultImage;
}
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation ImagePreviewViewController
@synthesize attachmentArray;
@synthesize selectedIndex;

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationItem.title=@"Gallery";
    self.previewImageView.userInteractionEnabled=YES;
    //add swipe gesture on iamge view
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesLeft:)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesRight:)];
    swipeImageRight.delegate=self;
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.previewImageView addGestureRecognizer:swipeImageLeft];
    [self.previewImageView addGestureRecognizer:swipeImageRight];
    swipeImageLeft.enabled = YES;
    swipeImageRight.enabled = YES;
    [self swipeImages];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //if this vc can be poped , then
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    //if this vc can be poped , then
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Swipe gesture methods
//display current index image on image view
- (void)swipeImages {
    if ([[attachmentArray objectAtIndex:selectedIndex] isKindOfClass:[NSString class]]) {
        [self downloadImages:self.previewImageView imageUrl:[attachmentArray objectAtIndex:selectedIndex] placeholderImage:@"placeholderListing" isVideo:@"0"];
    } else {
        self.previewImageView.image = [attachmentArray objectAtIndex:selectedIndex];
    }
}

//adding left animation to images
- (void)addLeftAnimationPresentToView:(UIView *)viewTobeAnimatedLeft {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [viewTobeAnimatedLeft.layer addAnimation:transition forKey:nil];
    
}

//adding right animation to images
- (void)addRightAnimationPresentToView:(UIView *)viewTobeAnimatedRight {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [viewTobeAnimatedRight.layer addAnimation:transition forKey:nil];
}

//swipe images in left direction
- (void)swipeImagesLeft:(UISwipeGestureRecognizer *)sender {
    selectedIndex++;
    if (selectedIndex<attachmentArray.count) {
        if ([[attachmentArray objectAtIndex:selectedIndex] isKindOfClass:[NSString class]]) {
            [self downloadImages:self.previewImageView imageUrl:[attachmentArray objectAtIndex:selectedIndex] placeholderImage:@"placeholderListing" isVideo:@"0"];
        } else {
            self.previewImageView.image = [attachmentArray objectAtIndex:selectedIndex];
        }
        UIImageView *moveImageView = self.previewImageView;
        [self addLeftAnimationPresentToView:moveImageView];
    }
    else {
        selectedIndex--;
    }
}

//swipe images in right direction
- (void)swipeImagesRight:(UISwipeGestureRecognizer *)sender {
    selectedIndex--;
    if (selectedIndex<attachmentArray.count) {
        //set image from afnetworking
        if ([[attachmentArray objectAtIndex:selectedIndex] isKindOfClass:[NSString class]]) {
            [self downloadImages:self.previewImageView imageUrl:[attachmentArray objectAtIndex:selectedIndex] placeholderImage:@"placeholderListing" isVideo:@"0"];
        } else {
            self.previewImageView.image = [attachmentArray objectAtIndex:selectedIndex];
        }
        UIImageView *moveImageView = self.previewImageView;
        [self addRightAnimationPresentToView:moveImageView];
    }
    else {
        selectedIndex++;
    }
}
#pragma mark - end

#pragma mark - Download images using AFNetworking
- (void)downloadImages:(UIImageView *)imageView imageUrl:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage isVideo:(NSString *)isVideo {
    __weak UIImageView *weakRef = imageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [imageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:placeholderImage] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if ([isVideo isEqualToString:@"1"]) {
            weakRef.contentMode = UIViewContentModeScaleAspectFit;
        }
        else {
            weakRef.contentMode = UIViewContentModeScaleAspectFill;
        }
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
        weakRef.backgroundColor = [UIColor clearColor];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
}
#pragma mark - end

@end
