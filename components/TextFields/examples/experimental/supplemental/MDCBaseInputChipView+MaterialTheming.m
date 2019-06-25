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

#import "MDCBaseInputChipView+MaterialTheming.h"

#import <Foundation/Foundation.h>

#import "MDCContainedInputView.h"
#import "MDCContainerStylerFilled.h"
#import "MDCContainerStylerOutlined.h"

@implementation MDCBaseInputChipView (MaterialTheming)

- (void)applyThemeWithScheme:(nonnull id<MDCContainerScheming>)containerScheme {
  [self applyTypographySchemeWith:containerScheme];
  [self applyColorSchemeWith:containerScheme];
}

- (void)applyTypographySchemeWith:(id<MDCContainerScheming>)containerScheme {
  id<MDCTypographyScheming> mdcTypographyScheming = containerScheme.typographyScheme;
  if (!mdcTypographyScheming) {
    mdcTypographyScheming =
        [[MDCTypographyScheme alloc] initWithDefaults:MDCTypographySchemeDefaultsMaterial201804];
  }
  [self applyMDCTypographyScheming:mdcTypographyScheming];
}

- (void)applyColorSchemeWith:(id<MDCContainerScheming>)containerScheme {
  id<MDCColorScheming> mdcColorScheme = containerScheme.colorScheme;
  if (!mdcColorScheme) {
    mdcColorScheme =
        [[MDCSemanticColorScheme alloc] initWithDefaults:MDCColorSchemeDefaultsMaterial201804];
  }
  [self applyMDCColorScheming:mdcColorScheme];
}

- (void)applyMDCColorScheming:(id<MDCColorScheming>)mdcColorScheming {
  MDCContainedInputViewColorScheme *normalColorScheme =
      [self.containerStyler defaultColorSchemeForState:MDCContainedInputViewStateNormal];
  [self setContainedInputViewColorScheming:normalColorScheme
                                  forState:MDCContainedInputViewStateNormal];

  MDCContainedInputViewColorScheme *focusedColorScheme =
      [self.containerStyler defaultColorSchemeForState:MDCContainedInputViewStateFocused];
  [self setContainedInputViewColorScheming:focusedColorScheme
                                  forState:MDCContainedInputViewStateFocused];

  MDCContainedInputViewColorScheme *disabledColorScheme =
      [self.containerStyler defaultColorSchemeForState:MDCContainedInputViewStateDisabled];
  [self setContainedInputViewColorScheming:disabledColorScheme
                                  forState:MDCContainedInputViewStateDisabled];

  self.tintColor = mdcColorScheming.primaryColor;
}

- (void)applyMDCTypographyScheming:(id<MDCTypographyScheming>)mdcTypographyScheming {
  self.textField.font = mdcTypographyScheming.subtitle1;
  self.leadingAssistiveLabel.font = mdcTypographyScheming.caption;
  self.trailingAssistiveLabel.font = mdcTypographyScheming.caption;
}

- (void)applyOutlinedThemeWithScheme:(nonnull id<MDCContainerScheming>)containerScheme {
  InputChipViewOutlinedPositioningDelegate *positioningDelegate =
      [[InputChipViewOutlinedPositioningDelegate alloc] init];
  MDCContainerStylerOutlined *outlinedStyle =
      [[MDCContainerStylerOutlined alloc] initWithPositioningDelegate:positioningDelegate];
  self.containerStyler = outlinedStyle;

  [self applyTypographySchemeWith:containerScheme];

  id<MDCColorScheming> mdcColorScheming =
      containerScheme.colorScheme ?: [[MDCSemanticColorScheme alloc] init];

  MDCContainedInputViewColorSchemeOutlined *normalColorScheme =
      [self outlinedColorSchemeWithMDCColorScheming:mdcColorScheming
                            containedInputViewState:MDCContainedInputViewStateNormal];
  [self setContainedInputViewColorScheming:normalColorScheme
                                  forState:MDCContainedInputViewStateNormal];

  MDCContainedInputViewColorSchemeOutlined *focusedColorScheme =
      [self outlinedColorSchemeWithMDCColorScheming:mdcColorScheming
                            containedInputViewState:MDCContainedInputViewStateFocused];
  [self setContainedInputViewColorScheming:focusedColorScheme
                                  forState:MDCContainedInputViewStateFocused];

  MDCContainedInputViewColorSchemeOutlined *disabledColorScheme =
      [self outlinedColorSchemeWithMDCColorScheming:mdcColorScheming
                            containedInputViewState:MDCContainedInputViewStateDisabled];
  [self setContainedInputViewColorScheming:disabledColorScheme
                                  forState:MDCContainedInputViewStateDisabled];

  self.tintColor = mdcColorScheming.primaryColor;
}

- (void)applyFilledThemeWithScheme:(nonnull id<MDCContainerScheming>)containerScheme {
  InputChipViewFilledPositioningDelegate *positioningDelegate =
      [[InputChipViewFilledPositioningDelegate alloc] init];
  MDCContainerStylerFilled *filledStyle =
      [[MDCContainerStylerFilled alloc] initWithPositioningDelegate:positioningDelegate];
  self.containerStyler = filledStyle;

  [self applyTypographySchemeWith:containerScheme];

  id<MDCColorScheming> mdcColorScheming =
      containerScheme.colorScheme ?: [[MDCSemanticColorScheme alloc] init];

  MDCContainedInputViewColorSchemeFilled *normalColorScheme =
      [self filledColorSchemeWithMDCColorScheming:mdcColorScheming
                          containedInputViewState:MDCContainedInputViewStateNormal];
  [self setContainedInputViewColorScheming:normalColorScheme
                                  forState:MDCContainedInputViewStateNormal];

  MDCContainedInputViewColorSchemeFilled *focusedColorScheme =
      [self filledColorSchemeWithMDCColorScheming:mdcColorScheming
                          containedInputViewState:MDCContainedInputViewStateFocused];
  [self setContainedInputViewColorScheming:focusedColorScheme
                                  forState:MDCContainedInputViewStateFocused];

  MDCContainedInputViewColorSchemeFilled *disabledColorScheme =
      [self filledColorSchemeWithMDCColorScheming:mdcColorScheming
                          containedInputViewState:MDCContainedInputViewStateDisabled];
  [self setContainedInputViewColorScheming:disabledColorScheme
                                  forState:MDCContainedInputViewStateDisabled];

  self.tintColor = mdcColorScheming.primaryColor;
}

- (MDCContainedInputViewColorSchemeOutlined *)
    outlinedColorSchemeWithMDCColorScheming:(id<MDCColorScheming>)colorScheming
                    containedInputViewState:(MDCContainedInputViewState)containedInputViewState {
  UIColor *textColor = colorScheming.onSurfaceColor;
  UIColor *underlineLabelColor =
      [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.60];
  UIColor *floatingLabelColor =
      [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.60];
  UIColor *placeholderColor = floatingLabelColor;
  UIColor *outlineColor = colorScheming.onSurfaceColor;
  UIColor *clearButtonTintColor =
      [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.20];

  switch (containedInputViewState) {
    case MDCContainedInputViewStateNormal:
      break;
    case MDCContainedInputViewStateDisabled:
      floatingLabelColor = [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.10];
      break;
      //    case MDCContainedInputViewStateErrored:
      //      floatingLabelColor = colorScheming.errorColor;
      //      underlineLabelColor = colorScheming.errorColor;
      //      outlineColor = colorScheming.errorColor;
      //      break;
    case MDCContainedInputViewStateFocused:
      outlineColor = colorScheming.primaryColor;
      floatingLabelColor = colorScheming.primaryColor;
      break;
    default:
      break;
  }

  MDCContainedInputViewColorSchemeOutlined *colorScheme =
      [[MDCContainedInputViewColorSchemeOutlined alloc] init];
  colorScheme.textColor = textColor;
  colorScheme.underlineLabelColor = underlineLabelColor;
  colorScheme.outlineColor = outlineColor;
  colorScheme.floatingLabelColor = floatingLabelColor;
  colorScheme.clearButtonTintColor = clearButtonTintColor;
  colorScheme.placeholderColor = placeholderColor;
  return colorScheme;
}

- (MDCContainedInputViewColorSchemeFilled *)
    filledColorSchemeWithMDCColorScheming:(id<MDCColorScheming>)colorScheming
                  containedInputViewState:(MDCContainedInputViewState)containedInputViewState {
  UIColor *textColor = colorScheming.onSurfaceColor;
  UIColor *underlineLabelColor =
      [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.60];
  UIColor *floatingLabelColor =
      [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.60];
  UIColor *thinUnderlineFillColor = colorScheming.onBackgroundColor;
  UIColor *thickUnderlineFillColor = colorScheming.primaryColor;
  UIColor *filledSublayerFillColor =
      [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.15];
  UIColor *clearButtonTintColor =
      [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.20];

  switch (containedInputViewState) {
    case MDCContainedInputViewStateNormal:
      break;
    case MDCContainedInputViewStateDisabled:
      floatingLabelColor = [colorScheming.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.10];
      break;
      //    case MDCContainedInputViewStateErrored:
      //      floatingLabelColor = colorScheming.errorColor;
      //      underlineLabelColor = colorScheming.errorColor;
      //      thinUnderlineFillColor = colorScheming.errorColor;
      //      thickUnderlineFillColor = colorScheming.errorColor;
      //      break;
    case MDCContainedInputViewStateFocused:
      floatingLabelColor = colorScheming.primaryColor;
      break;
    default:
      break;
  }

  MDCContainedInputViewColorSchemeFilled *colorScheme =
      [[MDCContainedInputViewColorSchemeFilled alloc] init];
  colorScheme.textColor = textColor;
  colorScheme.filledSublayerFillColor = filledSublayerFillColor;
  colorScheme.thickUnderlineFillColor = thickUnderlineFillColor;
  colorScheme.thinUnderlineFillColor = thinUnderlineFillColor;
  colorScheme.underlineLabelColor = underlineLabelColor;
  colorScheme.floatingLabelColor = floatingLabelColor;
  colorScheme.clearButtonTintColor = clearButtonTintColor;
  return colorScheme;
}

@end

@implementation InputChipViewFilledPositioningDelegate

- (CGFloat)assistiveLabelPaddingWithContainerHeight:(CGFloat)containerHeight {
  return (CGFloat)0.13 * containerHeight;
}

- (CGFloat)defaultContainerHeightWithTextHeight:(CGFloat)textHeight {
  return 2 * textHeight;
}

- (CGFloat)containerHeightWithTextHeight:(CGFloat)textHeight
                preferredContainerHeight:(CGFloat)preferredContainerHeight {
  if (preferredContainerHeight > 0) {
    return preferredContainerHeight;
  }
  return [self defaultContainerHeightWithTextHeight:textHeight];
}

- (CGFloat)floatingLabelMinYWithTextHeight:(CGFloat)textHeight
                       floatingLabelHeight:(CGFloat)floatingLabelHeight
                  preferredContainerHeight:(CGFloat)preferredContainerHeight {
  CGFloat containerHeight = [self containerHeightWithTextHeight:textHeight
                                       preferredContainerHeight:preferredContainerHeight];
  CGFloat offset = containerHeight * (CGFloat)0.20;
  return offset - ((CGFloat)0.5 * floatingLabelHeight);
}

- (CGFloat)textMinYWithFloatingLabelWithTextHeight:(CGFloat)textHeight
                               floatingLabelHeight:(CGFloat)floatingLabelHeight
                          preferredContainerHeight:(CGFloat)preferredContainerHeight {
  CGFloat containerHeight = [self containerHeightWithTextHeight:textHeight
                                       preferredContainerHeight:preferredContainerHeight];
  CGFloat offset = containerHeight * (CGFloat)0.64;
  return offset - ((CGFloat)0.5 * textHeight);
}

- (CGFloat)textMinYWithoutFloatingLabelWithTextHeight:(CGFloat)textHeight
                                  floatingLabelHeight:(CGFloat)floatingLabelHeight
                             preferredContainerHeight:(CGFloat)preferredContainerHeight {
  CGFloat containerHeight = [self containerHeightWithTextHeight:textHeight
                                       preferredContainerHeight:preferredContainerHeight];
  CGFloat offset = containerHeight * (CGFloat)0.5;
  return offset - ((CGFloat)0.5 * textHeight);
}

@end

@implementation InputChipViewOutlinedPositioningDelegate

- (CGFloat)assistiveLabelPaddingWithContainerHeight:(CGFloat)containerHeight {
  return (CGFloat)0.13 * containerHeight;
}

- (CGFloat)defaultContainerHeightWithTextHeight:(CGFloat)textHeight {
  return 2 * textHeight;
}

- (CGFloat)containerHeightWithTextHeight:(CGFloat)textHeight
                preferredContainerHeight:(CGFloat)preferredContainerHeight {
  if (preferredContainerHeight > 0) {
    return preferredContainerHeight;
  }
  return [self defaultContainerHeightWithTextHeight:textHeight];
}

- (CGFloat)floatingLabelMinYWithTextHeight:(CGFloat)textHeight
                       floatingLabelHeight:(CGFloat)floatingLabelHeight
                  preferredContainerHeight:(CGFloat)preferredContainerHeight {
  return 0 - ((CGFloat)0.5 * floatingLabelHeight);
}

- (CGFloat)textMinYWithFloatingLabelWithTextHeight:(CGFloat)textHeight
                               floatingLabelHeight:(CGFloat)floatingLabelHeight
                          preferredContainerHeight:(CGFloat)preferredContainerHeight {
  CGFloat containerHeight = [self containerHeightWithTextHeight:textHeight
                                       preferredContainerHeight:preferredContainerHeight];
  CGFloat offset = containerHeight * (CGFloat)0.5;
  return offset - ((CGFloat)0.5 * textHeight);
}

- (CGFloat)textMinYWithoutFloatingLabelWithTextHeight:(CGFloat)textHeight
                                  floatingLabelHeight:(CGFloat)floatingLabelHeight
                             preferredContainerHeight:(CGFloat)preferredContainerHeight {
  CGFloat containerHeight = [self containerHeightWithTextHeight:textHeight
                                       preferredContainerHeight:preferredContainerHeight];
  CGFloat offset = containerHeight * (CGFloat)0.5;
  return offset - ((CGFloat)0.5 * textHeight);
}

@end
