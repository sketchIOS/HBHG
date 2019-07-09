//
//  profileFullView.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 23/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "profileFullView.h"
#import "BlockUserView.h"
#import "ReportUserView.h"
#import "CustomViewForProfile.h"
#import "InterestCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CommonHeaderFile.h"
#import <AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "FullScreenPlay.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface profileFullView ()<UICollectionViewDelegate,UICollectionViewDataSource,profileBlockDelegate,profileReportDelegate>
{
    NSArray *foodArray,*interestArray,*musicArray;

    BlockUserView *blockUserVw;
    ReportUserView *reportUserVw;
    CustomViewForProfile *customVw;
    AppDelegate *appDell;
    float height_cell;
    double screenHeight,screenWidth;

    NSTimer *timer,*timer1,*timer2,*timer3;
    int timerIndex;
    
    NSString *str_userId;
    
    // For caresuyal
    
    NSArray *arrAnimationType,*caresuyalArray,*caresuyalArray1,*caresuyalArray2;
    int sliderCount1,sliderCount2,sliderCount3;

    NSString *strVideo1,*strVideo2,*strVideo3;
    
    AVPlayerLayer *playerLayer1,*playerLayer2,*playerLayer3;
    AVPlayer *player;
}

@end
static int animationType = 0;
static int animationType1 = 0;
static int animationType2 = 0;

@implementation profileFullView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //appDell.isProfileBlock = NO;
    
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
//    _leftVw.frame = CGRectMake(0,14, screenWidth/3, _leftVw.frame.size.height);
//    _middleVw.frame= CGRectMake(_leftVw.frame.size.width, 0, screenWidth/3, _middleVw.frame.size.height);
//    _rightVw.frame= CGRectMake(_leftVw.frame.size.width + _middleVw.frame.size.width, 14, screenWidth/3, _rightVw.frame.size.height);
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    str_userId = [userD objectForKey:khbhgUserId];
    NSLog(@"str_userId>>>>>%@",str_userId);
    
    [_interest_collectionVw registerNib:[UINib nibWithNibName:@"InterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"InterestCollectionViewCell"];
    
    _interest_collectionVw.delegate = self;
    _interest_collectionVw.dataSource = self;
    
  //  NSLog(@"_arrProfileData>>%@",_arrProfileData);
    NSLog(@"_dictProfileData>>>>>%@",_dictProfileData);
    
    // Button Actions
    
    [self.btn_Eats addTarget:self action:@selector(EatsBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self.btn_Loves addTarget:self action:@selector(LovesBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self.btn_Music addTarget:self action:@selector(ListenBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.leftEditButton addTarget:self action:@selector(leftEditBtnClick)forControlEvents:UIControlEventTouchUpInside];
    [self.middleEditButton addTarget:self action:@selector(middleEditBtnClick)forControlEvents:UIControlEventTouchUpInside];
    [self.rightEditButton addTarget:self action:@selector(rightEditBtnClick)forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_Eats setSelected:YES];
    [self.btn_Loves setSelected:NO];
    [self.btn_Music setSelected:NO];
    
    
    arrAnimationType = [NSArray arrayWithObjects:@"1",@"9",@"10", nil];//@"5",@"6",
    caresuyalArray = [NSArray array];
    self.carousel_middle.delegate = self;
    self.carousel_middle.dataSource = self;
    
    caresuyalArray1 = [NSArray array];
    self.carousel_left.delegate = self;
    self.carousel_left.dataSource = self;
    
    caresuyalArray2 = [NSArray array];
    self.carousel_right.delegate = self;
    self.carousel_right.dataSource = self;
    
    [self profileDataManage];
    [self startTimer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_BackAction:(id)sender {
    [timer invalidate];
    timer = nil;
    
    [timer1 invalidate];
    timer1 = nil;
    
    [timer2 invalidate];
    timer2 = nil;
    
    [timer3 invalidate];
    timer3 = nil;
    
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    
}

-(void)leftEditBtnClick{
    
    FullScreenPlay *fullScreenPlayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenPlay"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fullScreenPlayVC];
    if (strVideo2.length) {
        
        fullScreenPlayVC.isVideoString = YES;
    }
    
    else{
        fullScreenPlayVC.isVideoString = NO;

    }
    fullScreenPlayVC.arr_images = [caresuyalArray1 mutableCopy];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)middleEditBtnClick{
    
    FullScreenPlay *fullScreenPlayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenPlay"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fullScreenPlayVC];
    if (strVideo1.length) {
        
        fullScreenPlayVC.isVideoString = YES;
    }
    
    else{
        fullScreenPlayVC.isVideoString = NO;
        
    }
    
    fullScreenPlayVC.arr_images = [caresuyalArray mutableCopy];
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)rightEditBtnClick{
    
    FullScreenPlay *fullScreenPlayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenPlay"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fullScreenPlayVC];
    
    if (strVideo2.length) {
        
        fullScreenPlayVC.isVideoString = YES;
    }
    
    else{
        fullScreenPlayVC.isVideoString = NO;
        
    }
    
    fullScreenPlayVC.arr_images = [caresuyalArray2 mutableCopy];

    [self presentViewController:navigationController animated:YES completion:nil];
}



-(void)EatsBtnClick:(UIButton*)sender
{
//    [self.btn_Eats setImage:[UIImage imageNamed:@"button_eat.png"] forState:UIControlStateNormal];
//    [self.btn_Loves setImage:[UIImage imageNamed:@"button_love2.png"] forState:UIControlStateNormal];
//    [self.btn_Music setImage:[UIImage imageNamed:@"button_listen2.png"] forState:UIControlStateNormal];
    timerIndex = (int)sender.tag;
    
    [self.btn_Eats setSelected:YES];
    [self.btn_Loves setSelected:NO];
    [self.btn_Music setSelected:NO];
    
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
        
    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
        
    }
    
    _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);

}

-(void)LovesBtnClick:(UIButton*)sender
{
//    [self.btn_Eats setImage:[UIImage imageNamed:@"button_eat2.png"] forState:UIControlStateNormal];
//    [self.btn_Loves setImage:[UIImage imageNamed:@"button_love.png"] forState:UIControlStateNormal];
//    [self.btn_Music setImage:[UIImage imageNamed:@"button_listen2.png"] forState:UIControlStateNormal];
    
    timerIndex = (int)sender.tag;
    
    [self.btn_Eats setSelected:NO];
    [self.btn_Loves setSelected:YES];
    [self.btn_Music setSelected:NO];
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
        
    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
        
    }
    
    
    
    _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 16, 0.0);
}


-(void)ListenBtnClick:(UIButton*)sender
{
//    [self.btn_Eats setImage:[UIImage imageNamed:@"button_eat2.png"] forState:UIControlStateNormal];
//    [self.btn_Loves setImage:[UIImage imageNamed:@"button_love2.png"] forState:UIControlStateNormal];
//    [self.btn_Music setImage:[UIImage imageNamed:@"button_listen.png"] forState:UIControlStateNormal];
    
    timerIndex = (int)sender.tag;
    
    [self.btn_Eats setSelected:NO];
    [self.btn_Loves setSelected:NO];
    [self.btn_Music setSelected:YES];
    
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);
        
    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);
        
    }
    
    
    
    _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 28, 0.0);
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
        
        [self.btn_Eats setSelected:YES];
        [self.btn_Loves setSelected:NO];
        [self.btn_Music setSelected:NO];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
            
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375){
            
            _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
            
        }
        
        _interest_collectionVw.contentOffset = CGPointMake(0.0, 0.0);
        
    }
    
    else if (timerIndex == 1){
        
        [self.btn_Eats setSelected:NO];
        [self.btn_Loves setSelected:YES];
        [self.btn_Music setSelected:NO];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
            
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375){
            
            _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 18, 0.0);
            
        }
        
        
        
        _interest_collectionVw.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 16, 0.0);
        
    }
    
    else if (timerIndex == 2){
        
        [self.btn_Eats setSelected:NO];
        [self.btn_Loves setSelected:NO];
        [self.btn_Music setSelected:YES];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);
            
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375){
            
            _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 32, 0.0);
            
        }
        
        
        
        _interest_collectionVw.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width - 28, 0.0);
        
    }
    
}

//*************************************************************************************************

- (IBAction)btn_blockUser:(id)sender {
    
    blockUserVw = [[BlockUserView alloc] init];
    blockUserVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [blockUserVw setUpUi];
    blockUserVw.delegate_profileBlock = self;
    [self.view addSubview:blockUserVw];
}
// Block user Delegate

-(void)profileBlock{
    
   // NSDictionary *dict = [_arrProfileData objectAtIndex:_profileindex];
    NSDictionary *dict_basicinfo = [_dictProfileData objectForKey:@"basic_info"];
    
    NSDictionary *blockedProfile_dict = @{
                                          @"block_user_id":[NSString stringWithFormat:@"%@",[dict_basicinfo objectForKey:@"id"]],
                                          @"user_id" : str_userId,//,@"15"
                                          @"token" : @"adsahtoikng"
                                          };
    
    NSLog(@"blockedProfile_dict>>>><%@",blockedProfile_dict);
    [self blockuserServiceCall:blockedProfile_dict];
}


- (IBAction)btn_ReportUser:(id)sender {
    
    reportUserVw = [[ReportUserView alloc] init];
    
    reportUserVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [reportUserVw setUpUi];
    reportUserVw.delegate_profileReport = self;
    [self.view addSubview:reportUserVw];
}

// report user profile

-(void)profileReport:(NSString *)strReason{
    
 //   NSDictionary *dict = [_arrProfileData objectAtIndex:_profileindex];
    NSDictionary *dict_basicinfo = [_dictProfileData objectForKey:@"basic_info"];
    
    NSDictionary *reportProfile_dict = @{
                                          @"report_user_id":[NSString stringWithFormat:@"%@",[dict_basicinfo objectForKey:@"id"]],
                                          @"user_id" : str_userId,//,@"15"
                                          @"token" : @"adsahtoikng",
                                          @"description" : strReason
                                          };
    
    NSLog(@"blockedProfile_dict>>>><%@",reportProfile_dict);
    [self reportUserServiceCall:reportProfile_dict];
    
}



-(void)profileDataManage{
    
 //   NSDictionary *dict = [_arrProfileData objectAtIndex:_profileindex];
    NSDictionary *dict_basicinfo = [_dictProfileData objectForKey:@"basic_info"];
    
    
    NSString *strName = [dict_basicinfo objectForKey:@"name"];
    NSArray *nameArray = [strName componentsSeparatedByString:@" "];
    NSString *str_fName = [nameArray objectAtIndex:0];
    
    NSString *strGender = [dict_basicinfo objectForKey:@"gender"];
    
    if ([strGender isEqualToString:@"m"]) {
        _lbl_profileDetails.text = [NSString stringWithFormat:@"%@ ,%@ ,%@ ,%@",str_fName,[dict_basicinfo objectForKey:@"age"],@"Male",[dict_basicinfo objectForKey:@"city"]];
    }
    else if ([strGender isEqualToString:@"f"]){
        
        _lbl_profileDetails.text = [NSString stringWithFormat:@"%@ ,%@ ,%@ ,%@",str_fName,[dict_basicinfo objectForKey:@"age"],@"female",[dict_basicinfo objectForKey:@"city"]];
    }
    else{
        
        _lbl_profileDetails.text = [NSString stringWithFormat:@"%@ ,%@ ,%@ ,%@",str_fName,[dict_basicinfo objectForKey:@"age"],strGender,[dict_basicinfo objectForKey:@"city"]];
    }
    
    foodArray = [_dictProfileData objectForKey:@"food_data"];
    interestArray = [_dictProfileData objectForKey:@"interest_data"];
    musicArray = [_dictProfileData objectForKey:@"music_data"];
    
    [self careosalDataSource];
}

 //CollectioView Delegate and datsource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    InterestCollectionViewCell *cell = [_interest_collectionVw dequeueReusableCellWithReuseIdentifier:@"InterestCollectionViewCell" forIndexPath:indexPath];
    
    // **************************************************************************
    // Getting Data from My match page
    //**************************************************************************
    
   
    
    if (indexPath.row < 3)
    {
        
        if (foodArray.count) {
            
            if (foodArray.count > 0 && indexPath.row == 0) {
                
                NSDictionary  *foodDict = [foodArray objectAtIndex:0];
                NSLog(@"foodDict>>>>>>%@",foodDict);
                
                NSString *imageURLPath = [foodDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                     //   cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [foodDict valueForKey:@"title"];
            }
            
            else if (foodArray.count > 1 && indexPath.row == 1){
                
                NSDictionary  *foodDict = [foodArray objectAtIndex:1];
                NSLog(@"foodDict>>>>>>%@",foodDict);
                
                NSString *imageURLPath = [foodDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                     //   cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [foodDict valueForKey:@"title"];
                
            }
            
            else if (foodArray.count > 2 && indexPath.row == 2){
                
                NSDictionary  *foodDict = [foodArray objectAtIndex:2];
                NSLog(@"foodDict>>>>>>%@",foodDict);
                
                NSString *imageURLPath = [foodDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                      //  cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [foodDict valueForKey:@"title"];
                
            }
        }
        else{
            
            cell.lbl_Interest.text = @"Add Pic";
            
        }
    }
    
    if (indexPath.row > 2 && indexPath.row < 6)
    {
        if (interestArray.count) {
            
            if (interestArray.count > 0 && indexPath.row == 3) {
                
                NSDictionary *interestDict = [interestArray objectAtIndex:0];
                NSLog(@"interestDict>>>>%@",interestDict);
                
                NSString *imageURLPath = [interestDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                     //   cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width , cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [interestDict valueForKey:@"title"];
            }
            else if (interestArray.count > 1 && indexPath.row == 4){
                
                NSDictionary *interestDict = [interestArray objectAtIndex:1];
                NSLog(@"interestDict>>>>%@",interestDict);
                
                NSString *imageURLPath = [interestDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                      //  cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [interestDict valueForKey:@"title"];
            }
        }
        
        else{
            
            cell.lbl_Interest.text = @"Add Pic";
            
        }
    }
    
    if (indexPath.row > 5 && indexPath.row < 9){
        
        if(musicArray.count){
            
            if (musicArray.count > 0 && indexPath.row == 6) {
                
                NSDictionary *musicDict = [musicArray objectAtIndex:0];
                NSLog(@"musicDict>>>>%@",musicDict);
                
                NSString *imageURLPath = [musicDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                      //  cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width + 50, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [musicDict valueForKey:@"title"];
            }
            else if (musicArray.count > 1 && indexPath.row == 7){
                
                NSDictionary *musicDict = [musicArray objectAtIndex:1];
                NSLog(@"interestDict>>>>%@",musicDict);
                
                NSString *imageURLPath = [musicDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                       // cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width + 50, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [musicDict valueForKey:@"title"];
            }
            
            else if (musicArray.count > 2 && indexPath.row == 8){
                
                NSDictionary *musicDict = [musicArray objectAtIndex:2];
                NSLog(@"interestDict>>>>%@",musicDict);
                
                NSString *imageURLPath = [musicDict valueForKey:@"photo"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_interest sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                      //  cell.img_interest.image = image;
                        cell.img_interest.image = [self squareImageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width + 50, cell.frame.size.height - 30)];
                    }
                }];
                
                cell.lbl_Interest.text = [musicDict valueForKey:@"title"];
            }
        }
        else{
            
            cell.lbl_Interest.text = @"Add Pic";
            
        }
    }
    
    height_cell = cell.img_interest.frame.size.height + cell.lbl_Interest.frame.size.height;
    
    // NSLog(@"height_cell %f",height_cell);
    
    return cell;
}

//Jitendra
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.0299), 150);
    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/3-([UIScreen mainScreen].bounds.size.width*0.026), 171);
        
    }else if ([UIScreen mainScreen].bounds.size.width == 414){
        
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/3-([UIScreen mainScreen].bounds.size.width*0.023), 181);
        
    }else{
        NSLog(@"width=%f",[UIScreen mainScreen].bounds.size.width);
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.026), 171);
        
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


#pragma mark iCarousel methods

-(void)careosalDataSource{
 //   NSDictionary *dict = [_arrProfileData objectAtIndex:_profileindex];
    NSDictionary *dict_basicInfo = [_dictProfileData objectForKey:@"basic_info"];
    
    strVideo1 = [dict_basicInfo objectForKey:@"video"];
    if (strVideo1.length) {
        caresuyalArray = [NSArray arrayWithObject:strVideo1];
    }else{
        caresuyalArray = [dict_basicInfo objectForKey:@"image_video"];
    }
    if (strVideo2.length) {
        caresuyalArray1 = [NSArray arrayWithObject:strVideo2];
    }else{
        caresuyalArray1 = [dict_basicInfo objectForKey:@"second_image_video"];
    }
    if (strVideo3.length) {
        caresuyalArray2 = [NSArray arrayWithObject:strVideo3];
    }else{
        caresuyalArray2 = [dict_basicInfo objectForKey:@"third_image_video"];
    }
    
    sliderCount1 = 0;
    animationType = 0;
    [self.carousel_middle reloadData];
    
    _carousel_middle.tag = 1;
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
    
    sliderCount2 = 0;
    animationType1 = 2;
    [self.carousel_left reloadData];
    _carousel_left.tag = 2;

    timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodleft) userInfo:nil repeats:YES];
    
    sliderCount3 = 0;
    animationType2 = 4;
    [self.carousel_right reloadData];
    _carousel_right.tag = 3;

    timer3 =[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethodright) userInfo:nil repeats:YES];

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
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.middleVw.frame.size.width, _middleVw.frame.size.height)];
            view.backgroundColor = [UIColor blackColor];
            
            NSURL *url1 = [NSURL URLWithString:strVideo1];
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
            playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:player];
            playerLayer1.videoGravity=AVLayerVideoGravityResizeAspectFill;

            playerLayer1.frame = CGRectMake(0, 0, self.middleVw.frame.size.width, _middleVw.frame.size.height);
            [view.layer addSublayer:playerLayer1];
            //[player play];
            [player play];
            player.muted = true;
        }else{
        
        if (view == nil)
        {
            NSString *imgpath = [caresuyalArray objectAtIndex:index];
            
            NSLog(@"imagePath >>> %@",imgpath);
            
            UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.middleVw.frame.size.width, _middleVw.frame.size.height)];
            
            [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    imgVw.image = image;
                    imgVw.contentMode = UIViewContentModeScaleAspectFill;
                }
            }];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.middleVw.frame.size.width, _middleVw.frame.size.height)];
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
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftVw.frame.size.width, _leftVw.frame.size.height)];
            view.backgroundColor = [UIColor blackColor];
            
            NSURL *url1 = [NSURL URLWithString:strVideo2];
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
            playerLayer2 = [AVPlayerLayer playerLayerWithPlayer:player];
            playerLayer2.videoGravity=AVLayerVideoGravityResizeAspectFill;

            playerLayer2.frame = CGRectMake(0, 0, self.leftVw.frame.size.width, _leftVw.frame.size.height);
            [view.layer addSublayer:playerLayer2];
            //[player play];
            [player play];
            player.muted = true;
        }else{
        
        if (view == nil)
        {
            NSString *imgpath = [caresuyalArray1 objectAtIndex:index];
            
            NSLog(@"imagePath >>> %@",imgpath);
            
            UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.leftVw.frame.size.width, _leftVw.frame.size.height)];
            
            [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    imgVw.image = image;
                    imgVw.contentMode = UIViewContentModeScaleAspectFill;
                }
            }];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftVw.frame.size.width, _leftVw.frame.size.height)];
            view.backgroundColor = [UIColor clearColor];
            imgVw.tag = 101;

            [view addSubview:imgVw];
        }
        else{
            UIImageView *imgVw = (UIImageView *)[view viewWithTag:102];
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
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rightVw.frame.size.width, _rightVw.frame.size.height)];
            view.backgroundColor = [UIColor blackColor];
            
            NSURL *url1 = [NSURL URLWithString:strVideo3];
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
            playerLayer3 = [AVPlayerLayer playerLayerWithPlayer:player];
            playerLayer3.videoGravity=AVLayerVideoGravityResizeAspectFill;

            playerLayer3.frame = CGRectMake(0, 0, self.rightVw.frame.size.width, _rightVw.frame.size.height);
            [view.layer addSublayer:playerLayer3];
            //[player play];
            [player play];
            player.muted = true;
        }else{
        
        if (view == nil)
        {
            NSString *imgpath = [caresuyalArray2 objectAtIndex:index];
            
            NSLog(@"imagePath >>> %@",imgpath);
            
            UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.rightVw.frame.size.width, _rightVw.frame.size.height)];
            
            [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    imgVw.image = image;
                    imgVw.contentMode = UIViewContentModeScaleAspectFill;
                }
            }];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rightVw.frame.size.width, _rightVw.frame.size.height)];
            view.backgroundColor = [UIColor clearColor];
            imgVw.tag = 101;

            [view addSubview:imgVw];
        }
        else{
            UIImageView *imgVw = (UIImageView *)[view viewWithTag:103];
            [imgVw sd_setImageWithURL:[NSURL URLWithString:[caresuyalArray2 objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    imgVw.image = image;
                    imgVw.contentMode = UIViewContentModeScaleAspectFill;
                }
            }];
        }
    }
 }  //create new view if no view is available for recycling
    
    
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
            sliderCount1=0;
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
            sliderCount1=0;
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
                
                appDell.isProfileBlock = YES;
                [self.navigationController popViewControllerAnimated:YES];

      //          [self.delegate_profileFullView blockUserProfile];
                
   //             [appDell setMyMatchPage];
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
