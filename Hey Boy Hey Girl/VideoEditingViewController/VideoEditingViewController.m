//
//  VideoEditingViewController.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 06/03/18.
//  Copyright © 2018 Sketch Developer. All rights reserved.
//

#import "VideoEditingViewController.h"
#import "SAVideoRangeSlider.h"

@interface VideoEditingViewController ()
{
    AVPlayerLayer *playerLayer;
    AVPlayer *player;
    int sliderCount;
    NSArray *arrAnimationType;
}
@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (strong, nonatomic) NSString *originalVideoPath;
@property (strong, nonatomic) NSString *tmpVideoPath;
@property (nonatomic) CGFloat startTime;
@property (nonatomic) CGFloat stopTime;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *videoPlayView;
@property (weak, nonatomic) IBOutlet UIButton *trimBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgvScreenshots;

@end

@implementation VideoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.videoFilePathStr);
    
    arrAnimationType = [NSArray arrayWithObjects:@"0",@"5",@"6",@"9",@"10", nil];
    self.carousel1.delegate = self;
    self.carousel1.dataSource = self;
    self.carousel1.type = 1;
    //self.carousel1.autoscroll = 1.0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSString *urlToDownload = @"http://lab-5.sketchdemos.com/PHP-WEB-SERVICES/P-898-hey_boy_hey_girl_ci/uploads/profiles/video/1ebf2cbe4cf08780359b633efeb532ac.mp4";
        NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            
            // NSLog(@"urldata %@   ",urlData);
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"demo2.mov"];
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"File Saved !%@",filePath);
               // self.originalVideoPath = filePath;
                self.originalVideoPath = self.videoFilePathStr;
                [self showTrimmer];
            });
        }
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)orientationChanged{
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        NSLog(@"Potrait");
    }
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        NSLog(@"Landscape");
    }
    
}
-(void)showTrimmer{
    //
    self.myActivityIndicator.hidden = YES;
    
    NSString *tempDir = NSTemporaryDirectory();
    self.tmpVideoPath = [tempDir stringByAppendingPathComponent:@"tmpMov.mov"];
    //  NSBundle *mainBundle = [NSBundle mainBundle];
    //  self.originalVideoPath = [mainBundle pathForResource: @"thaiPhuketKaronBeach" ofType: @"MOV"];
    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.originalVideoPath];
    
    SAVideoRangeSlider *mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(10, 200,self.view.frame.size.width-20, 70) videoUrl:videoFileUrl];
    
    
    [mySAVideoRangeSlider setPopoverBubbleSize:200 height:100];
    mySAVideoRangeSlider.delegate = self;
    mySAVideoRangeSlider.minGap = 1; // optional, seconds
    mySAVideoRangeSlider.maxGap = 7; // optional, seconds
    
    // Yellow
    //    self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.996 green: 0.951 blue: 0.502 alpha: 1];
    //    self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];
    // Purple
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.768 green: 0.665 blue: 0.853 alpha: 1];
    //self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.535 green: 0.329 blue: 0.707 alpha: 1];
    
    // Gray
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.945 green: 0.945 blue: 0.945 alpha: 1];
    //self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.806 green: 0.806 blue: 0.806 alpha: 1];
    
    // Green
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.725 green: 0.879 blue: 0.745 alpha: 1];
    //self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.449 green: 0.758 blue: 0.489 alpha: 1];
    
    // Star
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 1 green: 0.114 blue: 0.114 alpha: 1];
    
    self.mySAVideoRangeSlider.delegate = self;
    [self.view addSubview:mySAVideoRangeSlider];
}


- (void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition{
    
}
- (IBAction)trimeVideoAction:(id)sender {
    
    [self deleteTmpFile];
    
    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.originalVideoPath];
    
    AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:anAsset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.
        
        NSURL *furl = [NSURL fileURLWithPath:self.tmpVideoPath];
        
        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(self.startTime, anAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime-self.startTime, anAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;
        
        self.trimBtn.hidden = YES;
        self.myActivityIndicator.hidden = NO;
        [self.myActivityIndicator startAnimating];
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                default:
                    NSLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.myActivityIndicator stopAnimating];
                        self.myActivityIndicator.hidden = YES;
                        self.trimBtn.hidden = NO;
                        [self playMovie:self.tmpVideoPath];
                    });
                    break;
            }
        }];
    }
}
- (IBAction)originalViedoBtnAction:(id)sender {
    [self playMovie:self.originalVideoPath];
}
#pragma mark - Other
-(void)deleteTmpFile{
    
    NSURL *url = [NSURL fileURLWithPath:self.tmpVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}

-(void)playMovie: (NSString *) path{
    // NSURL *url = [NSURL fileURLWithPath:path];
    //    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    //    [self presentMoviePlayerViewControllerAnimated:theMovie];
    //    theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    //    [theMovie.moviePlayer play];
    //
    
    
    //NSString  *generalVideoPath = @"http://lab-5.sketchdemos.com/PHP-WEB-SERVICES/P-950-YPOJordanChapter/assets/video/1504088766487268348.mp4";
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    // NSURL *url1 = [NSURL URLWithString:@"http://lab-5.sketchdemos.com/PHP-WEB-SERVICES/P-898-hey_boy_hey_girl_ci/uploads/profiles/video/1ebf2cbe4cf08780359b633efeb532ac.mp4"];
    //
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 1);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    _imgvScreenshots.image = [UIImage imageWithCGImage:refImg];
    // UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
    //
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(10, 100, 200, 100);
    [self.view.layer addSublayer:playerLayer];
    // [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [player play];
    
    // player.muted = true;
    /*
     [player pause];
     player seekToTime:kCMTimeZero];
     [player play];
     */
    
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

#pragma mark - SAVideoRangeSliderDelegate
- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    self.startTime = leftPosition;
    self.stopTime = rightPosition;
    self.timeLabel.text = [NSString stringWithFormat:@"%f - %f", leftPosition, rightPosition];
}
- (void)viewDidUnload {
    [self setMyActivityIndicator:nil];
    [self setTrimBtn:nil];
    [super viewDidUnload];
}


#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return 1;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    // UILabel *label = nil;
    
    //create new view if no view is available for recycling
    /* if (view == nil)
     {
     view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];ƒ
     ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
     view.contentMode = UIViewContentModeCenter;
     label = [[UILabel alloc] initWithFrame:view.bounds];
     label.backgroundColor = [UIColor clearColor];
     label.textAlignment = NSTextAlignmentCenter;
     label.font = [label.font fontWithSize:50];
     [view addSubview:label];
     }
     */
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    view.backgroundColor = [UIColor blueColor];
    
    NSURL *url1 = [NSURL URLWithString:@"http://lab-5.sketchdemos.com/PHP-WEB-SERVICES/P-898-hey_boy_hey_girl_ci/uploads/profiles/video/1ebf2cbe4cf08780359b633efeb532ac.mp4"];
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, 200, 100);
    [view.layer addSublayer:playerLayer];
    //[player play];
    [player play];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //  player.muted = true;
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    // label.text = [NSString stringWithFormat:@"%ld",index];
    
    //if (carousel == carousel1)
    
    
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
    sliderCount=0;
    [super viewDidAppear:animated];
    // [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
}

-(void)runMethod
{
    [self.carousel1 scrollToItemAtIndex:sliderCount animated:YES];
    if(sliderCount == 2)
    {
        self.carousel1.type = randomFloatBetween(1,10);
        NSLog(@"-- %ld",self.carousel1.type);
        sliderCount=0;
    }
    else
    {
        sliderCount++;
    }
}
float randomFloatBetween(float smallNumber, float bigNumber)
{
    float diff = bigNumber - smallNumber;
    return (((float) rand() / RAND_MAX) * diff) + smallNumber;
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(UIButton *)sender {
    
    
}


@end
