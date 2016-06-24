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

#import <UIKit/UIKit.h>

@protocol MDCButtonBarDelegate;

/**
 This protocol defines all of the properties on UINavigationItem that can be listened to by
 MDCNavigationBar.
 */
@protocol MDCUINavigationItemObservables <NSObject>
@required

@property(nonatomic, copy, nullable) NSString *title;
@property(nonatomic, strong, nullable) UIView *titleView;
@property(nonatomic) BOOL hidesBackButton;
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *leftBarButtonItems;
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *rightBarButtonItems;
@property(nonatomic) BOOL leftItemsSupplementBackButton;
@property(nonatomic, strong, nullable) UIBarButtonItem *leftBarButtonItem;
@property(nonatomic, strong, nullable) UIBarButtonItem *rightBarButtonItem;

@end

/**
 The MDCNavigationBar class is a view consisting of a leading and trailing button bar, title label,
 and an optional title view.

 This view is not designed to have subviews added to it except via through its declared properties
 (e.g. titleView).
 */
@interface MDCNavigationBar : UIView

#pragma mark Behavior

/* Title displayed in the bar if titleView is unset. */
@property(nonatomic, copy, nullable) NSString *title;

/**
 The title view layout differs from the traditional behavior of UINavigationBar.

 Due to MDCNavigationBar being able to expand vertically, the titleView's height is updated to match
 any changes in the MDCNavigationBar's height.

 You may wish to create a container view that is able to manage subview layout if your situation
 requires it.
 */
@property(nonatomic, strong, nullable) UIView *titleView;

/** The back button to be displayed, if any. */
@property(nonatomic, strong, nullable) UIBarButtonItem *backItem;

/*  If YES, this navigation bar will hide the back button. */
@property(nonatomic) BOOL hidesBackButton;

/* Use these properties to set multiple items in a navigation bar.
 The single properties (leadingBarButtonItem and trailingBarButtonItem) refer to the first item in
 the respective array of items.

 NOTE: You'll achieve the best results if you use either the singular properties or the plural
 properties consistently and don't try to mix them.

   leadingBarButtonItems are placed in the navigation bar from the leading edge to the trailing edge
 with the first item in the list at the leading outside edge and leading aligned.
   trailingBarButtonItems are placed from the trailing edge to the leading edge with the first item
 in the list at the trailing outside edge and trailing aligned.
 */
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *leadingBarButtonItems;
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *trailingBarButtonItems;

/* By default, the leadingItemsSupplementBackButton property is NO. In this case, the back button is
 not drawn and the leading item or items replace it. If you would like the leading items to appear
 in addition to the back button (as opposed to instead of it) set leadingItemsSupplementBackButton
 to YES.
 */
@property(nonatomic) BOOL leadingItemsSupplementBackButton;

/*
 Use these when you want to display a custom leading or trailing item in this navigation bar.
 A custom leading item replaces the regular back button unless you set
 leadingItemsSupplementBackButton to YES.
 */
@property(nonatomic, strong, nullable) UIBarButtonItem *leadingBarButtonItem;
@property(nonatomic, strong, nullable) UIBarButtonItem *trailingBarButtonItem;

#pragma mark Configuring Layout

/**
 The direction in which the navigation bar items should be laid out.

 Default:
 - Prior to iOS 9: UIUserInterfaceLayoutDirectionLeftToRight
 - iOS 9 and above: same as +[UIView userInterfaceLayoutDirectionForSemanticContentAttribute:]
 */
@property(nonatomic) UIUserInterfaceLayoutDirection layoutDirection;

#pragma mark Observing UINavigationItem instances

/**
 Begin observing changes to the provided navigation item.

 Only one navigation item instance can be observed at a time. Observing a second navigation item
 will stop observation of the first navigation item.

 Once execution returns from this method the receiver's state will match that of the newly-observed
 navigation item.

 The observed navigation item is strongly held.
 */
- (void)observeNavigationItem:(nonnull UINavigationItem *)navigationItem;

/**
 Stop observing changes to the previously-observed navigation item.

 Does nothing if no navigation item is being observed.
 */
- (void)unobserveNavigationItem;

#pragma mark UINavigationItem interface matching

/* Equivalent to leadingBarButtonItems. */
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *leftBarButtonItems;

/* Equivalent to trailingBarButtonItems. */
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *rightBarButtonItems;

/* Equivalent to leadingBarButtonItem. */
@property(nonatomic, strong, nullable) UIBarButtonItem *leftBarButtonItem;

/* Equivalent to trailingBarButtonItem. */
@property(nonatomic, strong, nullable) UIBarButtonItem *rightBarButtonItem;

/* Equivalent to leadingItemsSupplementBackButton. */
@property(nonatomic) BOOL leftItemsSupplementBackButton;

@end
