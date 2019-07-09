//
//  ProfilePage.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 17/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "ProfilePage.h"
#import "ChatPage.h"
#import "explorePage.h"
#import "myMatchesPage.h"
#import "notificationPage.h"
#import "FullScreenPlay.h"
#import "facebookImageGallery.h"
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "ImagesSelectionView.h"
#import "AppDelegate.h"
#import "CustomViewForProfile.h"
#import "InterestCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CommonHeaderFile.h"
#import "ImageViewForInterest.h"
#import <sqlite3.h>
#import <AFHTTPSessionManager.h>
#import <CoreLocation/CoreLocation.h>
#import "NewImageSelectionView.h"
#import "ViewForGalleryVideo.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoEditingViewController.h"
#import "GoogleImageViewController.h"

//ARUN
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"
#import "DefaultImageVideoView.h"

#define INSTAGRAM_AUTHURL                    @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                     @"https://api.instagram.com/v1/users/"
//#define INSTAGRAM_CLIENT_ID                  @"83e6164bc00f4f87b66f8d9947464b06"
//#define INSTAGRAM_CLIENTSERCRET              @"359bfaa799d64dc2b9bcb30beaf07cd9"
//#define INSTAGRAM_REDIRECT_URI               @"http://www.sketchwebsolutions.com"
#define INSTAGRAM_CLIENT_ID                  @"6cdc2067fd624c53a14df519f7e25893"
#define INSTAGRAM_CLIENTSERCRET              @"c6e25ac9d3904f4bbe781641883dab37"
#define INSTAGRAM_REDIRECT_URI               @"http://heyboyheygirl.co/"
#define INSTAGRAM_ACCESS_TOKEN               @"access_token"
#define INSTAGRAM_SCOPE                      @"likes+comments+relationships"


@interface ProfilePage ()<selectionDelegate,customViewForProfileDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,newSelectionDelegate,videoSelectionDelegate,fbImageDelegate,defaultVideoDelegate,CLLocationManagerDelegate,videoTrimmingDelegate>
{
    
    NSMutableDictionary *dictForInstagram;
    
    int saveEdit;
    ImagesSelectionView *imageSelectionVw;
    double screenHeight,screenWidth;
    AppDelegate *appDell;
    
    NSString *str_userId;
    
    float height_cell;
    NSTimer *timer;
    int timerIndex;
    NSDictionary *cellDetailsDict;
  //  int cellTapIndex;
   // CustomViewForProfile *customVw;
    
    NSMutableArray *arrImagePath,*arrInstagram,*profilePicUrlArrayFB;
    float width;
    NSTimer *timer1,*timer2,*timer3;
    
    //Sqlite
    sqlite3 *myDB;
    NSString *dbpath;
    int imageIndex_firstVw;
    int imageIndex_secondVw;
    int imageIndex_thirdVw;
    
    NSArray *foodArray;
    NSArray *musicArray;
    NSArray *interestArray;
    
    NSArray *arrImage1,*arrImage2,*arrImage3;
    
    NewImageSelectionView *newImageSelectionVw;
    ViewForGalleryVideo *galleryVw;
    NSMutableArray *imagesArrayForGallery;

    int imgView_no;
    
    NSArray *arrAnimationType,*caresuyalArray,*caresuyalArray1,*caresuyalArray2;
    int sliderCount1,sliderCount2,sliderCount3;
    
    UIWebView *loginWebView;
    NSString *typeOfAuthentication;
    BOOL isUpper;
    
    NSString *strVideo1,*strVideo2,*strVideo3;
    
    AVPlayerLayer *playerLayer1,*playerLayer2,*playerLayer3;
    AVPlayer *player;
    
    // find Latitude & Longitude
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocationManager *locationManager;
    NSString *str_latitude,*str_longitude,*str_area,*str_country;
    
    NSString *deviceIdStr;
    BOOL isvideoGallery;NSString *strVideo;
    BOOL isCameraForPicture;
    
    NSData *videoDataForService;
    
    
    BOOL isGalleryUpper,isCameraUpper,isGalleryLower,isCameraLower;
}
//Header
@property (strong, nonatomic) IBOutlet UILabel *userDetailsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userGenderImageVw;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

//Middle
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIView *rightView;

@property (strong, nonatomic) IBOutlet UIButton *leftEditButton;
@property (strong, nonatomic) IBOutlet UIButton *middleEditButton;
@property (strong, nonatomic) IBOutlet UIButton *rightEditButton;

@property (strong, nonatomic) IBOutlet UIButton *EatsButton;
@property (strong, nonatomic) IBOutlet UIButton *LovesButton;
@property (strong, nonatomic) IBOutlet UIButton *ListensButton;

//Scrolling view

@property (strong, nonatomic) IBOutlet UIScrollView *pageScrollVw;

//Footer
@property (strong, nonatomic) IBOutlet UIButton *profileFooterButton;
@property (strong, nonatomic) IBOutlet UIButton *chatFooterButton;

- (IBAction)profileButton:(id)sender;
- (IBAction)chatButton:(id)sender;
- (IBAction)exploreButton:(id)sender;
- (IBAction)myMatchesButton:(id)sender;
- (IBAction)notificationButton:(id)sender;

@end
static int animationType = 0;
static int animationType1 = 0;
static int animationType2 = 0;

@implementation ProfilePage

- (void)viewDidLoad {
    [super viewDidLoad];

    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _vw_back.hidden = YES;

  //  [appDell showCustomLoader:self.view text:@"testing"];
    
    deviceIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenKey"];
    if (deviceIdStr.length == 0) {
        deviceIdStr = @"070e17fa62b2bc514f9e89e69db7d015f98582a60b4a1db11b1b4bd899a01c5e";
    }

    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    screenWidth = [[UIScreen mainScreen] bounds].size.width;

//    _leftView.frame = CGRectMake(0,14, screenWidth/3, _leftView.frame.size.height);
//    _middleView.frame= CGRectMake(_leftView.frame.size.width, 0, screenWidth/3, _middleView.frame.size.height);
//    _rightView.frame= CGRectMake(_leftView.frame.size.width + _middleView.frame.size.width, 14, screenWidth/3, _rightView.frame.size.height);
    
    
    self.saveButton.layer.borderWidth = 1.0f;
    self.saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [[self.saveButton layer] setCornerRadius:5.0f];
    [[self.saveButton layer] setMasksToBounds:YES];
    
    [_interest_collectionVw registerNib:[UINib nibWithNibName:@"InterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"InterestCollectionViewCell"];
    
    _interest_collectionVw.delegate = self;
    _interest_collectionVw.dataSource = self;
    
    // ************ For caresoyel ************************
    
    arrAnimationType = [NSArray arrayWithObjects:@"1",@"9",@"10", nil];//@"5",@"6",@"9",@"1",@"10",@"5",@"6",//@"1",@"9",@"10",
    caresuyalArray = [NSArray array];
    self.carousel_middle.delegate = self;
    self.carousel_middle.dataSource = self;
    
    caresuyalArray1 = [NSArray array];
    self.carousel_left.delegate = self;
    self.carousel_left.dataSource = self;
    
    caresuyalArray2 = [NSArray array];
    self.carousel_right.delegate = self;
    self.carousel_right.dataSource = self;
    
    
    [self.saveButton addTarget:self action:@selector(saveBtnClick)forControlEvents:UIControlEventTouchUpInside];
    
    if (appDell.isSaveModeOn) {
        saveEdit = 1;
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.leftEditButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [self.middleEditButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [self.rightEditButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        appDell.isSaveModeOn = NO;
    }
    else{
        
        saveEdit = 0;
        [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.leftEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
        [self.middleEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
        [self.rightEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];

    }
    
//    saveEdit = 0;
//    [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
//    [self.leftEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
//    [self.middleEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
//    [self.rightEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];

   // [self startTimer];
    
    [self.EatsButton addTarget:self action:@selector(EatsBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self.LovesButton addTarget:self action:@selector(LovesBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self.ListensButton addTarget:self action:@selector(ListenBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.leftEditButton addTarget:self action:@selector(leftEditBtnClick)forControlEvents:UIControlEventTouchUpInside];
    [self.middleEditButton addTarget:self action:@selector(middleEditBtnClick)forControlEvents:UIControlEventTouchUpInside];
    [self.rightEditButton addTarget:self action:@selector(rightEditBtnClick)forControlEvents:UIControlEventTouchUpInside];

    [self.EatsButton setSelected:YES];
    [self.LovesButton setSelected:NO];
    [self.ListensButton setSelected:NO];
    
    imagesArrayForGallery = [[NSMutableArray alloc] init];
    arrInstagram = [[NSMutableArray alloc] init];
    profilePicUrlArrayFB = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    str_userId = [userD objectForKey:khbhgUserId];
    NSLog(@"str_userId>>>>>%@",str_userId);

    imageIndex_firstVw = 0;
    imageIndex_secondVw = 0;
    imageIndex_thirdVw = 0;
    arrImagePath = [[NSMutableArray alloc] init];
    
    [self startTimer];
    [self fetchDataFromUserMaster];
    [self showingUserData];
  //  [self getDataServiceCall];
    
    if (appDell.isFirstTimeAppearinProfile == NO) {
        
//        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//        NSDictionary *dict = [userD objectForKey:kuserDetails];
//
//        NSLog(@"dict>>>>>%@",dict);
//
//        foodArray = [dict objectForKey:@"food_data"];
//        musicArray = [dict objectForKey:@"music_data"];
//        interestArray = [dict objectForKey:@"interest_data"];
//
//        NSDictionary *besic_infoDict = [dict objectForKey:@"basic_info"];
//
//        arrImage1 = [besic_infoDict objectForKey:@"image_video"];
//        arrImage2 = [besic_infoDict objectForKey:@"second_image_video"];
//        arrImage3 = [besic_infoDict objectForKey:@"third_image_video"];
//
//        [self careosalDataSource];
        
        [self updateUserLatitudeLongitudeServiceCall];
    }
    else{
        
     //   [self updateUserLatitudeLongitudeServiceCall];

    
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [userD objectForKey:kuserDetails];
        NSString *strGender = [userD objectForKey:khbhgUserGender];
        NSLog(@"dict>>>>>%@",dict);
        NSLog(@"dict>>>>>%@",strGender);

        foodArray = [dict objectForKey:@"food_data"];
        musicArray = [dict objectForKey:@"music_data"];
        interestArray = [dict objectForKey:@"interest_data"];
        
        NSDictionary *besic_infoDict = [dict objectForKey:@"basic_info"];
        
//        arrImage1 = [besic_infoDict objectForKey:@"image_video"];
//        arrImage2 = [besic_infoDict objectForKey:@"second_image_video"];
//        arrImage3 = [besic_infoDict objectForKey:@"third_image_video"];
        
        strVideo1 = [besic_infoDict objectForKey:@"video"];
        strVideo2 = [besic_infoDict objectForKey:@"second_video"];
        strVideo3 = [besic_infoDict objectForKey:@"third_video"];
        
        if(strVideo1.length){
            
            arrImage1 = [NSArray arrayWithObject:strVideo1];
        }
        else{
            
            arrImage1 = [besic_infoDict objectForKey:@"image_video"];
        }
        if (strVideo2.length) {
            
            arrImage2 = [NSArray arrayWithObject:strVideo2];
            
        }
        else{
            
            arrImage2 = [besic_infoDict objectForKey:@"second_image_video"];
            
        }
        
        if (strVideo3.length) {
            
            arrImage3 = [NSArray arrayWithObject:strVideo3];
            
        }
        
        else{
            
            arrImage3 = [besic_infoDict objectForKey:@"third_image_video"];
            
        }
        
        
        
        
        NSString *str_orientation = [besic_infoDict objectForKey:@"sexual_orientation"];
      //  NSString *str_gender = [besic_infoDict valueForKey:@"gender"];
      //  NSString *strGender_firstLetter = [str_gender substringToIndex:1];
        
        [self careosalDataSource];
        
        
        if ([str_orientation isEqualToString:@"Straight"])   {
            
            if ([strGender isEqualToString:@"m" ]) {
                
                _userGenderImageVw.image = [UIImage imageNamed:@"straight_male_w"];
                
                //     _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Male",str_homeTown];
            }
            else{
                
                _userGenderImageVw.image = [UIImage imageNamed:@"straight_female_w"];
                
                //    _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Female",str_homeTown];
            }
            
        }
        
        
        else if ([str_orientation isEqualToString:@"Gay"])  {
            
            
            if ([strGender isEqualToString:@"m" ]) {
                
                _userGenderImageVw.image = [UIImage imageNamed:@"gay_w"];
                
                //     _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Male",str_homeTown];
                
            }
            
            else{
                
                _userGenderImageVw.image = [UIImage imageNamed:@"lesbian_w@3x"];
                
                //      _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Female",str_homeTown];
                
            }
        }
        
        else if ([str_orientation isEqualToString:@"Bisexual"])  {
            
            if ([strGender isEqualToString:@"m"]) {
                _userGenderImageVw.image = [UIImage imageNamed:@"bisexual_male_w"];
                
                //    _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Male",str_homeTown];
            }
            
            else{
                
                _userGenderImageVw.image = [UIImage imageNamed:@"bisexual_female_w"];
                
                //      _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Female",str_homeTown];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                
            case 1136:
            {
                
                printf("iPhone 5 or 5S or 5C");
                break;

            }
            case 1334:
            {
                printf("iPhone 6/6S/7/8");
                break;

            }
            case 2208:
            {
                printf("iPhone 6+/6S+/7+/8+");
                break;

            }
            case 2436:
            {
                printf("iPhone X");
                break;
            }
            default:
            {
                printf("unknown");
            }
        }
    }
    
    
    
}

// showingUserdata

-(void)showingUserData{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    BOOL loginType = [userD boolForKey:kSocialType];
    
    if(loginType){
        NSDictionary *dict = [userD objectForKey:kFBLoginData];
        NSDictionary *dictLocation = [userD objectForKey:kuserLocation];
        
        NSLog(@"dict>>>>%@",dict);
        
        NSString *str_orientation = [dict objectForKey:@"sexual_orientation"];
        NSString *str_name = [dict valueForKey:@"first_name"];
        NSString *str_gender = [userD objectForKey:khbhgUserGender];
     //   NSString *strGender_firstLetter = [str_gender substringToIndex:1];

        NSString *Dob = [dict valueForKey:@"birthday"];
        // NSDictionary *homeTownDict = [dict valueForKey:@"hometown"];
        NSString *str_homeTown = [dictLocation valueForKey:@"area"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *startD = [dateFormatter dateFromString:Dob];
        NSDate *endD = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
        
        NSInteger year  = [components year];
        //   NSInteger month  = [components month];
        //   NSInteger day  = [components day];
        
        NSString  *age = [NSString stringWithFormat:@"%li",(long)year];
        
        
        if ([str_gender isEqualToString:@"m"]) {

            _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Male",str_homeTown];

        }

        else{

            _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Female",str_homeTown];
        }
        

        
    }
    
    else{
        
     //   NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [userD objectForKey:kinstaProfileDetails];
        NSDictionary *dictLocation = [userD objectForKey:kuserLocation];
        
        NSLog(@"dict>>>>%@",dict);
        
  //      NSString *str = [dict_instagram valueForKey:@"userName"];
        NSString *str_name = [dict valueForKey:@"name"];
        NSArray *arr = [str_name componentsSeparatedByString:@" "];
        NSString *str_fname = [arr objectAtIndex:0];
        
        NSString *str_orientation = [dict objectForKey:@"sexual_orientation"];
        NSString *str_gender = [dict valueForKey:@"gender"];
        NSString *strGender_firstLetter = [str_gender substringToIndex:1];

        NSString *Dob = [dict valueForKey:@"dob"];
        // NSDictionary *homeTownDict = [dict valueForKey:@"hometown"];
        NSString *str_homeTown = [dictLocation valueForKey:@"area"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *startD = [dateFormatter dateFromString:Dob];
        NSDate *endD = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
        
        NSInteger year  = [components year];
        //   NSInteger month  = [components month];
        //   NSInteger day  = [components day];
        
        NSString  *age = [NSString stringWithFormat:@"%li",(long)year];
        
        

        if ([strGender_firstLetter isEqualToString:@"m"]) {

            _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Male",str_homeTown];
        }

        else{

            _userDetailsLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_name,age,@"Female",str_homeTown];
        }
        

        
    }
    
   
}





//*****************************************************************************
// BUTTON EATS LOVE AND MUSIC SETUP

-(void)EatsBtnClick:(UIButton*)sender
{
    timerIndex = (int)sender.tag;
    
    [self.EatsButton setSelected:YES];
    [self.LovesButton setSelected:NO];
    [self.ListensButton setSelected:NO];


    if ([UIScreen mainScreen].bounds.size.width == 320) {
        _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);

    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);

    }
    
    else if ([UIScreen mainScreen].bounds.size.width == 414){
        _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
    }
    else{
        _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);

    }

}

-(void)LovesBtnClick:(UIButton*)sender
{
    timerIndex = (int)sender.tag;

    [self.EatsButton setSelected:NO];
    [self.LovesButton setSelected:YES];
    [self.ListensButton setSelected:NO];
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);

    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);

    }
    else if ([UIScreen mainScreen].bounds.size.width == 414){
        _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
        
    }
    else{
        _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
    }

}


-(void)ListenBtnClick:(UIButton*)sender
{
    timerIndex = (int)sender.tag;

    [self.EatsButton setSelected:NO];
    [self.LovesButton setSelected:NO];
    [self.ListensButton setSelected:YES];
    
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);

    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);

    }
    else if ([UIScreen mainScreen].bounds.size.width == 414){
        _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);
    }
    else{
        _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);

    }


}
//*********************************************************************************************


//********************************BUTTON SEAV AND EDIT ************************************************

-(void)saveBtnClick
{
    if (saveEdit == 0)
    {
        saveEdit = 1;
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.leftEditButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [self.middleEditButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [self.rightEditButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [timer invalidate];
         timer = nil;
    }
    else
    {
       // imgView_no = 0;
        saveEdit = 0;
        [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.leftEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
        [self.middleEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
        [self.rightEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
        [self startTimer];
    }
}

//******************************************************************************************************

//*******************************BUTTON LEFT RIGHT AND MIDDLE TAPED ACTION*******************************
-(void)leftEditBtnClick
{
    if (saveEdit == 1)
    {
        [self showNewImageSelectionVW];
        
        imgView_no = 2;
    }
    else
    {
        FullScreenPlay *FullScreenPlayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenPlay"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:FullScreenPlayVC];
//        if(caresuyalArray1.count == 1){
        if(strVideo2.length){
            FullScreenPlayVC.isVideoString = YES;
   //         [FullScreenPlayVC.arr_images addObject:strVideo2];
        }
        else{
           
            FullScreenPlayVC.isVideoString = NO;
            
        }
        
         FullScreenPlayVC.arr_images = [caresuyalArray1 mutableCopy];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

-(void)middleEditBtnClick
{
    if (saveEdit == 1)
    {
        [self showNewImageSelectionVW];
        imgView_no = 1;

    }
    else
    {
        FullScreenPlay *FullScreenPlayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenPlay"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:FullScreenPlayVC];
        
  //      if(caresuyalArray.count == 1){
        
        if (strVideo1.length){
            FullScreenPlayVC.isVideoString = YES;
            //         [FullScreenPlayVC.arr_images addObject:strVideo2];
        }
        else{
            
            FullScreenPlayVC.isVideoString = NO;
            
        }
            FullScreenPlayVC.arr_images = [caresuyalArray mutableCopy];

        

        [self presentViewController:navigationController animated:YES completion:nil];
    }
}


-(void)rightEditBtnClick
{
    if (saveEdit == 1)
    {
        [self showNewImageSelectionVW];
        imgView_no = 3;

    }
    else
    {
        FullScreenPlay *FullScreenPlayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenPlay"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:FullScreenPlayVC];
        
 //       if(caresuyalArray2.count == 1){
        if(strVideo2.length){
            FullScreenPlayVC.isVideoString = YES;
            //         [FullScreenPlayVC.arr_images addObject:strVideo2];
        }
        else{
            
            FullScreenPlayVC.isVideoString = NO;
            
        }
            FullScreenPlayVC.arr_images = [caresuyalArray2 mutableCopy];

        

        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
}

//****************************************************************************************************

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ***************************************    FOOTERVIEW    ******************************************

- (IBAction)profileButton:(id)sender {
    
}

- (IBAction)chatButton:(id)sender {
    
    if (playerLayer1) {
        [playerLayer1.player pause];
        [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
        [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
        [playerLayer3 removeFromSuperlayer];
    }
    [appDell setChatPage];
}

- (IBAction)exploreButton:(id)sender {
    
    if (playerLayer1) {
        [playerLayer1.player pause];
        [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
        [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
        [playerLayer3 removeFromSuperlayer];
    }
    [appDell setExplorePage];
}

- (IBAction)myMatchesButton:(id)sender {
    
    if (playerLayer1) {
        [playerLayer1.player pause];
        [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
        [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
        [playerLayer3 removeFromSuperlayer];
    }
    [appDell setMyMatchPage];
}

- (IBAction)notificationButton:(id)sender {

    if (playerLayer1) {
        [playerLayer1.player pause];
        [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
        [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
        [playerLayer3 removeFromSuperlayer];
    }
    [appDell setNotificationPage];
}
// *************************************************************************

//**********************************  IMAGE SELECTION VIEW (OLD)    *****************************************

-(void)showImageSelectionView
{
    if (saveEdit == 1) {
        
        appDell.isSaveModeOn = YES;
    }
    
    imageSelectionVw = [[ImagesSelectionView alloc] init];
    imageSelectionVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [imageSelectionVw setUpUi];
    imageSelectionVw.delegate_selection = self;
    [self.view addSubview:imageSelectionVw];
    
}

#pragma marks - Selection delegate methods

-(void)faceBookAction
{
    if (playerLayer1) {
        [playerLayer1.player pause];
    //    [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
     //   [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
     //   [playerLayer3 removeFromSuperlayer];
    }
    
    if (!appDell.isFbSelect) {
        
        isUpper = NO;

        [self faceBookLogin];
    }
    else{
       
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [currentDefaults objectForKey:@"kfbpicArray"];
        NSMutableArray *arrFb = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"arrFb>>>>%@",arrFb);
        
        facebookImageGallery *facebookImageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"facebookImageGallery"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:facebookImageGalleryVC];
        facebookImageGalleryVC.cellDictionary = cellDetailsDict;
        facebookImageGalleryVC.fbSelect = YES;
        facebookImageGalleryVC.arr_fb = [arrFb mutableCopy];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
}

-(void)instragramAction
{
    if (playerLayer1) {
        [playerLayer1.player pause];
      //  [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
      //  [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
      //  [playerLayer3 removeFromSuperlayer];
    }
    
    
    isUpper = NO;
    

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"NS_tokenId"];
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"NS_userId"];
    
    if (accessToken.length && userIdStr.length) {
        [self photoAndVideoAccessForInstagramForEdit];
    }else{
        
        _vw_back.hidden = NO;

        loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, _vw_back.frame.size.height - 60)];
        //self.LoginWebView.hidden = NO;
        loginWebView.backgroundColor = [UIColor whiteColor];
        NSString* authURL = nil;
        
        if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
        {
            authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                       INSTAGRAM_AUTHURL,
                       INSTAGRAM_CLIENT_ID,
                       INSTAGRAM_REDIRECT_URI,
                       INSTAGRAM_SCOPE];
            
        }
        else
        {
            authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                       INSTAGRAM_AUTHURL,
                       INSTAGRAM_CLIENT_ID,
                       INSTAGRAM_REDIRECT_URI,
                       INSTAGRAM_SCOPE];
        }
        
        [self.vw_back addSubview:loginWebView];
        //  loginIndicator.hidden = NO;
        [self.view bringSubviewToFront:loginWebView];
        [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
        [loginWebView setDelegate:(id)self];
    }
    
}


-(void)galleryAction
{
    if (playerLayer1) {
        [playerLayer1.player pause];
      //  [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
       // [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
       // [playerLayer3 removeFromSuperlayer];
    }
    
    isGalleryLower = YES;
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = (id)self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:nil];

    [self launchController];
}

- (void)cameraAction{
    
    if (playerLayer1) {
        [playerLayer1.player pause];
      //  [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
      //  [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
      //  [playerLayer3 removeFromSuperlayer];
    }
    
  //  isCameraForPicture = YES;
    
    isCameraLower =YES;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
   // picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)googleImageSearchAction{
    
    GoogleImageViewController *googleImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GoogleImageViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:googleImageVC];
    googleImageVC.cellDictionary = cellDetailsDict;
//    facebookImageGalleryVC.fbSelect = YES;
//    facebookImageGalleryVC.arr_fb = [arrFb mutableCopy];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//
////    NSURL *imageurl  = [info objectForKey: UIImagePickerControllerOriginalImage];
////
////    NSMutableArray *arr = [[NSMutableArray alloc] init];
//
//    //[arr addObject:imageurl];
//
//    [self showImageInterestViewFromCellInfo:cellDetailsDict image:[info objectForKey: UIImagePickerControllerOriginalImage]];
////    NSMutableArray *arr;
////    arr = [[NSMutableArray alloc] init];
////    [arr addObject:imageurl];
////    [self showImageInterestViewFrom:arr CellNo:cellTapIndex];
//    // output image
//   // UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//
//}

//************************************************************************************************************

//**************************************** Image Selection View (New)***************************************

-(void)showNewImageSelectionVW{
    
    newImageSelectionVw = [[NewImageSelectionView alloc] init];
    newImageSelectionVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [newImageSelectionVw setUpUi];
    newImageSelectionVw.delegate_newSelection = self;
    [self.view addSubview:newImageSelectionVw];
}

// new Selection delegate methods

// Facebook Action
-(void)newFaceBookAction
{
    
    if (playerLayer1) {
        [playerLayer1.player pause];
      //  [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
      //  [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
       // [playerLayer3 removeFromSuperlayer];
    }
    
    if (!appDell.isFbSelect) {
        isUpper = YES;
        [self faceBookLogin];
    }
    
    else{
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [currentDefaults objectForKey:@"kfbpicArray"];
        NSMutableArray *arrFb = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"arrFb>>>>%@",arrFb);
        
        facebookImageGallery *facebookImageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"facebookImageGallery"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:facebookImageGalleryVC];
        facebookImageGalleryVC.str_PageName = @"profile";
        facebookImageGalleryVC.fbSelect = YES;
        facebookImageGalleryVC.viewNumber = imgView_no;
        facebookImageGalleryVC.delegate_fbImage =self;
        facebookImageGalleryVC.arr_fb = [arrFb mutableCopy];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
}
// facebook delegate methods

-(void)showFbimage:(NSMutableArray *)arr_img view:(int)imgVw_No{
    
    saveEdit = 0;
    [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.leftEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
    [self.middleEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
    [self.rightEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
    [self startTimer];
    
    [self uploadImage_VideoServiceCall:arr_img view:imgVw_No];
}

-(void)backFromFbGallary{
    
    if (playerLayer1) {
        [playerLayer1.player play];
    }
    if (playerLayer2) {
        [playerLayer2.player play];
    }
    if (playerLayer3) {
        [playerLayer3.player play];
    }
}


// Instagram Action
-(void)newInstragramAction
{
    if (playerLayer1) {
        [playerLayer1.player pause];
      //  [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
      //  [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
      //  [playerLayer3 removeFromSuperlayer];
    }
    
    isUpper = YES;
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"NS_tokenId"];
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"NS_userId"];
    
    if (accessToken.length && userIdStr.length) {
        [self photoAndVideoAccessForInstagramForEdit];
    }else{
        
        _vw_back.hidden = NO;

        loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, _vw_back.frame.size.height - 60)];
        //self.LoginWebView.hidden = NO;
        loginWebView.backgroundColor = [UIColor whiteColor];
        NSString* authURL = nil;
        
        if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
        {
            authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                       INSTAGRAM_AUTHURL,
                       INSTAGRAM_CLIENT_ID,
                       INSTAGRAM_REDIRECT_URI,
                       INSTAGRAM_SCOPE];
            
        }
        else
        {
            authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                       INSTAGRAM_AUTHURL,
                       INSTAGRAM_CLIENT_ID,
                       INSTAGRAM_REDIRECT_URI,
                       INSTAGRAM_SCOPE];
        }
        
        [self.vw_back addSubview:loginWebView];
        //  loginIndicator.hidden = NO;
        [self.view bringSubviewToFront:loginWebView];
        [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
        [loginWebView setDelegate:(id)self];
    }
    
}

// Open Gallery
-(void)newGalleryAction
{
    if (playerLayer1) {
        [playerLayer1.player pause];
        [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
        [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
       // [playerLayer3 removeFromSuperlayer];
    }
    
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.delegate = (id)self;
    //    picker.allowsEditing = YES;
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    [self presentViewController:picker animated:YES completion:nil];
    
    [self launchController];
    
}

// Open Camera

-(void)newVideoAction
{
    
    
    [self showVideoGalleryVw];
}


//**************************** Video Gallery View ***********************************

// View For Gallery Video

-(void)showVideoGalleryVw{
    
    ViewForGalleryVideo *galleryVw = [[ViewForGalleryVideo alloc] init];
    galleryVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [galleryVw setUpUi];
    galleryVw.delegate_videoSelection = self;
    [self.view addSubview:galleryVw];
}

// video gallery view delegate methods

-(void)videoGalleryAction{
    
    if (playerLayer1) {
        [playerLayer1.player pause];
        //  [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
        //  [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
        //  [playerLayer3 removeFromSuperlayer];
    }
    
    isvideoGallery = YES;
    // Present videos from which to choose
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self; // ensure you set the delegate so when a video is chosen the right method can be called
    
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    // This code ensures only videos are shown to the end user
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //  videoPicker.videoMaximumDuration = 7;
    
    [self presentViewController:videoPicker animated:YES completion:nil];
    
    
}
-(void)videoCameraAction{
    
    if (playerLayer1) {
        [playerLayer1.player pause];
        //  [playerLayer1 removeFromSuperlayer];
    }
    if (playerLayer2) {
        [playerLayer2.player pause];
        //  [playerLayer2 removeFromSuperlayer];
    }
    if (playerLayer3) {
        [playerLayer3.player pause];
        //  [playerLayer3 removeFromSuperlayer];
    }
    
    isCameraUpper = YES;
  //  isvideoGallery = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    picker.videoMaximumDuration = 7;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}


// Image Picker For Both Upper and Lower Gallery and Camera

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (isvideoGallery == YES) {
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSLog(@"VideoURL = %@", videoURL);
            strVideo = [NSString stringWithFormat:@"%@",videoURL];
            //    [self careosalDataSourceforImageAndVideo];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            VideoEditingViewController *videoEditVC = (VideoEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoEditingViewController"];
            videoEditVC.videoFilePathStr = strVideo;
            videoEditVC.delegate_trimVideo =self;
            [self presentViewController:videoEditVC animated:NO completion:nil];

        }
        
        else if (isCameraLower){
            
            
            [self showImageInterestViewFromCellInfo:cellDetailsDict image:[info objectForKey: UIImagePickerControllerOriginalImage]];
        }
        
        else if (isGalleryLower){
            
//            [self showImageInterestViewFromCellInfo:cellDetailsDict image:[info objectForKey: UIImagePickerControllerOriginalImage]];
        }
        
        else if (isCameraUpper){
            
//            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//            NSLog(@"VideoURL = %@", videoURL);
//            strVideo = [NSString stringWithFormat:@"%@",videoURL];
//            //    [self careosalDataSourceforImageAndVideo];
//
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//
//            VideoEditingViewController *videoEditVC = (VideoEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoEditingViewController"];
//            videoEditVC.videoFilePathStr = strVideo;
//            videoEditVC.delegate_trimVideo =self;
//
//            [self presentViewController:videoEditVC animated:NO completion:nil];
            
            
                        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
                        NSLog(@"VideoURL = %@", videoURL);
            NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
            
            [self uploadVideoServiceCall:videoData view:imgView_no];

            
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (playerLayer1) {
        [playerLayer1.player play];
    }
    if (playerLayer2) {
        [playerLayer2.player play];
    }
    if (playerLayer3) {
        [playerLayer3.player play];
    }
}

// Video trimming

-(void)trimVideo:(NSData *) videoData Image:(UIImage *) image{
    
    NSLog(@"videoData>>>>%@",videoData);
    
    videoDataForService = videoData;
    
 //   [self careosalDataSourceforImageAndVideo];
    
    [self uploadVideoServiceCall:videoData view:imgView_no];
    
}

// FB video trimming delegate

-(void)fbVideoTrmming:(NSString *)strVideoUrl{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    VideoEditingViewController *videoEditVC = (VideoEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoEditingViewController"];
    videoEditVC.videoFilePathStr = strVideoUrl;
    videoEditVC.delegate_trimVideo =self;
    // [self.navigationController pushViewController:videoEditVC animated:NO];
    [self presentViewController:videoEditVC animated:NO completion:nil];
}


//******************************************************************************************

#pragma marks - ELC Picker for image selection from gallery

- (void)launchController
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    if (!isGalleryLower) {
        elcPicker.maximumImagesCount = 7;
    }
    else{
        elcPicker.maximumImagesCount = 1;
    }
     //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}



- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 3;//Count check
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    width = 0;
    
    
    
    [imagesArrayForGallery removeAllObjects];
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                
                NSLog(@"dict>>>>%@",dict);
                
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [imagesArrayForGallery addObject:image];
                
                NSLog(@"imagesArrayForGallery....>>>>%@",imagesArrayForGallery);
                NSLog(@"imgView_no>>>>%d",imgView_no);
                
                [picker dismissViewControllerAnimated:YES completion:nil];
                
            }
            else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
        else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [imagesArrayForGallery addObject:image];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    if (!isGalleryLower) {
        if (imagesArrayForGallery.count) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self uploadImage_VideoServiceCall:imagesArrayForGallery view:imgView_no];

        }else{
            NSLog(@"select any one");
            [appDell alertViewToastMessage:@"select any one"];
        }

    }
    else{
        if (imagesArrayForGallery.count) {
            [self dismissViewControllerAnimated:YES completion:nil];

            [self showImageInterestViewFromCellInfo:cellDetailsDict image:[imagesArrayForGallery objectAtIndex:0]];
        }
        else{
            NSLog(@"select any one");
            [appDell alertViewToastMessage:@"select any one"];
        }
    }
   // [self showImagesFrom:imagesArrayForGallery];
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (playerLayer1) {
        [playerLayer1.player play];
    }
    if (playerLayer2) {
        [playerLayer2.player play];
    }
    if (playerLayer3) {
        [playerLayer3.player play];
    }
    
}


//*************************************************************************************************************************




// CollectioView Delegate and datsource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    InterestCollectionViewCell *cell = [_interest_collectionVw dequeueReusableCellWithReuseIdentifier:@"InterestCollectionViewCell" forIndexPath:indexPath];
    cell.img_interest.image = [UIImage imageNamed:@"whitegGlass"];
    cell.lbl_Interest.text = @"Add Pic";
 // **************************************************************************
   // After getdata web service Call
  //**************************************************************************
    
    if (indexPath.row < 3)
    {
        
        
        NSLog(@"EATS>>>>>>>>>");
        
        if (foodArray.count) {
            
            if (foodArray.count > 0 && indexPath.row == 0) {
                
                NSDictionary  *foodDict = [foodArray objectAtIndex:0];
                NSLog(@"foodDict>>>>>>%@",foodDict);
                
                NSString *imageURLPath = [foodDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                    //    cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width , cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [foodDict valueForKey:@"title"];
            }
            
            else if (foodArray.count > 1 && indexPath.row == 1){
                
                NSDictionary  *foodDict = [foodArray objectAtIndex:1];
                NSLog(@"foodDict>>>>>>%@",foodDict);
                
                NSString *imageURLPath = [foodDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                  //      cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width , cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [foodDict valueForKey:@"title"];

            }
            
            else if (foodArray.count > 2 && indexPath.row == 2){
                
                NSDictionary  *foodDict = [foodArray objectAtIndex:2];
                NSLog(@"foodDict>>>>>>%@",foodDict);
                
                NSString *imageURLPath = [foodDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                  //      cell.img_interest.image = image;
                        
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width , cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [foodDict valueForKey:@"title"];
                
            }
        }
        else{
            cell.img_interest.image = [UIImage imageNamed:@"whitegGlass"];
            cell.lbl_Interest.text = @"Add Pic";

        }
    }
   
    if (indexPath.row > 2 && indexPath.row < 6)
    {
        
        
        NSLog(@"Loves>>>>>>>>>");
        
        if (interestArray.count) {
            
            if (interestArray.count > 0 && indexPath.row == 3) {
                
                NSDictionary *interestDict = [interestArray objectAtIndex:0];
                NSLog(@"interestDict>>>>%@",interestDict);
                
                NSString *imageURLPath = [interestDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
               //         cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [interestDict valueForKey:@"title"];
            }
            else if (interestArray.count > 1 && indexPath.row == 4){
                
                NSDictionary *interestDict = [interestArray objectAtIndex:1];
                NSLog(@"interestDict>>>>%@",interestDict);
                
                NSString *imageURLPath = [interestDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                      //  cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [interestDict valueForKey:@"title"];
            }
            
            else if (interestArray.count > 2 && indexPath.row == 5){
                
                NSDictionary *interestDict = [interestArray objectAtIndex:2];
                NSLog(@"interestDict>>>>%@",interestDict);
                
                NSString *imageURLPath = [interestDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                    //    cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [interestDict valueForKey:@"title"];
            }
        }
        
        else{
            cell.img_interest.image = [UIImage imageNamed:@"whitegGlass"];
            cell.lbl_Interest.text = @"Add Pic";

        }
    }
    
    if (indexPath.row > 5 && indexPath.row < 9){
        
       
        
        NSLog(@"Listn>>>>>>>>>");
        
        if(musicArray.count){
            
            if (musicArray.count > 0 && indexPath.row == 6) {
                
                NSDictionary *musicDict = [musicArray objectAtIndex:0];
                NSLog(@"musicDict>>>>%@",musicDict);
                
                NSString *imageURLPath = [musicDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                     //   cell.img_interest.image = image;
                        
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [musicDict valueForKey:@"title"];
            }
            else if (musicArray.count > 1 && indexPath.row == 7){
                
                NSDictionary *musicDict = [musicArray objectAtIndex:1];
                NSLog(@"interestDict>>>>%@",musicDict);
                
                NSString *imageURLPath = [musicDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                    //    cell.img_interest.image = image;
                        
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [musicDict valueForKey:@"title"];
            }
            
            else if (musicArray.count > 2 && indexPath.row == 8){
                
                NSDictionary *musicDict = [musicArray objectAtIndex:2];
                NSLog(@"interestDict>>>>%@",musicDict);
                
                NSString *imageURLPath = [musicDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                      //  cell.img_interest.image = image;
                        
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [musicDict valueForKey:@"title"];
            }
        }
        else{
            cell.img_interest.image = [UIImage imageNamed:@"whitegGlass"];
            cell.lbl_Interest.text = @"Add Pic";
            
        }
    }

    height_cell = cell.img_interest.frame.size.height + cell.lbl_Interest.frame.size.height;
    
   // NSLog(@"height_cell %f",height_cell);
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(saveEdit == 1){
        
        if (indexPath.row < 3) {
            
            if (foodArray.count == 3) {
                
                NSDictionary *dict = [foodArray objectAtIndex:indexPath.row];
                                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                                    @"cellImageId": [dict valueForKey:@"id"]
                                                        };
                
                                [self showImageSelectionView];
            }
            
            else if ((foodArray.count == 2) && (indexPath.row < 2)){
                
                NSDictionary *dict = [foodArray objectAtIndex:indexPath.row];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            
            else if ((foodArray.count == 1) && (indexPath.row == 0)){
                
                NSDictionary *dict = [foodArray objectAtIndex:indexPath.row];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            

            else{

              cellDetailsDict = @{@"cellTapindex":[NSString stringWithFormat:@"%ld",indexPath.row],
                              @"cellImageId": @"0"
                              };
                [self showImageSelectionView];

            }
        }
       
        if (indexPath.row > 2 && indexPath.row < 6) {
            
            if (interestArray.count == 3) {
                
                NSDictionary *dict = [interestArray objectAtIndex:indexPath.row - 3];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            
            else if ((interestArray.count == 2) && (indexPath.row < 2)){
                
                NSDictionary *dict = [interestArray objectAtIndex:indexPath.row - 3];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            
            else if ((interestArray.count == 1) && (indexPath.row == 0)){
                
                NSDictionary *dict = [interestArray objectAtIndex:indexPath.row - 3];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            
            
            else{
                
                cellDetailsDict = @{@"cellTapindex":[NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": @"0"
                                    };
                [self showImageSelectionView];
                
            }
        }
        
        if (indexPath.row > 5 && indexPath.row < 9) {
            
            if (musicArray.count == 3) {
                
                NSDictionary *dict = [musicArray objectAtIndex:indexPath.row - 6];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            
            else if ((musicArray.count == 2) && (indexPath.row < 2)){
                
                NSDictionary *dict = [musicArray objectAtIndex:indexPath.row - 6];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            
            else if ((musicArray.count == 1) && (indexPath.row == 0)){
                
                NSDictionary *dict = [musicArray objectAtIndex:indexPath.row - 6];
                cellDetailsDict = @{@"cellTapindex": [NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": [dict valueForKey:@"id"]
                                    };
                
                [self showImageSelectionView];
            }
            
            
            else{
                
                cellDetailsDict = @{@"cellTapindex":[NSString stringWithFormat:@"%ld",indexPath.row],
                                    @"cellImageId": @"0"
                                    };
                [self showImageSelectionView];
                
            }
    }
 }
}

//Jitendra
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   // return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.033), 150);

    if ([UIScreen mainScreen].bounds.size.width == 320) {
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.0299), 150);
    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){

        return CGSizeMake([UIScreen mainScreen].bounds.size.width/3-([UIScreen mainScreen].bounds.size.width*0.026), 175);

    }else if ([UIScreen mainScreen].bounds.size.width == 414){

        return CGSizeMake([UIScreen mainScreen].bounds.size.width/3-([UIScreen mainScreen].bounds.size.width*0.023), 188);

    }else{
        NSLog(@"width=%f",[UIScreen mainScreen].bounds.size.width);
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.026), 175);

    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    //return UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0);
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath;
    for (UICollectionViewCell *cell in [self.interest_collectionVw visibleCells])
    {
        indexPath = [self.interest_collectionVw indexPathForCell:cell];
        NSLog(@"cell Index Path >>>>>>>>>%ld",indexPath.row);
    
        if(indexPath.row == 2){
            
            [self.EatsButton setSelected:YES];
            [self.LovesButton setSelected:NO];
            [self.ListensButton setSelected:NO];
        }
        else if (indexPath.row == 6){
            
            [self.EatsButton setSelected:NO];
            [self.LovesButton setSelected:YES];
            [self.ListensButton setSelected:NO];
        }
        else if (indexPath.row == 8){
            
            [self.EatsButton setSelected:NO];
            [self.LovesButton setSelected:NO];
            [self.ListensButton setSelected:YES];
        }
   }
    
    
}



// ******************   Eat, Love and Music Button selection Autometic and collection view cell changes autometically   ************************************************************************************

-(void)startTimer{
    
    
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(setAutoChanges)
                                               userInfo:nil
                                                repeats:YES];
    
    

}

-(void)setAutoChanges
{
    if (timerIndex == 2) {
        timerIndex = 0;
    }else
        timerIndex++;
    
    if (timerIndex == 0) {
        
        [self.EatsButton setSelected:YES];
        [self.LovesButton setSelected:NO];
        [self.ListensButton setSelected:NO];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
            
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375){
            
            _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
            
        }
        
        else{
            
            _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);

        }

    }
    
    else if (timerIndex == 1){
        
        [self.EatsButton setSelected:NO];
        [self.LovesButton setSelected:YES];
        [self.ListensButton setSelected:NO];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
            
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375){
            
            _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
            
        }
        
        else{
            
            _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 16, 0.0);
        }
        

    }
    
    else if (timerIndex == 2){
        
        [self.EatsButton setSelected:NO];
        [self.LovesButton setSelected:NO];
        [self.ListensButton setSelected:YES];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);
            
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375){
            
            _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);
            
        }
        else{
            
            _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 30, 0.0);
        }
        
        
        

    }
    
}

//***********************************************************************************************************

//// show Interest image view
//
//-(void)showImageInterestViewFrom:(NSArray *) imgArray CellNo:(int) cellIndexNo{
//    
//    ImageViewForInterest *imgInterestVw = [[ImageViewForInterest alloc] init];
//    imgInterestVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    imgInterestVw.arr_image = imgArray;
//  //  imgInterestVw.cellInfoDict = cellIndexNo;
//    [imgInterestVw setUpUI];
//    [self.view addSubview:imgInterestVw];
//}


// Fetch data from DB

- (void)fetchDataFromUserMaster
{
    sqlite3_stmt    *statement;
    NSArray *path    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docdir = [path objectAtIndex:0]; //path[0];
    dbpath = [docdir stringByAppendingPathComponent:@"HBHG.db"];
    const char *databasepath = [dbpath UTF8String];
    NSString *querySQL;
    if (sqlite3_open(databasepath, &myDB) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat:@"SELECT  * FROM FBIMAGETABLE"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *path= [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSLog(@"Path-%@",path);
                [arrImagePath addObject:path];
                
                
                
                
                // NSLog(@"imagePath >>>>%@",arrImagePath);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDB);
    }
    
    NSLog(@"arrImagePath>>>>%@",arrImagePath);
//    [self showImageVideosForFirstVw];
//    [self showImageVideosForSecondVw];
//    [self showImageVideosForThirdVw];
}



//
//*************************************Getdata Service Call*****************************************

-(void)getDataServiceCall{
    
   
    NSDictionary *getDataDict = @{@"user_id":str_userId,//@"24",str_userId
                                  @"token" :@"adsahtoikng"
                                  };
    
    NSLog(@"getDataDict>>>>%@",getDataDict);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];


        [manager POST:GetData_URL parameters:getDataDict progress:nil success:^(NSURLSessionTask *task, id resPonceObject){


            NSDictionary *responseDict = (NSDictionary*)resPonceObject;

            NSDictionary *resultDict = [responseDict objectForKey:@"basic_info"];

            NSString *strStatus = [responseDict objectForKey:@"success"];

            NSString *strMessage = [responseDict objectForKey:@"message"];

            
            NSLog(@"result >> %@",resultDict);
            NSLog(@"responseDict >> %@",responseDict);
         //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);

            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];

                
                [playerLayer1 removeFromSuperlayer];
                [playerLayer2 removeFromSuperlayer];
                [playerLayer3 removeFromSuperlayer];

                
                foodArray = [responseDict objectForKey:@"food_data"];
                musicArray = [responseDict objectForKey:@"music_data"];
                interestArray = [responseDict objectForKey:@"interest_data"];
                
                strVideo1 = [resultDict objectForKey:@"video"];
                strVideo2 = [resultDict objectForKey:@"second_video"];
                strVideo3 = [resultDict objectForKey:@"third_video"];
                
                if(strVideo1.length){
                    
                    arrImage1 = [NSArray arrayWithObject:strVideo1];
                }
                else{
                    
                    arrImage1 = [resultDict objectForKey:@"image_video"];
                }
                if (strVideo2.length) {
                    
                    arrImage2 = [NSArray arrayWithObject:strVideo2];

                }
                else{
                    
                    arrImage2 = [resultDict objectForKey:@"second_image_video"];

                }
                
                if (strVideo3.length) {
                    
                    arrImage3 = [NSArray arrayWithObject:strVideo3];

                }
                
                else{
                    
                    arrImage3 = [resultDict objectForKey:@"third_image_video"];

                }
                
                NSLog(@"arrImg1>>>>%@>>>>arrImg2>>>>%@>>>>arrImg3>>>>%@",arrImage1,arrImage2,arrImage3);
                
                NSString *str_Gender = [resultDict objectForKey:@"gender"];
                NSString *strGender_firstLetter = [str_Gender substringToIndex:1];

                
                if ([[resultDict objectForKey:@"sexual_orientation"] isEqualToString:@"Straight"])   {
                    
                    if ([strGender_firstLetter isEqualToString:@"m"] ) {
                        
                        _userGenderImageVw.image = [UIImage imageNamed:@"straight_male_w"];

                    }
                    else{
                        
                        _userGenderImageVw.image = [UIImage imageNamed:@"straight_female_w"];

                    }
                    
                }
                
                
               else if ([[resultDict objectForKey:@"sexual_orientation"] isEqualToString:@"Gay"])  {
                   
                   
                   if ([strGender_firstLetter isEqualToString:@"m"] ) {
                    
                       _userGenderImageVw.image = [UIImage imageNamed:@"gay_w"];

                   }
                   
                   else{
                       
                       _userGenderImageVw.image = [UIImage imageNamed:@"lesbian_w@3x"];

                   }
                }
                
               else if ([[resultDict objectForKey:@"sexual_orientation"] isEqualToString:@"Bisexual"])  {
                   
                   if ([strGender_firstLetter isEqualToString:@"m"] ) {
                       _userGenderImageVw.image = [UIImage imageNamed:@"bisexual_male_w"];

                   }
                   
                   else{
                       
                       _userGenderImageVw.image = [UIImage imageNamed:@"bisexual_female_w"];

                   }
                }
               
               
                
                 [self careosalDataSource];
                
                
                appDell.isFirstTimeAppearinProfile = YES;
                
                NSLog(@"%@",strMessage);
                
                [_interest_collectionVw reloadData];
                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                [userD setObject:responseDict forKey:kuserDetails];
                [userD synchronize];

                [self DeviceTokenUpdateServiceCall];

                
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
//****************************************************************


//
//*******************************************Upade user Latitude and Longitude*******************************

-(void)updateUserLatitudeLongitudeServiceCall{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLocationDict = [userD objectForKey:kuserLocation];
    NSLog(@"userLocationDict>>>>%@",userLocationDict);
    
    NSString *str_lat = [userLocationDict valueForKey:@"latitude"];
    NSString *str_long = [userLocationDict valueForKey:@"longitude"];
    NSDictionary *latLongDict;
    
    if (str_lat.length && str_long.length) {
        
        latLongDict = @{@"user_id" : str_userId,
                        @"token" : @"adsahtoikng",
                        @"lat" : [userLocationDict valueForKey:@"latitude"],
                        @"long" : [userLocationDict valueForKey:@"longitude"]
                        };
        
    }
    
//    else{
//
//        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//        NSDictionary *userLocationDict = [userD objectForKey:kuserLocation];
//        NSLog(@"userLocationDict>>>>%@",userLocationDict);
//
//        latLongDict = @{@"user_id" : str_userId,
//                        @"token" : @"adsahtoikng",
//                        @"lat" : [userLocationDict valueForKey:@"latitude"],
//                        @"long" : [userLocationDict valueForKey:@"longitude"]
//                        };
//    }
    
    
    NSLog(@"latLongDict>>>>%@",latLongDict);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:UpdateLatLong_URL parameters:latLongDict progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
      //      NSDictionary *resultDict = [responseDict objectForKey:@"basic_info"];
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            //            NSArray *foodArray = [responseDict objectForKey:@"food_data"];
            //            NSArray *musicArray = [responseDict objectForKey:@"music_data"];
            //            NSArray *interestArray = [responseDict objectForKey:@"interest_data"];
            
          //  NSLog(@"result >> %@",resultDict);
            NSLog(@"responseDict >> %@",responseDict);
            //            NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                NSLog(@"%@",strMessage);
                
                [self getDataServiceCall];

                //                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                //                [userD setObject:resultDict forKey:kuserDetails];
                //                [userD synchronize];
                
                
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



//****************************************** Interest Image View Open ******************************************

// show Interest image view

-(void)showImageInterestViewFromCellInfo:(NSDictionary *) dictcellInfo image:(UIImage *) image{
    
    ImageViewForInterest *imgInterestVw = [[ImageViewForInterest alloc] init];
    imgInterestVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
   // imgInterestVw.arr_image = imgArray;
    imgInterestVw.cellInfoDict = dictcellInfo;
    imgInterestVw.img_storage = image;
    imgInterestVw.isGalleryCameraImage = YES;
    [imgInterestVw setUpUI];
    [self.view addSubview:imgInterestVw];
}

#pragma mark iCarousel methods

-(void)careosalDataSource{
//    NSDictionary *dict = [_arrProfileData objectAtIndex:_profileindex];
//    NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
    caresuyalArray = [arrImage1 mutableCopy];
    caresuyalArray1 = [arrImage2 mutableCopy];
    caresuyalArray2 = [arrImage3 mutableCopy];
    if (timer1) {
        [timer1 invalidate]; timer1 = nil;
    }
    if (timer2) {
        [timer2 invalidate]; timer2 = nil;
    }
    if (timer3) {
        [timer3 invalidate]; timer3 = nil;
    }
    sliderCount1 = 0;
    animationType = 0;
    self.carousel_middle.tag = 1;
    [self.carousel_middle reloadData];
    timer1 =  [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
    
    sliderCount2 = 0;
    animationType1 = 2;
    [self.carousel_left reloadData];
    _carousel_left.tag = 2;
   timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodleft) userInfo:nil repeats:YES];
    
    sliderCount3 = 0;
    animationType2 = 4;
    [self.carousel_right reloadData];
    _carousel_right.tag = 3;

    timer3 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodright) userInfo:nil repeats:YES];
    
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    
    if (carousel == _carousel_middle) {
        
        return caresuyalArray.count;
        
    }
    
    if (carousel == _carousel_left) {
        
        return caresuyalArray1.count;
    }
    
    if (carousel == _carousel_right) {
        return caresuyalArray2.count;
    }
    
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (carousel == _carousel_middle){
        
        if (strVideo1.length) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _middleView.frame.size.width, _middleView.frame.size.height)];
            view.backgroundColor = [UIColor blackColor];
            
            NSURL *url1 = [NSURL URLWithString:strVideo1];
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
            playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:player];
            playerLayer1.videoGravity=AVLayerVideoGravityResizeAspectFill;

            playerLayer1.frame = CGRectMake(0, 0, _middleView.frame.size.width, _middleView.frame.size.height);
            [view.layer addSublayer:playerLayer1];
            //[player play];
            [player play];
            player.muted = true;
        }
        else{
            
            if (view == nil)
            {
                NSString *imgpath = [caresuyalArray objectAtIndex:index];
                
                NSLog(@"imagePath >>> %@",imgpath);
                
                UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _middleView.frame.size.width, _middleView.frame.size.height)];
                
                [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        imgVw.image = image;
                        imgVw.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }];
               view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _middleView.frame.size.width, _middleView.frame.size.height)];
                view.backgroundColor = [UIColor clearColor];
                imgVw.tag = 101;
                [view addSubview:imgVw];
            }
            
            else{
                UIImageView *imgVw = (UIImageView *)[view viewWithTag:101];
                [imgVw sd_setImageWithURL:[NSURL URLWithString:[caresuyalArray objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        imgVw.image = image;
                        imgVw.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }];
            }
        }
        
       
    }
    
    if (carousel == _carousel_left) {
        
        if (strVideo2.length) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _leftView.frame.size.height, _leftView.frame.size.height)];
            view.backgroundColor = [UIColor blackColor];
            
            NSURL *url1 = [NSURL URLWithString:strVideo2];
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
            playerLayer2 = [AVPlayerLayer playerLayerWithPlayer:player];
            playerLayer2.videoGravity=AVLayerVideoGravityResizeAspectFill;

            playerLayer2.frame = CGRectMake(0, 0, _leftView.frame.size.height, _leftView.frame.size.height);
            [view.layer addSublayer:playerLayer2];
            //[player play];
            [player play];
            player.muted = true;
            
            view.tag = 202;
            UILongPressGestureRecognizer *lpgr_left = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(handleLongPressleft:)];
            lpgr_left.minimumPressDuration = 1.0; //seconds
            [view addGestureRecognizer:lpgr_left];
        }
        
        else{
            
            
            if (view == nil)
            {
                NSString *imgpath = [caresuyalArray1 objectAtIndex:index];
                
                NSLog(@"imagePath >>> %@",imgpath);
                
                UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _leftView.frame.size.height, _leftView.frame.size.height)];
                
                [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        imgVw.image = image;
                        imgVw.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }];
                view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _leftView.frame.size.height, _leftView.frame.size.height)];
                view.backgroundColor = [UIColor clearColor];
                imgVw.tag = 101;
                [view addSubview:imgVw];
                view.tag = 202;
                UILongPressGestureRecognizer *lpgr_left = [[UILongPressGestureRecognizer alloc]
                                                           initWithTarget:self action:@selector(handleLongPressleft:)];
                lpgr_left.minimumPressDuration = 1.0; //seconds
                [view addGestureRecognizer:lpgr_left];
            }
            else{
                UIImageView *imgVw = (UIImageView *)[view viewWithTag:101];
                [imgVw sd_setImageWithURL:[NSURL URLWithString:[caresuyalArray1 objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        imgVw.image = image;
                        imgVw.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }];
            }
        }
        
        
    }
    
    if (carousel == _carousel_right) {
        
        if (strVideo3.length) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightView.frame.size.width, _rightView.frame.size.height)];
            view.backgroundColor = [UIColor blackColor];
            
            NSURL *url1 = [NSURL URLWithString:strVideo3];
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
            playerLayer3 = [AVPlayerLayer playerLayerWithPlayer:player];
            playerLayer3.videoGravity=AVLayerVideoGravityResizeAspectFill;

            playerLayer3.frame = CGRectMake(0, 0, _rightView.frame.size.width, _rightView.frame.size.height);
            [view.layer addSublayer:playerLayer3];
            //[player play];
            [player play];
            player.muted = true;
            
            view.tag = 203;
            UILongPressGestureRecognizer *lpgr_right = [[UILongPressGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(handleLongPressright:)];
            lpgr_right.minimumPressDuration = 1.0; //seconds
            [view addGestureRecognizer:lpgr_right];
        }
        else{
            
            if (view == nil)
            {
                NSString *imgpath = [caresuyalArray2 objectAtIndex:index];
                
                NSLog(@"imagePath >>> %@",imgpath);
                
                UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _rightView.frame.size.width, _rightView.frame.size.height)];
                
                [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        imgVw.image = image;
                        imgVw.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }];
                view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightView.frame.size.width, _rightView.frame.size.height)];
                view.backgroundColor = [UIColor clearColor];
                imgVw.tag = 101;
                [view addSubview:imgVw];
                view.tag = 203;
                UILongPressGestureRecognizer *lpgr_right = [[UILongPressGestureRecognizer alloc]
                                                            initWithTarget:self action:@selector(handleLongPressright:)];
                lpgr_right.minimumPressDuration = 1.0; //seconds
                [view addGestureRecognizer:lpgr_right];
            }
            else{
                UIImageView *imgVw = (UIImageView *)[view viewWithTag:101];
                [imgVw sd_setImageWithURL:[NSURL URLWithString:[caresuyalArray2 objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        imgVw.image = image;
                        imgVw.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }];
            }
            
        }
        
    }
    //create new view if no view is available for recycling
    
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
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
    sliderCount1=0;
    
    [super viewDidAppear:animated];
}

-(void)runMethod
{
    [self.carousel_middle scrollToItemAtIndex:sliderCount1 animated:sliderCount1 ? YES : NO];
    if((sliderCount1%2) == 0)
    {
        animationType++;
        animationType = (animationType > 2) ? 0 : animationType;
        self.carousel_middle.type = [[arrAnimationType objectAtIndex:animationType] intValue];
        NSLog(@"---rand %ld",self.carousel_middle.type);
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

-(void)runMethodleft
{
    [self.carousel_left scrollToItemAtIndex:sliderCount2 animated:sliderCount2 ? YES : NO];
    if((sliderCount2%2) == 0)
    {
        animationType++;
        animationType = (animationType > 2) ? 0 : animationType;
        self.carousel_left.type = [[arrAnimationType objectAtIndex:animationType] intValue];
        NSLog(@"---rand %ld",self.carousel_left.type);
        if (caresuyalArray1.count == (sliderCount2+1)) {
            sliderCount2=0;
        }else{
            sliderCount2++;
        }
        //[self.carousel1 reloadData];
    }
    else
    {
        if (caresuyalArray1.count == (sliderCount2+1)) {
            sliderCount2=0;
        }else{
            sliderCount2++;
        }
    }
}

-(void)runMethodright
{
    [self.carousel_right scrollToItemAtIndex:sliderCount3 animated:sliderCount3 ? YES : NO];
    if((sliderCount3%2) == 0)
    {
        animationType++;
        animationType = (animationType > 2) ? 0 : animationType;
        self.carousel_right.type = [[arrAnimationType objectAtIndex:animationType] intValue];
        NSLog(@"---rand %ld",self.carousel_right.type);
        if (caresuyalArray2.count == (sliderCount3+1)) {
            sliderCount3=0;
        }else{
            sliderCount3++;
        }
        //[self.carousel1 reloadData];
    }
    else
    {
        if (caresuyalArray2.count == (sliderCount3+1)) {
            sliderCount3=0;
        }else{
            sliderCount3++;
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
}

// Long Tap gesture

-(void)handleLongPressleft:(UILongPressGestureRecognizer *)longPress
{
    if(!saveEdit)
        return;
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        
        UIView *vw = longPress.view;
        //Do Whatever You want on End of Gesture
        if (vw.tag == 202){
            
       //     [self setDefaultVideoServiceCall:vw.tag];
            [self showDefaultImageVideoView:(int)vw.tag];
        }
        
    }
    
}

-(void)handleLongPressright:(UILongPressGestureRecognizer *)longPress
{
    if(!saveEdit)
        return;
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
        
        UIView *vw = longPress.view;
        //Do Whatever You want on End of Gesture
        if (vw.tag == 203){
            [self showDefaultImageVideoView:(int)vw.tag];

        //    [self setDefaultVideoServiceCall:vw.tag];

        }
    }
    
}


//*********************************** Video/image_video Upload service Call ***************************************

-(void)uploadImage_VideoServiceCall:(NSMutableArray *) imgArray view:(int) vwNum{

    
    
    NSDictionary *dictForUpload = @{@"user_id":str_userId,
                                    @"token":@"adsahtoikng"
                                    };




        NSLog(@"dictForLogin>>>>>%@",dictForUpload);

    [appDell showCustomLoader:self.view text:@"Loding...."];
    
        NSMutableArray *arrayOfImages;
        arrayOfImages = [[NSMutableArray alloc] init];

        for (UIImage *image in imgArray) {
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation (image,0.5);

                [arrayOfImages addObject:imageData ];

            }
        }


    //    NSData *imageData = UIImageJPEGRepresentation (imgvProfile.image,0.5);

        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@",AddProfileVideo_URL] parameters:dictForUpload constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0 ; i<arrayOfImages.count; i++) {
                
                if (vwNum == 1) {
                     [formData appendPartWithFileData:[arrayOfImages objectAtIndex:i] name:[NSString stringWithFormat:@"image_video[%d]",i] fileName:@"imageVideo.jpeg"  mimeType:@"image/json"];
                }
                else if (vwNum == 2){
                    
                    [formData appendPartWithFileData:[arrayOfImages objectAtIndex:i] name:[NSString stringWithFormat:@"second_image_video[%d]",i] fileName:@"imageVideo.jpeg"  mimeType:@"image/json"];
                }
                else{
                    
                    [formData appendPartWithFileData:[arrayOfImages objectAtIndex:i] name:[NSString stringWithFormat:@"third_image_video[%d]",i] fileName:@"imageVideo.jpeg"  mimeType:@"image/json"];
                }
            }
        } error:nil];

        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        NSURLSessionUploadTask *uploadTask;
        UIProgressView *progressView;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              [progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError *error) {

                          if (error) {
                              NSLog(@"Error: %@", error);
                          }
                          else
                          {
                              NSDictionary *notificationDict =responseObject;

                              if ([[notificationDict valueForKey:@"success"] intValue] == 1) {
                                  [appDell removeCustomLoader];
//                                 NSDictionary *dict = [notificationDict objectForKey:@"user_data"];
//                                  NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
//                                  NSLog(@"dict_basicInfo>>>>%@",dict_basicInfo);
//
//                                  if (vwNum == 1) {
//
//                                      [timer1 invalidate];
//
//                                      arrImage1 = [dict_basicInfo objectForKey:@"image_video"];
//                                      caresuyalArray = [arrImage1 mutableCopy];
//                                      [_carousel_middle reloadData];
//
//                                      timer1 =  [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
//                                  }
//
//                                  else if (vwNum == 2){
//
//                                      [timer2 invalidate];
//
//                                      arrImage2 = [dict_basicInfo objectForKey:@"second_image_video"];
//                                      caresuyalArray1 = [arrImage2 mutableCopy];
//                                      [_carousel_left reloadData];
//
//                                      timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodleft) userInfo:nil repeats:YES];
//                                  }
//
//                                  else{
//
//                                      [timer3 invalidate];
//
//                                      arrImage3 = [dict_basicInfo objectForKey:@"third_image_video"];
//                                      caresuyalArray2 = [arrImage3 mutableCopy];
//                                      [_carousel_right reloadData];
//
//                                      timer3 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodright) userInfo:nil repeats:YES];
//                                  }

//                                  NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//                                  [userD setObject:notificationDict forKey:kuserDetails];
//                                  [userD synchronize];
                                  [self getDataServiceCall];

                                  saveEdit = 0;
                                  [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
                                  [self.leftEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                                  [self.middleEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                                  [self.rightEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                                  [self startTimer];

                              }
                              else if ([[notificationDict valueForKey:@"success"] intValue] == 0) {
                                  //[self showAlertWithMessage:[resultDict valueForKey:@"message"]];
                                  [appDell removeCustomLoader];

                              }
                          }
                          [appDell removeCustomLoader];
                      }];
        [uploadTask resume];

    
      
    
}

-(void)uploadVideoServiceCall:(NSData *) video view:(int) vwNum{
    
    NSDictionary *dictForUpload = @{@"user_id":str_userId,
                                    @"token":@"adsahtoikng"
                                    };
    
    
    
    
    NSLog(@"dictForLogin>>>>>%@",dictForUpload);
    
    [appDell showCustomLoader:self.view text:@"Loding...."];
    
   
 //   NSData* videoData = [NSData dataWithContentsOfFile:videoString];

    
    //    NSData *imageData = UIImageJPEGRepresentation (imgvProfile.image,0.5);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@",AddProfileVideo_URL] parameters:dictForUpload constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (vwNum == 1) {
            
            [formData appendPartWithFileData:video name:@"video" fileName:@"video.mp4"  mimeType:@"video/mp4"];
        }
        
        else if (vwNum == 2){
            
             [formData appendPartWithFileData:video name:@"second_video" fileName:@"video.mp4"  mimeType:@"video/mp4"];
        }
        
        else{
            
             [formData appendPartWithFileData:video name:@"third_video" fileName:@"video.mp4"  mimeType:@"video/mp4"];
        }
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    UIProgressView *progressView;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError *error) {
                      
                      if (error) {
                          NSLog(@"Error: %@", error);
                      }
                      else
                      {
                          NSDictionary *notificationDict =responseObject;
                          
                          if ([[notificationDict valueForKey:@"success"] intValue] == 1) {
                              [appDell removeCustomLoader];
//                              NSDictionary *dict = [notificationDict objectForKey:@"user_data"];
//                              NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
//                              NSLog(@"dict_basicInfo>>>>%@",dict_basicInfo);
//
////                              [timer1 invalidate];
////                              [timer2 invalidate];
////                              [timer3 invalidate];
//
//                              if (vwNum == 1) {
//
//                                  [timer1 invalidate];
//
//                                  NSString *str_Video = [dict_basicInfo objectForKey:@"video"];
//
//                                  if (str_Video.length) {
//
//                                      strVideo1 = str_Video;
//                                      [_carousel_middle reloadData];
//                                  }
//
//                                  else{
//
//                                      arrImage1 = [dict_basicInfo objectForKey:@"image_video"];
//                                      caresuyalArray = [arrImage1 mutableCopy];
//                                      [_carousel_middle reloadData];
//                                      timer1 =  [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
//
//                                  }
//
//                              }
//
//                              else if (vwNum == 2){
//
//                                   [timer2 invalidate];
//
//                                  NSString *str_Video = [dict_basicInfo objectForKey:@"second_video"];
//
//                                  if (str_Video.length) {
//
//                                      strVideo2 = str_Video;
//                                      [_carousel_left reloadData];
//
//                                  }
//
//                                  else{
//
//                                      arrImage2 = [dict_basicInfo objectForKey:@"second_image_video"];
//                                      caresuyalArray1 = [arrImage2 mutableCopy];
//                                      [_carousel_left reloadData];
//
//                                       timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodleft) userInfo:nil repeats:YES];
//                                  }
//
//
//                              }
//
//                              else{
//
//                                  [timer3 invalidate];
//
//                                  NSString *str_Video = [dict_basicInfo objectForKey:@"third_video"];
//
//                                  if (str_Video.length) {
//
//                                      strVideo3 = str_Video;
//                                      [_carousel_right reloadData];
//
//                                  }
//
//                                  else{
//
//                                      arrImage3 = [dict_basicInfo objectForKey:@"third_image_video"];
//                                      caresuyalArray2 = [arrImage3 mutableCopy];
//                                      [_carousel_right reloadData];
//
//                                      timer3 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodright) userInfo:nil repeats:YES];
//                                  }
//
//                              }
                              
//                              NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//                              [userD setObject:notificationDict forKey:kuserDetails];
//                              [userD synchronize];
                              
                              [self getDataServiceCall];
                              saveEdit = 0;
                              [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
                              [self.leftEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                              [self.middleEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                              [self.rightEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                              [self startTimer];
                              
                          }
                          else if ([[notificationDict valueForKey:@"success"] intValue] == 0) {
                              //[self showAlertWithMessage:[resultDict valueForKey:@"message"]];
                              [appDell removeCustomLoader];
                              
                          }
                      }
                      [appDell removeCustomLoader];
                  }];
    [uploadTask resume];
    
    
    
    
}




// ****************************** Set Default Video Service Call ***************************************

-(void)setDefaultVideoServiceCall:(int) tagId{
   
    NSDictionary *dict;
    
    if (tagId == 202) {
        
        if (strVideo2.length) {
            
            dict = @{@"user_id" : str_userId,
                     @"token" :@"adsahtoikng",
                     @"key" : @"second_video"
                     };
        }
        else{
            
            dict = @{@"user_id" : str_userId,
                     @"token" :@"adsahtoikng",
                     @"key" : @"second_image_video"
                     };
        }
       
        
        NSLog(@"dict>>>>%@",dict);
    }
    else if (tagId == 203){
        if (strVideo3.length) {
            dict = @{@"user_id" : str_userId,
                     @"token" :@"adsahtoikng",
                     @"key" : @"third_video"
                     };
            
        }
        else{
            
            dict = @{@"user_id" : str_userId,
                     @"token" :@"adsahtoikng",
                     @"key" : @"third_image_video"
                     };
        }
        
        
        NSLog(@"dict>>>>%@",dict);
        
    }
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:SetDefaultVideo_URL parameters:dict progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
      //      NSLog(@"arrNotificationData >> %@",arrMatchData);
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                [appDell removeCustomLoader];

                [self getDataServiceCall];
                
                saveEdit = 0;
                [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
                [self.leftEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                [self.middleEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                [self.rightEditButton setImage:[UIImage imageNamed:@"rename_96.png"] forState:UIControlStateNormal];
                [self startTimer];

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


// show Default video assurance view

-(void)showDefaultImageVideoView:(int) vwTag{
    
    DefaultImageVideoView *defaultImgVw = [[DefaultImageVideoView alloc] init];
    defaultImgVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    defaultImgVw.delegate_defaultVideo = self;
    [defaultImgVw setUpUi];
    defaultImgVw.vwIndex = vwTag;
    [self.view addSubview:defaultImgVw];
}

// Delegate Methods

-(void)setDefaultVideo:(int)index{
    
    [self setDefaultVideoServiceCall:index];
}


//*********************************** For Instagram ***********************************************

#pragma mark -- Instagram Images & user info
// ************************************* Instagram Button Clicked ********************************************
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //  [loginIndicator startAnimating];
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        //  loginWebView.alpha = 0.2;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    //  [loginIndicator stopAnimating];
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark -
#pragma mark auth logic


- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"#access_token="];
            [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
}

-(void)makePostRequest:(NSString *)code
{
    
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableDictionary *userDic = [dict valueForKey:@"user"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[dict valueForKey:@"access_token"] forKey:@"NS_tokenId"];
    [[NSUserDefaults standardUserDefaults] setObject:[userDic valueForKey:@"id"] forKey:@"NS_userId"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self handleAuth:[dict valueForKey:@"access_token"]];
    
}

- (void) handleAuth: (NSString*) authToken
{
    NSLog(@"successfully logged in with Tocken == %@",authToken);
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"NS_tokenId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    Login *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    //    loginVC.isFacebook = NO;
    //    [self.navigationController pushViewController:loginVC animated:NO];
    
    [self userAccessForInstagram];
    [self photoAndVideoAccessForInstagramForEdit];
    [loginWebView removeFromSuperview];
}

-(void)photoAndVideoAccessForInstagramForEdit
{
    //    https://api.instagram.com/v1/users/self/media/recent/?access_token="+AccessToken
    //https://api.instagram.com/v1/media/{media-id}?access_token=ACCESS-TOKEN
    
    NSMutableArray *arrIntsagram;
    arrIntsagram = [[NSMutableArray alloc] init];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"NS_tokenId"];
    NSString *urlStr=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@",accessToken];
    NSHTTPURLResponse *response = nil;
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (responseData) {
        
        //-- JSON Parsing
        NSMutableDictionary *dataDic =[[NSMutableDictionary alloc]init];
        dataDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *arrData = [dataDic objectForKey:@"data"];
        NSMutableArray *arrImages = [NSMutableArray array];
        NSMutableArray *arrVideos = [NSMutableArray array];
        
//        for (NSDictionary *dict in arrData) {
//            NSDictionary *dictV = [dict objectForKey:@"videos"];
//            if([[dictV allKeys] count]){
//                NSString *imgUrl = [[dictV objectForKey:@"standard_resolution"] objectForKey:@"url"];
//                [arrVideos addObject:imgUrl];
//            }
//
//            NSDictionary *dictIm = [dict objectForKey:@"images"];
//            if([[dictIm allKeys] count]){
//                NSString *imgUrl = [[dictIm objectForKey:@"standard_resolution"] objectForKey:@"url"];
//                [arrImages addObject:imgUrl];
//            }
//        }
        
        for (NSDictionary *dict in arrData) {
            if ([(NSString*)[dict objectForKey:@"type"] isEqualToString:@"video"]) {
                NSDictionary *dictV = [dict objectForKey:@"videos"];
                NSDictionary *dictIm = [dict objectForKey:@"images"];
                NSString *imgUrl,*videoUrl;
                if([[dictV allKeys] count]){
                    videoUrl = [[dictV objectForKey:@"standard_resolution"] objectForKey:@"url"];
                }
                if([[dictIm allKeys] count]){
                    imgUrl = [[dictIm objectForKey:@"thumbnail"] objectForKey:@"url"];
                }
                [arrVideos addObject:[NSDictionary dictionaryWithObjectsAndKeys:imgUrl,@"thumbnail",videoUrl,@"videoUrl", nil]];
            }else{
                NSDictionary *dictIm = [dict objectForKey:@"images"];
                if([[dictIm allKeys] count]){
                    NSString *imgUrl = [[dictIm objectForKey:@"standard_resolution"] objectForKey:@"url"];
                    [arrImages addObject:imgUrl];
                }
            }
        }
        
        NSLog(@"arrVideos: %@ \narrImages - %@",arrVideos,arrImages);
        
        dictForInstagram = [[NSMutableDictionary alloc] init];
        
        [dictForInstagram setValue:arrImages forKey:@"images"];
        [dictForInstagram setValue:arrVideos forKey:@"videos"];
        
        // arrIntsagram = [arrImages mutableCopy];
        [self setAccessoryImageForEdit:arrImages];
        
        
        _vw_back.hidden = YES;
        [loginWebView removeFromSuperview];
    }
    
    
}

-(void)setAccessoryImageForEdit:(NSMutableArray *) instagramArray{
    
    facebookImageGallery *facebookImageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"facebookImageGallery"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:facebookImageGalleryVC];
    if (isUpper) {
        
        facebookImageGalleryVC.str_PageName = @"profile";
        facebookImageGalleryVC.viewNumber = imgView_no;
    }
    else{
        facebookImageGalleryVC.str_PageName = @"";
        facebookImageGalleryVC.cellDictionary = cellDetailsDict;
    }
    facebookImageGalleryVC.fbSelect = NO;
    facebookImageGalleryVC.delegate_fbImage = self;
  //  facebookImageGalleryVC.arr_instagram = instagramArray;//[instagramArray mutableCopy];
    facebookImageGalleryVC.dict_insta = dictForInstagram;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)userAccessForInstagram
{
    //https://api.instagram.com/v1/users/"+InstaUserId+"/media/recent/?access_token="+AccessToken
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"NS_tokenId"];
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"NS_userId"];
    NSString *urlStr=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@",userIdStr,accessToken];
    //https://api.instagram.com/v1/users/{user-id}/?access_token=ACCESS-TOKEN
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSMutableDictionary *dataDic =[[NSMutableDictionary alloc]init];
                dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"User Response - %@",dataDic);
                NSString *strName = [[dataDic objectForKey:@"data"] objectForKey:@"full_name"];
                dispatch_semaphore_signal(semaphore);
                
            }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

// ****************************** Facebook Login Action ****************************************

-(void)faceBookLogin{
    
    appDell.isFbSelect = YES;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends",@"user_birthday",@"user_photos",@"user_hometown"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error)
         {
             NSLog(@"Process error");
         }
         else if (result.isCancelled)
         {
             NSLog(@"Cancelled");
         }
         else
         {
             NSLog(@"Logged in");
             NSLog(@"Result - %@",result);
             NSLog(@"Token ID Result - %@",result.token.userID);
             
             [[NSUserDefaults standardUserDefaults] setObject:result.token.userID forKey:@"FBNS_tokenId"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [self fetchUserInfoForFirstTimeLogin];
             
         }
     }];
    
}

-(void)fetchUserInfoForFirstTimeLogin{
    
    
    
    if ([FBSDKAccessToken currentAccessToken]){
        
        NSString *fbaccesstoken = [[FBSDKAccessToken currentAccessToken]tokenString];
        NSLog(@"Token is available : %@",fbaccesstoken);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,cover, name,birthday,first_name,last_name,email,devices,education,hometown,video_upload_limits,picture,gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error){
                 NSLog(@"Information Results:%@",result);
                 
                 NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                 [userD setObject:result forKey:kFBLoginData];
                 [userD synchronize];
                 
//
//       //          firstNameString = [result objectForKey:@"first_name"];
//         //        genderString = [result objectForKey:@"gender"];
//                 NSString *dateStr = [result objectForKey:@"birthday"];
//
//                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                 [dateFormatter setDateFormat:@"MM/dd/yyyy"];
//                 NSDate *startD = [dateFormatter dateFromString:dateStr];
//                 NSDate *endD = [NSDate date];
//
//                 NSCalendar *calendar = [NSCalendar currentCalendar];
//                 NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
//                 NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
//
//                 NSInteger year  = [components year];
//                 NSInteger month  = [components month];
//                 NSInteger day  = [components day];
                 
            //     age = [NSString stringWithFormat:@"%li",(long)year];
                 
              //   _userInfoLabel.text = [NSString stringWithFormat:@"%@,%@,%@",firstNameString,age,genderString];
                 
             }
             else{
                 NSLog(@"Error %@",error);
             }
         }];
        
        // Fetching profile pictures
        [[[FBSDKGraphRequest alloc]  initWithGraphPath:@"me" parameters:@{@"fields": @"albums.fields(name,photos.fields(name,picture,source,created_time))"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             NSLog(@"result %@",result);
             NSArray* albums = result[@"albums"][@"data"];
             NSUInteger index = [albums indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                 return [obj[@"name"]  isEqualToString: @"Profile Pictures"];
             }];
             
             if (index != NSNotFound) {
                 NSDictionary *profileImages = albums[index];
                 NSDictionary *photos = profileImages[@"photos"];
                 NSArray *data = photos[@"data"];
                 
                 for (NSDictionary *picture in data) {
//                     NSString *picDate = picture[@"created_time"];
//                     NSString *picId = picture[@"id"];
//                     NSString *pictureUrl = picture[@"picture"];
                     NSString *sourceUrl = picture[@"source"];
                     
                     [profilePicUrlArrayFB addObject:sourceUrl];
                     
                     NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:profilePicUrlArrayFB];
                     [currentDefaults setObject:data forKey:@"kfbpicArray"];
                 }
                 NSLog(@"PICTURE URL- %@",profilePicUrlArrayFB);
                 //    [self downloadProfileImage];
                 //[self.userInfoLabel setText:[NSString stringWithFormat:@"%@,%@,%@",firstNameString,genderString,age]];
                 //  [self insertDB];
                 // [self dbchecking];
                 [appDell removeCustomLoader];
                 
                 facebookImageGallery *facebookImageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"facebookImageGallery"];
                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:facebookImageGalleryVC];
                 
                 if (isUpper) {
                     facebookImageGalleryVC.str_PageName = @"profile";
                     facebookImageGalleryVC.viewNumber = imgView_no;

                 }
                 else{
                     facebookImageGalleryVC.str_PageName = @"";
                     facebookImageGalleryVC.cellDictionary = cellDetailsDict;

                 }
                 facebookImageGalleryVC.fbSelect = YES;
                 facebookImageGalleryVC.delegate_fbImage =self;
                 facebookImageGalleryVC.arr_fb = [profilePicUrlArrayFB mutableCopy];
                 [self presentViewController:navigationController animated:YES completion:nil];
                 
             }
         }];
    }
    
    
}

//// Latitude and Longitude for User
//
//-(void)findLatLong{
//
//    geocoder = [[CLGeocoder alloc] init];
//    if (locationManager == nil)
//    {
//        locationManager = [[CLLocationManager alloc] init];
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        locationManager.delegate = self;
//        [locationManager requestAlwaysAuthorization];
//    }
//    [locationManager startUpdatingLocation];
//}
//
//#pragma mark - CLLocationManager delegate methods
//
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//
//    CLLocation *newLocation = [locations lastObject];
//
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//
//        if (error == nil && [placemarks count] > 0) {
//            placemark = [placemarks lastObject];
//
//            str_latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
//            str_longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//            str_area = placemark.administrativeArea;
//            str_country = placemark.country;
//
//            NSDictionary *locationDict = @{@"latitude" : str_latitude,
//                                           @"longitude" : str_longitude,
//                                           @"area" : str_area,
//                                           @"country":str_country
//                                           };
//            NSLog(@"latitude%@,longitude%@,area%@,country%@",str_latitude,str_longitude,str_area,str_country);
//            NSLog(@"locationDict>>>>%@",locationDict);
//
//            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//            [userD setObject:locationDict forKey:kuserLocation];
//            [userD synchronize];
//
//        } else {
//            NSLog(@"%@", error.debugDescription);
//        }
//    } ];
//
//    // Turn off the location manager to save power.
//    [manager stopUpdatingLocation];
//}

// Device Token update

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
                
              //  [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                
                
                
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
              //  [appDell removeCustomLoader];
                
                
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
- (IBAction)btnBackAction:(id)sender {
    
    _vw_back.hidden = YES;
    [loginWebView removeFromSuperview];
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
