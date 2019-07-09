//
//  ChatPage.h
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 22/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatPage : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *myChat_collectionVw;

@property (strong, nonatomic) IBOutlet UICollectionView *featuredChat_collectionVw;

@property (strong, nonatomic) IBOutlet UICollectionView *tradingChat_collectionVw;

@property (strong, nonatomic) IBOutlet UICollectionView *myChatRoom_collectionVw;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollVW;

-(void)showChatNotifiaction;

@end
