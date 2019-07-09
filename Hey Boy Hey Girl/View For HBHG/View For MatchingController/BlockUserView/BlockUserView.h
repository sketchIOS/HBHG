//
//  BlockUserView.h
//  Hey Boy Hey Girl
//
//  Created by Arka Banerjee on 22/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockUserView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *img_bg;


- (IBAction)btn_Ok:(id)sender;

- (IBAction)btn_Cancel:(id)sender;

-(void)setUpUi;

@end
