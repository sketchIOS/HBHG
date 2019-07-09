//
//  ProfilePage.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 17/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface ProfilePage : UIViewController<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *interest_collectionVw;
@property (strong) NSMutableDictionary *dictForProfileInterest;
//@property (strong, nonatomic) IBOutlet UIScrollView *scroll_middleVw;
//@property (strong, nonatomic) IBOutlet UIScrollView *scroll_secondVw;
//@property (strong, nonatomic) IBOutlet UIScrollView *scroll_thirdVw;

@property (nonatomic, strong) IBOutlet iCarousel *carousel_middle;
@property (nonatomic, strong) IBOutlet iCarousel *carousel_left;
@property (nonatomic, strong) IBOutlet iCarousel *carousel_right;

@property (nonatomic, strong) IBOutlet UIView *vw_back;
@property (nonatomic, strong) IBOutlet UIButton *btn_Back;


@property (strong) NSMutableArray *arrImageFromFB;
@property (assign) int view_Number;

@property (strong, nonatomic) IBOutlet UIView *mainVw;

@property (strong, nonatomic) IBOutlet UIView *headerVw;
@property (strong, nonatomic) IBOutlet UIView *slidingMainVw;
@property (strong, nonatomic) IBOutlet UIView *buttonBackVw;



@end
