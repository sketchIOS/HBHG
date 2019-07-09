//
//  UpdateDetails.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 07/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "UpdateDetails.h"

@implementation UpdateDetails

-(id)init{
    
    NSArray *nib =
    [[NSBundle mainBundle] loadNibNamed:@"UpdateDetails" owner:nil options:nil];
    
    self=[nib lastObject];
    
    
        
    return self;
    
}


-(void)setUpUi{
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.mainImgVw setUserInteractionEnabled:YES];
    [self.mainImgVw addGestureRecognizer:singleFingerTap];

}



    //The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
    {
        CGPoint location = [recognizer locationInView:[recognizer.view superview]];
        
        //Do stuff here...
        [self removeFromSuperview];
    }

    


@end
