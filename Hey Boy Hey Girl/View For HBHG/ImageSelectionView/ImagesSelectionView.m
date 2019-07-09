//
//  ImagesSelectionView.m
//  
//
//  Created by Sketch Developer on 01/12/17.
//

#import "ImagesSelectionView.h"

@implementation ImagesSelectionView

-(id)init{
    
    NSArray *nib =
    [[NSBundle mainBundle] loadNibNamed:@"ImageSelectionView" owner:nil options:nil];
    
    self=[nib lastObject];
    
    return self;
    
}


-(void)setUpUi{
    
    
}


- (IBAction)VideoButton:(id)sender {
    NSLog(@"VideoButton clicked");
    [self.delegate_selection videoAction];
}
- (IBAction)GalleryButton:(id)sender {
    NSLog(@"GalleryButton clicked");
    [self.delegate_selection galleryAction];
    [self removeFromSuperview];// self used for view
}
- (IBAction)facebookButton:(id)sender {
    NSLog(@"facebookButton clicked");
    [self.delegate_selection faceBookAction];

}
- (IBAction)instragramButton:(UIButton *)sender {
    NSLog(@"instragramButton clicked");
    [self.delegate_selection instragramAction];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
