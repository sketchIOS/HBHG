//
//  profileFullView.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 23/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol profileFullDelegate <NSObject>
-(void)blockUserProfile;
@end


@interface profileFullView : UIViewController<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, weak) id <profileFullDelegate> delegate_profileFullView;

@property (strong, nonatomic) IBOutlet UIView *middleVw;
@property (strong, nonatomic) IBOutlet UIView *leftVw;
@property (strong, nonatomic) IBOutlet UIView *rightVw;


@property (strong, nonatomic) IBOutlet UIButton *btn_Back;
- (IBAction)btn_blockUser:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_ReportUser;

@property (strong, nonatomic) IBOutlet UIButton *btn_Eats;
@property (strong, nonatomic) IBOutlet UIButton *btn_Loves;
@property (strong, nonatomic) IBOutlet UIButton *btn_Music;

@property (strong, nonatomic) IBOutlet UIButton *leftEditButton;
@property (strong, nonatomic) IBOutlet UIButton *middleEditButton;
@property (strong, nonatomic) IBOutlet UIButton *rightEditButton;

@property (strong, nonatomic) IBOutlet UICollectionView *interest_collectionVw;

//@property (strong) NSMutableArray *arrProfileData;
//@property (assign) int profileindex;
@property (strong) NSDictionary *dictProfileData;

@property (strong, nonatomic) IBOutlet UILabel *lbl_profileDetails;

@property (nonatomic, strong) IBOutlet iCarousel *carousel_middle;
@property (nonatomic, strong) IBOutlet iCarousel *carousel_left;
@property (nonatomic, strong) IBOutlet iCarousel *carousel_right;


@end
