//
//  PageViewController.m
//  DemoContainerView
//
//  Created by Bhavin Gupta on 29/05/17.
//  Copyright © 2017 Easy Pay. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()
{
    NSInteger index;
    NSInteger current;
    NSTimer *timer;
    
}
@end

@implementation PageViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    FirstPageViewController *firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstPageViewController"];
    SecondPageViewController *secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondPageViewController"];
    
    self.aryPages = [NSMutableArray new];
    [self.aryPages addObjectsFromArray:@[firstVC,secondVC]];
    
    [self setViewControllers:@[self.aryPages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    UIPageControl *pageControl = [UIPageControl appearanceWhenContainedIn:self.class, nil];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:400 green:200 blue:0 alpha:1.0];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    /*! setup an interval */
    
    if (current == 0)
    {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(loadNextController)
                                       userInfo:nil
                                        repeats:YES];

    
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPageViewController Delegate and Data Source Method
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return self.aryPages.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger current = [self.aryPages indexOfObject:viewController];
    NSInteger previous = labs(current-1) % self.aryPages.count;
    if(current == 0)
        return nil;
    else
        return self.aryPages[previous];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    current = [self.aryPages indexOfObject:viewController];
    NSInteger next = labs(current+1) % self.aryPages.count;
    
    NSLog(@"Index No-%li",(long)current);
    
    if(current == (self.aryPages.count-1))
    {
        return nil;
    }
    else
        return self.aryPages[next];
}

-(void)loadNextController
{
    NSLog(@"loadNextController");
     
     [timer invalidate];
     
    [self setViewControllers:@[self.aryPages[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

@end
