//
//  myMatchesPage.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 23/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "iCarousel.h"

@interface myMatchesPage : UIViewController<iCarouselDataSource, iCarouselDelegate>


@property (strong, nonatomic) IBOutlet UILabel *lbl_totalLikes;
@property (strong, nonatomic) IBOutlet UILabel *lbl_totalBlockUser;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ProfileDetails;

@property (strong, nonatomic) IBOutlet UIButton *btn_MatchProfile;

@property (strong, nonatomic) IBOutlet UIView *vw_top;
@property (strong, nonatomic) IBOutlet UIView *vw_chatNow;
@property (strong, nonatomic) IBOutlet UIView *vw_tap;
@property (strong, nonatomic) IBOutlet UIView *vw_buttom;
@property (strong, nonatomic) IBOutlet UIView *vw_NoMatchFound;


@property (strong, nonatomic) IBOutlet UIView *vw_lower;
@property (strong, nonatomic) IBOutlet UIView *vw_NoMyMatch;

@property (strong, nonatomic) IBOutlet UICollectionView *match_collectionVw;
@property (strong, nonatomic) IBOutlet UITableView *table_match;
@property (strong, nonatomic) IBOutlet UIView *vw_search;
@property (strong, nonatomic) IBOutlet UITextField *txt_search;

@property (strong, nonatomic) IBOutlet MKMapView *map_Vw;

@property (strong, nonatomic) IBOutlet UIView *vw_likes;
@property (strong, nonatomic) IBOutlet UIView *vw_chat;
@property (strong, nonatomic) IBOutlet UIView *vw_block;

@property (strong, nonatomic) IBOutlet UIButton *btn_chatNow;


@property (strong, nonatomic) IBOutlet UIButton *btn_gridVw;
@property (strong, nonatomic) IBOutlet UIButton *btn_tableVw;
@property (strong, nonatomic) IBOutlet UIButton *btn_searchview;

@property (strong, nonatomic) IBOutlet UIButton *btn_Map;

@property (nonatomic, strong) IBOutlet iCarousel *carousel1;

- (IBAction)btn_searchVw:(id)sender;

@end
