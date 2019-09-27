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

#import "MDCBaseTextField.h"

#import <Foundation/Foundation.h>

#import <MDFInternationalization/MDFInternationalization.h>

#import "MaterialMath.h"
#import "MaterialTypography.h"
#import "private/MDCBaseTextFieldLayout.h"
#import "private/MDCTextControlAssistiveLabelView.h"
#import "private/MDCTextControlStylePathDrawingUtils.h"
#import "private/MDCTextControlColorViewModel.h"
#import "private/MDCTextControlLabelAnimation.h"
#import "private/MDCTextControlStyleBase.h"
#import "private/MDCTextControlTextFieldPrototypes.h"

@interface MDCBaseTextField () <MDCTextControl>

@property(strong, nonatomic) UILabel *label;
@property(nonatomic, strong) MDCTextControlAssistiveLabelView *assistiveLabelView;
@property(strong, nonatomic) MDCBaseTextFieldLayout *layout;
@property(nonatomic, assign) UIUserInterfaceLayoutDirection layoutDirection;
@property(nonatomic, assign) MDCTextControlState textControlState;
@property(nonatomic, assign) MDCTextControlLabelState labelState;

@property(nonatomic, strong)
    NSMutableDictionary<NSNumber *, MDCTextControlColorViewModel *> *colorViewModels;

@end

@implementation MDCBaseTextField
@synthesize preferredContainerHeight = _preferredContainerHeight;
@synthesize assistiveLabelDrawPriority = _assistiveLabelDrawPriority;
@synthesize customAssistiveLabelDrawPriority = _customAssistiveLabelDrawPriority;
@synthesize containerStyle = _containerStyle;
@synthesize labelBehavior = _labelBehavior;
@synthesize placeholderColor = _placeholderColor;

#pragma mark Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonMDCBaseTextFieldInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonMDCBaseTextFieldInit];
  }
  return self;
}

- (void)commonMDCBaseTextFieldInit {
  [self initializeProperties];
  [self setUpColorViewModels];
  [self setUpLabel];
  [self setUpAssistiveLabels];
}

#pragma mark View Setup

- (void)initializeProperties {
  self.font = MDCTextControlDefaultFont();
  self.labelBehavior = MDCTextControlLabelBehaviorFloats;
  self.layoutDirection = self.mdf_effectiveUserInterfaceLayoutDirection;
  self.labelState = [self determineCurrentLabelState];
  self.textControlState = [self determineCurrentTextControlState];
  self.containerStyle = [[MDCTextControlStyleBase alloc] init];
  self.colorViewModels = [[NSMutableDictionary alloc] init];
}

- (void)setUpColorViewModels {
  self.colorViewModels[@(MDCTextControlStateNormal)] =
      [[MDCTextControlColorViewModel alloc] initWithState:MDCTextControlStateNormal];
  self.colorViewModels[@(MDCTextControlStateEditing)] =
      [[MDCTextControlColorViewModel alloc] initWithState:MDCTextControlStateEditing];
  self.colorViewModels[@(MDCTextControlStateDisabled)] =
      [[MDCTextControlColorViewModel alloc] initWithState:MDCTextControlStateDisabled];
}

- (void)setUpAssistiveLabels {
  self.assistiveLabelDrawPriority = MDCTextControlAssistiveLabelDrawPriorityTrailing;
  self.assistiveLabelView = [[MDCTextControlAssistiveLabelView alloc] init];
  CGFloat assistiveFontSize = MDCRound([UIFont systemFontSize] * (CGFloat)0.75);
  UIFont *assistiveFont = [UIFont systemFontOfSize:assistiveFontSize];
  self.assistiveLabelView.leftAssistiveLabel.font = assistiveFont;
  self.assistiveLabelView.rightAssistiveLabel.font = assistiveFont;
  [self addSubview:self.assistiveLabelView];
}

- (void)setUpLabel {
  self.label = [[UILabel alloc] initWithFrame:self.bounds];
  [self addSubview:self.label];
}

#pragma mark UIView Overrides

- (void)layoutSubviews {
  [self preLayoutSubviews];
  [super layoutSubviews];
  [self postLayoutSubviews];
}

// UITextField's sizeToFit calls this method and then also calls setNeedsLayout.
// When the system calls this method the size parameter is the view's current size.
- (CGSize)sizeThatFits:(CGSize)size {
  return [self preferredSizeWithWidth:size.width];
}

- (CGSize)intrinsicContentSize {
  return [self preferredSizeWithWidth:CGRectGetWidth(self.bounds)];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
  self.layoutDirection = self.mdf_effectiveUserInterfaceLayoutDirection;
}

#pragma mark Layout

- (void)preLayoutSubviews {
  self.textControlState = [self determineCurrentTextControlState];
  self.labelState = [self determineCurrentLabelState];
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:self.textControlState];
  [self applyColorViewModel:colorViewModel withLabelState:self.labelState];
  CGSize fittingSize = CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX);
  self.layout = [self calculateLayoutWithTextFieldSize:fittingSize];
}

- (void)postLayoutSubviews {
  [MDCTextControlLabelAnimation layOutLabel:self.label
                                      state:self.labelState
                           normalLabelFrame:self.layout.labelFrameNormal
                         floatingLabelFrame:self.layout.labelFrameFloating
                                 normalFont:self.normalFont
                               floatingFont:self.floatingFont];
  [self.containerStyle applyStyleToTextControl:self];
  self.assistiveLabelView.frame = self.layout.assistiveLabelViewFrame;
  self.assistiveLabelView.layout = self.layout.assistiveLabelViewLayout;
  [self.assistiveLabelView setNeedsLayout];
  self.leftView.hidden = self.layout.leftViewHidden;
  self.rightView.hidden = self.layout.rightViewHidden;
}

- (CGRect)textRectFromLayout:(MDCBaseTextFieldLayout *)layout
                  labelState:(MDCTextControlLabelState)labelState {
  CGRect textRect = layout.textRectNormal;
  if (labelState == MDCTextControlLabelStateFloating) {
    textRect = layout.textRectFloating;
  }
  return textRect;
}

- (CGRect)adjustTextAreaFrame:(CGRect)textRect
    withParentClassTextAreaFrame:(CGRect)parentClassTextAreaFrame {
  CGFloat systemDefinedHeight = CGRectGetHeight(parentClassTextAreaFrame);
  CGFloat minY = CGRectGetMidY(textRect) - (systemDefinedHeight * (CGFloat)0.5);
  return CGRectMake(CGRectGetMinX(textRect), minY, CGRectGetWidth(textRect), systemDefinedHeight);
}

- (CGFloat)clearButtonSideLength {
  static dispatch_once_t onceToken;
  static CGRect systemClearButtonRect;
  UITextField *textField = MDCTextControlUITextFieldPrototype();
  dispatch_once(&onceToken, ^{
    systemClearButtonRect = [textField clearButtonRectForBounds:textField.bounds];
  });
  CGFloat sideLength = CGRectGetHeight(systemClearButtonRect);
  return sideLength > 0 ? sideLength : 19.0;
}

- (MDCBaseTextFieldLayout *)calculateLayoutWithTextFieldSize:(CGSize)textFieldSize {
  CGFloat normalizedCustomAssistiveLabelDrawPriority =
      [self normalizedCustomAssistiveLabelDrawPriority:self.customAssistiveLabelDrawPriority];
  return [[MDCBaseTextFieldLayout alloc]
                 initWithTextFieldSize:textFieldSize
                  positioningReference:[self createPositioningReference]
                                  text:self.text
                                  font:self.normalFont
                          floatingFont:self.floatingFont
                                 label:self.label
                              leftView:self.leftView
                          leftViewMode:self.leftViewMode
                             rightView:self.rightView
                         rightViewMode:self.rightViewMode
                 clearButtonSideLength:[self clearButtonSideLength]
                       clearButtonMode:self.clearButtonMode
                    leftAssistiveLabel:self.assistiveLabelView.leftAssistiveLabel
                   rightAssistiveLabel:self.assistiveLabelView.rightAssistiveLabel
            assistiveLabelDrawPriority:self.assistiveLabelDrawPriority
      customAssistiveLabelDrawPriority:normalizedCustomAssistiveLabelDrawPriority
              preferredContainerHeight:self.preferredContainerHeight
                                 isRTL:self.isRTL
                             isEditing:self.isEditing];
}

- (id<MDCTextControlVerticalPositioningReference>)createPositioningReference {
  return [self.containerStyle
      positioningReferenceWithFloatingFontLineHeight:self.floatingFont.lineHeight
                                normalFontLineHeight:self.normalFont.lineHeight
                                       textRowHeight:self.normalFont.lineHeight
                                    numberOfTextRows:1
                                             density:0
                            preferredContainerHeight:self.preferredContainerHeight];
}

- (CGFloat)normalizedCustomAssistiveLabelDrawPriority:(CGFloat)customPriority {
  CGFloat value = customPriority;
  if (value < 0) {
    value = 0;
  } else if (value > 1) {
    value = 1;
  }
  return value;
}

- (CGSize)preferredSizeWithWidth:(CGFloat)width {
  CGSize fittingSize = CGSizeMake(width, CGFLOAT_MAX);
  MDCBaseTextFieldLayout *layout = [self calculateLayoutWithTextFieldSize:fittingSize];
  return CGSizeMake(width, layout.calculatedHeight);
}

#pragma mark UITextField Accessor Overrides

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  [self setNeedsLayout];
}

- (void)setLeftViewMode:(UITextFieldViewMode)leftViewMode {
  NSLog(@"Setting leftViewMode is not recommended. Consider setting leadingViewMode and "
        @"trailingViewMode instead.");
  [self mdc_setLeftViewMode:leftViewMode];
}

- (void)setRightViewMode:(UITextFieldViewMode)rightViewMode {
  NSLog(@"Setting rightViewMode is not recommended. Consider setting leadingViewMode and "
        @"trailingViewMode instead.");
  [self mdc_setRightViewMode:rightViewMode];
}

- (void)setLeftView:(UIView *)leftView {
  NSLog(@"Setting rightView and leftView are not recommended. Consider setting leadingView and "
        @"trailingView instead.");
  [self mdc_setLeftView:leftView];
}

- (void)setRightView:(UIView *)rightView {
  NSLog(@"Setting rightView and leftView are not recommended. Consider setting leadingView and "
        @"trailingView instead.");
  [self mdc_setRightView:rightView];
}

#pragma mark Custom Accessors

- (NSString *)labelText {
  return self.label.text;
}

- (void)setLabelText:(nullable NSString *)labelText {
  self.label.text = [labelText copy];
}

- (UILabel *)leadingAssistiveLabel {
  if ([self isRTL]) {
    return self.assistiveLabelView.rightAssistiveLabel;
  } else {
    return self.assistiveLabelView.leftAssistiveLabel;
  }
}

- (UILabel *)trailingAssistiveLabel {
  if ([self isRTL]) {
    return self.assistiveLabelView.leftAssistiveLabel;
  } else {
    return self.assistiveLabelView.rightAssistiveLabel;
  }
}

- (void)setTrailingView:(UIView *)trailingView {
  if ([self isRTL]) {
    [self mdc_setLeftView:trailingView];
  } else {
    [self mdc_setRightView:trailingView];
  }
}

- (UIView *)trailingView {
  if ([self isRTL]) {
    return self.leftView;
  } else {
    return self.rightView;
  }
}

- (void)setLeadingView:(UIView *)leadingView {
  if ([self isRTL]) {
    [self mdc_setRightView:leadingView];
  } else {
    [self mdc_setLeftView:leadingView];
  }
}

- (UIView *)leadingView {
  if ([self isRTL]) {
    return self.rightView;
  } else {
    return self.leftView;
  }
}

- (void)mdc_setLeftView:(UIView *)leftView {
  [super setLeftView:leftView];
  // TODO: Determine if a call to setNeedsLayout is necessary or if super calls it
}

- (void)mdc_setRightView:(UIView *)rightView {
  [super setRightView:rightView];
  // TODO: Determine if a call to setNeedsLayout is necessary or if super calls it
}

- (void)setTrailingViewMode:(UITextFieldViewMode)trailingViewMode {
  if ([self isRTL]) {
    [self mdc_setLeftViewMode:trailingViewMode];
  } else {
    [self mdc_setRightViewMode:trailingViewMode];
  }
}

- (UITextFieldViewMode)trailingViewMode {
  if ([self isRTL]) {
    return self.leftViewMode;
  } else {
    return self.rightViewMode;
  }
}

- (void)setLeadingViewMode:(UITextFieldViewMode)leadingViewMode {
  if ([self isRTL]) {
    [self mdc_setRightViewMode:leadingViewMode];
  } else {
    [self mdc_setLeftViewMode:leadingViewMode];
  }
}

- (UITextFieldViewMode)leadingViewMode {
  if ([self isRTL]) {
    return self.rightViewMode;
  } else {
    return self.leftViewMode;
  }
}

- (void)mdc_setLeftViewMode:(UITextFieldViewMode)leftViewMode {
  [super setLeftViewMode:leftViewMode];
}

- (void)mdc_setRightViewMode:(UITextFieldViewMode)rightViewMode {
  [super setRightViewMode:rightViewMode];
}

- (void)setLayoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection {
  if (_layoutDirection == layoutDirection) {
    return;
  }
  _layoutDirection = layoutDirection;
  [self setNeedsLayout];
}

- (UIColor *)placeholderColor {
  return _placeholderColor ?: [UIColor lightGrayColor];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
  _placeholderColor = placeholderColor;
  if (_placeholderColor) {
    [self updateAttributedPlaceholderColor];
  } else {
    [self reestablishDefaultPlaceholderAttributes];
  }
}

- (void)setPlaceholder:(NSString *)placeholder {
  [super setPlaceholder:placeholder];
  if (self.placeholderColor) {
    [self updateAttributedPlaceholderColor];
  }
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
  [super setAttributedPlaceholder:attributedPlaceholder];
  if (self.placeholderColor) {
    [self updateAttributedPlaceholderColor];
  }
}

#pragma mark MDCTextControl accessors

- (void)setLabelBehavior:(MDCTextControlLabelBehavior)labelBehavior {
  if (_labelBehavior == labelBehavior) {
    return;
  }
  _labelBehavior = labelBehavior;
  [self setNeedsLayout];
}

- (void)setContainerStyle:(id<MDCTextControlStyle>)containerStyle {
  id<MDCTextControlStyle> oldStyle = _containerStyle;
  if (oldStyle) {
    [oldStyle removeStyleFrom:self];
  }
  _containerStyle = containerStyle;
  [_containerStyle applyStyleToTextControl:self];
}

- (CGRect)containerFrame {
  return CGRectMake(0, 0, CGRectGetWidth(self.frame), self.layout.containerHeight);
}

- (CGFloat)numberOfTextRows {
  return 1;
}

#pragma mark UITextField Layout Overrides

- (CGRect)textRectForBounds:(CGRect)bounds {
  CGRect textRect = [self textRectFromLayout:self.layout labelState:self.labelState];
  return [self adjustTextAreaFrame:textRect
      withParentClassTextAreaFrame:[super textRectForBounds:bounds]];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  CGRect textRect = [self textRectFromLayout:self.layout labelState:self.labelState];
  return [self adjustTextAreaFrame:textRect
      withParentClassTextAreaFrame:[super editingRectForBounds:bounds]];
}

// The implementations for this method and the method below deserve some context! Unfortunately,
// Apple's RTL behavior with these methods is very unintuitive. Imagine you're in an RTL locale and
// you set @c leftView on a standard UITextField. Even though the property that you set is called @c
// leftView, the method @c -rightViewRectForBounds: will be called. They are treating @c leftView as
// @c rightView, even though @c rightView is nil. It's bonkers.
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
  if ([self isRTL]) {
    return self.layout.rightViewFrame;
  } else {
    return self.layout.leftViewFrame;
  }
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
  if ([self isRTL]) {
    return self.layout.leftViewFrame;
  } else {
    return self.layout.rightViewFrame;
  }
}

- (CGRect)borderRectForBounds:(CGRect)bounds {
  if (!self.containerStyle) {
    return [super borderRectForBounds:bounds];
  }
  return CGRectZero;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
  if (self.labelState == MDCTextControlLabelStateFloating) {
    return self.layout.clearButtonFrameFloating;
  }
  return self.layout.clearButtonFrameNormal;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
  if (self.shouldPlaceholderBeVisible) {
    return [super placeholderRectForBounds:bounds];
  }
  return CGRectZero;
}

#pragma mark UITextField Drawing Overrides

- (void)drawPlaceholderInRect:(CGRect)rect {
  if (self.shouldPlaceholderBeVisible) {
    [super drawPlaceholderInRect:rect];
  }
}

#pragma mark Fonts

- (UIFont *)font {
  return [super font] ?: MDCTextControlDefaultFont();
}

- (UIFont *)normalFont {
  return self.font;
}

- (UIFont *)floatingFont {
  return [self.containerStyle floatingFontWithNormalFont:self.normalFont];
}

- (void)mdc_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
  _mdc_adjustsFontForContentSizeCategory = adjusts;
  if (_mdc_adjustsFontForContentSizeCategory) {
    [self startObservingUIContentSizeCategory];
  } else {
    [self stopObservingUIContentSizeCategory];
  }
  [self updateFontsForDynamicType];
}

- (void)updateFontsForDynamicType {
  if (self.mdc_adjustsFontForContentSizeCategory) {
    UIFont *textFont = [UIFont mdc_preferredFontForMaterialTextStyle:MDCFontTextStyleBody1];
    UIFont *helperFont = [UIFont mdc_preferredFontForMaterialTextStyle:MDCFontTextStyleCaption];
    self.font = textFont;
    self.label.font = textFont;
    self.leadingAssistiveLabel.font = helperFont;
    self.leadingAssistiveLabel.font = helperFont;
  }
  [self setNeedsLayout];
}

- (void)startObservingUIContentSizeCategory {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateFontsForDynamicType)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
}

- (void)stopObservingUIContentSizeCategory {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIContentSizeCategoryDidChangeNotification
                                                object:nil];
}

#pragma mark MDCtextControlState

- (MDCTextControlState)determineCurrentTextControlState {
  return [self textControlStateWithIsEnabled:self.isEnabled isEditing:self.isEditing];
}

- (MDCTextControlState)textControlStateWithIsEnabled:(BOOL)isEnabled isEditing:(BOOL)isEditing {
  if (isEnabled) {
    if (isEditing) {
      return MDCTextControlStateEditing;
    } else {
      return MDCTextControlStateNormal;
    }
  } else {
    return MDCTextControlStateDisabled;
  }
}

#pragma mark Placeholder

- (BOOL)shouldPlaceholderBeVisible {
  return [self shouldPlaceholderBeVisibleWithPlaceholder:self.placeholder
                                              labelState:self.labelState
                                                    text:self.text
                                               isEditing:self.isEditing];
}

- (BOOL)shouldPlaceholderBeVisibleWithPlaceholder:(NSString *)placeholder
                                       labelState:(MDCTextControlLabelState)labelState
                                             text:(NSString *)text
                                        isEditing:(BOOL)isEditing {
  BOOL hasPlaceholder = placeholder.length > 0;
  BOOL hasText = text.length > 0;

  if (hasPlaceholder) {
    if (hasText) {
      return NO;
    } else {
      if (labelState == MDCTextControlLabelStateNormal) {
        return NO;
      } else {
        return YES;
      }
    }
  } else {
    return NO;
  }
}

- (void)reestablishDefaultPlaceholderAttributes {
  // this doesn't work
  self.placeholder = self.placeholder;
}

- (void)updateAttributedPlaceholderColor {
  if (self.placeholderColor && self.attributedPlaceholder) {
    NSMutableAttributedString *mutableAttributedString =
        [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedPlaceholder];
    NSRange range = NSMakeRange(0, mutableAttributedString.length);
    NSDictionary *newColorAttribute = @{NSForegroundColorAttributeName : self.placeholderColor};
    [mutableAttributedString addAttributes:newColorAttribute range:range];
    [super setAttributedPlaceholder:[mutableAttributedString copy]];
  }
}

#pragma mark Label

- (BOOL)canLabelFloat {
  return self.labelBehavior == MDCTextControlLabelBehaviorFloats;
}

- (MDCTextControlLabelState)determineCurrentLabelState {
  return [self labelStateWithLabel:self.label
                              text:self.text
                     canLabelFloat:self.canLabelFloat
                         isEditing:self.isEditing];
}

- (MDCTextControlLabelState)labelStateWithLabel:(UILabel *)label
                                                  text:(NSString *)text
                                         canLabelFloat:(BOOL)canLabelFloat
                                             isEditing:(BOOL)isEditing {
  BOOL hasFloatingLabelText = label.text.length > 0;
  BOOL hasText = text.length > 0;
  if (hasFloatingLabelText) {
    if (canLabelFloat) {
      if (isEditing) {
        return MDCTextControlLabelStateFloating;
      } else {
        if (hasText) {
          return MDCTextControlLabelStateFloating;
        } else {
          return MDCTextControlLabelStateNormal;
        }
      }
    } else {
      if (hasText) {
        return MDCTextControlLabelStateNone;
      } else {
        return MDCTextControlLabelStateNormal;
      }
    }
  } else {
    return MDCTextControlLabelStateNone;
  }
}

#pragma mark Internationalization

- (BOOL)isRTL {
  return self.layoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
}

#pragma mark Coloring

- (void)applyColorViewModel:(MDCTextControlColorViewModel *)colorViewModel
             withLabelState:(MDCTextControlLabelState)labelState {
  UIColor *labelColor = [UIColor clearColor];
  if (labelState == MDCTextControlLabelStateNormal) {
    labelColor = colorViewModel.normalLabelColor;
  } else if (labelState == MDCTextControlLabelStateFloating) {
    labelColor = colorViewModel.floatingLabelColor;
  }
  self.textColor = colorViewModel.textColor;
  self.leadingAssistiveLabel.textColor = colorViewModel.assistiveLabelColor;
  self.trailingAssistiveLabel.textColor = colorViewModel.assistiveLabelColor;
  self.label.textColor = labelColor;
}

- (void)setTextControlColorViewModel:(MDCTextControlColorViewModel *)colorViewModel
                                   forState:(MDCTextControlState)textControlState {
  if (colorViewModel) {
    self.colorViewModels[@(textControlState)] = colorViewModel;
  }
}

- (MDCTextControlColorViewModel *)textControlColorViewModelForState:
    (MDCTextControlState)textControlState {
  MDCTextControlColorViewModel *colorViewModel = self.colorViewModels[@(textControlState)];
  if (!colorViewModel) {
    colorViewModel = [[MDCTextControlColorViewModel alloc] initWithState:textControlState];
  }
  return colorViewModel;
}

#pragma mark Color Accessors

- (void)setNormalLabelColor:(nonnull UIColor *)labelColor forState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  colorViewModel.normalLabelColor = labelColor;
  [self setNeedsLayout];
}

- (UIColor *)normalLabelColorForState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  return colorViewModel.normalLabelColor;
}

- (void)setFloatingLabelColor:(nonnull UIColor *)labelColor forState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  colorViewModel.floatingLabelColor = labelColor;
  [self setNeedsLayout];
}

- (UIColor *)floatingLabelColorForState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  return colorViewModel.floatingLabelColor;
}

- (void)setTextColor:(nonnull UIColor *)labelColor forState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  colorViewModel.textColor = labelColor;
  [self setNeedsLayout];
}

- (UIColor *)textColorForState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  return colorViewModel.textColor;
}

- (void)setAssistiveLabelColor:(nonnull UIColor *)assistiveLabelColor
                      forState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  colorViewModel.assistiveLabelColor = assistiveLabelColor;
  [self setNeedsLayout];
}

- (UIColor *)assistiveLabelColorForState:(MDCTextControlState)state {
  MDCTextControlColorViewModel *colorViewModel =
      [self textControlColorViewModelForState:state];
  return colorViewModel.assistiveLabelColor;
}

@end
