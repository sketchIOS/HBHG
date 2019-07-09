//
//  GoogleImageViewController.h
//  Hey Boy Hey Girl
//
//  Created by Arka Banerjee on 19/03/18.
//  Copyright © 2018 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSearching.h"

@interface GoogleImageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btn_Back;
@property (strong, nonatomic) IBOutlet UIButton *btn_cancel;
@property (strong, nonatomic) IBOutlet UIButton *btn_load;

@property (strong, nonatomic) IBOutlet UICollectionView *img_collectionVw;
@property (strong, nonatomic) IBOutlet UITextField *txt_search;
@property (assign) NSDictionary *cellDictionary;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


//@property (nonatomic, strong) NSMutableArray *images;
- (void)updateTitle;
- (id<ImageSearching>)activeSearchClient;
- (void)loadImagesWithOffset:(int)offset;

@end

