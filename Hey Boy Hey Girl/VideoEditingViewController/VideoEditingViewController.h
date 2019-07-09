//
//  VideoEditingViewController.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 06/03/18.
//  Copyright © 2018 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SAVideoRangeSlider.h"
#import "iCarousel.h"

@interface VideoEditingViewController : UIViewController<SAVideoRangeSliderDelegate,iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel1;
@property (nonatomic, strong) NSString *videoFilePathStr;

@end
