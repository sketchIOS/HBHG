//
//  ReportUserView.h
//  Hey Boy Hey Girl
//
//  Created by Arka Banerjee on 22/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportUserView : UIView


@property (strong, nonatomic) IBOutlet UITextField *txt_Reason;

- (IBAction)btn_Ok:(id)sender;
- (IBAction)btn_Cancel:(id)sender;

@end
