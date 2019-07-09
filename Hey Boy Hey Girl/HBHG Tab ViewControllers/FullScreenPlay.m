//
//  FullScreenPlay.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 30/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "FullScreenPlay.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface FullScreenPlay ()
{
    
    NSArray *arrAnimationType,*caresuyalArray;
    int sliderCount1;
    NSTimer *timer;
    AVPlayerLayer *playerLayer;
    AVPlayer *player;
    NSString *strVideo;
}
- (IBAction)exitButton:(id)sender;

@end

@implementation FullScreenPlay

static int animationType = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    arrAnimationType = [NSArray arrayWithObjects:@"1",@"9",@"10", nil];//@"5",@"6"
    
    if (_isVideoString) {
        strVideo = [_arr_images objectAtIndex:0];
        caresuyalArray = [NSArray arrayWithObject:strVideo];

    }else{
      //  caresuyalArray = [NSMutableArray arrayWithArray:_arr_images];
        caresuyalArray = [_arr_images mutableCopy];
    }
    self.carousel1.delegate = self;
    self.carousel1.dataSource = self;
    
    [self careosalDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitButton:(id)sender {
    
    if (playerLayer) {
        [playerLayer.player pause];
        [playerLayer removeFromSuperlayer];
    }
   
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];

}


#pragma mark iCarousel methods

-(void)careosalDataSource{
    
   // caresuyalArray = [_arr_images mutableCopy];
    
    sliderCount1 = 0;
    animationType = 0;
    [self.carousel1 reloadData];
   timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return caresuyalArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (strVideo.length) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vw_imageshow.frame.size.width, _vw_imageshow.frame.size.height)];
        view.backgroundColor = [UIColor blackColor];
        
        NSURL *url1 = [NSURL URLWithString:strVideo];
        AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;

        playerLayer.frame = CGRectMake(0, 0, _vw_imageshow.frame.size.width, _vw_imageshow.frame.size.height);
        [view.layer addSublayer:playerLayer];
        //[player play];
        [player play];
        player.muted = false;
    }else{
    
         if (view == nil) {
             
        NSString *imgpath = [caresuyalArray objectAtIndex:index];
        
        NSLog(@"imagePath >>> %@",imgpath);
        
        UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _vw_imageshow.frame.size.width, _vw_imageshow.frame.size.height)];
        
        [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image){
                imgVw.image = [self squareImageWithImage:image scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                imgVw.contentMode = UIViewContentModeScaleAspectFill;
            }
        }];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vw_imageshow.frame.size.width, _vw_imageshow.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        imgVw.tag = 101;
        [view addSubview:imgVw];
    }else{
        UIImageView *imgVw = (UIImageView *)[view viewWithTag:101];
        [imgVw sd_setImageWithURL:[NSURL URLWithString:[caresuyalArray objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image){
                imgVw.image = [self squareImageWithImage:image scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                imgVw.contentMode = UIViewContentModeScaleAspectFill;
            }
        }];
    }
}
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    //    switch (option)
    //    {
    //        case iCarouselOptionSpacing:
    //        {
    //            if (carousel == carousel2)
    //            {
    //                //add a bit of spacing between the item views
    //                return value * 1.05f;
    //            }
    //        }
    //        default:
    //        {
    //            return value;
    //        }
    //    }
    return value;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    sliderCount1=0;
    
    [super viewDidAppear:animated];
}

-(void)runMethod
{
   
    [self.carousel1 scrollToItemAtIndex:sliderCount1 animated:sliderCount1 ? YES : NO];
    if((sliderCount1%2) == 0)
    {
        animationType++;
        animationType = (animationType > 2) ? 0 : animationType;
        self.carousel1.type = [[arrAnimationType objectAtIndex:animationType] intValue];
        NSLog(@"---rand %ld",self.carousel1.type);
        if (caresuyalArray.count == (sliderCount1+1)) {
            sliderCount1=0;
        }else{
            sliderCount1++;
        }
        //[self.carousel1 reloadData];
    }
    else
    {
        if (caresuyalArray.count == (sliderCount1+1)) {
            sliderCount1=0;
        }else{
            sliderCount1++;
        }
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    NSLog(@"123456");
    // [playerLayer removeFromSuperlayer];
    // [self.carousel1 reloadData];
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero completionHandler:^(BOOL isFinished){
        NSLog(@"finished");
        
    }];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [timer invalidate];
    timer = nil;
}

//Image Resizing

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
