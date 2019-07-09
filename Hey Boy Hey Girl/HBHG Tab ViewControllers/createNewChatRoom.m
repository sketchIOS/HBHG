//
//  createNewChatRoom.m
//  Hey Boy Hey Girl
//
//  Created by Sketch Developer on 22/11/17.
//  Copyright © 2017 Sketch Developer. All rights reserved.
//

#import "createNewChatRoom.h"
#import "ViewForNewChatroom.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"
#import "SelectFriendViewController.h"
#import "VideoEditingViewController.h"
#import <AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "CommonHeaderFile.h"

@interface createNewChatRoom()<videoSelectionForChatRoomDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,newChatroomDelegate,UITextFieldDelegate,videoTrimmingDelegate>{
    
    int width;
    NSMutableArray *imagesArrayForGallery;
    BOOL isvideoGallery;
    NSString *str_friendList;
    float keyboardHeight;
    NSString *strVideo;
    AppDelegate *appDell;
    NSString *videoPath;
    NSString *str_userId;
    
    NSData *videoDataForService;
}

@property (strong, nonatomic) IBOutlet UIView *addTitleVw;
@property (strong, nonatomic) IBOutlet UIView *addTagsVw;
@property (strong, nonatomic) IBOutlet UIButton *addVideoButton;

@end

@implementation createNewChatRoom

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDell = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    str_userId = [userD objectForKey:khbhgUserId];
    NSLog(@"str_userId>>>>>%@",str_userId);
    
    self.addTitleVw.layer.borderWidth = 1.5f;
    self.addTitleVw.layer.borderColor = [UIColor whiteColor].CGColor;
    [[self.addTitleVw layer] setCornerRadius:5.0f];
    [[self.addTitleVw layer] setMasksToBounds:YES];
    
    self.addTagsVw.layer.borderWidth = 1.5f;
    self.addTagsVw.layer.borderColor = [UIColor whiteColor].CGColor;
    [[self.addTagsVw layer] setCornerRadius:5.0f];
    [[self.addTagsVw layer] setMasksToBounds:YES];
    
    self.addVideoButton.layer.borderWidth = 1.5f;
    self.addVideoButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [[self.addVideoButton layer] setCornerRadius:5.0f];
    [[self.addVideoButton layer] setMasksToBounds:YES];


    UIColor *color = [UIColor whiteColor];
    _txt_title.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add title of Chatroom" attributes:@{NSForegroundColorAttributeName: color}];
    _txt_tag.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add Tags seperaed by (,)" attributes:@{NSForegroundColorAttributeName: color}];
    
    imagesArrayForGallery = [[NSMutableArray alloc] init];
    
    
    _txt_title.delegate = self;
    _txt_tag.delegate = self;
    
    //Keyboard Height
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_inviteAction:(id)sender {
    
//    if (_txt_title.text.length && _txt_tag.text.length) {
//
//        SelectFriendViewController *selectFriendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFriendViewController"];
//        selectFriendVC.delegate_newChatroom = self;
//        [self.navigationController pushViewController:selectFriendVC animated:NO];
//    }
    
    if(!_txt_title.text.length && !_txt_tag.text.length){
        
        [appDell alertViewToastMessage:@"Enter All the fields"];
    }
    else if (!videoDataForService.length){
        
        [appDell alertViewToastMessage:@"Please Select Video First"];
    }
    else{
        
        SelectFriendViewController *selectFriendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFriendViewController"];
                selectFriendVC.delegate_newChatroom = self;
                [self.navigationController pushViewController:selectFriendVC animated:NO];
    }
  
}


- (IBAction)btn_addVideoAction:(id)sender {
    
    [self showVideoSelectionVw];
}

// view For new chatroom Video Selection

-(void)showVideoSelectionVw{
    
    ViewForNewChatroom *vwVideo = [[ViewForNewChatroom alloc] init];
    vwVideo.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    vwVideo.delegate_videoSelectionForChatroom = self;
    [vwVideo setUpUi];
    [self.view addSubview:vwVideo];
}

-(void)videoGalleryAction{
    
   // [self launchController];
    
    isvideoGallery = YES;
    // Present videos from which to choose
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self; // ensure you set the delegate so when a video is chosen the right method can be called
    
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    // This code ensures only videos are shown to the end user
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //  videoPicker.videoMaximumDuration = 7;
    
    [self presentViewController:videoPicker animated:YES completion:nil];
    
    
}
-(void)videoCameraAction{
    
    isvideoGallery = NO;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    picker.videoMaximumDuration = 7;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    if (isvideoGallery)
        
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"VideoURL = %@", videoURL);
        strVideo = [NSString stringWithFormat:@"%@",videoURL];
        [picker dismissViewControllerAnimated:YES completion:^(){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            VideoEditingViewController *videoEditVC = (VideoEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoEditingViewController"];
            videoEditVC.videoFilePathStr = strVideo;
            videoEditVC.delegate_trimVideo = self;
            [self presentViewController:videoEditVC animated:NO completion:nil];
        }];
    }
    else{
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"VideoURL = %@", videoURL);
        strVideo = [NSString stringWithFormat:@"%@",videoURL];
        
        [picker dismissViewControllerAnimated:YES completion:^(){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            VideoEditingViewController *videoEditVC = (VideoEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoEditingViewController"];
            videoEditVC.videoFilePathStr = strVideo;
            videoEditVC.delegate_trimVideo = self;
            [self presentViewController:videoEditVC animated:NO completion:nil];
        }];
        
        
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//
//        VideoEditingViewController *videoEditVC = (VideoEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"VideoEditingViewController"];
//        videoEditVC.videoFilePathStr = strVideo;
//        videoEditVC.delegate_trimVideo = self;
//
//        [self presentViewController:videoEditVC animated:NO completion:nil];

        
  //  [picker dismissViewControllerAnimated:YES completion:nil];
    
   }

}

// new Chatroom Delegate methods

-(void)createNewChatRoomSuccess:(NSMutableArray *)arr_id{
    
    NSLog(@"arr_id>>>>%@",arr_id);
    NSString *friendList;

    friendList = @"";
    
    for (int i = 0; i< arr_id.count; i++) {
        
        friendList = [friendList stringByAppendingString:[NSString stringWithFormat:@"%@,",[arr_id objectAtIndex:i]] ];
        
    }
    
    if (friendList.length) {
        
        str_friendList = [friendList substringWithRange:NSMakeRange(0,[friendList length] - 1)];
    }
    
    NSLog(@"str_friendList>>>>%@",str_friendList);
    
   
    [self createNewChatroomServiceCall:str_friendList];

}


-(void)createNewChatroomServiceCall:(NSString *) friendList{
    
    NSDictionary * dictForChatroom = @{@"user_id":str_userId,
                                       @"token":@"adsahtoikng",
                                       @"title" : _txt_title.text,
                                       @"tags" : _txt_tag.text,
                                       @"content": @"",
                                       @"msg_type":@"4",
                                       @"invited_users":friendList,
                                       @"content_media" :@""
                                       };
    
    NSLog(@"dictForChatroom>>>>%@",dictForChatroom);//Addchatroom_URL
    
    
    [appDell showCustomLoader:self.view text:@"Loading...."];
    
   // NSURL *videoURL = [NSURL fileURLWithPath:videoPath];

 //   NSData* videoData = [NSData dataWithContentsOfFile:videoPath];
    
    NSData *imageData = UIImageJPEGRepresentation (_img_btn.image,0.5);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@",Addchatroom_URL] parameters:dictForChatroom constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"snap_image" fileName:@"user_image_file.jpeg"  mimeType:@"image/json"];
        [formData appendPartWithFileData:videoDataForService name:@"video" fileName:@"video.mov"  mimeType:@"video/mov"];

    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    UIProgressView *progressView;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError *error) {
                      
                      if (error) {
                          NSLog(@"Error: %@", error);
                      }
                      else
                      {
                          NSDictionary *notificationDict =responseObject;
                          
                          if ([[notificationDict valueForKey:@"success"] intValue] == 1) {
                              [appDell removeCustomLoader];
                            
                              NSLog(@"Success");
                              
                              NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                              [currentDefaults removeObjectForKey:@"kmatchProfileResponseDetails"];
                              
                              [appDell setChatPage];
                              
                          }
                          else if ([[notificationDict valueForKey:@"success"] intValue] == 0) {
                              [appDell removeCustomLoader];
                              [appDell alertViewToastMessage:[notificationDict valueForKey:@"message"]];
                          }
                      }
                      [appDell removeCustomLoader];
                  }];
    [uploadTask resume];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
  //   [self makeViewUpper];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if (textField == _txt_title) {
//
//        [_txt_title resignFirstResponder];
//        return YES;
//    }
//    else{
//
//        [_txt_tag resignFirstResponder];
//        return YES;
//    }
//
//    return NO;
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _txt_title) {
        [_txt_tag becomeFirstResponder];
    }
    else{
        [self makeViewLower];
        
    }
    
   // [self makeViewLower];
}



-(void)makeViewUpper{
    CGRect frameView = self.btn_invite.frame;
    frameView.origin.y = [UIScreen mainScreen].bounds.size.height - keyboardHeight - _btn_invite.frame.size.height;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.btn_invite.frame = frameView;
    } completion:^(BOOL done) {
        
    }];
}

-(void)makeViewLower{
    CGRect frameView = self.btn_invite.frame;
    frameView.origin.y = [UIScreen mainScreen].bounds.size.height - _btn_invite.frame.size.height;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.btn_invite.frame = frameView;
    } completion:^(BOOL done) {
        
    }];
}
// KeyBoard height

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSLog(@"%f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    
    keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
//    [self makeViewUpper];
}


// Video trimmer Delegate

-(void)trimVideo:(NSData *) videoData Image:(UIImage *) image{
    
    NSLog(@"str_videoPath>>>>%@",videoData);
    
    videoDataForService = videoData;
    
    
    _img_btn.image = image;
    [_btn_addVideo setImage:image forState:UIControlStateNormal];

    
  //  _img_btn.center = CGPointMake(100.0, 100.0);

    //rotate rect
   // _img_btn.transform = CGAffineTransformMakeRotation(M_PI_2);
    
}

@end
