//
//  explorePage.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 23/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "GBSliderBubbleView.h"
#import "CustomSlider.h"

@interface explorePage : UIViewController<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) IBOutlet UIView *HeyBoyNoBoyView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *vw_imageshow;

@property (strong, nonatomic) IBOutlet UILabel *lbl_profileDetails;

@property (strong, nonatomic) IBOutlet UILabel *lbl_message;
@property (strong, nonatomic) IBOutlet UIView *view_settings;
@property (strong, nonatomic) IBOutlet UIButton *btn_Search;
@property (strong, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (strong, nonatomic) IBOutlet UITextField *txt_search;
@property (strong, nonatomic) IBOutlet UISlider *slider_distance;

@property (strong, nonatomic) IBOutlet UIButton *btn_reportProfile;
@property (strong, nonatomic) IBOutlet UIButton *btn_BlockProfile;
@property (strong, nonatomic) IBOutlet UIButton *btn_ShowProfile;
@property (strong, nonatomic) IBOutlet UIButton *btn_Settings;

@property (strong, nonatomic) IBOutlet UIButton *btn_hey;
@property (strong, nonatomic) IBOutlet UIButton *btn_btnNo;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) IBOutlet UIView *view_NoMatch;


@property (nonatomic, strong) IBOutlet iCarousel *carousel1;
@property (strong, nonatomic) IBOutlet UIImageView *img_gifLike;
@property (strong, nonatomic) IBOutlet UIImageView *img_gifDislike;
@property (strong, nonatomic) IBOutlet GBSliderBubbleView *GBSliderBubbleView;


@end
