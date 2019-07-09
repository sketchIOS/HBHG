//
//  Login.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 06/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "Login.h"
#import "ProfilePage.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ImagesSelectionView.h"
#import "UpdateDetails.h"
#import "facebookImageGallery.h"
#import "instagramImageGalery.h"
#import "AppDelegate.h"
#import "CommonHeaderFile.h"
#import <sqlite3.h>
//#import "FSPagerViewExample_Objc-Swift.h"
#import "SDWebImage/UIImageView+WebCache.h"
//ARUN
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"


@interface Login ()<userUpdateDelegate,selectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    AppDelegate *appDell;
    ImagesSelectionView *imageSelectionVw;
    UpdateDetails *UpdateDetailsVw;

    NSMutableArray *profilePicUrlArray;
    
    NSString *facebookIdString;
    NSString *deviceTypeString;
    NSString *tokenIdString;
    NSString *optionalParamString;
    NSString *firstNameString;
    NSString *lastNameString;
    NSString *genderString;
    NSString *sexualOrientationString;
    NSString *phoneNoString;
    NSString *countryString;
    NSString *dobString;
    NSString *profileImageString;
    NSString *age;

    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    
    NSMutableArray *arrImagePath;
    float width;
    NSTimer *timer;
    
    //Sqlite
    sqlite3 *myDB;
    NSString *dbpath;
    BOOL isDBcreated;
  //  BOOL isEditImagesForFB;
    
    int imageIndex;
    
}
@property (strong, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;



//inage sliding
//@property (strong, nonatomic) FSPagerView *pagerView;
//@property (strong, nonatomic)  FSPageControl *pageControl;
//@property (strong, nonatomic) NSArray<NSString *> *imageNames;
//@property (assign, nonatomic) NSInteger numberOfItems;


- (IBAction)EditVideoButton:(id)sender;
- (IBAction)IamHppyButton:(id)sender;

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    
    if (isDBcreated == YES) {
        
        [self updateDB];
    }
    else{
        
        [self createDB];

    }
    
    
    NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
    NSString *tokenID = [userDF stringForKey:@"NS_tokenId"];
    NSLog(@"TokenID - %@",tokenID);

    profilePicUrlArray = [[NSMutableArray alloc] init];
    [self fetchUserInfo];
    
//    // showing profile pics
//
//    NSString *imgpath = [_arrImageForFB objectAtIndex:0];
//
//    NSLog(@"imagePath >>> %@",imgpath);
//
//    [_img_profile sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if(image){
//            _img_profile.image = image;
//        }
//    }];
    
    
    
   
    
//    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//   _arrImageForFB = [userD objectForKey:kimageArrayFromFb];
    
    
    imageIndex = 0;
    
    
    
//______________________________________________________________
    
    
    arrImagePath = [[NSMutableArray alloc] init];
    
    
    //Test New
//    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, screenWidth,50)];
//    self.headerView.backgroundColor = [UIColor yellowColor];
//    self.userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, screenWidth, 100)];
//    
//    self.userInfoLabel.textAlignment = NSTextAlignmentCenter;
//    
//    self.userInfoLabel.text = @"text";
//    
//    [self.view addSubview:self.headerView];
//    [self.headerView addSubview:self.userInfoLabel];
    
    _headerView.frame = CGRectMake(-200, 18, 320, 110);
    
    [UIView animateWithDuration:3.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.headerView.frame  = CGRectMake(([UIScreen mainScreen].bounds.size.width -_headerView.frame.size.width)/2, 18, 320,110);
    } completion:^(BOOL finished) {

    }];
    
    _footerView.frame = CGRectMake(0, 550, 320, 260);
    
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.footerView.frame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _footerView.frame.size.height, 320,260);
        
    } completion:^(BOOL finished) {
        
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    
    NSString *imgpath = [_arrImageForFB objectAtIndex:0];
    
    NSLog(@"imagePath >>> %@",imgpath);
    
    [_img_profile sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            _img_profile.image = image;
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    self.headerView.frame  = CGRectMake(self.headerView.frame.origin.x,-265, 320,260);
//
//    self.footerView.frame  = CGRectMake(self.headerView.frame.origin.x, screenHeight+265, 320,260);

}

//#pragma mark - FSPagerViewDataSource
//
//- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView
//{
//    return self.numberOfItems;
//}
//
//- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
//{
//    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
//    cell.imageView.image = [UIImage imageNamed:self.imageNames[index]];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    cell.imageView.clipsToBounds = YES;
//    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@(index),@(index)];
//    return cell;
//}
//
//#pragma mark - FSPagerView Delegate
//
//- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
//{
//    [pagerView deselectItemAtIndex:index animated:YES];
//    [pagerView scrollToItemAtIndex:index animated:YES];
//    self.pageControl.currentPage = index;
//}
//
//- (void)pagerViewDidScroll:(FSPagerView *)pagerView
//{
//    if (self.pageControl.currentPage != pagerView.currentIndex) {
//        self.pageControl.currentPage = pagerView.currentIndex;
//    }
//}
//
//#pragma mark - Target actions
//
//- (void)sliderValueChanged:(UISlider *)sender
//{
//    switch (sender.tag) {
//        case 1: {
//            CGFloat scale = 0.5 * (1 + sender.value); // [0.5 - 1.0]
//            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, CGAffineTransformMakeScale(scale, scale));
//            break;
//        }
//        case 2: {
//            self.pagerView.interitemSpacing = sender.value * 20; // [0 - 20]
//            break;
//        }
//        case 3: {
//            self.numberOfItems = roundf(sender.value * 7);
//            self.pageControl.numberOfPages = self.numberOfItems;
//            [self.pagerView reloadData];
//            break;
//        }
//        default:
//            break;
//    }
//}



-(void)fetchUserInfo{
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

                 
                 firstNameString = [result objectForKey:@"first_name"];
                 genderString = [result objectForKey:@"gender"];
                 NSString *dateStr = [result objectForKey:@"birthday"];

                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                 NSDate *startD = [dateFormatter dateFromString:dateStr];
                 NSDate *endD = [NSDate date];
                 
                 NSCalendar *calendar = [NSCalendar currentCalendar];
                 NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
                 NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
                 
                 NSInteger year  = [components year];
                 NSInteger month  = [components month];
                 NSInteger day  = [components day];
                 
                 age = [NSString stringWithFormat:@"%li",(long)year];
                 
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
                     NSString *picDate = picture[@"created_time"];
                     NSString *picId = picture[@"id"];
                     NSString *pictureUrl = picture[@"picture"];
                     NSString *sourceUrl = picture[@"source"];
                     
                     [profilePicUrlArray addObject:sourceUrl];
                 }
                 NSLog(@"PICTURE URL- %@",profilePicUrlArray);
                 [self.userInfoLabel setText:[NSString stringWithFormat:@"%@,%@,%@",firstNameString,genderString,age]];
                 [self insertDB];
                // [self dbchecking];
                 
                 if (_isEditImagesForFB == YES) {
                     [self showImageVideosFormFB];
                 }
                 else{
                    [self showImageVideosByDefaults];
                 }
             }
         }];
    }
    

}

-(NSString *)getAge:(NSDate *)dateOfBirth
{
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    return [NSString stringWithFormat:@"%li",age];
}

#pragma mark - Login webservice

-(void)loginServiceCall{
    
    NSDictionary *dict = @{@"facebook_id" :@"1717809028252365",
                           @"device_type" : @"ios",
                           @"token" : @"123",
                           @"Optional Param" :@"",
                           @"first_name" : @"Arun",
                           @"last_name" : @"Halder",
                           @"gender" : @"male",
                           @"sexual_orientation": @"",
                           @"phone" :@"9876543210",
                           @"city" : @"Kolkata",
                           @"country" : @"ios",
                           @"dob" : @"28-07-1987",
                           @"allow_push" :@"yes",
                           @"profile_image" :@"",
                           @"video" :@"",
                           @"image_video" : @"",
                           };
    
    NSLog(@"dict >> %@",dict);
    
    
    
    
}


- (IBAction)EditVideoButton:(id)sender {
    
    
    imageSelectionVw = [[ImagesSelectionView alloc] init];
    imageSelectionVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    imageSelectionVw.vw_body.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    [imageSelectionVw setUpUi];
    imageSelectionVw.delegate_selection = (id)self;
    [self.view addSubview:imageSelectionVw];
}

- (IBAction)IamHppyButton:(id)sender {
    UpdateDetailsVw = [[UpdateDetails alloc] init];
    UpdateDetailsVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UpdateDetailsVw setUpUi];
    UpdateDetailsVw.delegate_updateUser = (id)self;
    [self.view addSubview:UpdateDetailsVw];
    
//    ProfilePage *proflePageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
//    [self.navigationController pushViewController:proflePageVC animated:YES];

  //  [appDell setProfile];
}

-(void)updateUserDetailsDone{
    
    [appDell setProfile];
}



#pragma marks - Selection delegate methods


// Facebook Action
-(void)faceBookAction
{

    
    facebookImageGallery *facebookImageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"facebookImageGallery"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:facebookImageGalleryVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

// Instagram Action
-(void)instragramAction
{
    instagramImageGalery *instagramImageGaleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"instagramImageGalery"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:instagramImageGaleryVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

// Open Gallery
-(void)galleryAction
{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = (id)self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:nil];
    
    [self launchController];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    for (UIImageView *image in _scroll_image.subviews) {
        if ([image isKindOfClass:[UIImageView class]]) {
            [image removeFromSuperview];
        }
    }
    // output image
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    UIImageView *imgVw_camera = [[UIImageView alloc] init];

    imgVw_camera.frame = CGRectMake(0, 0, _scroll_image.frame.size.width, _scroll_image.frame.size.height);
     imgVw_camera.image = chosenImage;
    [_scroll_image addSubview:imgVw_camera];
    [_scroll_image setContentOffset:CGPointZero];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

// Open Camera

-(void)cameraAction
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    _img_profile.image = image;
//    [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
//}




#pragma marks- DB CREATE
-(void)createDB
{
    isDBcreated = YES;
    NSArray *path    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docdir = [path objectAtIndex:0]; //path[0];
    dbpath = [docdir stringByAppendingPathComponent:@"HBHG.db"];
    NSLog(@"database path : %@",dbpath);
    if (sqlite3_open([dbpath UTF8String], &myDB) == SQLITE_OK)
    {
        //CREATE TABLE QUERY
        NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FBIMAGETABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,IMAGEPATH TEXT)";
        char *error = nil;
        if (sqlite3_exec(myDB, [createSQL UTF8String] , NULL, NULL, &error) == SQLITE_OK){
            NSLog(@" HBHG Database and tables created.");
        }
        else{
            NSLog(@"Error %s",error);
        }
        sqlite3_close(myDB);
    }
}

# pragma mark - Insert into DB

-(void)insertDB{
    
    [self DeleteFromDB];
    sqlite3_stmt *statement;
    NSArray *path    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docdir = [path objectAtIndex:0]; //path[0];
    dbpath = [docdir stringByAppendingPathComponent:@"HBHG.db"];
    NSLog(@"database path : %@",dbpath);
    if (sqlite3_open([dbpath UTF8String], &myDB) == SQLITE_OK) {

        for (int i = 0; i < profilePicUrlArray.count; i++) {
            NSString *image = profilePicUrlArray[i];
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO FBIMAGETABLE(IMAGEPATH) VALUES (\"%@\")",image];

            const char *insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(myDB, insert_stmt,-1, &statement, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                NSLog(@"insert into DB");
            }
            else {
                
                NSLog(@"Error");
            }
            sqlite3_reset(statement);
        }
}

}


#pragma mark - update columntext from DB
-(void)updateDB
{
    sqlite3_stmt *statement;
    NSArray *path    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docdir = [path objectAtIndex:0]; //path[0];
    dbpath = [docdir stringByAppendingPathComponent:@"HBHG.db"];
    if(sqlite3_open([dbpath UTF8String], &myDB) == SQLITE_OK)
    {
        for (int i = 0; i < profilePicUrlArray.count; i++) {
            
            NSString *image = profilePicUrlArray[i];

        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE FBIMAGETABLE SET IMAGEPATH= \"%@\"",image];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(myDB, update_stmt, -1, &statement, NULL);
//        if(sqlite3_step(statement)==SQLITE_DONE){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data updated" message:@"Success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert=nil;
//        }
    }
}
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data not updated" message:@"Data not deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        sqlite3_finalize(statement);
        sqlite3_close(myDB);
   
    
}


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
                
                if(arrImagePath.count){
                    
                    NSLog(@"DB is not Empty");
                }
                
                else{
                    
                    [self insertDB];
                }
                
                
               // NSLog(@"imagePath >>>>%@",arrImagePath);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDB);
    }
}

# pragma mark - Delete from DB

-(void)DeleteFromDB{
    sqlite3_stmt *statement;
    
    NSArray *path    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docdir = [path objectAtIndex:0]; //path[0];
    dbpath = [docdir stringByAppendingPathComponent:@"HBHG.db"];
    NSLog(@"database path : %@",dbpath);
    if (sqlite3_open([dbpath UTF8String], &myDB) == SQLITE_OK) {
        
        
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM FBIMAGETABLE"];
            
            const char *insert_stmt = [deleteSQL UTF8String];
            
            sqlite3_prepare_v2(myDB, insert_stmt,-1, &statement, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                NSLog(@"insert into DB");
            }
            else {
                
                NSLog(@"Error");
            }
            sqlite3_reset(statement);
        
    }
    
}




-(void)dbchecking{
    
    [self fetchDataFromUserMaster];
  //  [self updateDB];

}

// For Image Animation

-(void)imageAnimation{
    
    
//    int count;
//    count= (int)_arrImageForFB.count;
//    for (int i = 1; i < count - 1; i++)
    
//     {
    if (imageIndex == 6) {
        imageIndex = 0;
        _scroll_image.contentOffset = CGPointZero;
        return;
    }else
        imageIndex++;
        NSLog(@"Hello Timer is working");
        CGRect frame;
        frame.origin.x = _scroll_image.frame.size.width * imageIndex;
  //  frame.origin.x = 2250;
        frame.origin.y = 0;
        frame.size = _scroll_image.frame.size;
        [_scroll_image scrollRectToVisible:frame animated:NO];
    NSLog(@"frame %@",NSStringFromCGPoint(_scroll_image.contentOffset));
       // count = count + 1;
       // [self setPageControllerUI];
    //}
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [timer invalidate];
}

#pragma marks - ELC Picker for image selection from gallery

- (void)launchController
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 7; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

//- (IBAction)launchSpecialController
//{
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    self.specialLibrary = library;
//    NSMutableArray *groups = [NSMutableArray array];
//    [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        if (group) {
//            [groups addObject:group];
//        } else {
//            // this is the end
//            [self displayPickerForGroup:[groups objectAtIndex:0]];
//        }
//    } failureBlock:^(NSError *error) {
//        self.chosenImages = nil;
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//
//        NSLog(@"A problem occured %@", [error description]);
//        // an error here means that the asset groups were inaccessable.
//        // Maybe the user or system preferences refused access.
//    }];
//}

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
    [self dismissViewControllerAnimated:YES completion:nil];
    
    width = 0;

    NSMutableArray *imagesArrayForGallery = [[NSMutableArray alloc] init];
 //   NSMutableArray *imagesArrayForGallery = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                
                NSLog(@"dict>>>>%@",dict);
                
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [imagesArrayForGallery addObject:image];
                
                NSLog(@"imagesArrayForGallery....>>>>%@",imagesArrayForGallery);
               
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
    
    [self showImagesFrom:imagesArrayForGallery];
}
    

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// For show images from gallery

-(void)showImagesFrom:(NSMutableArray *) arrayForImages
{
    for (UIImageView *image in _scroll_image.subviews) {
        if ([image isKindOfClass:[UIImageView class]]) {
            [image removeFromSuperview];
        }
    }
    for (int i = 0; i < arrayForImages.count; i++) {
        
        // Show images
        
       
        // output image
        //  UIImage *chosenImage = [imagesArrayForGallery objectAtIndex:i];
        
        UIImageView *imgVw_Gallery = [[UIImageView alloc] init];
        
        imgVw_Gallery.frame = CGRectMake(width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        width = width + [UIScreen mainScreen].bounds.size.width;
        imgVw_Gallery.image = [arrayForImages objectAtIndex:i];;
        [_scroll_image addSubview:imgVw_Gallery];
        [_scroll_image setContentOffset:CGPointZero];
    }
    
    
    [_scroll_image setContentSize:CGSizeMake(arrayForImages.count*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(imageAnimation)
                                           userInfo:nil
                                            repeats:YES];
    
}

// First Time Show ImageVideos From FaceBook (Top 7 Seven Images) by Defaults

-(void)showImageVideosByDefaults{
    
    width = 0;

        for(int i = 0; i< 7; i++){
            
            NSString *imgpath = [profilePicUrlArray objectAtIndex:i];
            
            NSLog(@"imagePath >>> %@",imgpath);
            
            UIImageView *imgVw = [[UIImageView alloc] init];
            
            [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    imgVw.image = image;
                }
            }];
            
            
            imgVw.frame = CGRectMake(width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
            width = width + [UIScreen mainScreen].bounds.size.width;
            [_scroll_image addSubview:imgVw];
            
            
        }
        
        [_scroll_image setContentSize:CGSizeMake(7*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(imageAnimation)
                                               userInfo:nil
                                                repeats:YES];
        
    
}

// show image videos From FB After Selecting

-(void)showImageVideosFormFB{
    
    width = 0;
    
        if (_arrImageForFB.count) {
            for(int i = 0; i< _arrImageForFB.count; i++){
                
                NSString *imgpath = [_arrImageForFB objectAtIndex:i];
                
                NSLog(@"imagePath >>> %@",imgpath);
                
                UIImageView *imgVw = [[UIImageView alloc] init];
                
                [imgVw sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        imgVw.image = image;
                    }
                }];
                
                
                imgVw.frame = CGRectMake(width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                
                width = width + [UIScreen mainScreen].bounds.size.width;
                [_scroll_image addSubview:imgVw];
                
            }
            
            [_scroll_image setContentSize:CGSizeMake(7*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                     target:self
                                                   selector:@selector(imageAnimation)
                                                   userInfo:nil
                                                    repeats:YES];
            
        }
        
        else{
            
            NSLog(@"SORRY");
        }
        
    
}


@end
