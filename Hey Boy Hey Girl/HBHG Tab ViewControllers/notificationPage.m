//
//  notificationPage.m
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
#import "NotificationDeleteView.h"
#import "AppDelegate.h"
#import "NotificationTableViewCell.h"
#import <AFHTTPSessionManager.h>
#import "CommonHeaderFile.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SingleChatViewController.h"
#import "ChatViewController.h"
#import "explorePage.h"


@interface notificationPage ()<UITableViewDelegate,UITableViewDataSource,notificationDelegate>
{
    NotificationDeleteView *notificatiDeleteVw;
    AppDelegate *appDell;
    
    NSString *str_userId;
    NSMutableArray *arrNotificationData;
    NSString *str_notiType;
    BOOL isSingleDelete;
    NSDictionary *notificationSelectionDict;
    NSMutableArray *arrProfileMatched,*arr_myChat,*arrData;
}

- (IBAction)profileButton:(id)sender;
- (IBAction)chatButton:(id)sender;
- (IBAction)exploreButton:(id)sender;
- (IBAction)myMatchesButton:(id)sender;
- (IBAction)notificationButton:(id)sender;

@end

@implementation notificationPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    arrNotificationData = [[NSMutableArray alloc] init];
    
    //  isSingleDelete = NO;
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapPress.numberOfTapsRequired = 1;
    tapPress.numberOfTouchesRequired = 1;
    [self.img_DeleteNotification addGestureRecognizer:tapPress];
    
    [_notification_table registerNib:[UINib  nibWithNibName:@"NotificationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotificationTableViewCell"];
    
    _notification_table.delegate = self;
    _notification_table.dataSource = self;
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    str_userId = [userD objectForKey:khbhgUserId];
    NSLog(@"str_userId>>>>>%@",str_userId);
    
    arrProfileMatched = [[NSMutableArray alloc] init];
    arrData = [[NSMutableArray alloc] init];
    arr_myChat = [[NSMutableArray alloc] init];
    
    //    _vwNoNotification.hidden = YES;
    //
    //
    //    [self getNotificationServiceCall];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    isSingleDelete = NO;
    _vwNoNotification.hidden = YES;
    
    [self getNotificationServiceCall];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gesture{
    
    [self showdeleteNotificationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)profileButton:(id)sender {
    [appDell setProfile];
}

- (IBAction)chatButton:(id)sender {
    [appDell setChatPage];
}

- (IBAction)exploreButton:(id)sender {
    [appDell setExplorePage];
}

- (IBAction)myMatchesButton:(id)sender {
    [appDell setMyMatchPage];
}

- (IBAction)notificationButton:(id)sender {
    [appDell setNotificationPage];
}

// notification tableview Delegate & datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrNotificationData.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 84;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotificationTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    
    cell.view_img.layer.cornerRadius = cell.view_img.frame.size.width / 2;
    cell.view_img.clipsToBounds = YES;
    cell.img_profile.layer.cornerRadius = cell.img_profile.frame.size.width / 2;
    cell.img_profile.clipsToBounds = YES;
    
    NSDictionary *notificationDict = [arrNotificationData objectAtIndex:indexPath.row];
    
    NSLog(@"notificationDict >>>>%@",notificationDict);
    
    cell.lbl_likes.text = [notificationDict objectForKey:@"noti_content"];
    cell.lbl_dateTime.text = [notificationDict objectForKey:@"create_date"];
    
    NSString *imageURLPath = [notificationDict valueForKey:@"sender_image"];
    NSLog(@"foodDict>>>>>>%@",imageURLPath);
    
    [cell.img_profile sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            cell.img_profile.image = image;
        }
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    notificationSelectionDict = [arrNotificationData objectAtIndex:indexPath.row];
    
    NSLog(@"notificationSelectionDict >>>>%@",notificationSelectionDict);
    
    isSingleDelete = YES;
    
    str_notiType = [notificationSelectionDict objectForKey:@"noti_type"];
    NSLog(@"str_notiType>>>>%@",str_notiType);
    
    NSString *str_Id = [NSString stringWithFormat:@"%@",[notificationSelectionDict objectForKey:@"id"]];
    
    NSDictionary *dictForDelete = @{@"user_id":str_userId ,//,@"24"
                                    @"token" :@"adsahtoikng",
                                    @"noti_id": str_Id
                                    };
    
    NSLog(@"dictForDelete >>>> %@",dictForDelete);
    
    [self deleteNotificationServiceCall:dictForDelete];
    
    //    if ([str_notiType isEqualToString:@"4"]) {
    //
    //        [self singleChatNotification:[NSString stringWithFormat:@"%@",[notificationDict objectForKey:@"action_did_by"]]];
    //    }
    //    else if([str_notiType isEqualToString:@"5"]){
    //
    //        [self chatroomChatNotification:[NSString stringWithFormat:@"%@",[notificationDict objectForKey:@"chatroom_id"]]];
    //    }
    //
    //    else if ([str_notiType isEqualToString:@"8"]){
    //
    //        [self likeProfieNotification:[NSString stringWithFormat:@"%@",[notificationDict objectForKey:@"action_did_by"]]];
    //    }
}



// ****************************** Get notification Webservice  ******************************************

-(void)getNotificationServiceCall{
    
    
    NSDictionary *getNotificationDict = @{@"user_id":str_userId,//, @"24"
                                          @"token" :@"adsahtoikng"
                                          };
    
    NSLog(@"getDataDict>>>>%@",getNotificationDict);
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Getnotification_URL parameters:getNotificationDict progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                [arrNotificationData removeAllObjects];
                
                arrNotificationData = [[responseDict objectForKey:@"data"] mutableCopy];
                [_notification_table reloadData];
                
//                int lastRowNumber = (int)[_notification_table numberOfRowsInSection:0] - 1;
//                NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
//                [_notification_table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];

                
                NSLog(@"arrNotificationData >> %@",arrNotificationData);
                
                
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [currentDefaults objectForKey:@"kmatchProfileResponseDetails"];
                NSDictionary *dict_data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                if([dict_data allKeys] == 0){
                    
                    [self myMatchServiceCall];
                }
                
                
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                [appDell removeCustomLoader];
                _notification_table.hidden = YES;
                _vwNoNotification.hidden = NO;
                
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

//************************************** Notification Delete confirmation View ***************************************

-(void)showdeleteNotificationView{
    
    notificatiDeleteVw = [[NotificationDeleteView alloc] init];
    notificatiDeleteVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [notificatiDeleteVw setUpUi];
    notificatiDeleteVw.delegate_Notification = self;
    [self.view addSubview:notificatiDeleteVw];
    
}

// Notifiction Delegate Method

-(void)confirmDelete{
    
    NSString *str_id=@"";
    NSString * str_comma = @",";
    for (int i = 0; i < arrNotificationData.count; i ++) {
        
        NSDictionary *dict = [arrNotificationData objectAtIndex:i];
        NSString     *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        if (i == (arrNotificationData.count - 1)) {
            str_id = [str_id stringByAppendingString:str];
        }else{
            str_id = [str_id stringByAppendingString:[str stringByAppendingString:str_comma]];
        }
        NSLog(@"str_id>>>>%@",str_id);
    }
    
    NSDictionary *dictForDelete = @{@"user_id":str_userId ,//,@"24"
                                    @"token" :@"adsahtoikng",
                                    @"noti_id": str_id
                                    };
    
    NSLog(@"dictForDelete >>>>%@",dictForDelete);
    [self deleteNotificationServiceCall:dictForDelete];
}

-(void)deleteNotificationServiceCall:(NSDictionary *) deleteNotificstion{
    
    
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Deletenotification_URL parameters:deleteNotificstion progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            //   arrNotificationData = [responseDict objectForKey:@"data"];
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            //    NSLog(@"arrNotificationData >> %@",arrNotificationData);
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                if (isSingleDelete) {
                    
                    if ([str_notiType isEqualToString:@"4"]) {
                        
                        [self singleChatNotification:[NSString stringWithFormat:@"%@",[notificationSelectionDict objectForKey:@"action_did_by"]]];
                    }
                    else if([str_notiType isEqualToString:@"5"]){
                        
                        [self chatroomChatNotification:[NSString stringWithFormat:@"%@",[notificationSelectionDict objectForKey:@"chatroom_id"]]];
                    }
                    
                    else if ([str_notiType isEqualToString:@"8"]){
                        
                        [self likeProfieNotification:[NSString stringWithFormat:@"%@",[notificationSelectionDict objectForKey:@"action_did_by"]]];
                    }
                    
                    else{
                        
                        [arrNotificationData removeAllObjects];
                        [_notification_table reloadData];
                        [self getNotificationServiceCall];
                    }
                }
                else{
                    
                    [arrNotificationData removeAllObjects];
                    [_notification_table reloadData];
                    [self getNotificationServiceCall];
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

// Notification for single chat

-(void)singleChatNotification:(NSString *) singleChatId{
    
    NSLog(@"singleChatId>>>>%@",singleChatId);
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"ksinglechatUserArray"];
    // NSDictionary *dict_data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    // NSMutableArray  *arrProfileMatched = [[dict_data objectForKey:@"data"] mutableCopy];
    
    arrProfileMatched = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    NSLog(@"arrProfileMatched>>>>>%@",arrProfileMatched);
    
    for (int i = 0; i < arrProfileMatched.count; i++) {
        
        NSDictionary *dict = [arrProfileMatched objectAtIndex:i];
        NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
        NSString *str_id = [dict_basicInfo objectForKey:@"id"];
        
        if ([str_id isEqualToString:singleChatId]) {
            
            NSLog(@"Id matched");
            
            SingleChatViewController *SingleChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleChatViewController"];
            
            SingleChatVC.str_ToUserId = [dict_basicInfo objectForKey:@"id"];
            
            NSString *str_name = [NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"name"]];
            if ([str_name isEqualToString:@"(null)"]) {
                
                SingleChatVC.str_ChatUserName = [NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"first_name"]];
                
            }
            else{
                
                SingleChatVC.str_ChatUserName = [NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"name"]];
            }
            [self.navigationController pushViewController:SingleChatVC animated:NO];        }
        
    }
    
}

// Notification For Chatroom Chat

-(void)chatroomChatNotification:(NSString *) chatroomId{
    
    NSLog(@"chatroomId>>>>%@",chatroomId);
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"kchatroomArray"];
    //  NSDictionary *dict_data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    // NSMutableArray  *arr_myChat = [[dict_data objectForKey:@"my_chatrooms"] mutableCopy];
    
    arr_myChat = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    
    for (int i = 0; i<arr_myChat.count; i++) {
        
        NSDictionary *dict_mychatroomChat = [arr_myChat objectAtIndex:i];
        NSLog(@"dict_myChat>>>>%@",dict_mychatroomChat);
        
        NSString *str_chatroomId = [NSString stringWithFormat:@"%@",[dict_mychatroomChat objectForKey:@"id"]];
        
        if ([str_chatroomId isEqualToString:chatroomId]) {
            
            ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
            chatVC.dict_chatroom = dict_mychatroomChat;
            [self.navigationController pushViewController:chatVC animated:NO];
        }
        
        
    }
    
}


// Notification for like profile


-(void)likeProfieNotification:(NSString *) strProfileId{
    
    NSLog(@"strProfileId>>>>%@",strProfileId);
    
    NSDictionary *getDataDict = @{@"user_id":strProfileId,//@"24",str_userId
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
                
                NSLog(@"%@",strMessage);
                
                
                //                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                //                [userD setObject:responseDict forKey:kuserLikeProfileDetails];
                //                [userD synchronize];
                
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
                [currentDefaults setObject:data forKey:@"kuserLikeProfileDetails"];
                
                
                //         [self.delegate_notification likeProfileNotificationaction:responseDict];
                
                appDell.islikeNotification = YES;
                [appDell setExplorePage];
                
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

//**************************************** My matches Service Call ************************************************

-(void)myMatchServiceCall{
    
    NSDictionary *dictForMatch = @{@"user_id":str_userId,//, @"24"str_userId
                                   @"token" :@"adsahtoikng"
                                   };
    
    NSLog(@"dictForMatch>>>>%@",dictForMatch);
    
    //  [appDell showCustomLoader:self.view text:@"Loading...."];
    
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
                //       [arr_tradingChat removeAllObjects];
                //       [arr_featuredChat removeAllObjects];
                
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
                    
                }
                
                //                arr_tradingChat = [[responseDict objectForKey:@"trending_chatrooms"] mutableCopy];
                //                arr_featuredChat = [[responseDict objectForKey:@"featured_chatrooms"] mutableCopy];
                
                NSDictionary *dict_adminDetails = [[responseDict objectForKey:@"admin_details"]mutableCopy];
                
                [arrProfileMatched addObject:dict_adminDetails];
                
                
                //                [_myChat_collectionVw reloadData];
                //                [_myChatRoom_collectionVw reloadData];
                //                [_tradingChat_collectionVw reloadData];
                //                [_featuredChat_collectionVw reloadData];
                
                //     NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
                [currentDefaults setObject:data forKey:@"kmatchProfileResponseDetails"];
                
                NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:arrProfileMatched];
                [currentDefaults setObject:data1 forKey:@"ksinglechatUserArray"];
                
                NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:arr_myChat];
                [currentDefaults setObject:data2 forKey:@"kchatroomArray"];
                
                
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



@end
