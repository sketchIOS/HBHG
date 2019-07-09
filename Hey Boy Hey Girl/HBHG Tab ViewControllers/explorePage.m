//
//  explorePage.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 23/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "ProfilePage.h"
#import "ChatPage.h"
#import "explorePage.h"
#import "myMatchesPage.h"
#import "notificationPage.h"
#import "ReportUserView.h"
#import "BlockUserView.h"
#import "profileFullView.h"
#import "AppDelegate.h"
#import <AFHTTPSessionManager.h>
#import "CommonHeaderFile.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+animatedGIF.h"
#import "GBSliderBubbleView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SettingsView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface explorePage ()<profileBlockDelegate,profileReportDelegate,UITextFieldDelegate,GBSliderBubbleViewDelegate>
{
    SettingsView *sVw;
    ReportUserView *reportUserVw;
    BlockUserView *blockUserVw;
    AppDelegate *appDell;
    NSString *str_userId;
    NSMutableArray *arrMatchData,*caresuyalArray;
    AVPlayerLayer *playerLayer;
    AVPlayer *player;
    
    int itemIndex;
    
    BOOL isNotification;
    
    // Carasoul data
    
    NSArray *arrAnimationType;
    int sliderCount1;
    NSTimer *timer;
    NSString *strVideo;
    int value_radius;
    
    NSString *deviceIdStr;
}
@property (strong, nonatomic) IBOutlet UIView *mainView;
- (IBAction)searchSettingButton:(id)sender;
- (IBAction)profileUserButton:(id)sender;
- (IBAction)blockUserButton:(id)sender;
- (IBAction)reportUserButton:(id)sender;




- (IBAction)profileButton:(id)sender;
- (IBAction)chatButton:(id)sender;
- (IBAction)exploreButton:(id)sender;
- (IBAction)myMatchesButton:(id)sender;
- (IBAction)notificationButton:(id)sender;

@end

@implementation explorePage

static int animationType = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    deviceIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenKey"];
    if (deviceIdStr.length == 0) {
        deviceIdStr = @"070e17fa62b2bc514f9e89e69db7d015f98582a60b4a1db11b1b4bd899a01c5e";
    }
    
    _HeyBoyNoBoyView.hidden = NO;
     _view_settings.frame = CGRectMake(0, 800, _view_settings.frame.size.width, _view_settings.frame.size.height);
    
    _txt_search.delegate = self;
    
    _btn_Search.layer.cornerRadius = 10.0;
    _btn_Cancel.layer.cornerRadius = 10.0;
    
    _lbl_message.hidden = NO;
    _view_NoMatch.hidden = NO;
    _btn_reportProfile.hidden = YES;
    _btn_BlockProfile.hidden = YES;
    _btn_ShowProfile.hidden = YES;
    _HeyBoyNoBoyView.hidden = YES;
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    str_userId = [userD objectForKey:khbhgUserId];
    NSLog(@"str_userId>>>>>%@",str_userId);
    
    arrMatchData = [[NSMutableArray alloc] init];
    caresuyalArray = [[NSMutableArray alloc] init];
    itemIndex = 0;
    
    // Caresuyl
    
    arrAnimationType = [NSArray arrayWithObjects:@"9",@"1",@"10", nil];//@"5",@"6"
    self.carousel1.delegate = self;
    self.carousel1.dataSource = self;
    
    // GBSlider

    _GBSliderBubbleView.delegate = self;
    _GBSliderBubbleView.isBubbleHideAnimation = NO;
    _GBSliderBubbleView.maxValue = 1000;
    [_GBSliderBubbleView renderSliderBubbleView];
    
    value_radius = 100;
    
    if (appDell.islikeNotification == YES) {
        
        [self profileLikeNotificationCall];
    }
    else{
        [self matchServiceCall];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)searchSettingButton:(id)sender {
    
    sVw = [[SettingsView alloc] init];
    sVw.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [sVw setUpUi];
    [sVw.btnSearch addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [sVw.btnLogout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:sVw];

//    _btn_Search.selected = !_btn_Search.selected;
//
//    if (!_btn_Search.selected) {
//
//        [_txt_search resignFirstResponder];
//
//        _view_settings.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, _view_settings.frame.size.width, _view_settings.frame.size.height);
//
//    }
//    else{
//        _GBSliderBubbleView.minValue = 100;
//        [_GBSliderBubbleView renderSliderBubbleView];
//
//        _view_settings.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - _footerView.bounds.size.height - _view_settings.bounds.size.height - 20), _view_settings.frame.size.width, _view_settings.frame.size.height);
//    }
    
    
    
}
-(void)searchAction{
    [sVw removeFromSuperview];
    _GBSliderBubbleView.minValue = 100;
    [_GBSliderBubbleView renderSliderBubbleView];
    
    _view_settings.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - _footerView.bounds.size.height - _view_settings.bounds.size.height - 20), _view_settings.frame.size.width, _view_settings.frame.size.height);
}
-(void)logoutAction{
    [sVw removeFromSuperview];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login logOut];
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setBool:NO forKey:kisLogin];
    [userD synchronize];
    [appDell setLogin];
}
- (IBAction)profileUserButton:(id)sender {
    
    if (playerLayer) {
        [playerLayer.player pause];
    //    [playerLayer removeFromSuperlayer];
    }
    
    if (!isNotification) {
        
        profileFullView *profileFullVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileFullView"];
        //    profileFullVC.arrProfileData = [arrMatchData mutableCopy];
        //    profileFullVC.profileindex = itemIndex;
        profileFullVC.dictProfileData = [arrMatchData objectAtIndex:itemIndex];
        [self.navigationController pushViewController:profileFullVC animated:NO];
    }
    else{
        
        profileFullView *profileFullVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileFullView"];
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictProfile = [userD objectForKey:kuserLikeProfileDetails];
        NSLog(@"dictProfile>>>>>%@",dictProfile);
    
        profileFullVC.dictProfileData = dictProfile;
        [self.navigationController pushViewController:profileFullVC animated:NO];
    }
    
    
  //  [appDell setProfile];
}

- (IBAction)blockUserButton:(id)sender {
    
    blockUserVw = [[BlockUserView alloc] init];
    blockUserVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    blockUserVw.delegate_profileBlock = self;
    [blockUserVw setUpUi];
    [self.view addSubview:blockUserVw];
    
}
// Profile Block Delegate Methods

-(void)profileBlock{
    
    if (!isNotification) {
     
        NSDictionary *dict = [arrMatchData objectAtIndex:itemIndex];
        NSDictionary *dict_basicinfo = [dict objectForKey:@"basic_info"];
        
        NSDictionary *blockedProfile_dict = @{
                                              @"block_user_id":[NSString stringWithFormat:@"%@",[dict_basicinfo objectForKey:@"id"]],
                                              @"user_id" : str_userId,//,@"15"
                                              @"token" : @"adsahtoikng"
                                              };
        
        NSLog(@"blockedProfile_dict>>>><%@",blockedProfile_dict);
        [self blockuserServiceCall:blockedProfile_dict];
    }
    
    else{
        
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictProfile = [userD objectForKey:kuserLikeProfileDetails];
        NSLog(@"dictProfile>>>>>%@",dictProfile);
        NSDictionary *dict_basicinfo = [dictProfile objectForKey:@"basic_info"];
        
        NSDictionary *blockedProfile_dict = @{
                                              @"block_user_id":[NSString stringWithFormat:@"%@",[dict_basicinfo objectForKey:@"id"]],
                                              @"user_id" : str_userId,//,@"15"
                                              @"token" : @"adsahtoikng"
                                              };
        
        NSLog(@"blockedProfile_dict>>>><%@",blockedProfile_dict);
        [self blockuserServiceCall:blockedProfile_dict];
    }
    
}


- (IBAction)reportUserButton:(id)sender {
    
    reportUserVw = [[ReportUserView alloc] init];

    reportUserVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    reportUserVw.delegate_profileReport = self;
    
    [reportUserVw setUpUi];
    
    [self.view addSubview:reportUserVw];
}

// report user profile

-(void)profileReport:(NSString *)strReason{
    
    if (!isNotification) {
        NSDictionary *dict = [arrMatchData objectAtIndex:itemIndex];
        NSDictionary *dict_basicinfo = [dict objectForKey:@"basic_info"];
        
        NSDictionary *reportProfile_dict = @{
                                             @"report_user_id":[NSString stringWithFormat:@"%@",[dict_basicinfo objectForKey:@"id"]],
                                             @"user_id" : str_userId,//,@"15"
                                             @"token" : @"adsahtoikng",
                                             @"description" : strReason
                                             };
        
        NSLog(@"blockedProfile_dict>>>><%@",reportProfile_dict);
        [self reportUserServiceCall:reportProfile_dict];
    }
    else{
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictProfile = [userD objectForKey:kuserLikeProfileDetails];
        NSLog(@"dictProfile>>>>>%@",dictProfile);
        NSDictionary *dict_basicinfo = [dictProfile objectForKey:@"basic_info"];
        
        NSDictionary *reportProfile_dict = @{
                                             @"report_user_id":[NSString stringWithFormat:@"%@",[dict_basicinfo objectForKey:@"id"]],
                                             @"user_id" : str_userId,//,@"15"
                                             @"token" : @"adsahtoikng",
                                             @"description" : strReason
                                             };
        
        NSLog(@"blockedProfile_dict>>>><%@",reportProfile_dict);
        [self reportUserServiceCall:reportProfile_dict];
    }
    
    
}
- (IBAction)profileButton:(id)sender {
//    ProfilePage *profilePageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
//    [self.navigationController pushViewController:profilePageVC animated:NO];
    [appDell setProfile];
}

- (IBAction)chatButton:(id)sender {
//    ChatPage *chatPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatPage"];
//    [self.navigationController pushViewController:chatPageVC animated:NO];
    [appDell setChatPage];
}

- (IBAction)exploreButton:(id)sender {
}

- (IBAction)myMatchesButton:(id)sender {
//    myMatchesPage *myMatchesPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myMatchesPage"];
//    [self.navigationController pushViewController:myMatchesPageVC animated:NO];
    [appDell setMyMatchPage];
}

- (IBAction)notificationButton:(id)sender {
//    notificationPage *notificationPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"notificationPage"];
//    [self.navigationController pushViewController:notificationPageVC animated:NO];
    [appDell setNotificationPage];
}

- (IBAction)btn_heyAction:(id)sender {

    _img_gifLike.hidden = NO;

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"like" withExtension:@"gif"];
    _img_gifLike.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
    [self performSelector:@selector(heyBoyHeyGirl) withObject: nil
               afterDelay:2.0];
    
    _btn_btnNo.userInteractionEnabled = NO;
 //   [self heyBoyHeyGirl];
}

- (IBAction)btn_NoAction:(id)sender {
    
    _img_gifDislike.hidden = NO;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dislike" withExtension:@"gif"];
    _img_gifDislike.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
    [self performSelector:@selector(NoBoyNoGirl) withObject: nil
               afterDelay:5.0];

    _btn_hey.userInteractionEnabled = NO;
  //  [self NoBoyNoGirl];
}

-(void)heyBoyHeyGirl{
    
    _img_gifLike.hidden = YES;
    
    [self likeUnlikeServiceCall:1];


}

-(void)NoBoyNoGirl{
    
    _img_gifDislike.hidden = YES;
    
    [self likeUnlikeServiceCall:0];
}

#pragma mark iCarousel methods

-(void)careosalDataSource{
    
    NSDictionary *dict = [arrMatchData objectAtIndex:itemIndex];
    NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
 //   NSString *str_gender = [dict_basicInfo objectForKey:@"gender"];
    NSString *strCity = [dict_basicInfo objectForKey:@"city"];
    NSString *strCountry = [dict_basicInfo objectForKey:@"country"];
    
    NSString *strName = [dict_basicInfo objectForKey:@"name"];
    NSArray *nameArray = [strName componentsSeparatedByString:@" "];
    NSString *str_fName = [nameArray objectAtIndex:0];
    
    NSString *str_Gender = [dict_basicInfo objectForKey:@"gender"];
    NSString *strGender_firstLetter = [str_Gender substringToIndex:1];
    
    
    
    if ([strGender_firstLetter isEqualToString:@"m"]) {
        
        UIImage *btnImage1 = [UIImage imageNamed:@"hey_boy_symbol.png"];
        UIImage *btnImage2 = [UIImage imageNamed:@"no_boy_symbol.png"];

        [_btn_hey setImage:btnImage1 forState:UIControlStateNormal];
        [_btn_btnNo setImage:btnImage2 forState:UIControlStateNormal];
        
        _lbl_profileDetails.hidden = NO;
        
        if (!strCity.length) {
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"country"]];
        }
        
        else if (!strCountry.length){
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"]];
        }
        
        else{
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
        }

    }
    
    else{
        
        UIImage *btnImage1 = [UIImage imageNamed:@"hey_girl_symbol.png"];
        UIImage *btnImage2 = [UIImage imageNamed:@"no_girl_symbol.png"];
        
        [_btn_hey setImage:btnImage1 forState:UIControlStateNormal];
        [_btn_btnNo setImage:btnImage2 forState:UIControlStateNormal];
        
        if (!strCity.length) {
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"country"]];
        }
        
        else if (!strCountry.length){
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"]];
        }
        
        else{
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
        }
    }
    
    strVideo = [dict_basicInfo objectForKey:@"video"];

    
   // caresuyalArray = [[dict_basicInfo objectForKey:@"image_video"] mutableCopy];
    
    [caresuyalArray removeAllObjects];
    caresuyalArray = nil;
    
    if (strVideo.length) {
        caresuyalArray = [[NSMutableArray arrayWithObject:strVideo] mutableCopy];
    }else{
        strVideo = @"";
        caresuyalArray = [[dict_basicInfo objectForKey:@"image_video"] mutableCopy];
    }
    
    sliderCount1 = 0;
    animationType = 0;
    if (timer) {
        [timer invalidate];
    }
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
    }
    else{
        if (view == nil) {
            NSString *imgpath = [caresuyalArray objectAtIndex:index];
            
            NSLog(@"imagePath >>> %@",imgpath);
            
            UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _vw_imageshow.frame.size.width, _vw_imageshow.frame.size.height)];
            
            [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    imgVw.image = [self squareImageWithImage:image scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, _carousel1.frame.size.height)];
                    imgVw.contentMode = UIViewContentModeScaleAspectFill;
                }
            }];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vw_imageshow.frame.size.width, _vw_imageshow.frame.size.height)];
            view.backgroundColor = [UIColor clearColor];
            imgVw.tag = 101;
            [view addSubview:imgVw];
        }else{
            UIImageView *imgVw = (UIImageView *)[view viewWithTag:101];
            [imgVw sd_setImageWithURL:[NSURL URLWithString:[caresuyalArray objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    imgVw.image = [self squareImageWithImage:image scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, _carousel1.frame.size.height)];
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
    
    if (playerLayer) {
        [playerLayer.player play];
        
    }
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





//*********************************** Match profile Service Call ********************************************

-(void)matchServiceCall{
    
  
    
    NSDictionary *dictForMatch = @{@"user_id":str_userId,//, @"24"str_userId
                                   @"token" :@"adsahtoikng"
                                   };
    
    NSLog(@"dictForMatch>>>>%@",dictForMatch);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Match_URL parameters:dictForMatch progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                arrMatchData = [[responseDict objectForKey:@"data"] mutableCopy];
                
     //           [self careosalDataSource];
                [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
            
                
                if (arrMatchData.count) {
                    _lbl_message.hidden = YES;
                    _view_NoMatch.hidden = YES;
                    _btn_reportProfile.hidden = NO;
                    _btn_BlockProfile.hidden = NO;
                    _btn_ShowProfile.hidden = NO;
                    _HeyBoyNoBoyView.hidden = NO;
                    _btn_hey.userInteractionEnabled = YES;
                    _btn_btnNo.userInteractionEnabled = YES;

                    [self careosalDataSource];
                }
                else{
                    _lbl_message.hidden = NO;
                    _view_NoMatch.hidden = NO;
                    _lbl_profileDetails.hidden = NO;
                    _btn_reportProfile.hidden = YES;
                    _btn_BlockProfile.hidden = YES;
                    _btn_ShowProfile.hidden = YES;
                    _HeyBoyNoBoyView.hidden = YES;
                }
                
//                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
//                [currentDefaults setObject:data forKey:@"kmatchProfileResponseDetails"];
                
                [self DeviceTokenUpdateServiceCall];
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                
                [self DeviceTokenUpdateServiceCall];

                [appDell removeCustomLoader];
                
                
            }
            
            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            //   [appDell stopHUD];
            if (error.code == -1009) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}

//******************************* Like And Unlike Service Call ******************************************

-(void)likeUnlikeServiceCall:(int) status
{
    NSDictionary *dict_basicInfo;
    
    if (!isNotification) {
        NSDictionary *dict = [arrMatchData objectAtIndex:itemIndex];
        dict_basicInfo = [dict objectForKey:@"basic_info"];
    }
    else{
//        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//        NSDictionary *dictProfile = [userD objectForKey:kuserLikeProfileDetails];
//        NSLog(@"dictProfile>>>>>%@",dictProfile);
        
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [currentDefaults objectForKey:@"kuserLikeProfileDetails"];
        NSDictionary *dictProfile = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        
        dict_basicInfo = [dictProfile objectForKey:@"basic_info"];
    }
   
    //    NSString *str_gender = [dict_basicInfo objectForKey:@"gender"];
    
    
    NSDictionary *dictForLike = @{@"user_id":[dict_basicInfo objectForKey:@"id"],//, @"24"str_userId
                                   @"token" :@"adsahtoikng",
                                  @"like_by_user_id":str_userId,//str_userId@"24"
                                  @"is_like": [NSString stringWithFormat:@"%d",status]
                                   };
    
    NSLog(@"dictForMatch>>>>%@",dictForLike);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Like_Unlike_URL parameters:dictForLike progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                
                NSLog(@"strMessage>>>>%@",strMessage);
                
                if (!isNotification) {
                    
                    itemIndex++;
                    
                    _btn_hey.userInteractionEnabled = YES;
                    _btn_btnNo.userInteractionEnabled = YES;
                    
                    
                    if (itemIndex != arrMatchData.count ) {
                        

                        
                        NSDictionary *dict = [arrMatchData objectAtIndex:itemIndex];
                        NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
                    //    NSString *str_gender = [dict_basicInfo objectForKey:@"gender"];
                        NSString *strCity = [dict_basicInfo objectForKey:@"city"];
                        NSString *strCountry = [dict_basicInfo objectForKey:@"country"];
                        
                        NSString *strName = [dict_basicInfo objectForKey:@"name"];
                        NSArray *nameArray = [strName componentsSeparatedByString:@" "];
                        NSString *str_fName = [nameArray objectAtIndex:0];

                        
                        NSString *str_Gender = [dict_basicInfo objectForKey:@"gender"];
                        NSString *strGender_firstLetter = [str_Gender substringToIndex:1];
                        
                        if ([strGender_firstLetter isEqualToString:@"m"]) {
                            
                            UIImage *btnImage1 = [UIImage imageNamed:@"hey_boy_symbol.png"];
                            UIImage *btnImage2 = [UIImage imageNamed:@"no_boy_symbol.png"];
                            
                            [_btn_hey setImage:btnImage1 forState:UIControlStateNormal];
                            [_btn_btnNo setImage:btnImage2 forState:UIControlStateNormal];
                            
                            if (!strCity.length) {
                                
                                _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"country"]];
                            }
                            
                            else if (!strCountry.length){
                                
                                _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"]];
                            }
                            
                            else{
                                
                                _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
                            }
                        }
                        
                        else{
                            
                            UIImage *btnImage1 = [UIImage imageNamed:@"hey_girl_symbol.png"];
                            UIImage *btnImage2 = [UIImage imageNamed:@"no_girl_symbol.png"];
                            
                            [_btn_hey setImage:btnImage1 forState:UIControlStateNormal];
                            [_btn_btnNo setImage:btnImage2 forState:UIControlStateNormal];
                            
                            if (!strCity.length) {
                                
                                _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"country"]];
                            }
                            
                            else if (!strCountry.length){
                                
                                _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"]];
                            }
                            
                            else{
                                
                                _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
                            }
                        }
                        
                        strVideo = [dict_basicInfo objectForKey:@"video"];
                        
                        
                        // caresuyalArray = [[dict_basicInfo objectForKey:@"image_video"] mutableCopy];
                        
                        [caresuyalArray removeAllObjects];
                        caresuyalArray = nil;
                        
                        if (strVideo.length) {
                            caresuyalArray = [[NSMutableArray arrayWithObject:strVideo] mutableCopy];
                        }else{
                            strVideo = @"";
                            caresuyalArray = [[dict_basicInfo objectForKey:@"image_video"] mutableCopy];
                        }
                        if (playerLayer) {
                            [playerLayer.player pause];
                            [playerLayer removeFromSuperlayer];
                        }
                        
                        sliderCount1 = 0;
                        animationType = 0;
                        if (timer) {
                            [timer invalidate];
                        }
                        [self.carousel1 reloadData];
                        timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
                        
                        //             caresuyalArray = [[dict_basicInfo objectForKey:@"image_video"] mutableCopy];
                        //      [_carousel1 reloadData];
                    }
                    
                    else{
                        
                        itemIndex = 0;
                        [caresuyalArray removeAllObjects];
                        [_carousel1 reloadData];
                       // _carousel1.hidden = YES;
                        [timer invalidate];
                        _lbl_message.hidden = NO;
                        _view_NoMatch.hidden = NO;
                        _lbl_profileDetails.hidden = NO;
                        _btn_reportProfile.hidden = YES;
                        _btn_BlockProfile.hidden = YES;
                        _btn_ShowProfile.hidden = YES;
                        _HeyBoyNoBoyView.hidden = YES;
                        _lbl_profileDetails.hidden = YES;
                        
                        if (playerLayer) {
                            [playerLayer.player pause];
                            [playerLayer removeFromSuperlayer];
                        }
                    }
                    
                }
                else{
                    
          //          [appDell setNotificationPage];
                    [appDell setMyMatchPage];
                }
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                
                [appDell removeCustomLoader];
                
                
            }
            
            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            //   [appDell stopHUD];
            if (error.code == -1009) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}


// ******************************* Block/Unblock User Service Call *********************************************

-(void)blockuserServiceCall:(NSDictionary *) dict_blockedProfile{
    
    
    
    NSLog(@"dictForMatch>>>>%@",dict_blockedProfile);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:BlockUser_URL parameters:dict_blockedProfile progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            NSArray *arrData;
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                // [self blockuserlistServiceCall];
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                
                [appDell removeCustomLoader];
                
                
            }
            
            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            //   [appDell stopHUD];
            if (error.code == -1009) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}

//*************************************** Report User Service Call *********************************************

-(void)reportUserServiceCall:(NSDictionary *) dictForReport
{
    NSLog(@"dictForMatch>>>>%@",dictForReport);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:ReportUser_URL parameters:dictForReport progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            //     NSArray *arrData;
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                // [self blockuserlistServiceCall];
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                
                [appDell removeCustomLoader];
                
                
            }
            
            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            //   [appDell stopHUD];
            if (error.code == -1009) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
}

//******************************************** Search *******************************************


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self makeViewUpper];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self makeViewLower];
    [_txt_search resignFirstResponder];
    
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if([string isEqualToString:@"\n"])
//        return YES;
//    
//    if(range.length==1)
//    {
//        NSLog(@"Delete %@",strSearchVal);
//        
//        if ( [strSearchVal length] > 0)
//        {
//            strSearchVal = [strSearchVal substringToIndex:[strSearchVal length] - 1];
//        }
//        
//    }
//    else
//    {
//        strSearchVal=[textField.text stringByAppendingString:string];
//        
//    }
//    [self search];
//    [self.table_match reloadData];
//    return YES;
//    
//}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self makeViewLower];
}

-(void)makeViewUpper{
    CGRect frameView = self.view_settings.frame;
    frameView.origin.y = 185;//_view_settings.frame.origin.y - 230
    
    [UIView animateWithDuration:0.1 animations:^{
        self.view_settings.frame = frameView;
    } completion:^(BOOL done) {
        
    }];
}

-(void)makeViewLower{
    CGRect frameView = self.view_settings.frame;
    frameView.origin.y = ([UIScreen mainScreen].bounds.size.height - _footerView.bounds.size.height - _view_settings.bounds.size.height - 20);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.view_settings.frame = frameView;
    } completion:^(BOOL done) {
        
    }];
}
- (IBAction)btnSearchAction:(id)sender {

    [_txt_search resignFirstResponder];
    
    if (_txt_search.text.length) {
        
        [timer invalidate];
        
        
        NSString *string = _txt_search.text ;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSLog(@"trimmedString>>>>%@",trimmedString);
        
        [self searchProfileByKeyWordsServiceCall:trimmedString];
        
        _txt_search.text = @"";

    }
    
    else{
        [self findMatchesbyradius:value_radius];
    }
}
- (IBAction)btnCancelAction:(id)sender {
    
    _txt_search.text = @"";
    _view_settings.frame = CGRectMake(0, 800, _view_settings.frame.size.width, _view_settings.frame.size.height);
    
    
}

-(void)searchProfileByKeyWordsServiceCall:(NSString *) strText{
    
    NSDictionary *dictForSearch = @{@"user_id":str_userId,//, @"24"str_userId
                                   @"token" :@"adsahtoikng",
                                   @"text" : strText
                                   };
    
    NSLog(@"dictForSearch>>>>%@",dictForSearch);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Mtchesbykeyword_URL parameters:dictForSearch progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                [appDell removeCustomLoader];

                [arrMatchData removeAllObjects];
                arrMatchData = [[responseDict objectForKey:@"data"] mutableCopy];
                
                //           [self careosalDataSource];
                
                NSLog(@"%@",strMessage);
            
                if (arrMatchData.count) {
                    _lbl_message.hidden = YES;
                    _view_NoMatch.hidden = YES;
                    _carousel1.hidden = NO;

                    _btn_reportProfile.hidden = NO;
                    _btn_BlockProfile.hidden = NO;
                    _btn_ShowProfile.hidden = NO;
                    _HeyBoyNoBoyView.hidden = NO;
                    _btn_hey.userInteractionEnabled = YES;
                    _btn_btnNo.userInteractionEnabled = YES;
                    
                    _view_settings.frame = CGRectMake(0, 800, _view_settings.frame.size.width, _view_settings.frame.size.height);
                    
                    [self careosalDataSource];
                }
                else{
                    _lbl_message.hidden = NO;
                    _view_NoMatch.hidden = YES;
                    _carousel1.hidden = YES;

                    _btn_reportProfile.hidden = YES;
                    _btn_BlockProfile.hidden = YES;
                    _btn_ShowProfile.hidden = YES;
                    _HeyBoyNoBoyView.hidden = YES;
                }
                
                //                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                //                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
                //                [currentDefaults setObject:data forKey:@"kmatchProfileResponseDetails"];
                
                
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                
                [appDell removeCustomLoader];
                
                
            }
            
            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            //   [appDell stopHUD];
            if (error.code == -1009) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}


//***************************** GB Slider ***************************************

#pragma mark -
#pragma mark - GBSliderBubbleViewDelegate
-(void)getSliderDidEndChangeValue:(NSInteger)value{
    NSLog(@"didEndChanged - %ld",value);
    
    value_radius = (int)value;
   // [self findMatchesbyradius:(int)value];
}

-(void)getSliderDidChangeValue:(NSInteger)value{
    NSLog(@"didChanged - %ld",value);
}



-(void)findMatchesbyradius:(int) radiusV{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLocationDict = [userD objectForKey:kuserLocation];
    NSLog(@"userLocationDict>>>>%@",userLocationDict);
    
    NSDictionary *latLongDict = @{@"user_id" : str_userId,
                                  @"token" : @"adsahtoikng",
                                  @"lat" : [userLocationDict valueForKey:@"latitude"],
                                  @"long" : [userLocationDict valueForKey:@"longitude"],
                                  @"radius":[NSString stringWithFormat:@"%d",radiusV]
                                  };
    
    NSLog(@"latLongDict>>>>%@",latLongDict);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Matchesbyradius_URL parameters:latLongDict progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            //      NSDictionary *resultDict = [responseDict objectForKey:@"basic_info"];
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
           
            NSLog(@"responseDict >> %@",responseDict);
            
            if ([strStatus intValue] == 1){
                [appDell removeCustomLoader];

                [arrMatchData removeAllObjects];
                
                arrMatchData = [[responseDict objectForKey:@"data"] mutableCopy];
                
                //           [self careosalDataSource];
                
                NSLog(@"%@",strMessage);
                
                
                if (arrMatchData.count) {
                    _lbl_message.hidden = YES;
                    _view_NoMatch.hidden = YES;
                    _lbl_profileDetails.hidden = NO;

                    _btn_reportProfile.hidden = NO;
                    _btn_BlockProfile.hidden = NO;
                    _btn_ShowProfile.hidden = NO;
                    _HeyBoyNoBoyView.hidden = NO;
                    _btn_hey.userInteractionEnabled = YES;
                    _btn_btnNo.userInteractionEnabled = YES;
                    
                    _view_settings.frame = CGRectMake(0, 800, _view_settings.frame.size.width, _view_settings.frame.size.height);
                    
                    [self careosalDataSource];
                }
                else{
                    _lbl_message.hidden = NO;
                    _view_NoMatch.hidden = YES;
                    _btn_reportProfile.hidden = YES;
                    _btn_BlockProfile.hidden = YES;
                    _btn_ShowProfile.hidden = YES;
                    _HeyBoyNoBoyView.hidden = YES;
                }
                
                
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                [appDell removeCustomLoader];
                
                
            }
            
            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            //   [appDell stopHUD];
            if (error.code == -1009) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
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


// ProfileLike Notification Call

-(void)profileLikeNotificationCall{
    
    appDell.islikeNotification = NO;
    isNotification = YES;
    _lbl_message.hidden = YES;
    _view_NoMatch.hidden = YES;
    _btn_Settings.hidden = YES;
    _btn_reportProfile.hidden = NO;
    _btn_BlockProfile.hidden = NO;
    _btn_ShowProfile.hidden = NO;
    _HeyBoyNoBoyView.hidden = NO;
    _btn_hey.userInteractionEnabled = YES;
    _btn_btnNo.userInteractionEnabled = YES;
    
    
//    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dictProfile = [userD objectForKey:kuserLikeProfileDetails];
//    NSLog(@"dictProfile>>>>>%@",dictProfile);
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];    
    NSData *data = [currentDefaults objectForKey:@"kuserLikeProfileDetails"];
    NSDictionary *dictProfile = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSDictionary *dict_basicInfo = [dictProfile objectForKey:@"basic_info"];
    NSString *str_gender = [dict_basicInfo objectForKey:@"gender"];
    NSString *strCity = [dict_basicInfo objectForKey:@"city"];
    NSString *strCountry = [dict_basicInfo objectForKey:@"country"];
    
    NSString *strName = [dict_basicInfo objectForKey:@"name"];
    NSArray *nameArray = [strName componentsSeparatedByString:@" "];
    NSString *str_fName = [nameArray objectAtIndex:0];
    
    if ([str_gender isEqualToString:@"m"]) {
        
        UIImage *btnImage1 = [UIImage imageNamed:@"hey_boy_symbol.png"];
        UIImage *btnImage2 = [UIImage imageNamed:@"no_boy_symbol.png"];
        
        [_btn_hey setImage:btnImage1 forState:UIControlStateNormal];
        [_btn_btnNo setImage:btnImage2 forState:UIControlStateNormal];
        
        
        if (!strCity.length) {
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"country"]];
        }
        
        else if (!strCountry.length){
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"]];
        }
        
        else{
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
        }
        
    }
    
    else{
        
        UIImage *btnImage1 = [UIImage imageNamed:@"hey_girl_symbol.png"];
        UIImage *btnImage2 = [UIImage imageNamed:@"no_girl_symbol.png"];
        
        [_btn_hey setImage:btnImage1 forState:UIControlStateNormal];
        [_btn_btnNo setImage:btnImage2 forState:UIControlStateNormal];
        
        if (!strCity.length) {
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"country"]];
        }
        
        else if (!strCountry.length){
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"]];
        }
        
        else{
            
            _lbl_profileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
        }
    }
    
    strVideo = [dict_basicInfo objectForKey:@"video"];
    
    
    // caresuyalArray = [[dict_basicInfo objectForKey:@"image_video"] mutableCopy];
    
    
    [caresuyalArray removeAllObjects];
    caresuyalArray = nil;
    
    if (strVideo.length) {
        caresuyalArray = [NSMutableArray arrayWithObject:strVideo];
    }else{
        strVideo = @"";
        caresuyalArray = [dict_basicInfo objectForKey:@"image_video"];
    }
    
    sliderCount1 = 0;
    animationType = 0;
    if (timer) {
        [timer invalidate];
    }
    [self.carousel1 reloadData];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];

}


-(void)DeviceTokenUpdateServiceCall{
    
//    NSDictionary *dictUpdateToken = @{@"user_id":str_userId,
//                                      @"token":@"adsahtoikng",
//                                      @"device_token":deviceIdStr,
//                                      @"device_type":@"ios"
//                                      };
    
    NSDictionary *dictUpdateToken = @{@"user_id":str_userId,
                                      @"token":@"adsahtoikng",
                                      @"device_token":deviceIdStr
                                      };
    
    NSLog(@"dictUpdateToken>>>>%@",dictUpdateToken);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Updatedevicetoken_URL parameters:dictUpdateToken progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
            //    [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                
                
                
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
           //     [appDell removeCustomLoader];
                
                
            }
            
            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            //   [appDell stopHUD];
            if (error.code == -1009) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}

@end
