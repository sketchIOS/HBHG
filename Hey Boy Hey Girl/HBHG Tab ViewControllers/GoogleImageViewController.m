//
//  GoogleImageViewController.m
//  Hey Boy Hey Girl
//
//  Created by Arka Banerjee on 19/03/18.
//  Copyright © 2018 Sketch Developer. All rights reserved.
//

#import "GoogleImageViewController.h"
#import "ImageRecord.h"
#import "UIImageView+AFNetworking.h"
#import "ImageSearching.h"
#import "FacebookImageCollectionViewCell.h"
#import "ImageViewForInterest.h"
#import "AppDelegate.h"
#import "CommonHeaderFile.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface GoogleImageViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>{
    
    NSString *strSearchVal;
  //  NSMutableArray *images;
    AppDelegate *appDell;
    BOOL inSearchMode;
    
    int startId;
}

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation GoogleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    strSearchVal = @"";
    _images = [[NSMutableArray alloc] init];
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    self.navigationController.navigationBarHidden = YES;
    
    startId = 1;

    
    
    [_img_collectionVw registerNib:[UINib nibWithNibName:@"FacebookImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FacebookImageCollectionViewCell"];
    
    _img_collectionVw.delegate = self;
    _img_collectionVw.dataSource = self;

    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    _txt_search.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_backAction:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];

    
}
- (IBAction)btn_cancelAction:(id)sender {
    
    _searchBar.text = @"";
    startId = 1;
    [_images removeAllObjects];
    [_img_collectionVw reloadData];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setInteger:startId forKey:kGoogleInageStartIndex];
    [userD synchronize];
}
- (IBAction)btn_load:(id)sender {
    
    startId = startId + 10;
    
    [self loadImagesWithOffset:0];
}
// collection view Delegate and Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FacebookImageCollectionViewCell *cell = [_img_collectionVw dequeueReusableCellWithReuseIdentifier:@"FacebookImageCollectionViewCell" forIndexPath:indexPath];
    
    
    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
    
  
  //  [cell.img_fb setImageWithURL:imageRecord.thumbnailURL];
    
    [cell.img_fb sd_setImageWithURL:imageRecord.thumbnailURL placeholderImage:[UIImage imageNamed:@"whitegGlass.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            cell.img_fb.image = image;
        }
    }];
    
    cell.img_video.hidden = YES;
    cell.img_checked.hidden = YES;
    
    // Check if this has been the last item, if so start loading more images...
//    if (indexPath.row == [self.images count] - 1) {
//        [self loadImagesWithOffset:(int)[self.images count]];
//    };

    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *arr;
    
    arr = [[NSMutableArray alloc] init];
    
    FacebookImageCollectionViewCell *cell = [_img_collectionVw dequeueReusableCellWithReuseIdentifier:@"FacebookImageCollectionViewCell" forIndexPath:indexPath];
   
//    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
//
//
//    [arr addObject:imageRecord.thumbnailURL];
    
//    if (cell.img_fb.image) {
//        
//        [arr addObject: cell.img_fb.image];
//
//    }
//    
//    
//    NSLog(@"arr>>>>%@",arr);
    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];

    [self showImageInterestViewFromCellInfo:_cellDictionary image:imageRecord.thumbnailURL];
   
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
    return UIEdgeInsetsMake(5, 5, 5, 5);
}






//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//
//    [_txt_search resignFirstResponder];
//    return YES;
//}
//
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
//    NSLog(@"searchText---- %@",strSearchVal);
//    if (strSearchVal.length == 0) {
//        startId = 1;
//        [_images removeAllObjects];
//        [_img_collectionVw reloadData];
//    }
//   // [self loadImagesWithOffset:0];
//    return YES;
//
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//
// //   [self makeViewLower];
//    startId = 1;
//    if (_txt_search.text.length != 0) {
//        [self loadImagesWithOffset:0];
//    }
//
//}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Dismiss the keyboard
    [searchBar resignFirstResponder];
    
    [self loadImagesWithOffset:0];
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//
//  //  _searchBar.text = @"";
//    startId = 1;
//    [_images removeAllObjects];
//    [_img_collectionVw reloadData];
//    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//    [userD setInteger:startId forKey:kGoogleInageStartIndex];
//    [userD synchronize];
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
   // [self filterContent:searchBar.text];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   // [self filterContent:searchText];
   // [searchBar setShowsCancelButton:true ganimated:true];
    if ([searchBar.text isEqualToString: @""]) {
            startId = 1;
            [_images removeAllObjects];
            [_img_collectionVw reloadData];
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            [userD setInteger:startId forKey:kGoogleInageStartIndex];
            [userD synchronize];
    }
    
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//   // inSearchMode = true;
//    [searchBar setShowsCancelButton:false animated:true];
//}

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    NSString *searchText = searchBar.text;
//    
//    // We're still 'in edit mode', if the user left a keyword in the searchBar
//    inSearchMode = (searchText != nil && [searchText length] > 0);
//    [searchBar setShowsCancelButton:inSearchMode animated:true];
//    
//    [self filterContent:searchText];
//}
//- (void)filterContent:(NSString*)searchText
//{
//    if(inSearchMode)
//    {
//        // Populate the results
//    }
//}


- (void)updateTitle
{
    NSString *searchProviderString = [[NSUserDefaults standardUserDefaults] stringForKey:@"search_provider"];
    self.title = [NSClassFromString(searchProviderString) title];;
    
    NSLog(@"Updated search provider to %@", searchProviderString);
}

- (id<ImageSearching>)activeSearchClient
{
    NSString *searchProviderString = [[NSUserDefaults standardUserDefaults] stringForKey:@"search_provider"];
    id<ImageSearching> sharedClient = [NSClassFromString(searchProviderString) sharedClient];
    NSAssert(sharedClient, @"Invalid class string from settings encountered");
    
    return sharedClient;
}


- (void)loadImagesWithOffset:(int)offset
{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setInteger:startId forKey:kGoogleInageStartIndex];
    [userD synchronize];
    
    // Do not allow empty searches
//    if ([self.txt_search.text isEqual:@""]) {
//        return;
//    }
    if ([self.searchBar.text isEqual:@""]) {
        return;
    }
    
    if (offset == 0) {
        // Clear the images array and refresh the table view so it's empty
       // [_images removeAllObjects];
        [_img_collectionVw reloadData];
        
        // Show a loading spinner
   //     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [appDell showCustomLoader:self.view text:@"Loading..."];
    }
    
    
    __weak GoogleImageViewController *weakSelf = self;
    
    [[self activeSearchClient] findImagesForQuery:self.searchBar.text withOffset:offset
                                          success:^(NSURLSessionDataTask *dataTask, NSArray *imageArray) {
                                              if (offset == 0) {
                                                 // weakSelf.images = [NSMutableArray arrayWithArray:imageArray];
                                                  [weakSelf.images addObjectsFromArray:imageArray];
                                              } else {
                                                  [weakSelf.images addObjectsFromArray:imageArray];
                                              }
                                              
                                              [weakSelf.img_collectionVw reloadData];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                 // [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  [appDell removeCustomLoader];
                                              });
                                          }
                                          failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                                              NSLog(@"An error occured while searching for images, %@", [error description]);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                 // [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                  [appDell removeCustomLoader];

                                              });
                                          }
     ];
    
   /*
 //   __weak GoogleImageViewController *weakSelf = self;
    
    [[self activeSearchClient] findImagesForQuery:self.txt_search.text withOffset:offset
                                          success:^(NSURLSessionDataTask *dataTask, NSArray *imageArray) {
                                              if (offset == 0) {
                                                  images = [NSMutableArray arrayWithArray:imageArray];
                                              } else {
                                                  [images addObjectsFromArray:imageArray];
                                              }
                                              
                                              [_img_collectionVw reloadData];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                              });
                                          }
                                          failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                                              NSLog(@"An error occured while searching for images, %@", [error description]);
                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                              });
                                          }
     ];
    */
}



//-(void)showImageInterestViewFrom:(NSArray *) imgArray cellInfo:(NSDictionary *) dictcellInfo{
//
//    ImageViewForInterest *imgInterestVw = [[ImageViewForInterest alloc] init];
//    imgInterestVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    imgInterestVw.arr_image = imgArray;
//    imgInterestVw.cellInfoDict = dictcellInfo;
//    [imgInterestVw setUpUI];
//    [self.view addSubview:imgInterestVw];
//}

-(void)showImageInterestViewFromCellInfo:(NSDictionary *) dictcellInfo image:(NSURL *) imageUrl{
    
    ImageViewForInterest *imgInterestVw = [[ImageViewForInterest alloc] init];
    imgInterestVw.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    // imgInterestVw.arr_image = imgArray;
    imgInterestVw.cellInfoDict = dictcellInfo;
    imgInterestVw.img_url = imageUrl;
    imgInterestVw.strSearchName = _searchBar.text;
    imgInterestVw.isGoogleImage = YES;
    [imgInterestVw setUpUI];
    [self.view addSubview:imgInterestVw];
}

@end
