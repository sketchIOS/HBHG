//
//  ImagesSelectionView.h
//  
//
//  Created by Sketch Developer on 01/12/17.
//

#import <UIKit/UIKit.h>
@protocol selectionDelegate <NSObject>
-(void)galleryAction;
-(void)faceBookAction;
-(void)instragramAction;
-(void)videoAction;

@end


@interface ImagesSelectionView : UIView
@property (nonatomic, weak) id <selectionDelegate> delegate_selection;
-(void)setUpUi;

@end
