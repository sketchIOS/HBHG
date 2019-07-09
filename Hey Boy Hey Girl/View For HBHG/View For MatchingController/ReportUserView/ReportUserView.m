//
//  ReportUserView.m
//  Hey Boy Hey Girl
//
//  Created by Arka Banerjee on 22/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "ReportUserView.h"

@implementation ReportUserView

-(id)init{
    
    NSArray *nib =
    [[NSBundle mainBundle] loadNibNamed:@"ReportUserView" owner:nil options:nil];
    
    self=[nib lastObject];
    
    return self;
    
}

- (IBAction)btn_Ok:(id)sender {
    
}

- (IBAction)btn_Cancel:(id)sender {
    
}
@end
