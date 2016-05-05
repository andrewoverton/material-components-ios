/*
 Copyright 2016-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "PestoFlexibleHeaderContainerViewController.h"
#import "PestoCollectionViewController.h"
#import "PestoDetailViewController.h"
#import "PestoSettingsViewController.h"
#import "PestoSideView.h"

#import "MaterialAppBar.h"

static CGFloat kPestoAnimationDuration = 0.33f;
static CGFloat kPestoInset = 5.f;

@interface PestoFlexibleHeaderContainerViewController () <PestoCollectionViewControllerDelegate,
                                                          PestoSideViewDelegate,
                                                          UIViewControllerAnimatedTransitioning,
                                                          UIViewControllerTransitioningDelegate>

@property(nonatomic, strong) MDCAppBar *appBar;
@property(nonatomic, strong) PestoCollectionViewController *collectionViewController;
@property(nonatomic, strong) PestoSideView *sideView;
@property(nonatomic, strong) UIImageView *zoomableView;
@property(nonatomic, strong) UIView *zoomableCardView;

@end

@implementation PestoFlexibleHeaderContainerViewController

- (instancetype)init {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumInteritemSpacing = 0;
  CGFloat sectionInset = kPestoInset * 2.f;
  [layout setSectionInset:UIEdgeInsetsMake(sectionInset,
                                           sectionInset,
                                           sectionInset,
                                           sectionInset)];
  PestoCollectionViewController *collectionVC =
      [[PestoCollectionViewController alloc] initWithCollectionViewLayout:layout];
  self = [super initWithContentViewController:collectionVC];
  if (self) {
    _collectionViewController = collectionVC;
    _collectionViewController.flexHeaderContainerVC = self;
    _collectionViewController.delegate = self;

    _appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];

    _appBar.headerViewController.headerView.backgroundColor = [UIColor clearColor];
    _appBar.navigationBar.tintColor = [UIColor whiteColor];

    UIBarButtonItem *menuButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menuButton;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.appBar addSubviewsToParent];

  self.sideView = [[PestoSideView alloc] initWithFrame:self.view.bounds];
  self.sideView.hidden = YES;
  self.sideView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.sideView.delegate = self;
  [self.view addSubview:self.sideView];

  self.zoomableCardView = [[UIView alloc] initWithFrame:CGRectZero];
  self.zoomableCardView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.zoomableCardView];

  self.zoomableView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.zoomableView.backgroundColor = [UIColor lightGrayColor];
  self.zoomableView.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:self.zoomableView];
}

- (void)showMenu {
  self.sideView.hidden = NO;
  [self.sideView showSideView];
}

/** Use MDCAnimationCurve once available. */
- (CAMediaTimingFunction *)quantumEaseInOut {
  // This curve is slow both at the beginning and end.
  // Visualization of curve  http://cubic-bezier.com/#.4,0,.2,1
  return [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0.0f:0.2f:1.0f];
}

#pragma mark - PestoCollectionViewControllerDelegate

- (void)didSelectCell:(PestoCardCollectionViewCell *)cell completion:(void (^)())completionBlock {
  self.zoomableView.frame =
      CGRectMake(cell.frame.origin.x,
                 cell.frame.origin.y - self.collectionViewController.scrollOffsetY,
                 cell.frame.size.width,
                 cell.frame.size.height - 50.f);
  self.zoomableCardView.frame =
      CGRectMake(cell.frame.origin.x,
                 cell.frame.origin.y - self.collectionViewController.scrollOffsetY,
                 cell.frame.size.width,
                 cell.frame.size.height);
  dispatch_async(dispatch_get_main_queue(), ^{
    self.zoomableView.image = cell.image;

    [UIView animateWithDuration:kPestoAnimationDuration
        delay:0.0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
          CAMediaTimingFunction *quantumEaseInOut = [self quantumEaseInOut];
          [CATransaction setAnimationTimingFunction:quantumEaseInOut];
          CGRect zoomFrame = CGRectMake(0, 0, self.view.bounds.size.width, 320.f);
          self.zoomableView.frame = zoomFrame;
          self.zoomableCardView.frame = self.view.bounds;
        }
        completion:^(BOOL finished) {
          PestoDetailViewController *detailVC =
              [[PestoDetailViewController alloc] init];
          detailVC.image = cell.image;
          detailVC.title = cell.title;
          detailVC.iconImageName = cell.iconImageName;
          detailVC.descText = cell.descText;

          detailVC.modalPresentationStyle = UIModalPresentationCustom;
          detailVC.transitioningDelegate = self;

          [self presentViewController:detailVC
                             animated:NO
                           completion:^() {
                             self.zoomableView.frame = CGRectZero;
                             self.zoomableCardView.frame = CGRectZero;
                             completionBlock();
                           }];
        }];
  });
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:
                                                          (UIViewController *)presented
                                                                           presentingController:(UIViewController *)presenting
                                                                               sourceController:(UIViewController *)source {
  return nil;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:
        (UIViewController *)dismissed {
  return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *const fromController = [transitionContext
      viewControllerForKey:UITransitionContextFromViewControllerKey];

  UIViewController *const toController = [transitionContext
      viewControllerForKey:UITransitionContextToViewControllerKey];

  if ([fromController isKindOfClass:[PestoDetailViewController class]] &&
      [toController isKindOfClass:self.class]) {
    CGRect detailFrame = fromController.view.frame;
    detailFrame.origin.y = self.view.frame.size.height;

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
        delay:0.f
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
          fromController.view.frame = detailFrame;
        }
        completion:^(BOOL finished) {
          [fromController.view removeFromSuperview];
          [transitionContext completeTransition:YES];
        }];
  }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.2;
}

#pragma mark - PestoSideViewDelegate

- (void)sideViewDidSelectSettings:(PestoSideView *)sideView {
  PestoSettingsViewController *settingsVC = [PestoSettingsViewController new];
  settingsVC.title = @"Settings";

  UIColor *white = [UIColor whiteColor];
  UIColor *teal = [UIColor colorWithRed:0 green:0.67f blue:0.55f alpha:1.f];
  UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
      initWithTitle:@"Done"
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(closeViewController)];
  rightBarButton.tintColor = white;
  settingsVC.navigationItem.rightBarButtonItem = rightBarButton;

  UINavigationController *navVC = [[UINavigationController alloc]
      initWithRootViewController:settingsVC];
  navVC.navigationBar.barTintColor = teal;
  navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : white};
  navVC.navigationBar.translucent = NO;
  navVC.navigationBarHidden = YES;

  [sideView hideSideView];
  [self presentViewController:navVC animated:YES completion:nil];
}

- (void)closeViewController {
  [self dismissViewControllerAnimated:true completion:nil];
}

@end
