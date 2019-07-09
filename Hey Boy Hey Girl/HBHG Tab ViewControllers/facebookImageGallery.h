//
//  facebookImageGallery.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 04/12/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol fbImageDelegate <NSObject>

//@property (nonatomic, weak) id <fbImageDelegate> delegate_fbImage;

-(void)backFromFbGallary;
-(void)fbVideoTrmming:(NSString *) strVideoUrl;
-(void)showFbimage:(NSMutableArray *) arr_img view:(int) imgVw_No;
-(void)showImageInCarosal:(NSMutableArray *) arrImageData;
//-(void)showImageInCell:(NSMutableArray *)arrImageData cellDetails:(NSDictionary *)dictForCell;
@end


@interface facebookImageGallery : UIViewController

@property (nonatomic, weak) id <fbImageDelegate> delegate_fbImage;

@property (strong, nonatomic) IBOutlet UICollectionView *fb_CollectionVw;

- (IBAction)btn_Done:(id)sender;
@property (strong) NSString *str_PageName;
@property (assign) NSDictionary *cellDictionary;
@property (assign) int viewNumber;
@property (strong) NSMutableArray *arr_instagram;
@property (strong) NSMutableArray *arr_fb;
@property (assign) BOOL fbSelect;
@property (assign) BOOL isImageVideo;

@property (assign) NSMutableDictionary *dict_insta;

@end
