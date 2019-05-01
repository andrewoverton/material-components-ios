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

#import <UIKit/UIKit.h>

/** This type is used to configure the behavior of an MDCInputTextField's label. */
typedef NS_ENUM(NSInteger, MDCInputTextFieldLabelBehavior) {
  /** Indicates that the text field label animates to a position above the text when editing begins. */
  MDCInputTextFieldLabelBehaviorFloats,
  /** Indicates that the text field label disappears when editing begins. */
  MDCInputTextFieldLabelBehaviorDisappears,
};

/**
 A UITextField subclass that attempts to do the following:

 - Earnestly interpret and actualize the Material guidelines for text fields, which can be found
 here: https://material.io/design/components/text-fields.html#outlined-text-field

 - Feel intuitive for someone used to the conventions of iOS development and UIKit controls.

 - Enable easy set up and reliable and predictable behavior.

 Caution: While not explicitly forbidden by the compiler, subclassing this class is highly discouraged and not supported. Please consider alternatives.
 */
@interface MDCInputTextField : UITextField

/**
 The @c label is a label that occupies the area the text usually occupies when there is no
 text. It is distinct from the placeholder in that it can move above the text area or disappear to reveal the placeholder when editing begins.
 */
@property(strong, nonatomic, readonly, nonnull) UILabel *label;

/**
 This property determines the behavior of the textfield's label during editing.

 @note The default is MDCInputTextFieldLabelBehaviorFloats.
 */
@property(nonatomic, assign) MDCInputTextFieldLabelBehavior labelBehavior;

/**
 The @c leadingAssistiveLabel is a label below the text on the leading edge of the view. It can be
 used to display helper or error text.
 */
@property(strong, nonatomic, readonly, nonnull) UILabel *leadingAssistiveLabel;

/**
 The @c trailingAssistiveLabel is a label below the text on the trailing edge of the view. It can be
 used to display helper or error text.
 */
@property(strong, nonatomic, readonly, nonnull) UILabel *trailingAssistiveLabel;

/**
 This is essentially an RTL-aware wrapper around UITextField's leftView/rightView property.
 */
@property(strong, nonatomic, nullable) UIView *leadingView;

/**
 This is essentially an RTL-aware wrapper around UITextField's leftView/rightView property.
 */
@property(strong, nonatomic, nullable) UIView *trailingView;

/**
 This is essentially an RTL-aware wrapper around UITextField's leftViewMode/rightViewMode property.
 */
@property(nonatomic, assign) UITextFieldViewMode leadingViewMode;

/**
 This is essentially an RTL-aware wrapper around UITextField's leftViewMode/rightViewMode property.
 */
@property(nonatomic, assign) UITextFieldViewMode trailingViewMode;

/**
 Indicates whether the text field should automatically update its font when the device’s
 UIContentSizeCategory is changed.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 Defaults value is NO.
 */
@property(nonatomic, setter=mdc_setAdjustsFontForContentSizeCategory:)
    BOOL mdc_adjustsFontForContentSizeCategory;

/**
 Sets the label color for a given state.

 @param labelColor The UIColor for the given state.
 @param state The UIControlState. The accepted values are UIControlStateNormal,
 UIControlStateDisabled, and UIControlStateEditing, which is a custom MDC
 UIControlState value.
 */
- (void)setLabelColor:(nonnull UIColor *)labelColor forState:(UIControlState)state;
/**
 Returns the label color for a given state.

 @param state The UIControlState.
 */
- (nonnull UIColor *)labelColorForState:(UIControlState)state;

/**
 Sets the text color for a given state.

 @param textColor The UIColor for the given state.
 @param state The UIControlState. The accepted values are UIControlStateNormal,
 UIControlStateDisabled, and UIControlStateEditing, which is a custom MDC
 UIControlState value.
 */
- (void)setTextColor:(nonnull UIColor *)textColor forState:(UIControlState)state;
/**
 Returns the text color for a given state.

 @param state The UIControlState.
 */
- (nonnull UIColor *)textColorForState:(UIControlState)state;

@end
