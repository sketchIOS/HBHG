//
//  FullScreenPlay.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 30/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface FullScreenPlay : UIViewController<iCarouselDataSource, iCarouselDelegate>

@property(strong) NSMutableArray *arr_images;
@property(assign) BOOL isVideoString;

@property (nonatomic, strong) IBOutlet iCarousel *carousel1;
@property (nonatomic, strong) IBOutlet UIView *vw_imageshow;


@end
