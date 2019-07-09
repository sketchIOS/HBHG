//
//  facebookImageGallery.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 04/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "facebookImageGallery.h"
#import <sqlite3.h>
#import "FacebookImageCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Login.h"
#import "CommonHeaderFile.h"
#import "AppDelegate.h"
#import "ImageViewForInterest.h"
#import "VideoEditingViewController.h"

@interface facebookImageGallery ()<UICollectionViewDelegate,UICollectionViewDataSource,interestDelegate,videoTrimmingDelegate>
{
    
    //Sqlite
    sqlite3 *myDB;
    NSString *dbpath;
    NSMutableArray *imagePath,*arrSelectedImage,*arrInstagram;
    
    NSMutableArray *arrInstaImage,*arrInstaVideo,*arrInstavideoTumbnil;
    
    AppDelegate *appDell;
}

- (IBAction)backButton:(id)sender;
@end

@implementation facebookImageGallery

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBarHidden = YES;
    
    [_fb_CollectionVw registerNib:[UINib nibWithNibName:@"FacebookImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FacebookImageCollectionViewCell"];
    
    _fb_CollectionVw.delegate = self;
    _fb_CollectionVw.dataSource = self;
    
   imagePath  = [[NSMutableArray alloc]init];
    arrSelectedImage = [[NSMutableArray alloc] init];
    arrInstagram = [[NSMutableArray alloc] init];
    arrInstaImage = [[NSMutableArray alloc] init];
    arrInstaVideo = [[NSMutableArray alloc] init];
    arrInstavideoTumbnil = [[NSMutableArray alloc] init];
    
    if (!_fbSelect) {
        
        
//        arrInstagram = [_arr_instagram mutableCopy];
//        NSLog(@"arrInstagram>>>>%@",arrInstagram);
        
        NSLog(@"dictInsta>>>>>%@",_dict_insta);
        
        arrInstaImage = [_dict_insta objectForKey:@"images"];
        arrInstaVideo = [_dict_insta objectForKey:@"videos"];
        
        
    }
    else{
      //  [self fetchDataFromUserMaster];
        
        imagePath = [_arr_fb mutableCopy];
        NSLog(@"arrFb>>>>%@",imagePath);

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
 //   [self fetchDataFromUserMaster];
}

- (IBAction)backButton:(id)sender
{

    if ([_str_PageName isEqualToString:@"login"]) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }
    else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^(){
            
            [self backFromGallery];
        }];
    }
    
}

// collectionview Dalegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  //   return 1;
    
    if (!_fbSelect) {
        
        return 2;
    }
    
    else{
        return 1;
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (!_fbSelect) {
        
   //     return arrInstagram.count;
        
        if (section == 0) {
            
            return arrInstaImage.count;
        }
        
        else{
            
            return arrInstaVideo.count;
        }
    }
    else{
        return imagePath.count;

    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FacebookImageCollectionViewCell *cell = [_fb_CollectionVw dequeueReusableCellWithReuseIdentifier:@"FacebookImageCollectionViewCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.row +1;
    cell.img_fb.tag = indexPath.section +1;
    if (_fbSelect) {
       
        
        cell.img_video.hidden = YES;
      NSString *imgpath  = [imagePath objectAtIndex:indexPath.row];
        
        NSLog(@"imagePath >>> %@",imgpath);
        
        [cell.img_fb sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image){
                cell.img_fb.image = image;
            }
        }];
    }
    
    else
    {
        if (indexPath.section == 0) {
            
            
            cell.img_video.hidden = YES;
            NSString   *imgPath = [arrInstaImage objectAtIndex:indexPath.row];
            
            NSLog(@"imagePath >>> %@",imgPath);
            
            [cell.img_fb sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    cell.img_fb.image = image;
                }
            }];
            
        }
        
        else{
            
            
            cell.img_video.hidden = NO;
            NSDictionary *dict = [arrInstaVideo objectAtIndex:indexPath.row];
            
            NSString   *imgPath = [dict objectForKey:@"thumbnail"];
            
            [cell.img_fb sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    cell.img_fb.image = image;
                }
            }];
            
        }
     
    }
   
    
//    cell.img_fb.tag = indexPath.row + 1;
//    cell.img_checked.tag = indexPath.row + 1;
    cell.img_checked.hidden = YES;
    
   
    
    UITapGestureRecognizer * imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedImage:)];
    [cell setUserInteractionEnabled:YES];
    [cell addGestureRecognizer:imageGesture];
    
    
    
    return cell;
}

// Image Tap Gesture Gesture

- (void)userTappedImage:(UIGestureRecognizer*)gestureRecognizer
{
    int count;
    
    count = 0;
    NSLog(@"userTappedImage called");
    
    FacebookImageCollectionViewCell *cell = (FacebookImageCollectionViewCell *)gestureRecognizer.view;
    
   // cell.img_checked.hidden = NO;
    int selectIndex;
    
    selectIndex = (int)cell.tag - 1;
    
    NSLog(@"selectIndex>>>>>%d",selectIndex);
  
    // FOR LOGIN PAGE
    
    
    if ([_str_PageName isEqualToString:@"login"]) {
        
        if (cell.img_fb.tag == 1) {
            if (_fbSelect) {
                
                if (cell.img_checked.hidden == YES) {
                    
                    if (arrSelectedImage.count == 7){
                        [self alertViewToastMessage:@"Select only 7 pics  to make your profile video"];
                        return;
                    }
                    
                    cell.img_checked.hidden = NO;
                    
                    [arrSelectedImage addObject:[imagePath objectAtIndex:selectIndex]];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    count++;
                }
                else{
                    
                    cell.img_checked.hidden = YES;
                    [arrSelectedImage removeObject:[imagePath objectAtIndex:selectIndex]];
                    //  [arrSelectedImage removeObjectAtIndex:count -1];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    
                }
            }
            else{
                
                if (cell.img_checked.hidden == YES) {
                    
                    if (arrSelectedImage.count == 7){
                        [self alertViewToastMessage:@"Select only 7 pics  to make your profile video"];
                        return;
                    }
                    
                    cell.img_checked.hidden = NO;
                    
                    [arrSelectedImage addObject:[arrInstaImage objectAtIndex:selectIndex]];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    count++;
                }
                else{
                    
                    cell.img_checked.hidden = YES;
                    [arrSelectedImage removeObject:[arrInstaImage objectAtIndex:selectIndex]];
                    //  [arrSelectedImage removeObjectAtIndex:count -1];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    
                }
            }
        }
        
        else{
            
            if (_fbSelect) {
                
            }
            
            else{
                
                NSLog(@"Instagram Video Select>>>>>>>>>>>>>>>>");
                NSString *strVideo;
                NSDictionary *dict= [arrInstaVideo objectAtIndex:selectIndex];
                strVideo = [dict objectForKey:@"videoUrl"];
            
                [self dismissViewControllerAnimated:NO completion:^{
                    [self.delegate_fbImage fbVideoTrmming:strVideo];
                }];
            
//                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//                
//                VideoEditingViewController *videoEditVC = (VideoEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoEditingViewController"];
//                videoEditVC.videoFilePathStr = strVideo;
//                videoEditVC.delegate_trimVideo =self;
//                [self.navigationController pushViewController:videoEditVC animated:NO];
            }
        }
        
    }
    
    
    // FOR PROFILE PAGE
    
    else{
        
        
        if ([_str_PageName isEqualToString:@"profile"]) {
            
            // Profile Page Upper image_video Selection
            
            if(cell.img_fb.tag == 1){
                
                if (cell.img_checked.hidden == YES) {
                    
                    if (arrSelectedImage.count == 7){
                        [self alertViewToastMessage:@"Select only 7 pics  to make your profile video"];
                        return;
                    }
                    cell.img_checked.hidden = NO;
                    
                    [arrSelectedImage addObject: cell.img_fb.image];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    count++;
                }
                else{
                    
                    cell.img_checked.hidden = YES;
                    [arrSelectedImage removeObject: cell.img_fb.image];
                    //  [arrSelectedImage removeObjectAtIndex:count -1];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    
                }
            }
            
            else{
                // Profile page upper video selection From instagram
                
                NSLog(@"Instagram Video Select>>>>>>>>>>>>>>>>");
                NSString *strVideo;
                NSDictionary *dict= [arrInstaVideo objectAtIndex:selectIndex];
                strVideo = [dict objectForKey:@"videoUrl"];
                
                [self dismissViewControllerAnimated:NO completion:^{
                    [self.delegate_fbImage fbVideoTrmming:strVideo];
                }];
            }
        }
        
        else{
            
            // Profile page Lower interest view Image Selecion
            
            if(cell.img_fb.tag == 1){
                
                if (cell.img_checked.hidden == YES) {
                    
                    if (arrSelectedImage.count == 1){
           //             [self alertViewToastMessage:@"Only select only 7 pics  to make your profile video"];
                        return;
                    }
                    cell.img_checked.hidden = NO;
                    
                    [arrSelectedImage addObject: cell.img_fb.image];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    count++;
                }
                else{
                    
                    cell.img_checked.hidden = YES;
                    [arrSelectedImage removeObject: cell.img_fb.image];
                    //  [arrSelectedImage removeObjectAtIndex:count -1];
                    NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
                    
                }
            }
            
        }

        
    }

}



//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSString *strImg = [imagePath objectAtIndex:indexPath.row];
//    NSArray *arr = [NSArray arrayWithObject:strImg];
//    Login *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//    loginVC.arrImageForFB = [arr mutableCopy];
//
//    [self.navigationController pushViewController:loginVC animated:YES];
//}

//Jitendra
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.033), 120);

    }
    else if ([UIScreen mainScreen].bounds.size.width == 375){

        return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.028), 120);

    }
    
    
    
    return CGSizeMake(self.view.frame.size.width/3-(self.view.frame.size.width*0.024), 120);
    
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
    return UIEdgeInsetsMake(10, 5, 5, 10);
}



- (IBAction)btn_Done:(id)sender {
    NSMutableArray *arr;
    
    arr = [[NSMutableArray alloc] init];
    if (arrSelectedImage.count) {
        
        NSLog(@"arrSelectedImage>>>>%@",arrSelectedImage);
        
        for (int i = 0; i< arrSelectedImage.count; i++) {
            NSString *strImg = [arrSelectedImage objectAtIndex:i];

            NSLog(@"strImg>>>>%@",strImg);

            
            [arr addObject:strImg];
        }
        
        if (arr.count < 8) {
            
//            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//            [userD setObject:arr forKey:kimageArrayFromFb];
            if ([_str_PageName isEqualToString:@"login"]) {
               

                
                [self.delegate_fbImage showImageInCarosal:arr];
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
                
            }
            
            else if ([_str_PageName isEqualToString:@"profile"]){
                

                
                NSLog(@"_viewNumber>>>>%d",_viewNumber);
                
               [self.delegate_fbImage showFbimage:arr view:_viewNumber];
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];

            }
            
            else
            {
                [self showImageInterestViewFrom:arr cellInfo:_cellDictionary];
        //        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];

            }
            
            
        }
        
        else{
            
            NSLog(@"111124556546467657657577");
            [self alertViewToastMessage:@"Select only 7 pics  to make your profile video"];
        }
        
    }
    
}


// show Interest image view

-(void)showImageInterestViewFrom:(NSArray *) imgArray cellInfo:(NSDictionary *) dictcellInfo{
    
    ImageViewForInterest *imgInterestVw = [[ImageViewForInterest alloc] init];
    imgInterestVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    imgInterestVw.arr_image = imgArray;
    imgInterestVw.cellInfoDict = dictcellInfo;
    [imgInterestVw setUpUI];
     [self.view addSubview:imgInterestVw];
}

-(void)dismissVC{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

// Alert Toast Message
-(void)alertViewToastMessage:(NSString *) message{
    
    
    NSString *alert_message = message;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"HBHG"
                                                                   message:alert_message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 2; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)backFromGallery{
    
    [self.delegate_fbImage backFromFbGallary];
}

@end
