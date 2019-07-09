//
//  ChatPage.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 22/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "ProfilePage.h"
#import "ChatPage.h"
#import "explorePage.h"
#import "myMatchesPage.h"
#import "notificationPage.h"
#import "createNewChatRoom.h"
#import "AppDelegate.h"
#import "MyChatCollectionViewCell.h"
#import <AFHTTPSessionManager.h>
#import "CommonHeaderFile.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ChatroomCollectionViewCell.h"
#import "SingleChatViewController.h"
#import "ChatViewController.h"

@interface ChatPage ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    AppDelegate *appDell;
    NSMutableArray *arr_myChat,*arr_tradingChat,*arr_featuredChat,*arrProfileMatched,*arrData;
    NSString *str_userId;
    NSDictionary *dict_adminDetails;
    int indexId;
    NSMutableArray *tmpArray,*arrNotiId,*arrChatroomNotiId, *arrFeaturedChatroomID;
    
    BOOL isAdminFound;
}
@property (strong, nonatomic) IBOutlet UIView *searchBackImageVw;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *layoutTrading;

@property (strong, nonatomic) IBOutlet UIButton *createNewChatRoomButton;
- (IBAction)profileButton:(id)sender;
- (IBAction)chatButton:(id)sender;
- (IBAction)exploreButton:(id)sender;
- (IBAction)myMatchesButton:(id)sender;
- (IBAction)notificationButton:(id)sender;

@end

@implementation ChatPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.searchBackImageVw layer] setCornerRadius:5.0f];
    [[self.searchBackImageVw layer] setMasksToBounds:YES];
    
    self.createNewChatRoomButton.layer.borderWidth = 1.0f;
    self.createNewChatRoomButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [[self.createNewChatRoomButton layer] setCornerRadius:15.0f];
    [[self.createNewChatRoomButton layer] setMasksToBounds:YES];
    
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    indexId = 0;
    isAdminFound = NO;
    arrData = [[NSMutableArray alloc] init];
    arrChatroomNotiId = [[NSMutableArray alloc] init];
    arrNotiId = [[NSMutableArray alloc] init];
    tmpArray = [[NSMutableArray alloc] init];
    arr_myChat = [[NSMutableArray alloc] init];
    arr_tradingChat = [[NSMutableArray alloc] init];
    arr_featuredChat = [[NSMutableArray alloc] init];
    arrProfileMatched = [[NSMutableArray alloc] init];
    arrFeaturedChatroomID = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    str_userId = [userD objectForKey:khbhgUserId];
    NSLog(@"str_userId>>>>>%@",str_userId);
    
    [_myChat_collectionVw registerNib:[UINib nibWithNibName:@"MyChatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyChatCollectionViewCell"];
    
    _myChat_collectionVw.delegate = self;
    _myChat_collectionVw.dataSource = self;
    
    [_featuredChat_collectionVw registerNib:[UINib nibWithNibName:@"ChatroomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChatroomCollectionViewCell"];
    
    _featuredChat_collectionVw.delegate = self;
    _featuredChat_collectionVw.dataSource = self;
    
    [_tradingChat_collectionVw registerNib:[UINib nibWithNibName:@"ChatroomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChatroomCollectionViewCell"];
    
    _tradingChat_collectionVw.delegate = self;
    _tradingChat_collectionVw.dataSource = self;
    
    [_myChatRoom_collectionVw registerNib:[UINib nibWithNibName:@"ChatroomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChatroomCollectionViewCell"];
    
    _myChatRoom_collectionVw.delegate = self;
    _myChatRoom_collectionVw.dataSource = self;
    
    [_scrollVW setContentSize:CGSizeMake(0, 500)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
   // [currentDefaults removeObjectForKey:@"kmatchProfileResponseDetails"];
    
    NSData *data = [currentDefaults objectForKey:@"kmatchProfileResponseDetails"];
    NSDictionary *dict_data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([dict_data allKeys] > 0){
        
        [tmpArray removeAllObjects];
        [arrProfileMatched removeAllObjects];
        [arr_myChat removeAllObjects];
        [arr_tradingChat removeAllObjects];
        [arr_featuredChat removeAllObjects];
        
        NSLog(@"dict_data>>>>>>%@",dict_data);
        dict_adminDetails = [dict_data objectForKey:@"admin_details"];
        NSLog(@"dict_adminDetails>>>>%@",dict_adminDetails);
        
        NSData *data1 = [currentDefaults objectForKey:@"ksinglechatUserArray"];
        NSData *data2 = [currentDefaults objectForKey:@"kchatroomArray"];
        
        arrProfileMatched = [[NSKeyedUnarchiver unarchiveObjectWithData:data1] mutableCopy];
        arr_myChat = [[NSKeyedUnarchiver unarchiveObjectWithData:data2] mutableCopy];
        
        for (int i = 0; i < arrProfileMatched.count; i++) {
            
            NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:i];
            NSLog(@"dict_myChat>>>>%@",dict_myChat);
            
            NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
            
          NSString  *id_string  = [dict_besic_info objectForKey:@"id"];
            
            if ([id_string isEqualToString:@"1"]) {
                
                isAdminFound = YES;
                break;
                
            }
        }
        
        if (isAdminFound == NO) {
            
           [arrProfileMatched addObject:dict_adminDetails];
        }
        
        
     //   [arrProfileMatched addObject:dict_adminDetails];
        
     //   arr_myChat = [[dict_data objectForKey:@"my_chatrooms"] mutableCopy];
        arr_featuredChat = [[dict_data objectForKey:@"featured_chatrooms"] mutableCopy];
        arr_tradingChat = [[dict_data objectForKey:@"trending_chatrooms"] mutableCopy];
      //  arrProfileMatched = [[dict_data objectForKey:@"data"] mutableCopy];
        NSLog(@"arr_myChat>>>>>>%@",arr_myChat);
        
        
         NSLog(@"strSingleChat%@",appDell.strSingleChatId);
        NSLog(@"strChatroomId%@",appDell.strChtroomId);
        
        
        if ([appDell.strSingleChatId intValue] > 0) {
 
    //        arr_myChat = [[dict_data objectForKey:@"my_chatrooms"] mutableCopy];

            NSLog(@"strSingleChat%@",appDell.strSingleChatId);
            
            for (int i = 0; i < arrProfileMatched.count; i++) {
                
                NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:i];
                NSLog(@"dict_myChat>>>>%@",dict_myChat);
                
                NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
                
                NSString *id_string = [dict_besic_info objectForKey:@"id"];
                
                if ([id_string isEqualToString:appDell.strSingleChatId]) {
                    
                    indexId = i;
                    
                    [ tmpArray addObject:[arrProfileMatched objectAtIndex:i]];
                    
                    break;
                }
                
            }
            
            [arrProfileMatched removeObjectAtIndex:indexId];
            [tmpArray addObjectsFromArray:arrProfileMatched];
            [arrProfileMatched removeAllObjects];
            arrProfileMatched = [tmpArray mutableCopy];

            NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrProfileMatched];
            [currentDefaults setObject:data forKey:@"ksinglechatUserArray"];
        }
        
        if ([appDell.strChtroomId intValue] > 0) {
            
            [tmpArray removeAllObjects];

            for (int i = 0; i < arr_myChat.count; i++) {
                
                NSDictionary *dict_myChatroom = [arr_myChat objectAtIndex:i];//
                NSLog(@"dict_myChatroom>>>>%@",dict_myChatroom);
                
             //   NSDictionary *dict_besic_info = [dict_myChatroom objectForKey:@"basic_info"];
                
                NSString *id_string = [dict_myChatroom objectForKey:@"id"];
                
                if ([id_string isEqualToString:appDell.strChtroomId]) {
                    
                    indexId = i;
                    
                    [ tmpArray addObject:[arr_myChat objectAtIndex:i]];
                    
                    break;
                }
                
            }
            
            [arr_myChat removeObjectAtIndex:indexId];
            [tmpArray addObjectsFromArray:arr_myChat];
            [arr_myChat removeAllObjects];
            arr_myChat = [tmpArray mutableCopy];

            NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr_myChat];
            [currentDefaults setObject:data forKey:@"kchatroomArray"];
        }
      
        [_myChat_collectionVw reloadData];
        [_myChatRoom_collectionVw reloadData];
        [_tradingChat_collectionVw reloadData];
        [_featuredChat_collectionVw reloadData];
    }
    else{
        
        [self myMatchServiceCall];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)profileButton:(id)sender {
    //    ProfilePage *profilePageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
    //    [self.navigationController pushViewController:profilePageVC animated:NO];
    [appDell setProfile];
}

- (IBAction)chatButton:(id)sender {
    
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

- (IBAction)exploreButton:(id)sender {
    //    explorePage *explorePageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"explorePage"];
    //    [self.navigationController pushViewController:explorePageVC animated:NO];
    [appDell setExplorePage];
}

- (IBAction)btnNewChatrromAction:(id)sender {
    
    createNewChatRoom *createNewChatRoomVC = [self.storyboard instantiateViewControllerWithIdentifier:@"createNewChatRoom"];
    [self.navigationController pushViewController:createNewChatRoomVC animated:NO];
    
}

// ************************ Mychat Collectionview Delegate and datasource ***********************************************

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _myChat_collectionVw) {
        
        return arrProfileMatched.count ;
    }
    
    if (collectionView == _featuredChat_collectionVw) {
        
        return arr_featuredChat.count;
    }
    
    if (collectionView == _tradingChat_collectionVw) {

        return arr_tradingChat.count;
    }

    if (collectionView == _myChatRoom_collectionVw) {
        return arr_myChat.count;
    }
    
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    NSString *id_string;
    
    if (collectionView == _myChat_collectionVw) {
        
        MyChatCollectionViewCell *cell = [_myChat_collectionVw dequeueReusableCellWithReuseIdentifier:@"MyChatCollectionViewCell" forIndexPath:indexPath];
        
//        if (indexPath.row == 0) {
//
//            NSDictionary *dict_besic_info = [dict_adminDetails objectForKey:@"basic_info"];
//            NSLog(@"dict_besic_info>>>>%@",dict_besic_info);
//
//            cell.vw_newChat.hidden = YES;
//            cell.lbl_name.text = [dict_besic_info objectForKey:@"first_name"];
//
//            NSString *imageURLPath = [dict_besic_info valueForKey:@"profile_image"];
//            NSLog(@"foodDict>>>>>>%@",imageURLPath);
//
//            [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if(image){
//                    cell.img_vw.image = image;
//                }
//            }];
//
//            id_string  = [dict_besic_info objectForKey:@"id"];
//
//        }
//        else{
//            NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:indexPath.row - 1];
//            NSLog(@"dict_myChat>>>>%@",dict_myChat);
//
//            NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
//
//            NSString *nameString= [dict_besic_info objectForKey:@"name"];
//            NSArray *nameArray = [nameString componentsSeparatedByString:@" "];
//
//            cell.lbl_name.text = [nameArray objectAtIndex:0] ;
//
//            NSString *imageURLPath = [dict_besic_info valueForKey:@"profile_image"];
//            NSLog(@"foodDict>>>>>>%@",imageURLPath);
//
//            [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if(image){
//                    cell.img_vw.image = image;
//                }
//            }];
//
//           id_string  = [dict_besic_info objectForKey:@"id"];
//
//        }
        
        NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:indexPath.row ];
                    NSLog(@"dict_myChat>>>>%@",dict_myChat);
        
                    NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
        
                    id_string  = [dict_besic_info objectForKey:@"id"];

        if ([id_string isEqualToString:@"1"]) {
            
            cell.lbl_name.text = [dict_besic_info objectForKey:@"first_name"] ;
            NSString *imageURLPath = [dict_besic_info valueForKey:@"profile_image"];
            NSLog(@"foodDict>>>>>>%@",imageURLPath);
            
            [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    cell.img_vw.image = image;
                }
            }];
        }
        else{
           
            NSString *nameString= [dict_besic_info objectForKey:@"name"];
            NSArray *nameArray = [nameString componentsSeparatedByString:@" "];
            
            cell.lbl_name.text = [nameArray objectAtIndex:0] ;
            
            NSString *imageURLPath = [dict_besic_info valueForKey:@"profile_image"];
            NSLog(@"foodDict>>>>>>%@",imageURLPath);
            
            [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    cell.img_vw.image = image;
                }
            }];
        }
        
        
        if (appDell.arrNotiId.count) {
            
            NSLog(@"appDell.arrNotiId>>>>>%@",appDell.arrNotiId);
            
            for (int i = 0; i < appDell.arrNotiId.count; i++) {
                
                NSString *notificationId = [appDell.arrNotiId objectAtIndex:i];
                
                if ([id_string isEqualToString: notificationId]) {
                    
                    cell.vw_newChat.hidden = NO;
                    cell.vw_newChat.backgroundColor = [UIColor whiteColor];
                    cell.vw_newChat.layer.cornerRadius = cell.vw_newChat.frame.size.width / 2;
                    break;
                }
                else{
                    
                    cell.vw_newChat.hidden = YES;
                    
                }
            }
        }
        else{
            
            cell.vw_newChat.hidden = YES;
            
        }
        
        
        cell.img_vw.layer.cornerRadius = cell.img_vw.frame.size.width / 2;
        cell.img_vw.clipsToBounds = YES;
        cell.img_vw.layer.borderWidth = 2.0f;
        cell.img_vw.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        return cell;
    }
    
    else{

        
         if (collectionView == _featuredChat_collectionVw){
             
              ChatroomCollectionViewCell *cell = [_featuredChat_collectionVw dequeueReusableCellWithReuseIdentifier:@"ChatroomCollectionViewCell" forIndexPath:indexPath];
            
            NSDictionary *dict_myChat = [arr_featuredChat objectAtIndex:indexPath.row];
            NSLog(@"dict_myChat>>>>%@",dict_myChat);
            
            cell.lbl_name.text = [dict_myChat objectForKey:@"title"];
            
             NSString *str_contentType = [dict_myChat objectForKey:@"content_type"];
             
             if ([str_contentType isEqualToString:@"2"]) {
                 
                 NSString *imageURLPath = [dict_myChat valueForKey:@"content_img"];
                 NSLog(@"foodDict>>>>>>%@",imageURLPath);
                 
                 [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     if(image){
                         cell.img_vw.image = image;
                     }
                 }];
             }
             else{
                 
                 NSString *imageURLPath = [dict_myChat valueForKey:@"content_video_img"];
                 NSLog(@"foodDict>>>>>>%@",imageURLPath);
                 
                 [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     if(image){
                         cell.img_vw.image = image;
                     }
                 }];
             }
            
             
             cell.img_vw.layer.borderWidth = 2.0f;
             cell.img_vw.layer.borderColor = [UIColor whiteColor].CGColor;
    
             NSMutableArray *arrFeatured = [[NSMutableArray alloc] init];
             
             NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
             arrFeatured = [userD objectForKey:kFeaturedChatroomID] ;
             NSLog(@"arrFeatured>>>>>%@",arrFeatured);
             
             NSString *str_featuredChatId = [NSString stringWithFormat:@"%@",[dict_myChat objectForKey:@"id"]];
             cell.vw_newChat.hidden = NO;
             cell.vw_newChat.layer.cornerRadius = cell.vw_newChat.frame.size.width / 2;
             cell.imgNewchat.image = [UIImage imageNamed:@"circular_orage"];
             if (arrFeatured.count) {
                 
                 for (int i = 0; i < arrFeatured.count; i++) {
                     
                     NSString *str_id = [NSString stringWithFormat:@"%@",[arrFeatured objectAtIndex:i]];
                     
                     if ([str_featuredChatId isEqualToString:str_id]) {
                         
                         cell.vw_newChat.hidden = YES;
                         break;

                     }
                 }
             }             
             
             
             return cell;
        }
        
         else if (collectionView == _tradingChat_collectionVw){
             
              ChatroomCollectionViewCell *cell = [_tradingChat_collectionVw dequeueReusableCellWithReuseIdentifier:@"ChatroomCollectionViewCell" forIndexPath:indexPath];
             
                         NSDictionary *dict_myChat = [arr_tradingChat objectAtIndex:indexPath.row];
                         NSLog(@"dict_myChat>>>>%@",dict_myChat);
             
                         cell.lbl_name.text = [dict_myChat objectForKey:@"title"];
             
             NSString *str_contentType = [dict_myChat objectForKey:@"content_type"];
             
             if ([str_contentType isEqualToString:@"2"]) {
                 
                 NSString *imageURLPath = [dict_myChat valueForKey:@"content_img"];
                 NSLog(@"foodDict>>>>>>%@",imageURLPath);
                 
                 [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     if(image){
                         cell.img_vw.image = image;
                     }
                 }];
             }
             else{
                 
                 NSString *imageURLPath = [dict_myChat valueForKey:@"content_video_img"];
                 NSLog(@"foodDict>>>>>>%@",imageURLPath);
                 
                 [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     if(image){
                         cell.img_vw.image = image;
                     }
                 }];
             }
             cell.img_vw.layer.borderWidth = 2.0f;
             cell.img_vw.layer.borderColor = [UIColor whiteColor].CGColor;
             cell.vw_newChat.hidden = YES;

             return cell;
         }
        
        else if (collectionView == _myChatRoom_collectionVw){
            
             ChatroomCollectionViewCell *cell = [_myChatRoom_collectionVw dequeueReusableCellWithReuseIdentifier:@"ChatroomCollectionViewCell" forIndexPath:indexPath];

            NSDictionary *dict_myChat = [arr_myChat objectAtIndex:indexPath.row];
            NSLog(@"dict_myChat>>>>%@",dict_myChat);

            cell.lbl_name.text = [dict_myChat objectForKey:@"title"];

            NSString *str_contentType = [dict_myChat objectForKey:@"content_type"];
            
            if ([str_contentType isEqualToString:@"2"]) {
                
                NSString *imageURLPath = [dict_myChat valueForKey:@"content_img"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        cell.img_vw.image = image;
                    }
                }];
            }
            else{
                
                NSString *imageURLPath = [dict_myChat valueForKey:@"content_video_img"];
                NSLog(@"foodDict>>>>>>%@",imageURLPath);
                
                [cell.img_vw sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        cell.img_vw.image = image;
                    }
                }];
            }
            
            NSString *id_string1 = [dict_myChat objectForKey:@"id"];

            if (appDell.arrChatroomNotiId.count) {
                
                for (int i = 0; i < appDell.arrChatroomNotiId.count; i++) {
                    
                    NSString *chatroomNotiId =  [appDell.arrChatroomNotiId objectAtIndex:i];
                    
                    if ([id_string1 isEqualToString:chatroomNotiId]) {
                        cell.vw_newChat.hidden = NO;
                        cell.vw_newChat.layer.cornerRadius = cell.vw_newChat.frame.size.width / 2;
                        cell.imgNewchat.image = [UIImage imageNamed:@"circular_green"];
                        break;
                    }
                    else{
                        
                        cell.vw_newChat.hidden = YES;
                        
                    }
                }
                
            }
            else{
                cell.vw_newChat.hidden = YES;

            }
            
            
            cell.img_vw.layer.borderWidth = 2.0f;
            cell.img_vw.layer.borderColor = [UIColor whiteColor].CGColor;
            
            return cell;
        }
        
        
        //        cell.img_vw.layer.cornerRadius = cell.img_vw.frame.size.width / 2;
        //        cell.img_vw.clipsToBounds = YES;
       
        
        //return cell;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _myChat_collectionVw) {
        
        NSString *id_string;
        NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:indexPath.row];
                    NSLog(@"dict_myChat>>>>%@",dict_myChat);
        
                    NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
        
                    id_string = [dict_besic_info objectForKey:@"id"];
        
        
        if ([id_string isEqualToString:@"1"]) {
            
                        SingleChatViewController *SingleChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleChatViewController"];
            
                        SingleChatVC.str_ToUserId = [dict_besic_info objectForKey:@"id"];
                        SingleChatVC.str_ChatUserName = [dict_besic_info objectForKey:@"first_name"];
                        [self.navigationController pushViewController:SingleChatVC animated:NO];
        }
        
        else{
            
                        if ([id_string isEqualToString:appDell.strSingleChatId]) {
            
                            appDell.strSingleChatId = @"";
            
                        }
            
                        SingleChatViewController *SingleChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleChatViewController"];
            
                        SingleChatVC.str_ToUserId = [dict_besic_info objectForKey:@"id"];
                        SingleChatVC.str_ChatUserName = [dict_besic_info objectForKey:@"name"];
                        [self.navigationController pushViewController:SingleChatVC animated:NO];
            
        }
        
//        if (indexPath.row == 0) {
//
//            NSDictionary *dict_besic_info = [dict_adminDetails objectForKey:@"basic_info"];
//            NSLog(@"dict_besic_info>>>>%@",dict_besic_info);
//           id_string = [dict_besic_info objectForKey:@"id"];
//
//            SingleChatViewController *SingleChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleChatViewController"];
//
//            SingleChatVC.str_ToUserId = [dict_besic_info objectForKey:@"id"];
//            SingleChatVC.str_ChatUserName = [dict_besic_info objectForKey:@"first_name"];
//            [self.navigationController pushViewController:SingleChatVC animated:NO];
//        }
//        else{
//
//            NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:indexPath.row - 1];
//            NSLog(@"dict_myChat>>>>%@",dict_myChat);
//
//            NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
//
//            id_string = [dict_besic_info objectForKey:@"id"];
//
//            if ([id_string isEqualToString:appDell.strSingleChatId]) {
//
//                appDell.strSingleChatId = @"";
//
//            }
//
//            SingleChatViewController *SingleChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleChatViewController"];
//
//            SingleChatVC.str_ToUserId = [dict_besic_info objectForKey:@"id"];
//            SingleChatVC.str_ChatUserName = [dict_besic_info objectForKey:@"name"];
//            [self.navigationController pushViewController:SingleChatVC animated:NO];
//        }
        
        if (appDell.arrNotiId.count) {
            
            for (int i = 0; i < appDell.arrNotiId.count; i++) {
                
                NSString *notificationId = [appDell.arrNotiId objectAtIndex:i];
                
                if ([id_string isEqualToString: notificationId]) {
                    
                    [appDell.arrNotiId removeObjectAtIndex:i];
                }
            }
    }
}
    else if (collectionView == _featuredChat_collectionVw) {
        
        NSDictionary *dict_featuredChat = [arr_featuredChat objectAtIndex:indexPath.row];
        NSLog(@"dict_featuredChat>>>>%@",dict_featuredChat);
        
        [arrFeaturedChatroomID addObject:[NSString stringWithFormat:@"%@",[dict_featuredChat objectForKey:@"id"]]]; 
        
        NSLog(@"arrFeaturedChatroomID>>>>%@",arrFeaturedChatroomID);
        
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setObject: arrFeaturedChatroomID forKey:kFeaturedChatroomID];
        [userD synchronize];
        
        NSLog(@"print>>>>%@",[userD objectForKey:kFeaturedChatroomID]);
        
        ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        chatVC.dict_chatroom = dict_featuredChat;
        [self.navigationController pushViewController:chatVC animated:NO];

        
    }
    else if (collectionView == _tradingChat_collectionVw) {
        
        NSDictionary *dict_tradingChat = [arr_tradingChat objectAtIndex:indexPath.row];
        NSLog(@"dict_tradingChat>>>>%@",dict_tradingChat);
        
        ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        chatVC.dict_chatroom = dict_tradingChat;
        [self.navigationController pushViewController:chatVC animated:NO];
        
        
    }
    else if (collectionView == _myChatRoom_collectionVw) {
        
        NSDictionary *dict_mychatroomChat = [arr_myChat objectAtIndex:indexPath.row];
        NSLog(@"dict_myChat>>>>%@",dict_mychatroomChat);
        
        NSString *id_string = [dict_mychatroomChat objectForKey:@"id"];

        if ([id_string isEqualToString:appDell.strChtroomId]) {

            appDell.strChtroomId = @"";
        }
        
        ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        chatVC.dict_chatroom = dict_mychatroomChat;
        [self.navigationController pushViewController:chatVC animated:NO];
        
        
        
        if (appDell.arrChatroomNotiId.count) {
            
            for (int i = 0; i < appDell.arrChatroomNotiId.count; i++) {
                
                NSString *chatroomNotiId =  [appDell.arrChatroomNotiId objectAtIndex:i];
                
                if ([id_string isEqualToString:chatroomNotiId]) {
                    
                    [appDell.arrChatroomNotiId removeObjectAtIndex:i];
                }
            }
    }
  }
}




//////Jitendra
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    
//    return 2.0;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    if ([UIScreen mainScreen].bounds.size.width == 320) {
//        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.033), 260);
//
//    }
//    else if ([UIScreen mainScreen].bounds.size.width == 375){
//
//        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.028), 200);
//
//    }
//
//
//
//    return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.024), 200);
//
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(UICollectionViewLayout *)collectionViewLayout
//minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 1;
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
//                        layout:(UICollectionViewLayout *)collectionViewLayout
//        insetForSectionAtIndex:(NSInteger)section{
//    //return UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0);
//    return UIEdgeInsetsMake(2, 2, 2, 2);
//}




// Search Chat By Keyword

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_searchTextField resignFirstResponder];
    return YES;
}

- (IBAction)btnSearchAction:(id)sender {
    
    if (_searchTextField.text.length >  1) {
        
//        NSString *string = _searchTextField.text ;
//        NSString *trimmedString = [string stringByTrimmingCharactersInSet:
//                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//        NSLog(@"trimmedString>>>>%@",trimmedString);
        
        [self searchServiceCallWithText:_searchTextField.text];
        [_searchTextField resignFirstResponder];

    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
        return YES;
    
    if(range.length == 1 && (textField.text.length == 1))
    {
        NSLog(@"Delete %@",string);
        [self myMatchServiceCall];
        
    }
    
    if (range.length== 0){
        if (textField.text.length >= 1) {
            [self searchServiceCallWithText:[NSString stringWithFormat:@"%@%@",textField.text,string]];
            textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            [_searchTextField resignFirstResponder];
        }
    }
    
    return YES;
    
}

-(void)searchServiceCallWithText:(NSString*)searchText{
    
    NSString *string = _searchTextField.text ;
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"trimmedString>>>>%@",trimmedString);
    
    NSDictionary *dictForSearch = @{@"user_id":str_userId,//@"15",
                                    @"token" : @"adsahtoikng",
                                    @"text" : searchText
                                    };
    
    NSLog(@"dictForSearch>>>>%@",dictForSearch);//Mymatchesbychatroomkeyword_URL
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Mymatchesbychatroomkeyword_URL parameters:dictForSearch progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                [arr_myChat removeAllObjects];
                [arr_tradingChat removeAllObjects];
                [arr_featuredChat removeAllObjects];
                [arrProfileMatched removeAllObjects];
                
                arrProfileMatched = [[responseDict objectForKey:@"data"] mutableCopy];
                arr_myChat = [[responseDict objectForKey:@"my_chatrooms"] mutableCopy];
                arr_tradingChat = [[responseDict objectForKey:@"trending_chatrooms"] mutableCopy];
                arr_featuredChat = [[responseDict objectForKey:@"featured_chatrooms"] mutableCopy];
                
                [_myChat_collectionVw reloadData];
                [_myChatRoom_collectionVw reloadData];
                [_tradingChat_collectionVw reloadData];
                [_featuredChat_collectionVw reloadData];
            }
            
            else if([strStatus intValue] == 0){
                
                
                [appDell removeCustomLoader];
                [appDell alertViewToastMessage:strMessage];

                
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


// My match service call

-(void)myMatchServiceCall{
    
    NSDictionary *dictForMatch = @{@"user_id":str_userId,//, @"24"str_userId
                                   @"token" :@"adsahtoikng"
                                   };
    
    NSLog(@"dictForMatch>>>>%@",dictForMatch);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:MyMatch_URL parameters:dictForMatch progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];

                
                [arrProfileMatched removeAllObjects];
                [arr_myChat removeAllObjects];
                [arr_tradingChat removeAllObjects];
                [arr_featuredChat removeAllObjects];
                
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];

                arrData = [[responseDict objectForKey:@"data"] mutableCopy];
                arr_myChat = [[responseDict objectForKey:@"my_chatrooms"] mutableCopy];

                
                if (arrData.count) {
                
                    for (int i = 0; i < arrData.count; i++) {
                        
                        NSDictionary *dictData = [arrData objectAtIndex:i];
                        
                        if ([[dictData objectForKey:@"is_blocked"] isEqualToString:@"0"]) {
                            
                            [arrProfileMatched addObject:[arrData objectAtIndex:i]];
                        }
                        
                    }
                    
                    if (arrProfileMatched.count) {
                        

                        
                        if ([appDell.strSingleChatId intValue] > 0) {
                            
                            [tmpArray removeAllObjects];

                            
                            NSLog(@"strSingleChat%@",appDell.strSingleChatId);
                            
                            for (int i = 0; i < arrProfileMatched.count; i++) {
                                
                                NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:i];
                                NSLog(@"dict_myChat>>>>%@",dict_myChat);
                                
                                NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
                                
                                NSString *id_string = [dict_besic_info objectForKey:@"id"];
                                
                                if ([id_string isEqualToString:appDell.strSingleChatId]) {
                                    
                                    indexId = i;
                                    
                                    [ tmpArray addObject:[arrProfileMatched objectAtIndex:i]];
                                    
                                    break;
                                }
                                
                            }
                            
                            [arrProfileMatched removeObjectAtIndex:indexId];
                            [tmpArray addObjectsFromArray:arrProfileMatched];
                            [arrProfileMatched removeAllObjects];
                            arrProfileMatched = [tmpArray mutableCopy];
                        }
                    }
                    
                }
                
                if (arr_myChat.count) {
                    
                    
                    if ([appDell.strChtroomId intValue] > 0) {
                        
                        [tmpArray removeAllObjects];

                        
                        for (int i = 0; i < arr_myChat.count; i++) {
                            
                            NSDictionary *dict_myChatroom = [arr_myChat objectAtIndex:i];//
                            NSLog(@"dict_myChatroom>>>>%@",dict_myChatroom);
                            
                            //   NSDictionary *dict_besic_info = [dict_myChatroom objectForKey:@"basic_info"];
                            
                            NSString *id_string = [dict_myChatroom objectForKey:@"id"];
                            
                            if ([id_string isEqualToString:appDell.strChtroomId]) {
                                
                                indexId = i;
                                
                                [ tmpArray addObject:[arr_myChat objectAtIndex:i]];
                                
                                break;
                            }
                            
                        }
                        
                        [arr_myChat removeObjectAtIndex:indexId];
                        [tmpArray addObjectsFromArray:arr_myChat];
                        [arr_myChat removeAllObjects];
                        arr_myChat = [tmpArray mutableCopy];
                    }
                }
                
                arr_tradingChat = [[responseDict objectForKey:@"trending_chatrooms"] mutableCopy];
                arr_featuredChat = [[responseDict objectForKey:@"featured_chatrooms"] mutableCopy];
                
                dict_adminDetails = [[responseDict objectForKey:@"admin_details"] mutableCopy];
                
                [arrProfileMatched addObject:dict_adminDetails];
                
                
                [_myChat_collectionVw reloadData];
                [_myChatRoom_collectionVw reloadData];
                [_tradingChat_collectionVw reloadData];
                [_featuredChat_collectionVw reloadData];
                
           //     NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
                [currentDefaults setObject:data forKey:@"kmatchProfileResponseDetails"];
               
                NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:arrProfileMatched];
                [currentDefaults setObject:data1 forKey:@"ksinglechatUserArray"];
                
                NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:arr_myChat];
                [currentDefaults setObject:data2 forKey:@"kchatroomArray"];
            }
            
            else if([strStatus intValue] == 0){
                
                [appDell alertViewToastMessage:strMessage];
                
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

// Notification coming while in  chat page

-(void)showChatNotifiaction{
    
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    // [currentDefaults removeObjectForKey:@"kmatchProfileResponseDetails"];
    
    NSData *data = [currentDefaults objectForKey:@"kmatchProfileResponseDetails"];
    NSDictionary *dict_data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([dict_data allKeys] > 0){
        [tmpArray removeAllObjects];

        NSLog(@"dict_data>>>>>>%@",dict_data);
        dict_adminDetails = [dict_data objectForKey:@"admin_details"];
        NSLog(@"dict_adminDetails>>>>%@",dict_adminDetails);
        
        NSData *data1 = [currentDefaults objectForKey:@"ksinglechatUserArray"];
        NSData *data2 = [currentDefaults objectForKey:@"kchatroomArray"];
        
        arrProfileMatched = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
        arr_myChat = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
        
        [arrProfileMatched addObject:dict_adminDetails];
        
        //   arr_myChat = [[dict_data objectForKey:@"my_chatrooms"] mutableCopy];
        arr_featuredChat = [[dict_data objectForKey:@"featured_chatrooms"] mutableCopy];
        arr_tradingChat = [[dict_data objectForKey:@"trending_chatrooms"] mutableCopy];
        //  arrProfileMatched = [[dict_data objectForKey:@"data"] mutableCopy];
        NSLog(@"arr_myChat>>>>>>%@",arr_myChat);
        
        
        NSLog(@"strSingleChat%@",appDell.strSingleChatId);
        NSLog(@"strChatroomId%@",appDell.strChtroomId);
        
        
        if (appDell.strSingleChatId.length) {
            

            
            //        arr_myChat = [[dict_data objectForKey:@"my_chatrooms"] mutableCopy];
            
            NSLog(@"strSingleChat%@",appDell.strSingleChatId);
            
            for (int i = 0; i < arrProfileMatched.count; i++) {
                
                NSDictionary *dict_myChat = [arrProfileMatched objectAtIndex:i];
                NSLog(@"dict_myChat>>>>%@",dict_myChat);
                
                NSDictionary *dict_besic_info = [dict_myChat objectForKey:@"basic_info"];
                
                NSString *id_string = [dict_besic_info objectForKey:@"id"];
                
                if ([id_string isEqualToString:appDell.strSingleChatId]) {
                    
                    indexId = i;
                    
                    [ tmpArray addObject:[arrProfileMatched objectAtIndex:i]];
                    
                    break;
                }
                
            }
            
            [arrProfileMatched removeObjectAtIndex:indexId];
            [tmpArray addObjectsFromArray:arrProfileMatched];
            [arrProfileMatched removeAllObjects];
            arrProfileMatched = [tmpArray mutableCopy];
            
            NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrProfileMatched];
            [currentDefaults setObject:data forKey:@"ksinglechatUserArray"];
        }
        
        if (appDell.strChtroomId.length) {
            
            [tmpArray removeAllObjects];

            
            for (int i = 0; i < arr_myChat.count; i++) {
                
                NSDictionary *dict_myChatroom = [arr_myChat objectAtIndex:i];//
                NSLog(@"dict_myChatroom>>>>%@",dict_myChatroom);
                
                //   NSDictionary *dict_besic_info = [dict_myChatroom objectForKey:@"basic_info"];
                
                NSString *id_string = [dict_myChatroom objectForKey:@"id"];
                
                if ([id_string isEqualToString:appDell.strChtroomId]) {
                    
                    indexId = i;
                    
                    [ tmpArray addObject:[arr_myChat objectAtIndex:i]];
                    
                    break;
                }
                
            }
            
            [arr_myChat removeObjectAtIndex:indexId];
            [tmpArray addObjectsFromArray:arr_myChat];
            [arr_myChat removeAllObjects];
            arr_myChat = [tmpArray mutableCopy];
            
            NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr_myChat];
            [currentDefaults setObject:data forKey:@"kchatroomArray"];
        }
        
        [_myChat_collectionVw reloadData];
        [_myChatRoom_collectionVw reloadData];
        [_tradingChat_collectionVw reloadData];
        [_featuredChat_collectionVw reloadData];
    }
}


@end
