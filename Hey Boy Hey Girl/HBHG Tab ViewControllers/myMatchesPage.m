//
//  myMatchesPage.m
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
#import "AppDelegate.h"
#import "MyMatchCollectionViewCell.h"
#import "MyMatchTableViewCell.h"
#import "BlockListView.h"
#import <AFHTTPSessionManager.h>
#import "CommonHeaderFile.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "profileFullView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SingleChatViewController.h"


@interface myMatchesPage ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,blockUserDelegate,profileFullDelegate>
{
    NSString *str_userId;
    AppDelegate *appDell;
    NSMutableArray *arrMatchData,*base_Array,*search_Array,*arrBlock;
    NSString *strSearchVal;
    NSArray *arrAnimationType,*caresuyalArray;
    int sliderCount;
    
    NSMutableArray *arrData,*arrMychatroomData;

    
    int selectedProfileIndex;

    AVPlayerLayer *playerLayer;
    AVPlayer *player;
    NSString *strVideo;
    NSTimer *timer;
    NSString *str_cityTitle;
    int index;
}
- (IBAction)profileButton:(id)sender;
- (IBAction)chatButton:(id)sender;
- (IBAction)exploreButton:(id)sender;
- (IBAction)myFavouriteButton:(id)sender;
- (IBAction)notificationButton:(id)sender;

@end
static int animationType = 0;

@implementation myMatchesPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    index = 0;
    
    arrBlock = [[NSMutableArray alloc] init];
    arrData = [[NSMutableArray alloc]   init];
    arrMychatroomData = [[NSMutableArray alloc]   init];
    selectedProfileIndex = 0;
    arrAnimationType = [NSArray arrayWithObjects:@"0",@"5",@"6",@"9",@"10", nil];
    caresuyalArray = [NSArray array];
    self.carousel1.delegate = self;
    self.carousel1.dataSource = self;
    self.carousel1.type = 0;
    
    arrMatchData = [[NSMutableArray alloc] init];
    strSearchVal = @"";
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    str_userId = [userD objectForKey:khbhgUserId];
    NSLog(@"str_userId>>>>>%@",str_userId);

    [_match_collectionVw registerNib:[UINib nibWithNibName:@"MyMatchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyMatchCollectionViewCell"];

    _match_collectionVw.delegate = self;
    _match_collectionVw.dataSource = self;
    
    
    [_table_match registerNib:[UINib  nibWithNibName:@"MyMatchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyMatchTableViewCell"];
    
    _table_match.delegate = self;
    _table_match.dataSource = self;
    
    _table_match.frame = CGRectMake(0, 14, _table_match.frame.size.width, _table_match.frame.size.height);
    
    _txt_search.delegate = self;

    _match_collectionVw.hidden = NO;
    _table_match.hidden = YES;
    _vw_search.hidden = YES;
    _map_Vw.hidden = YES;
    
  //  _vw_NoMyMatch.hidden = YES;
    _vw_tap.hidden = NO;
    _vw_top.hidden = NO;
    _vw_lower.hidden = NO;
        _vw_NoMatchFound.hidden = YES;

    _vw_chatNow.hidden = NO;
    _vw_buttom.hidden = NO;
    
    [self.btn_gridVw setSelected:YES];
    [self.btn_tableVw setSelected:NO];
    [self.btn_Map setSelected:NO];
    [self.btn_searchview setSelected:NO];
    
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapPress.numberOfTapsRequired = 1;
    tapPress.numberOfTouchesRequired = 1;
    [self.vw_block addGestureRecognizer:tapPress];
    
    [self myMatchServiceCall];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (appDell.isProfileBlock) {
        
        selectedProfileIndex = 0;
        appDell.isProfileBlock = NO;
        [self myMatchServiceCall];

    }
    else{
     
        if (playerLayer) {
            [playerLayer.player play];
            
        }
        else{
           
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
        }
        

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Tap gesture For View Block

-(void)handleSingleTap:(UITapGestureRecognizer *)gesture{
//    if (!arrMatchData.count) {
//        return;
//    }
//
    if (!_lbl_totalBlockUser.text.length) {
        return;
    }
    else
    {
        [self shownBlockListView];

    }
}

- (IBAction)btn_MatchProfileAction:(id)sender {
    
    [_txt_search resignFirstResponder];

    
    if (!arrMatchData.count) {
        return;
    }
    
    if (playerLayer) {
        [playerLayer.player pause];
     //   [playerLayer removeFromSuperlayer];
    }

    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    profileFullView *profileFullVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileFullView"];
//    profileFullVC.arrProfileData = [arrMatchData mutableCopy];
//    profileFullVC.profileindex = selectedProfileIndex;
    profileFullVC.dictProfileData = [arrMatchData objectAtIndex:selectedProfileIndex];
    [self.navigationController pushViewController:profileFullVC animated:NO];
}


// Blocklist view

-(void)shownBlockListView{
    
    [_txt_search resignFirstResponder];

    
    if (playerLayer) {
        [playerLayer.player pause];
      //  [playerLayer removeFromSuperlayer];
    }
    
    BlockListView *blockListVw = [[BlockListView alloc] init];
    blockListVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
 //   blockListVw.arrBlockList = [arrBlock mutableCopy];

    [blockListVw setUpUi];
    blockListVw.delegate_blockUserList = self;
    [self.view addSubview:blockListVw];
}


// BlockListView Delegate function

-(void)showTotalBlockUser:(NSString *)st_blockUserNo{
    
    if ([st_blockUserNo isEqualToString:@"0"]) {
        
        _lbl_totalBlockUser.text = @"";
        [self myMatchServiceCall];

    }
    else{
       
        _lbl_totalBlockUser.text = st_blockUserNo;
        
        [self myMatchServiceCall];
    }
   
}

- (IBAction)profileButton:(id)sender {

    if (playerLayer) {
        [playerLayer.player pause];
        [playerLayer removeFromSuperlayer];
    }
    
    [appDell setProfile];
}

- (IBAction)chatButton:(id)sender {
    
    if (playerLayer) {
        [playerLayer.player pause];
        [playerLayer removeFromSuperlayer];
    }
    [appDell setChatPage];
}

- (IBAction)exploreButton:(id)sender {
    
    if (playerLayer) {
        [playerLayer.player pause];
        [playerLayer removeFromSuperlayer];
    }
    [appDell setExplorePage];
}

- (IBAction)myFavouriteButton:(id)sender {
}

- (IBAction)notificationButton:(id)sender {
    
    if (playerLayer) {
        [playerLayer.player pause];
        [playerLayer removeFromSuperlayer];
    }
    
    [appDell setNotificationPage];

}

- (IBAction)btn_gridVwAction:(id)sender {
    
    [_txt_search resignFirstResponder];

    
    if (!arrMatchData.count) {
        return;
    }
    
    index = 0;
    
    [self.btn_gridVw setSelected:YES];
    [self.btn_tableVw setSelected:NO];
    [self.btn_Map setSelected:NO];
    [self.btn_searchview setSelected:NO];

    _table_match.hidden = YES;
    _match_collectionVw.hidden = NO;
    _vw_search.hidden = YES;
    _map_Vw.hidden = YES;
}
- (IBAction)btnTableVwAction:(id)sender {
    
    [_txt_search resignFirstResponder];

    
    if (!arrMatchData.count) {
        return;
    }
    
    index = 0;

    
    [self.btn_gridVw setSelected:NO];
    [self.btn_tableVw setSelected:YES];
    [self.btn_Map setSelected:NO];
    [self.btn_searchview setSelected:NO];

    _table_match.hidden = NO;
    _match_collectionVw.hidden = YES;
    _vw_search.hidden = YES;
    _table_match.frame = CGRectMake(0, 14, _table_match.frame.size.width, _table_match.frame.size.height);
    _map_Vw.hidden = YES;
    
 //   search_Array = [arrMatchData mutableCopy];
    [_table_match reloadData];

}

- (IBAction)btnMapAction:(id)sender {
    
    [_txt_search resignFirstResponder];

    
    if (!arrMatchData.count) {
        return;
    }
    
    [self.btn_gridVw setSelected:NO];
    [self.btn_tableVw setSelected:NO];
    [self.btn_Map setSelected:YES];
    [self.btn_searchview setSelected:NO];

    _table_match.hidden = YES;
    _match_collectionVw.hidden = YES;
    _vw_search.hidden = YES;
    _map_Vw.hidden = NO;
    
        NSDictionary *dict = [arrMatchData objectAtIndex:index];
    NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
    
    NSDictionary *DictForMap = @{@"name":[dict_basicInfo objectForKey:@"name"],
                                 @"lat" :[dict_basicInfo objectForKey:@"lat"],
                                 @"long": [dict_basicInfo objectForKey:@"long"],
                                 @"city" : [dict_basicInfo objectForKey:@"city"]
                                 };
    
    NSLog(@"dictForMap>>>>%@",DictForMap);
    
    
    [self initViews:DictForMap];
    [self initConstraints];
    
    [self addAllPins:DictForMap];
}

- (IBAction)btn_searchVw:(id)sender {
    
    
    
    if (!arrMatchData.count) {
        return;
    }
    
    _txt_search.text = @"";
    
    [self.btn_gridVw setSelected:NO];
    [self.btn_tableVw setSelected:NO];
    [self.btn_Map setSelected:NO];
    [self.btn_searchview setSelected:YES];
    _table_match.hidden = NO;
    _match_collectionVw.hidden = YES;
    _vw_search.hidden = NO;
    _table_match.frame = CGRectMake(0, _vw_search.frame.size.height, _table_match.frame.size.width, _table_match.frame.size.height);

    _map_Vw.hidden = YES;
    
    
    [self.map_Vw removeFromSuperview];
}

// Individual Chat Button press

- (IBAction)btn_chatNowAction:(id)sender {
    
    [_txt_search resignFirstResponder];

    
    if (!arrMatchData.count) {
        return;
    }
    
    if (playerLayer) {
        [playerLayer.player pause];
     //   [playerLayer removeFromSuperlayer];
    }
    
    SingleChatViewController *SingleChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleChatViewController"];
    NSDictionary *dict = [arrMatchData objectAtIndex:selectedProfileIndex];
    NSDictionary *dict_besicInfo = [dict objectForKey:@"basic_info"];
    SingleChatVC.str_ToUserId = [dict_besicInfo objectForKey:@"id"];
    SingleChatVC.str_ChatUserName = [dict_besicInfo objectForKey:@"name"];
    [self.navigationController pushViewController:SingleChatVC animated:NO];
}



// collection view Delegate and Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 //   return arrMatchData.count;
    return search_Array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     MyMatchCollectionViewCell *cell = [_match_collectionVw dequeueReusableCellWithReuseIdentifier:@"MyMatchCollectionViewCell" forIndexPath:indexPath];
    
    cell.vw_new.layer.cornerRadius = cell.vw_new.frame.size.width / 2;
    
    NSDictionary *dict = [arrMatchData objectAtIndex:indexPath.row];
    NSDictionary *dict_besicInfo = [dict objectForKey:@"basic_info"];
    NSString *str_isNew = [NSString stringWithFormat:@"%@",[dict objectForKey:@"is_new"]];
    NSString *imageURLPath = [dict_besicInfo valueForKey:@"profile_image"];
    NSLog(@"imageURLPath>>>>>>%@",imageURLPath);
    
    [cell.img_matchedProfile sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            cell.img_matchedProfile.image = image;
        }
    }];
    
    if ([str_isNew isEqualToString:@"1"]) {
        
        cell.vw_new.hidden = NO;
        
    }
    else{
        
        cell.vw_new.hidden = YES;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedProfileIndex = (int)indexPath.row;
    
    index = (int)indexPath.row;
    
    NSDictionary *dict = [arrMatchData objectAtIndex:selectedProfileIndex];
    NSDictionary *dict_besicInfo = [dict objectForKey:@"basic_info"];
    NSString *str_isNew = [NSString stringWithFormat:@"%@",[dict objectForKey:@"is_new"]];
    
    if ([str_isNew isEqualToString:@"1"]) {
        
        [self readMatchesServiceCall:[dict_besicInfo objectForKey:@"id"]];
    }
    
    [self careosalDataSource];
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
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.033), 100);
        
    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){
        
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.028), 120);
        
    }
    else{
        
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.024), 120);

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


// match tableview Delegate & datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return search_Array.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 84;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyMatchTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMatchTableViewCell"];
    
    cell.vw_new.layer.cornerRadius = cell.vw_new.frame.size.width / 2;

    NSDictionary *dict = [search_Array objectAtIndex:indexPath.row];
    NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
    NSString *str_isNew = [NSString stringWithFormat:@"%@",[dict objectForKey:@"is_new"]];

    NSString *nameString= [dict_basicInfo objectForKey:@"name"];
    NSArray *nameArray = [nameString componentsSeparatedByString:@" "];
    
    cell.lbl_userName.text = [nameArray objectAtIndex:0];
    cell.lbl_userAge.text = [NSString stringWithFormat:@"%@ years",[dict_basicInfo objectForKey:@"age"]] ;

    NSString *imageURLPath = [dict_basicInfo valueForKey:@"profile_image"];
    NSLog(@"imageURLPath>>>>>>%@",imageURLPath);

    [cell.img_matchProfile sd_setImageWithURL:[NSURL URLWithString:imageURLPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            cell.img_matchProfile.image = image;
        }
    }];
    
    if ([str_isNew isEqualToString:@"1"]) {
        
        cell.vw_new.hidden = NO;
        
    }
    else{
        
        cell.vw_new.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedProfileIndex = (int)indexPath.row;
    
    index = (int)indexPath.row;
    
    NSDictionary *dict = [arrMatchData objectAtIndex:selectedProfileIndex];
    NSDictionary *dict_besicInfo = [dict objectForKey:@"basic_info"];
    NSString *str_isNew = [NSString stringWithFormat:@"%@",[dict objectForKey:@"is_new"]];
    
    if ([str_isNew isEqualToString:@"1"]) {
        
        [self readMatchesServiceCall:[dict_besicInfo objectForKey:@"id"]];
    }
    
    
    
    [self careosalDataSource];
}
// Mapview

-(void)initViews:(NSDictionary *) mapDict
{
   // self.map_Vw = [[MKMapView alloc] init];
    self.map_Vw.delegate = self;
    self.map_Vw.showsUserLocation = YES;
    //self.map_Vw.showsCompass = YES;
    self.map_Vw.mapType = MKMapTypeStandard;//standard map(not satellite)
    
    float lat;
    float longitude;
    
    lat = [[mapDict objectForKey:@"lat"] floatValue];
    longitude = [[mapDict objectForKey:@"long"] floatValue];
    
    MKCoordinateRegion region = self.map_Vw.region;
    
    region.center = CLLocationCoordinate2DMake(lat, longitude);
    
    
    region.span.longitudeDelta = 2.0; // Bigger the value, closer the map view
    region.span.latitudeDelta = 2.0;
    [self.map_Vw setRegion:region animated:YES]; // Choose if you want animate or not
    
    [self.vw_lower addSubview:self.map_Vw];
    
//    MKCoordinateRegion mapRegion;
//    mapRegion.center = mapView.userLocation.coordinate;
//    mapRegion.span.latitudeDelta = 0.2;
//    mapRegion.span.longitudeDelta = 0.2;
//
//    [mapView setRegion:mapRegion animated: YES];
}

-(void)initConstraints
{
    self.map_Vw.translatesAutoresizingMaskIntoConstraints = NO;
    
    id views = @{
                 @"mapView": self.map_Vw
                 };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:views]];
}

-(void)addAllPins:(NSDictionary *) mapDict
{
   // self.map_Vw.delegate=self;
    
    float lat;
    float longitude;
    
    lat = [[mapDict objectForKey:@"lat"] floatValue];
    longitude = [[mapDict objectForKey:@"long"] floatValue];

    NSString *str_coordinate = [NSString stringWithFormat:@"%f,%f",lat,longitude];
    
    NSString *str_name = [mapDict objectForKey:@"name"];
    NSArray *arr = [str_name componentsSeparatedByString:@" "];
    NSString *name_str = [arr objectAtIndex:0];
    str_cityTitle = [mapDict objectForKey:@"city"];
    
    NSArray *name=[[NSArray alloc]initWithObjects:name_str,nil];
    
    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:name.count];
    
    [arrCoordinateStr addObject:str_coordinate];
    
    NSLog(@"arrCoordinateStr>>>>%@",arrCoordinateStr);
//    [arrCoordinateStr addObject:@"22.501558, 88.362160"];
//    [arrCoordinateStr addObject:@"22.585128, 88.346793"];
//    [arrCoordinateStr addObject:@"22.444902, 88.341030"];
    
    
    [self addPinWithTitle:name[0] AndCoordinate:arrCoordinateStr[0]];
    
//    for(int i = 0; i < name.count; i++)
//    {
//        [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i]];
//
//    }
    
    //  [self getDirections];
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
    [_map_Vw removeAnnotations:_map_Vw.annotations];
    
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.coordinate = coordinate;
    NSLog(@"Pin-Title--%@",title);    NSLog(@"Pin-subTitle--%@",str_cityTitle);

    mapPin.title = title;
    mapPin.subtitle = str_cityTitle ;
    
    [self.map_Vw addAnnotation:mapPin];
}

/*
#pragma mark - MapKit
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.canShowCallout = YES;
    annView.animatesDrop = YES;
    return annView;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView
           rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 2.0;
    
    return renderer;
}
*/

//**************************************** My matches Service Call ************************************************

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
                
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];

                arrData = [responseDict objectForKey:@"data"];
                arrMychatroomData = [responseDict objectForKey:@"my_chatrooms"];
                NSLog(@"arrData >> %@",arrData);
                
                if (arrMychatroomData.count) {
                    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:arrMychatroomData];
                    [currentDefaults setObject:data2 forKey:@"kchatroomArray"];
                }
                
                if (arrData.count) {
            //        _vw_NoMyMatch.hidden = YES;
                    
                    
                    [appDell removeCustomLoader];

                    [arrMatchData removeAllObjects];
                    [search_Array removeAllObjects];
                    [base_Array removeAllObjects];
                   
                    for (int i = 0; i < arrData.count; i++) {
                        
                        NSDictionary *dictData = [arrData objectAtIndex:i];
                        
                        if ([[dictData objectForKey:@"is_blocked"] isEqualToString:@"0"]) {
                            
                            [arrMatchData addObject:[arrData objectAtIndex:i]];
                        }
                        
                    }
                    
                    if (arrMatchData.count) {
                        
                        _vw_tap.hidden = NO;
                        _vw_top.hidden = NO;
                        _vw_lower.hidden = NO;
                        _vw_NoMatchFound.hidden = YES;
                        _vw_chatNow.hidden = NO;
                        _vw_buttom.hidden = NO;
                        _match_collectionVw.hidden = NO;
                        
                        NSDictionary *dict = [arrMatchData objectAtIndex:0];
                        NSDictionary *dict_besicInfo = [dict objectForKey:@"basic_info"];
                        NSString *str_isNew = [NSString stringWithFormat:@"%@",[dict objectForKey:@"is_new"]];
                        
                        base_Array = [arrMatchData mutableCopy];
                        search_Array = [arrMatchData mutableCopy];
                        
                        [self careosalDataSource];
                        
                        NSLog(@"%@",strMessage);
                        
                        [_match_collectionVw reloadData];
                        [_table_match reloadData];
                        
                        _lbl_totalLikes.text = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"likes_count"]];
                        
                    NSDictionary    *dict_adminDetails = [[responseDict objectForKey:@"admin_details"] mutableCopy];
                        
                        [arrMatchData addObject:dict_adminDetails];
                        
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
                        [currentDefaults setObject:data forKey:@"kmatchProfileResponseDetails"];
                        
                        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:arrMatchData];
                        [currentDefaults setObject:data1 forKey:@"ksinglechatUserArray"];
                        
                        
                        
                        if ([str_isNew isEqualToString:@"1"]) {
                            
                            [self readMatchesServiceCall:[dict_besicInfo objectForKey:@"id"]];
                        }else{
                            [appDell removeCustomLoader];
                        }
                    }
                    
                    else{
                        
                        _vw_NoMatchFound.hidden = NO;
                        _vw_tap.hidden = NO;
                        _vw_top.hidden = NO;
                        _vw_lower.hidden = NO;
                        _table_match.hidden = YES;
                        _match_collectionVw.hidden = YES;
                        _map_Vw.hidden = YES;
                        _vw_chatNow.hidden = NO;
                        _vw_buttom.hidden = NO;
                        
                        _lbl_ProfileDetails.text = @"";
                        
                        if (playerLayer) {
                            [playerLayer.player pause];
                            [playerLayer removeFromSuperlayer];
                        }
                        
                        if (timer) {
                            [timer invalidate];
                            timer = nil;
                        }
                        
                        [_carousel1 reloadData];
                        
                        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
                        [currentDefaults setObject:data forKey:@"kmatchProfileResponseDetails"];
                    }
                    
                }
                else{
                    
//                    _vw_NoMyMatch.hidden = NO;
//                    _vw_NoMyMatch.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 70);
                    _vw_NoMatchFound.hidden = NO;
                    _vw_tap.hidden = NO;
                    _vw_top.hidden = NO;
                    _vw_lower.hidden = NO;
                        _table_match.hidden = YES;
                        _match_collectionVw.hidden = YES;
                        _map_Vw.hidden = YES;
                    _vw_chatNow.hidden = NO;
                    _vw_buttom.hidden = NO;
                    
                    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseDict];
                    [currentDefaults setObject:data forKey:@"kmatchProfileResponseDetails"];
                }
                
                
            }
            
            else if([strStatus intValue] == 0){
      
                //        [self alertViewToastMessage:strMessage];
                
                [appDell removeCustomLoader];

//                _vw_NoMyMatch.hidden = NO;
//                _vw_NoMyMatch.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 70);
                _vw_tap.hidden = NO;
                _vw_top.hidden = NO;
                _vw_lower.hidden = NO;
                    _table_match.hidden = YES;
                    _match_collectionVw.hidden = YES;
                    _map_Vw.hidden = YES;
                _vw_chatNow.hidden = NO;
                _vw_buttom.hidden = NO;
                
                
                
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


// ********************************* Search Name *****************************************************


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([UIScreen mainScreen].bounds.size.width == 320){
        
        [self makeViewUpper];

    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_txt_search resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
        return YES;
    
    if(range.length==1)
    {
        NSLog(@"Delete %@",strSearchVal);
        
        if ( [strSearchVal length] > 0)
        {
            strSearchVal = [strSearchVal substringToIndex:[strSearchVal length] - 1];
        }
        
    }
    else
    {
        strSearchVal=[textField.text stringByAppendingString:string];
        
    }
    [self search];
    [self.table_match reloadData];
    return YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
        [self makeViewLower];
}

-(void)makeViewUpper{
    CGRect frameView = self.vw_search.frame;
    frameView.origin.y = -150.0f;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.vw_search.frame = frameView;
    } completion:^(BOOL done) {
        
    }];
}

-(void)makeViewLower{
    CGRect frameView = self.vw_search.frame;
    frameView.origin.y = 0.0f;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.vw_search.frame = frameView;
    } completion:^(BOOL done) {
        
    }];
}
-(void)search
{
    [search_Array removeAllObjects];
    
    if(strSearchVal.length>0){
        
        NSLog(@"Seacrh text %ld %@",strSearchVal.length ,strSearchVal);
        //        for (NSMutableDictionary* dict in arrBaseHistory) {
        //            if ([[[dict objectForKey:@"fromText"] lowercaseString] hasPrefix:[self.strVal lowercaseString]]) {
        //                [arrHistory addObject:dict];
        //            }
        //        }
        for (NSDictionary *dictB in base_Array) {
            NSDictionary *dict_basicInfo = [dictB objectForKey:@"basic_info"];
            
            NSString *name = [dict_basicInfo objectForKey:@"name"];

            if ([[name lowercaseString] containsString:[strSearchVal lowercaseString]]) {
                [search_Array addObject:dictB];
            }
        }
        [_table_match reloadData];
        
    }
    else{
        
        search_Array = [arrMatchData mutableCopy];
        [_table_match reloadData];
    }
    
}
#pragma mark iCarousel methods

-(void)careosalDataSource{
    NSDictionary *dict = [base_Array objectAtIndex:selectedProfileIndex];
    NSDictionary *dict_basicInfo = [dict objectForKey:@"basic_info"];
    
    NSString *strCity = [dict_basicInfo objectForKey:@"city"];
    NSString *strCountry = [dict_basicInfo objectForKey:@"country"];
    //NSString *str_gender = [dict_basicInfo objectForKey:@"gender"];
   // NSString *strGender_firstLetter = [str_gender substringToIndex:1];
    NSString *strName = [dict_basicInfo objectForKey:@"name"];
    NSArray *nameArray = [strName componentsSeparatedByString:@" "];
    NSString *str_fName = [nameArray objectAtIndex:0];
    
    
    if ([[dict_basicInfo objectForKey:@"gender"] isEqualToString:@"m"]) {
      
        if (!strCity.length) {
            
            _lbl_ProfileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"country"]];
        }
        
        else if (!strCountry.length){
            
            _lbl_ProfileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"]];
        }
        
        else{
            
           _lbl_ProfileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Male",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
        }
        
    }
    
    else{
        
        if (!strCity.length) {
            
            _lbl_ProfileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"country"]];
        }
        
        else if (!strCountry.length){
            
            _lbl_ProfileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"]];
        }
        
        else{
            
            _lbl_ProfileDetails.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",str_fName,[NSString stringWithFormat:@"%@",[dict_basicInfo objectForKey:@"age"]],@"Female",[dict_basicInfo objectForKey:@"city"],[dict_basicInfo objectForKey:@"country"]];
        }
        
    }
 //   [timer invalidate];
    sliderCount = 0;
    animationType = 0;
    if (playerLayer) {
        [playerLayer.player pause];
        [playerLayer removeFromSuperlayer];
    }
    strVideo = [dict_basicInfo objectForKey:@"video"];
    if (strVideo.length) {
        caresuyalArray = [NSArray arrayWithObject:strVideo];
    }else{
        strVideo = @"";
        caresuyalArray = [dict_basicInfo objectForKey:@"image_video"];
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        
         timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
    }
    
    [self.carousel1 reloadData];
   


}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return caresuyalArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (strVideo.length) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 212)];
        view.backgroundColor = [UIColor blackColor];
        
        NSURL *url1 = [NSURL URLWithString:strVideo];
        AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url1];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;

        playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 212);
        [view.layer addSublayer:playerLayer];
        //[player play];
        [player play];
        player.muted = true;
    }else{
        //create new view if no view is available for recycling
        if (view == nil)
        {
            NSString *imgpath = [caresuyalArray objectAtIndex:index];
            
            NSLog(@"imagePath >>> %@",imgpath);
            
            UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 212)];
            
            [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                //    imgVw.image = [self squareImageWithImage:image scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, _carousel1.frame.size.height)];
                    imgVw.image = image;
                    imgVw.contentMode = UIViewContentModeScaleAspectFill;
                }
            }];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 212)];
            view.backgroundColor = [UIColor clearColor];
            imgVw.tag = 101;
            [view addSubview:imgVw];
        }
        else
        {
            UIImageView *imgVw = (UIImageView *)[view viewWithTag:101];
            [imgVw sd_setImageWithURL:[NSURL URLWithString:[caresuyalArray objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
           //         imgVw.image = [self squareImageWithImage:image scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, _carousel1.frame.size.height)];
                    imgVw.image = image;

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
    [super viewDidAppear:animated];
    [self blockuserlistServiceCall];

}

-(void)runMethod
{
    [self.carousel1 scrollToItemAtIndex:sliderCount animated:sliderCount ? YES : NO];
    if((sliderCount%2) == 0)
    {
        animationType++;
        animationType = (animationType > 4) ? 0 : animationType;
        self.carousel1.type = [[arrAnimationType objectAtIndex:animationType] intValue];
        NSLog(@"---rand %ld",self.carousel1.type);
        if (caresuyalArray.count == (sliderCount+1)) {
            sliderCount=0;
        }else{
            sliderCount++;
        }
        //[self.carousel1 reloadData];
    }
    else
    {
        sliderCount++;
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
// *************************************** Block User Service Call ***************************************************

-(void)blockuserlistServiceCall{
    
    NSDictionary *dictForMatch = @{@"user_id":str_userId,//,@"15"
                                   @"token" :@"adsahtoikng"
                                   };
    
    NSLog(@"dictForMatch>>>>%@",dictForMatch);
    
 //   [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:BlockUserList_URL parameters:dictForMatch progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"success"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
          //  NSArray *arrData;
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                arrBlock = [responseDict objectForKey:@"data"];
                NSLog(@"arrNotificationData >> %@",arrBlock);
                
                for (int i = 0; i < arrBlock.count; i++) {
                    
                    NSDictionary *dict_basicInfo = [arrBlock objectAtIndex:i];
                    NSLog(@"dict_basicInfo>>>>>%@",dict_basicInfo);
                    
                    _lbl_totalBlockUser.text = [NSString stringWithFormat:@"%lu",arrBlock.count];
                    
                }
                //save
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrBlock];
                [currentDefaults setObject:data forKey:@"kBlockUserList"];
                [currentDefaults synchronize];
            
//                //fetch
//                data = [currentDefaults objectForKey:@"kBlockUserList"];
//                NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//                NSLog(@"arr %@",arr);
                
                
                NSLog(@"%@",strMessage);
                
 //               [_match_collectionVw reloadData];
                
//                _lbl_totalLikes.text = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"likes_count"]];
            }
            
            else if([strStatus intValue] == 0){
                
                //        [self alertViewToastMessage:strMessage];
                
                _lbl_totalBlockUser.text = @"";
                
            }
        //    [appDell removeCustomLoader];

            
        }failure:^(NSURLSessionTask *myOpration, NSError *error){
            NSLog(@"error=%@",error);
            [appDell removeCustomLoader];
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

// Read mymatches Service Call

-(void)readMatchesServiceCall:(NSString *) str_matchFriendId{
    
    NSLog(@"str_matchFriendId>>>>%@",str_matchFriendId);
    
    NSDictionary *dictReadMatch = @{@"user_id":str_userId,
                                    @"token" : @"adsahtoikng",
                                    @"match_friend_id": str_matchFriendId
                                    };
    
    NSLog(@"dictReadMatch>>>>%@",dictReadMatch);//Readmatches_URL
    
   // [appDell showCustomLoader:self.view text:@"Loading...."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        [manager POST:Readmatches_URL parameters:dictReadMatch progress:nil success:^(NSURLSessionTask *task, id resPonceObject){
            
            
            NSDictionary *responseDict = (NSDictionary*)resPonceObject;
            
            NSString *strStatus = [responseDict objectForKey:@"status"];
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            
            NSLog(@"responseDict >> %@",responseDict);
            //   NSLog(@"foodArray>>%@,musicArray>>%@,interestArray>>%@",foodArray,musicArray,interestArray);
            
            if ([strStatus intValue] == 1){
                
                [appDell removeCustomLoader];
                
                NSLog(@"%@",strMessage);
                
                [self myMatchServiceCall];
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
            [appDell removeCustomLoader];

        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
}



@end
