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

#import "InputChipViewLayout.h"

#import <MDFInternationalization/MDFInternationalization.h>
#import "InputChipView.h"
#import "MaterialMath.h"

static const CGFloat kEstimatedCursorWidth = (CGFloat)2.0;

static const CGFloat kLeadingMargin = (CGFloat)8.0;
static const CGFloat kTrailingMargin = (CGFloat)8.0;

static const CGFloat kFloatingLabelXOffset = (CGFloat)3.0;

@interface InputChipViewLayout ()

@property(nonatomic, assign) CGFloat calculatedHeight;
@property(nonatomic, assign) CGFloat minimumHeight;
@property(nonatomic, assign) CGFloat contentAreaMaxY;

@end

@implementation InputChipViewLayout

- (instancetype)initWithSize:(CGSize)size
                      containerStyler:(id<MDCContainedInputViewStyler>)containerStyler
                                 text:(NSString *)text
                          placeholder:(NSString *)placeholder
                                 font:(UIFont *)font
                         floatingFont:(UIFont *)floatingFont
                   floatingLabelState:(MDCContainedInputViewFloatingLabelState)floatingLabelState
                                chips:(NSArray<UIView *> *)chips
                       staleChipViews:(NSArray<UIView *> *)staleChipViews
                            chipsWrap:(BOOL)chipsWrap
                        chipRowHeight:(CGFloat)chipRowHeight
                     interChipSpacing:(CGFloat)interChipSpacing
                          clearButton:(UIButton *)clearButton
                  clearButtonViewMode:(UITextFieldViewMode)clearButtonViewMode
                   leftAssistiveLabel:(UILabel *)leftAssistiveLabel
                  rightAssistiveLabel:(UILabel *)rightAssistiveLabel
           underlineLabelDrawPriority:
               (MDCContainedInputViewAssistiveLabelDrawPriority)underlineLabelDrawPriority
     customAssistiveLabelDrawPriority:(CGFloat)normalizedCustomAssistiveLabelDrawPriority
       preferredContainerHeight:(CGFloat)preferredContainerHeight
    preferredAssistiveLabelAreaHeight:(CGFloat)preferredAssistiveLabelAreaHeight
                                isRTL:(BOOL)isRTL
                            isEditing:(BOOL)isEditing {
  self = [super init];
  if (self) {
    [self calculateLayoutWithSize:size
                          containerStyler:containerStyler
                                     text:text
                              placeholder:placeholder
                                     font:font
                             floatingFont:floatingFont
                       floatingLabelState:floatingLabelState
                                    chips:chips
                           staleChipViews:staleChipViews
                                chipsWrap:chipsWrap
                            chipRowHeight:chipRowHeight
                         interChipSpacing:interChipSpacing
                              clearButton:clearButton
                      clearButtonViewMode:clearButtonViewMode
                       leftAssistiveLabel:leftAssistiveLabel
                      rightAssistiveLabel:rightAssistiveLabel
               underlineLabelDrawPriority:underlineLabelDrawPriority
         customAssistiveLabelDrawPriority:normalizedCustomAssistiveLabelDrawPriority
           preferredContainerHeight:preferredContainerHeight
        preferredAssistiveLabelAreaHeight:preferredAssistiveLabelAreaHeight
                                    isRTL:isRTL
                                isEditing:isEditing];
  }
  return self;
}

- (void)calculateLayoutWithSize:(CGSize)size
                      containerStyler:(id<MDCContainedInputViewStyler>)containerStyler
                                 text:(NSString *)text
                          placeholder:(NSString *)placeholder
                                 font:(UIFont *)font
                         floatingFont:(UIFont *)floatingFont
                   floatingLabelState:(MDCContainedInputViewFloatingLabelState)floatingLabelState
                                chips:(NSArray<UIView *> *)chips
                       staleChipViews:(NSArray<UIView *> *)staleChipViews
                            chipsWrap:(BOOL)chipsWrap
                        chipRowHeight:(CGFloat)chipRowHeight
                     interChipSpacing:(CGFloat)interChipSpacing
                          clearButton:(UIButton *)clearButton
                  clearButtonViewMode:(UITextFieldViewMode)clearButtonViewMode
                   leftAssistiveLabel:(UILabel *)leftAssistiveLabel
                  rightAssistiveLabel:(UILabel *)rightAssistiveLabel
           underlineLabelDrawPriority:
               (MDCContainedInputViewAssistiveLabelDrawPriority)underlineLabelDrawPriority
     customAssistiveLabelDrawPriority:(CGFloat)normalizedCustomAssistiveLabelDrawPriority
       preferredContainerHeight:(CGFloat)preferredContainerHeight
    preferredAssistiveLabelAreaHeight:(CGFloat)preferredAssistiveLabelAreaHeight
                                isRTL:(BOOL)isRTL
                            isEditing:(BOOL)isEditing {
  CGFloat globalChipRowMinX = isRTL ? kTrailingMargin : kLeadingMargin;
  CGFloat globalChipRowMaxX = isRTL ? size.width - kLeadingMargin : size.width - kTrailingMargin;
  CGFloat maxTextWidth = globalChipRowMaxX - globalChipRowMinX;
  CGRect floatingLabelFrameFloating = [self floatingLabelFrameWithPlaceholder:placeholder
                                                                         font:floatingFont
                                                                 floatingFont:floatingFont
                                                            globalChipRowMinX:globalChipRowMinX
                                                            globalChipRowMaxX:globalChipRowMaxX
                                                                chipRowHeight:chipRowHeight
                                                     preferredContainerHeight:preferredContainerHeight
                                                              containerStyler:containerStyler
                                                                        isRTL:isRTL];
  CGFloat floatingLabelMaxY = CGRectGetMaxY(floatingLabelFrameFloating);
  CGFloat initialChipRowMinYWithFloatingLabel =
      [containerStyler.positioningDelegate contentAreaTopPaddingFloatingLabelWithFloatingLabelMaxY:floatingLabelMaxY];
  if ([containerStyler.positioningDelegate respondsToSelector:@selector(textMinYWithFloatingLabelWithTextHeight:floatingLabelHeight:preferredContainerHeight:)]) {
    initialChipRowMinYWithFloatingLabel =
        [containerStyler.positioningDelegate textMinYWithFloatingLabelWithTextHeight:chipRowHeight
                                                                 floatingLabelHeight:floatingFont.lineHeight
                                                            preferredContainerHeight:preferredContainerHeight];
  }
  CGFloat highestPossibleInitialChipRowMaxY = initialChipRowMinYWithFloatingLabel + chipRowHeight;
  CGFloat bottomPadding = [containerStyler.positioningDelegate
      contentAreaVerticalPaddingNormalWithFloatingLabelMaxY:floatingLabelMaxY];
  if ([containerStyler.positioningDelegate respondsToSelector:@selector(textMinYWithoutFloatingLabelWithTextHeight:floatingLabelHeight:preferredContainerHeight:)]) {
    bottomPadding = [containerStyler.positioningDelegate textMinYWithoutFloatingLabelWithTextHeight:chipRowHeight
                                                                                floatingLabelHeight:floatingFont.lineHeight
                                                                           preferredContainerHeight:preferredContainerHeight];
  }
  CGFloat intrinsicMainContentAreaHeight = highestPossibleInitialChipRowMaxY + bottomPadding;
  CGFloat contentAreaMaxY = 0;
  if (preferredContainerHeight > intrinsicMainContentAreaHeight) {
    contentAreaMaxY = preferredContainerHeight;
  } else {
    contentAreaMaxY = intrinsicMainContentAreaHeight;
  }

  CGRect floatingLabelFrameNormal =
      [self normalPlaceholderFrameWithFloatingLabelFrame:floatingLabelFrameFloating
                                             placeholder:placeholder
                                                    font:font
                                            floatingFont:floatingFont
                                       globalChipRowMinX:globalChipRowMinX
                                       globalChipRowMaxX:globalChipRowMaxX
                                               chipsWrap:chipsWrap
                                           chipRowHeight:chipRowHeight
                                preferredContainerHeight:preferredContainerHeight
                                       contentAreaHeight:contentAreaMaxY
                                         containerStyler:containerStyler
                                                   isRTL:isRTL];

  CGFloat initialChipRowMinYNormal =
      CGRectGetMidY(floatingLabelFrameNormal) - ((CGFloat)0.5 * chipRowHeight);
  if (chipsWrap) {
  } else {
    CGFloat center = contentAreaMaxY * (CGFloat)0.5;
    initialChipRowMinYNormal = center - (chipRowHeight * (CGFloat)0.5);
  }
  CGFloat initialChipRowMinY = initialChipRowMinYNormal;
  if (floatingLabelState == MDCContainedInputViewFloatingLabelStateFloating) {
    initialChipRowMinY = initialChipRowMinYWithFloatingLabel;
  }

  CGSize textFieldSize = [self textSizeWithText:text font:font maxWidth:maxTextWidth];

  NSArray<NSValue *> *chipFrames = [self determineChipFramesWithChips:chips
                                                            chipsWrap:chipsWrap
                                                        chipRowHeight:chipRowHeight
                                                     interChipSpacing:interChipSpacing
                                                   initialChipRowMinY:initialChipRowMinY
                                                    globalChipRowMinX:globalChipRowMinX
                                                    globalChipRowMaxX:globalChipRowMaxX
                                                                isRTL:isRTL];

  CGSize scrollViewSize = CGSizeMake(size.width, contentAreaMaxY);

  CGRect textFieldFrame = [self textFieldFrameWithSize:scrollViewSize
                                            chipFrames:chipFrames
                                             chipsWrap:chipsWrap
                                         chipRowHeight:chipRowHeight
                                      interChipSpacing:interChipSpacing
                                    initialChipRowMinY:initialChipRowMinY
                                     globalChipRowMinX:globalChipRowMinX
                                     globalChipRowMaxX:globalChipRowMaxX
                                         textFieldSize:textFieldSize
                                                 isRTL:isRTL];

  CGPoint contentOffset = [self scrollViewContentOffsetWithSize:scrollViewSize
                                                      chipsWrap:chipsWrap
                                                  chipRowHeight:chipRowHeight
                                               interChipSpacing:interChipSpacing
                                                 textFieldFrame:textFieldFrame
                                             initialChipRowMinY:initialChipRowMinY
                                              globalChipRowMinX:globalChipRowMinX
                                              globalChipRowMaxX:globalChipRowMaxX
                                                  bottomPadding:bottomPadding
                                                          isRTL:isRTL];
  CGSize contentSize = [self scrollViewContentSizeWithSize:scrollViewSize
                                             contentOffset:contentOffset
                                                chipFrames:chipFrames
                                                 chipsWrap:chipsWrap
                                            textFieldFrame:textFieldFrame];

  self.contentAreaMaxY = contentAreaMaxY;
  self.chipFrames = chipFrames;
  self.textFieldFrame = textFieldFrame;
  self.scrollViewContentOffset = contentOffset;
  self.scrollViewContentSize = contentSize;
  self.scrollViewContentViewTouchForwardingViewFrame =
      CGRectMake(0, 0, contentSize.width, contentSize.height);
  self.floatingLabelFrameFloating = floatingLabelFrameFloating;
  self.floatingLabelFrameNormal = floatingLabelFrameNormal;
  self.initialChipRowMinY = initialChipRowMinY;
  self.globalChipRowMinX = globalChipRowMinX;
  self.globalChipRowMaxX = globalChipRowMaxX;
  CGRect scrollViewRect = CGRectMake(0, 0, size.width, contentAreaMaxY);
  self.maskedScrollViewContainerViewFrame = scrollViewRect;
  self.scrollViewFrame = scrollViewRect;

  //  if (isRTL) {
  //    NSMutableArray<NSValue *> *rtlChips =
  //        [[NSMutableArray alloc] initWithCapacity:chipFrames.count];
  //    for (NSValue *chipFrame in chipFrames) {
  //      CGRect frame = [chipFrame CGRectValue];
  //      frame = MDFRectFlippedHorizontally(frame, size.width);
  //      [rtlChips addObject:[NSValue valueWithCGRect:frame]];
  //    }
  //    self.chipFrames = [rtlChips copy];
  //    self.textFieldFrame = MDFRectFlippedHorizontally(textFieldFrame, size.width);
  //    self.scrollViewContentViewTouchForwardingViewFrame =
  //        MDFRectFlippedHorizontally(self.scrollViewContentViewTouchForwardingViewFrame,
  //        size.width);
  //    self.floatingLabelFrameFloating = MDFRectFlippedHorizontally(floatingLabelFrameFloating,
  //    size.width); self.floatingLabelFrameNormal =
  //    MDFRectFlippedHorizontally(floatingLabelFrameNormal, size.width);
  //    self.maskedScrollViewContainerViewFrame =
  //        MDFRectFlippedHorizontally(self.maskedScrollViewContainerViewFrame, size.width);
  //    self.scrollViewFrame = MDFRectFlippedHorizontally(scrollViewRect, size.width);
  //  }

  return;
}

- (CGFloat)calculatedHeight {
  CGFloat maxY = 0;
  CGFloat floatingLabelFrameFloatingMaxY = CGRectGetMaxY(self.floatingLabelFrameFloating);
  if (floatingLabelFrameFloatingMaxY > maxY) {
    maxY = floatingLabelFrameFloatingMaxY;
  }
  CGFloat floatingLabelFrameNormalMaxY = CGRectGetMaxY(self.floatingLabelFrameNormal);
  if (floatingLabelFrameFloatingMaxY > maxY) {
    maxY = floatingLabelFrameNormalMaxY;
  }
  CGFloat textRectMaxY = self.contentAreaMaxY;
  if (textRectMaxY > maxY) {
    maxY = textRectMaxY;
  }
  //  CGFloat clearButtonFrameMaxY = CGRectGetMaxY(self.clearButtonFrame);
  //  if (clearButtonFrameMaxY > maxY) {
  //    maxY = clearButtonFrameMaxY;
  //  }
  CGFloat leftAssistiveLabelFrameMaxY = CGRectGetMaxY(self.leftAssistiveLabelFrame);
  if (leftAssistiveLabelFrameMaxY > maxY) {
    maxY = leftAssistiveLabelFrameMaxY;
  }
  CGFloat rightAssistiveLabelFrameMaxY = CGRectGetMaxY(self.rightAssistiveLabelFrame);
  if (rightAssistiveLabelFrameMaxY > maxY) {
    maxY = rightAssistiveLabelFrameMaxY;
  }
  return maxY;
}

- (CGRect)normalPlaceholderFrameWithFloatingLabelFrame:(CGRect)floatingLabelFrame
                                           placeholder:(NSString *)placeholder
                                                  font:(UIFont *)font
                                          floatingFont:(UIFont *)floatingFont
                                     globalChipRowMinX:(CGFloat)globalChipRowMinX
                                     globalChipRowMaxX:(CGFloat)globalChipRowMaxX
                                             chipsWrap:(BOOL)chipsWrap
                                         chipRowHeight:(CGFloat)chipRowHeight
                              preferredContainerHeight:(CGFloat)preferredContainerHeight
                                     contentAreaHeight:(CGFloat)contentAreaHeight
                                       containerStyler:
                                           (id<MDCContainedInputViewStyler>)containerStyler
                                                 isRTL:(BOOL)isRTL {
  CGFloat maxTextWidth = globalChipRowMaxX - globalChipRowMinX;
  CGSize placeholderSize = [self textSizeWithText:placeholder font:font maxWidth:maxTextWidth];
  CGFloat placeholderMinX = globalChipRowMinX;
  if (isRTL) {
    placeholderMinX = globalChipRowMaxX - placeholderSize.width;
  }
  CGFloat placeholderMinY = 0;
  if (chipsWrap) {
    if ([containerStyler.positioningDelegate respondsToSelector:@selector(textMinYWithoutFloatingLabelWithTextHeight:floatingLabelHeight:preferredContainerHeight:)]) {
      placeholderMinY = [containerStyler.positioningDelegate textMinYWithoutFloatingLabelWithTextHeight:chipRowHeight floatingLabelHeight:floatingFont.lineHeight preferredContainerHeight:preferredContainerHeight];
    } else {
      placeholderMinY = [containerStyler.positioningDelegate
       contentAreaVerticalPaddingNormalWithFloatingLabelMaxY:CGRectGetMaxY(floatingLabelFrame)];
    }
  } else {
    CGFloat center = contentAreaHeight * (CGFloat)0.5;
    placeholderMinY = center - (placeholderSize.height * (CGFloat)0.5);
  }
  return CGRectMake(placeholderMinX, placeholderMinY, placeholderSize.width,
                    placeholderSize.height);
}

- (CGRect)floatingLabelFrameWithPlaceholder:(NSString *)placeholder
                                       font:(UIFont *)font
                               floatingFont:(UIFont *)floatingFont
                          globalChipRowMinX:(CGFloat)globalChipRowMinX
                          globalChipRowMaxX:(CGFloat)globalChipRowMaxX
                              chipRowHeight:(CGFloat)chipRowHeight
                   preferredContainerHeight:(CGFloat)preferredContainerHeight
                            containerStyler:(id<MDCContainedInputViewStyler>)containerStyler
                                      isRTL:(BOOL)isRTL {
  CGFloat maxTextWidth = globalChipRowMaxX - globalChipRowMinX - kFloatingLabelXOffset;
  CGSize placeholderSize = [self textSizeWithText:placeholder font:floatingFont maxWidth:maxTextWidth];
  CGFloat placeholderMinY = 0;
  //[containerStyler.positioningDelegate
//      floatingLabelMinYWithFloatingLabelHeight:placeholderSize.height];
  if ([containerStyler.positioningDelegate respondsToSelector:@selector(floatingLabelMinYWithTextHeight:floatingLabelHeight:preferredContainerHeight:)]) {
    placeholderMinY = [containerStyler.positioningDelegate floatingLabelMinYWithTextHeight:chipRowHeight
                                                                       floatingLabelHeight:floatingFont.lineHeight
                                                                  preferredContainerHeight:preferredContainerHeight];
  }

  CGFloat placeholderMinX = globalChipRowMinX + kFloatingLabelXOffset;
  if (isRTL) {
    placeholderMinX = globalChipRowMaxX - kFloatingLabelXOffset - placeholderSize.width;
  }
  return CGRectMake(placeholderMinX, placeholderMinY, placeholderSize.width,
                    placeholderSize.height);
}

- (CGFloat)textHeightWithFont:(UIFont *)font {
  return (CGFloat)ceil((double)font.lineHeight);
}

- (NSArray<NSValue *> *)determineChipFramesWithChips:(NSArray<UIView *> *)chips
                                           chipsWrap:(BOOL)chipsWrap
                                       chipRowHeight:(CGFloat)chipRowHeight
                                    interChipSpacing:(CGFloat)interChipSpacing
                                  initialChipRowMinY:(CGFloat)initialChipRowMinY
                                   globalChipRowMinX:(CGFloat)globalChipRowMinX
                                   globalChipRowMaxX:(CGFloat)globalChipRowMaxX
                                               isRTL:(BOOL)isRTL {
  NSMutableArray<NSValue *> *frames = [[NSMutableArray alloc] initWithCapacity:chips.count];

  if (isRTL) {
    NSArray<UIView *> *rtlChips = [[chips reverseObjectEnumerator] allObjects];
    if (chipsWrap) {
      //      CGFloat chipMinX = globalChipRowMinX;
      //      CGFloat chipMidY = initialChipRowMinY + (0.5 * chipRowHeight);
      //      CGFloat chipMinY = 0;
      //      CGRect chipFrame = CGRectZero;
      //      NSInteger row = 0;
      //      for (MDCChipView *chip in chips) {
      //        CGFloat chipWidth = CGRectGetWidth(chip.frame);
      //        CGFloat chipHeight = CGRectGetHeight(chip.frame);
      //        CGFloat chipMaxX = chipMinX + chipWidth;
      //        BOOL chipIsTooLong = chipMaxX > globalChipRowMaxX;
      //        BOOL firstChipInRow = chipMinX == globalChipRowMinX;
      //        BOOL isNewRow = chipIsTooLong && !firstChipInRow;
      //        if (isNewRow) {
      //          row++;
      //          chipMinX = globalChipRowMinX;
      //          chipMidY = initialChipRowMinY + (row * (chipRowHeight + interChipSpacing)) +
      //          (0.5 * chipRowHeight);
      //          chipMinY = chipMidY - (0.5 * chipHeight);
      //          chipFrame = CGRectMake(chipMinX, chipMinY, chipWidth, chipHeight);
      //          chipMaxX = CGRectGetMaxX(chipFrame);
      //        } else {
      //          chipMinY = chipMidY - (0.5 * chipHeight);
      //          chipFrame = CGRectMake(chipMinX, chipMinY, chipWidth, chipHeight);
      //        }
      //        chipMinX = chipMaxX + interChipSpacing;
      //        NSValue *chipFrameValue = [NSValue valueWithCGRect:chipFrame];
      //        [frames addObject:chipFrameValue];
      //      }
    } else {
      CGFloat chipMinX = globalChipRowMinX;
      CGFloat chipCenterY = initialChipRowMinY + (chipRowHeight * (CGFloat)0.5);
      for (MDCChipView *chip in rtlChips) {
        CGFloat chipWidth = CGRectGetWidth(chip.frame);
        CGFloat chipHeight = CGRectGetHeight(chip.frame);
        CGFloat chipMinY = chipCenterY - ((CGFloat)0.5 * chipHeight);
        CGRect chipFrame = CGRectMake(chipMinX, chipMinY, chipWidth, chipHeight);
        NSValue *chipFrameValue = [NSValue valueWithCGRect:chipFrame];
        [frames addObject:chipFrameValue];
        CGFloat chipMaxX = MDCCeil(CGRectGetMaxX(chipFrame));
        chipMinX = chipMaxX + interChipSpacing;
      }
    }
  } else {
    if (chipsWrap) {
      CGFloat chipMinX = globalChipRowMinX;
      CGFloat chipMidY = initialChipRowMinY + ((CGFloat)0.5 * chipRowHeight);
      CGFloat chipMinY = 0;
      CGRect chipFrame = CGRectZero;
      CGFloat row = 0;
      for (MDCChipView *chip in chips) {
        CGFloat chipWidth = CGRectGetWidth(chip.frame);
        CGFloat chipHeight = CGRectGetHeight(chip.frame);
        CGFloat chipMaxX = chipMinX + chipWidth;
        BOOL chipIsTooLong = chipMaxX > globalChipRowMaxX;
        BOOL firstChipInRow = chipMinX == globalChipRowMinX;
        BOOL isNewRow = chipIsTooLong && !firstChipInRow;
        if (isNewRow) {
          row++;
          chipMinX = globalChipRowMinX;
          chipMidY = initialChipRowMinY + (row * (chipRowHeight + interChipSpacing)) +
                     ((CGFloat)0.5 * chipRowHeight);
          chipMinY = chipMidY - ((CGFloat)0.5 * chipHeight);
          chipFrame = CGRectMake(chipMinX, chipMinY, chipWidth, chipHeight);
          chipMaxX = CGRectGetMaxX(chipFrame);
        } else {
          chipMinY = chipMidY - ((CGFloat)0.5 * chipHeight);
          chipFrame = CGRectMake(chipMinX, chipMinY, chipWidth, chipHeight);
        }
        chipMinX = chipMaxX + interChipSpacing;
        NSValue *chipFrameValue = [NSValue valueWithCGRect:chipFrame];
        [frames addObject:chipFrameValue];
      }
    } else {
      CGFloat chipMinX = globalChipRowMinX;
      CGFloat chipCenterY = initialChipRowMinY + (chipRowHeight * (CGFloat)0.5);
      for (MDCChipView *chip in chips) {
        CGFloat chipWidth = CGRectGetWidth(chip.frame);
        CGFloat chipHeight = CGRectGetHeight(chip.frame);
        CGFloat chipMinY = chipCenterY - ((CGFloat)0.5 * chipHeight);
        CGRect chipFrame = CGRectMake(chipMinX, chipMinY, chipWidth, chipHeight);
        NSValue *chipFrameValue = [NSValue valueWithCGRect:chipFrame];
        [frames addObject:chipFrameValue];
        CGFloat chipMaxX = MDCCeil(CGRectGetMaxX(chipFrame));
        chipMinX = chipMaxX + interChipSpacing;
      }
    }
  }
  return [frames copy];
}

- (CGSize)textSizeWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
  CGSize fittingSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
  NSDictionary *attributes = @{NSFontAttributeName : font};
  CGRect rect = [text boundingRectWithSize:fittingSize
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes
                                   context:nil];
  CGFloat maxTextFieldHeight = font.lineHeight;
  CGFloat textFieldWidth = MDCCeil(CGRectGetWidth(rect)) + kEstimatedCursorWidth;
  CGFloat textFieldHeight = MDCCeil(CGRectGetHeight(rect));
  if (textFieldWidth > maxWidth) {
    textFieldWidth = maxWidth;
  }
  if (textFieldHeight > maxTextFieldHeight) {
    textFieldHeight = maxTextFieldHeight;
  }
  rect.size.width = textFieldWidth;
  rect.size.height = textFieldHeight;
  return rect.size;
}

- (CGSize)scrollViewContentSizeWithSize:(CGSize)size
                          contentOffset:(CGPoint)contentOffset
                             chipFrames:(NSArray<NSValue *> *)chipFrames
                              chipsWrap:(BOOL)chipsWrap
                         textFieldFrame:(CGRect)textFieldFrame {
  if (chipsWrap) {
    if (contentOffset.y > 0) {
      size.height += contentOffset.y;
    }
    return size;
  } else {
    if (contentOffset.x > 0) {
      size.width += contentOffset.x;
    }
    return size;
  }
  //  CGFloat totalMinX = 0;
  //  CGFloat totalMaxX = 0;
  //  CGFloat totalMinY = 0;
  //  CGFloat totalMaxY = 0;
  //  NSValue *textFieldFrameValue = [NSValue valueWithCGRect:textFieldFrame];
  //  NSArray *allFrames = [chipFrames arrayByAddingObject:textFieldFrameValue];
  //  for (NSUInteger index = 0; index < allFrames.count; index++) {
  //    NSValue *frameValue = allFrames[index];
  //    CGRect frame = frameValue.CGRectValue;
  //    if (index == 0) {
  //      totalMinX = CGRectGetMinX(frame);
  //      totalMaxX = CGRectGetMaxX(frame);
  //      totalMinY = CGRectGetMinY(frame);
  //      totalMaxY = CGRectGetMaxY(frame);
  //    } else {
  //      CGFloat minX = CGRectGetMinX(frame);
  //      CGFloat maxX = CGRectGetMaxX(frame);
  //      CGFloat minY = CGRectGetMinY(frame);
  //      CGFloat maxY = CGRectGetMaxY(frame);
  //      if (minX < totalMinX) {
  //        totalMinX = minX;
  //      }
  //      if (minY < totalMinY) {
  //        totalMinY = minY;
  //      }
  //      if (maxX > totalMaxX) {
  //        totalMaxX = maxX;
  //      }
  //      if (maxY > totalMaxY) {
  //        totalMaxY = maxY;
  //      }
  //    }
  //  }
  //  CGFloat width = totalMaxX - totalMinX;
  //  CGFloat height = totalMaxY - totalMinY;
  //  return CGSizeMake(width, height);
}

- (CGRect)textFieldFrameWithSize:(CGSize)size
                      chipFrames:(NSArray<NSValue *> *)chipFrames
                       chipsWrap:(BOOL)chipsWrap
                   chipRowHeight:(CGFloat)chipRowHeight
                interChipSpacing:(CGFloat)interChipSpacing
              initialChipRowMinY:(CGFloat)initialChipRowMinY
               globalChipRowMinX:(CGFloat)globalChipRowMinX
               globalChipRowMaxX:(CGFloat)globalChipRowMaxX
                   textFieldSize:(CGSize)textFieldSize
                           isRTL:(BOOL)isRTL {
  if (isRTL) {
    if (chipsWrap) {
    } else {
    }
  } else {
    if (chipsWrap) {
      CGFloat textFieldMinX = 0;
      CGFloat textFieldMaxX = 0;
      CGFloat textFieldMinY = 0;
      CGFloat textFieldMidY = 0;
      if (chipFrames.count > 0) {
        CGRect lastChipFrame = [[chipFrames lastObject] CGRectValue];
        CGFloat lastChipMidY = CGRectGetMidY(lastChipFrame);
        textFieldMidY = lastChipMidY;
        textFieldMinY = textFieldMidY - ((CGFloat)0.5 * textFieldSize.height);
        textFieldMinX = CGRectGetMaxX(lastChipFrame) + interChipSpacing;
        textFieldMaxX = textFieldMinX + textFieldSize.width;
        BOOL textFieldShouldMoveToNextRow = textFieldMaxX > globalChipRowMaxX;
        if (textFieldShouldMoveToNextRow) {
          NSInteger currentRow = [self chipRowWithRect:lastChipFrame
                                    initialChipRowMinY:initialChipRowMinY
                                         chipRowHeight:chipRowHeight
                                      interChipSpacing:interChipSpacing];
          NSInteger nextRow = currentRow + 1;
          CGFloat nextRowMinY =
              initialChipRowMinY + ((CGFloat)(nextRow) * (chipRowHeight + interChipSpacing));
          textFieldMidY = nextRowMinY + ((CGFloat)0.5 * chipRowHeight);
          textFieldMinY = textFieldMidY - ((CGFloat)0.5 * textFieldSize.height);
          textFieldMinX = globalChipRowMinX;
          textFieldMaxX = textFieldMinX + textFieldSize.width;
          BOOL textFieldIsStillTooBig = textFieldMaxX > globalChipRowMaxX;
          if (textFieldIsStillTooBig) {
            CGFloat difference = textFieldMaxX - globalChipRowMaxX;
            textFieldSize.width = textFieldSize.width - difference;
          }
        }
        return CGRectMake(textFieldMinX, textFieldMinY, textFieldSize.width, textFieldSize.height);
      } else {
        textFieldMinX = globalChipRowMinX;
        textFieldMidY = initialChipRowMinY + ((CGFloat)0.5 * chipRowHeight);
        textFieldMinY = textFieldMidY - ((CGFloat)0.5 * textFieldSize.height);
        return CGRectMake(textFieldMinX, textFieldMinY, textFieldSize.width, textFieldSize.height);
      }
      return CGRectMake(textFieldMinX, textFieldMinY, textFieldSize.width, textFieldSize.height);
    } else {
      CGFloat textFieldMinX = 0;
      if (chipFrames.count > 0) {
        CGRect lastFrame = [[chipFrames lastObject] CGRectValue];
        textFieldMinX = MDCCeil(CGRectGetMaxX(lastFrame)) + interChipSpacing;
      } else {
        textFieldMinX = globalChipRowMinX;
      }
      CGFloat textFieldCenterY = initialChipRowMinY + ((CGFloat)0.5 * chipRowHeight);
      CGFloat textFieldMinY = textFieldCenterY - ((CGFloat)0.5 * textFieldSize.height);
      return CGRectMake(textFieldMinX, textFieldMinY, textFieldSize.width, textFieldSize.height);
    }
  }
  return CGRectZero;
}

- (CGPoint)scrollViewContentOffsetWithSize:(CGSize)size
                                 chipsWrap:(BOOL)chipsWrap
                             chipRowHeight:(CGFloat)chipRowHeight
                          interChipSpacing:(CGFloat)interChipSpacing
                            textFieldFrame:(CGRect)textFieldFrame
                        initialChipRowMinY:(CGFloat)initialChipRowMinY
                         globalChipRowMinX:(CGFloat)globalChipRowMinX
                         globalChipRowMaxX:(CGFloat)globalChipRowMaxX
                             bottomPadding:(CGFloat)bottomPadding
                                     isRTL:(BOOL)isRTL {
  CGPoint contentOffset = CGPointZero;
  if (isRTL) {
    if (chipsWrap) {
    } else {
    }
  } else {
    if (chipsWrap) {
      NSInteger row = [self chipRowWithRect:textFieldFrame
                         initialChipRowMinY:initialChipRowMinY
                              chipRowHeight:chipRowHeight
                           interChipSpacing:interChipSpacing];
      CGFloat lastRowMaxY = initialChipRowMinY + ((row + 1) * (chipRowHeight + interChipSpacing));
      CGFloat boundsMaxY = size.height;
      if (lastRowMaxY > boundsMaxY) {
        CGFloat difference = lastRowMaxY - boundsMaxY;
        contentOffset = CGPointMake(0, (difference + bottomPadding));
      }
    } else {
      CGFloat textFieldMinX = CGRectGetMinX(textFieldFrame);
      CGFloat textFieldMaxX = CGRectGetMaxX(textFieldFrame);

      if (textFieldMaxX > globalChipRowMaxX) {
        CGFloat difference = textFieldMaxX - globalChipRowMaxX;
        contentOffset = CGPointMake(difference, 0);
      } else if (textFieldMinX < globalChipRowMinX) {
        CGFloat difference = globalChipRowMinX - textFieldMinX;
        contentOffset = CGPointMake((-1 * difference), 0);
      }
    }
  }
  return contentOffset;
}

- (NSInteger)chipRowWithRect:(CGRect)rect
          initialChipRowMinY:(CGFloat)initialChipRowMinY
               chipRowHeight:(CGFloat)chipRowHeight
            interChipSpacing:(CGFloat)interChipSpacing {
  CGFloat viewMidY = CGRectGetMidY(rect);
  CGFloat midYAdjustedForContentInset = MDCRound(viewMidY - initialChipRowMinY);
  NSInteger row =
      (NSInteger)midYAdjustedForContentInset / (NSInteger)(chipRowHeight + interChipSpacing);
  return row;
}

@end
