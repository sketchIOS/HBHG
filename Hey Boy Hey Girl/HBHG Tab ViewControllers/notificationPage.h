//
//  notificationPage.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 23/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol notificationDelegate <NSObject>
-(void)likeProfileNotificationaction:(NSDictionary *) dictProfile;

@end

@interface notificationPage : UIViewController

@property (nonatomic, weak) id <notificationDelegate> delegate_notification;

@property (strong, nonatomic) IBOutlet UIImageView *img_DeleteNotification;

@property (strong, nonatomic) IBOutlet UITableView *notification_table;
@property (strong, nonatomic) IBOutlet UIView *vwNoNotification;



@end
