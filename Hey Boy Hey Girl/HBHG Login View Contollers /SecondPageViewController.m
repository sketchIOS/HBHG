//
//  SecondPageViewController.m
//  DemoContainerView
//
//  Created by Bhavin Gupta on 07/06/17.
//  Copyright © 2017 Easy Pay. All rights reserved.
//

#import "SecondPageViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <AFHTTPSessionManager.h>
#import "CommonHeaderFile.h"
#import "Login.h"
#import "Util.h"


@interface SecondPageViewController ()<FBSDKLoginButtonDelegate>
{
    NSMutableDictionary *params;
    NSString *deviceId;
    double screenHeight,screenWidth;
    
    UIWebView *loginWebView;
    NSString *typeOfAuthentication;
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *faceookButton;
@property (strong, nonatomic) IBOutlet UIButton *instagramButton;
@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;
@property (strong, nonatomic) IBOutlet UILabel *instragramLabel;
@property (strong, nonatomic) IBOutlet UIWebView *LoginWebView;

@end

@implementation SecondPageViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    screenWidth = [[UIScreen mainScreen] bounds].size.width;

    deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    self.faceookButton.layer.cornerRadius = 10;
    self.faceookButton.layer.masksToBounds = YES;
    
    self.instagramButton.layer.cornerRadius = 10;
    self.instagramButton.layer.masksToBounds = YES;
    
    // Handle clicks on the button
    [self.faceookButton addTarget:self action:@selector(faceookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.instagramButton addTarget:self action:@selector(instagramButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (screenHeight < 570)
    {
        [self.facebookLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.instragramLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.LoginWebView.hidden = YES;
}

//######################## FACEBOOK INTREGRATION ########################


-(void)faceookButtonClicked
{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"email",@"public_profile",@"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error)
         {
             NSLog(@"Process error");
         }
         else if (result.isCancelled)
         {
             NSLog(@"Cancelled");
         }
         else
         {
             NSLog(@"Logged in");
             NSLog(@"Result - %@",result);
             NSLog(@"Token ID Result - %@",result.token.userID);
            
             [[NSUserDefaults standardUserDefaults] setObject:result.token.userID forKey:@"NS_tokenId"];
             [[NSUserDefaults standardUserDefaults] synchronize];

             Login *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
             [self.navigationController pushViewController:loginVC animated:NO];

         }
     }];

}






//######################## INSTAGRAM INTREGRATION ########################


-(void)instagramButtonClicked
{
    loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.LoginWebView.hidden = NO;
    
    NSString* authURL = nil;
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
        
    }
    else
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
    }
    
    [self.view addSubview:loginWebView];
    [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [loginWebView setDelegate:(id)self];
    

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        //  loginWebView.alpha = 0.2;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark -
#pragma mark auth logic


- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"#access_token="];
            [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
}

-(void)makePostRequest:(NSString *)code
{
    
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    [self handleAuth:[dict valueForKey:@"access_token"]];
    
}

- (void) handleAuth: (NSString*) authToken
{
    NSLog(@"successfully logged in with Tocken == %@",authToken);
    
}

@end
