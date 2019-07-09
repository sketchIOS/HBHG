//
//  UpdateDetails.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 07/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol updateDelegate <NSObject>
@end


@interface UpdateDetails : UIView
@property (nonatomic, weak) id <updateDelegate> delegate_selection;
-(void)setUpUi;

@property (strong, nonatomic) IBOutlet UIImageView *mainImgVw;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDobLabel;
@property (strong, nonatomic) IBOutlet UILabel *userGenderLabel;

@property (strong, nonatomic) IBOutlet UIButton *straightSignImgVw;
@property (strong, nonatomic) IBOutlet UIButton *gaySignImgVw;
@property (strong, nonatomic) IBOutlet UIButton *bisexualSignImgVw;

@property (strong, nonatomic) IBOutlet UILabel *strightTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *gayTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *bisexualTextLabel;

@property (strong, nonatomic) IBOutlet UIButton *straightCheckButton;
@property (strong, nonatomic) IBOutlet UIButton *GayCheckButton;
@property (strong, nonatomic) IBOutlet UIButton *BisexualCheckButton;

@end
