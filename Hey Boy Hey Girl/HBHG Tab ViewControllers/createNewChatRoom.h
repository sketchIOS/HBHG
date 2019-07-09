//
//  createNewChatRoom.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 22/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface createNewChatRoom : UIViewController


- (IBAction)btn_Back:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txt_title;
@property (strong, nonatomic) IBOutlet UITextField *txt_tag;
@property (strong, nonatomic) IBOutlet UIButton *btn_invite;

@property (strong, nonatomic) IBOutlet UIButton *btn_addVideo;
@property (strong, nonatomic) IBOutlet UIImageView *img_btn;

@end
