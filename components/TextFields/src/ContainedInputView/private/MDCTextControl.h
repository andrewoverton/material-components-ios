// Copyright 2019-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MDCTextControlAssistiveLabelDrawPriority.h"
#import "MDCTextControlColorViewModel.h"
#import "MDCTextControlLabelAnimation.h"
#import "MDCTextControlLabelBehavior.h"
#import "MDCTextControlLabelState.h"
#import "MDCTextControlState.h"
#import "MDCTextControlVerticalPositioningReference.h"

static const CGFloat kMDCTextControlDefaultAnimationDuration = (CGFloat)0.15;

@protocol MDCTextControlStyle;

@protocol MDCTextControl <NSObject>

/**
 Dictates the @c MDCTextControlStyle of the text field. Defaults to an instance of
 MDCTextControlStyleBase.
 */
@property(nonatomic, strong, nonnull) id<MDCTextControlStyle> containerStyle;

/**
 Describes the current @c MDCtextControlState of the view.
 */
@property(nonatomic, assign, readonly) MDCTextControlState textControlState;

/**
 Describes the current @c MDCTextControlLabelState of the view. This
 value is affected by things like the view's state, the value for @c canFloatingLabelFloat, and the
 text of the floating label.
 */
@property(nonatomic, assign, readonly) MDCTextControlLabelState labelState;

/**
 Describes the behavior of the label when the control begis editing.
 */
@property(nonatomic, assign, readonly) MDCTextControlLabelBehavior labelBehavior;

/**
 The @c label is a label that occupies the text area in a resting state with no text and that either
 floats above the text or disappears in an editing state. It is distinct from a placeholder.
 */
@property(strong, nonatomic, readonly, nonnull) UILabel *label;

/**
 The @c normalFont is the view's primary font. The text has this font. The label
 also has this font when it isn't floating.
 */
@property(strong, nonatomic, readonly, nonnull) UIFont *normalFont;

/**
 The @c floatingFont is the font of the label when it's floating.
 */
@property(strong, nonatomic, readonly, nonnull) UIFont *floatingFont;

/**
 The @c leadingAssistiveLabel can be used to display helper or error text.
 */
@property(strong, nonatomic, readonly, nonnull) UILabel *leadingAssistiveLabel;

/**
 The @c trailingAssistiveLabel can be used to display helper or error text.
 */
@property(strong, nonatomic, readonly, nonnull) UILabel *trailingAssistiveLabel;

/**
 This property is used to determine how much horizontal space to allot for each of the two assistive
 labels.

 @note The default value is MDCTextControlAssistiveLabelDrawPriorityTrailing. The rationale
 behind this is it is less likely to have long explanatory error text and more likely to have short
 text, like a character counter. It is better to draw the short text first and use whatever space is
 leftover for the longer text, which may wrap to new lines.
 */
@property(nonatomic, assign) MDCTextControlAssistiveLabelDrawPriority assistiveLabelDrawPriority;

/**
 When @c assistiveLabelDrawPriority is set to @c .custom the value of this property helps determine
 what percentage of the available width each assistive label gets. It can be thought of as a
 divider. A value of @c 0 would result in the trailing assistive label getting all the available
 width. A value of @c 1 would result in the leading assistive label getting all the available width.
 A value of @c .5 would result in each assistive label getting 50% of the available width.
 */
@property(nonatomic, assign) CGFloat customAssistiveLabelDrawPriority;

/**
 This method returns a color view model for a given MDCTextControlState.
 */
- (nonnull MDCTextControlColorViewModel *)textControlColorViewModelForState:
    (MDCTextControlState)textControlState;

/**
 This method sets a color view model for a given MDCTextControlState.
 */
- (void)setTextControlColorViewModel:
            (nonnull MDCTextControlColorViewModel *)textControlColorViewModel
                            forState:(MDCTextControlState)textFieldState;

/**
 Returns the rect surrounding the main content, i.e. the area that the container should be drawn
 around.
 */
@property(nonatomic, assign, readonly) CGRect containerFrame;

/**
 This API allows the user to override the default main content area height. The main content area is
 the part of the view where the where the data input happens. It is located above the assistive
 label area. If this property is set to a value that's lower than the default main content area
 height the value will be ignored in the calculation of the view's @c intrinsicContentSize.
 */
@property(nonatomic, assign) CGFloat preferredContainerHeight;

@property(nonatomic, assign, readonly) CGFloat numberOfTextRows;

@end

@protocol MDCTextControlStyle <NSObject>

/**
 This method allows objects conforming to MDCTextControlStyle to apply themselves to objects
 conforming to MDCTextControl with a set of colors represented by an object conforming to
 MDCTextControlColorViewModel.
 */
- (void)applyStyleToTextControl:(nonnull id<MDCTextControl>)textControl;
/**
 This method allows objects conforming to MDCTextControlStyle to remove the styling
 previously applied to objects conforming to MDCTextControl.
 */
- (void)removeStyleFrom:(nonnull id<MDCTextControl>)textControl;

/**
 The method returns a UIFont for the floating label based on the @c normalFont of the
 view.
 */
- (UIFont *_Nonnull)floatingFontWithNormalFont:(nonnull UIFont *)font;

/**
 This method returns an object that tells the view where to position it's views
 vertically.
 */
- (nonnull id<MDCTextControlVerticalPositioningReference>)
    positioningReferenceWithFloatingFontLineHeight:(CGFloat)floatingLabelHeight
                              normalFontLineHeight:(CGFloat)normalFontLineHeight
                                     textRowHeight:(CGFloat)textRowHeight
                                  numberOfTextRows:(CGFloat)numberOfTextRows
                                           density:(CGFloat)density
                          preferredContainerHeight:(CGFloat)preferredContainerHeight;

@end
