//
//  BlockUserView.m
//  Hey Boy Hey Girl
//
//  Created by Arka Banerjee on 22/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "BlockUserView.h"

@implementation BlockUserView

-(id)init{
    
    NSArray *nib =
    [[NSBundle mainBundle] loadNibNamed:@"BlockUserView" owner:nil options:nil];
    
    self=[nib lastObject];
    
    return self;
    
}

-(void)setUpUi{
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapPress.numberOfTapsRequired = 1;
    tapPress.numberOfTouchesRequired = 1;
    [self.img_bg addGestureRecognizer:tapPress];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gesture{
    [self removeFromSuperview];
}


- (IBAction)btn_Ok:(id)sender {
}

- (IBAction)btn_Cancel:(id)sender {
    
    [self removeFromSuperview];
}
@end
