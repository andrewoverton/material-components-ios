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

#import "MDCFilledTextArea.h"

#import <Foundation/Foundation.h>

#import "private/MDCBaseTextArea+MDCContainedInputView.h"
#import "private/MDCContainedInputView.h"
#import "private/MDCContainedInputViewStyleFilled.h"

@interface MDCFilledTextArea ()
@end

@implementation MDCFilledTextArea

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonMDCFilledTextAreaInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonMDCFilledTextAreaInit];
  }
  return self;
}

- (void)commonMDCFilledTextAreaInit {
  MDCContainedInputViewStyleFilled *filledStyle = [[MDCContainedInputViewStyleFilled alloc] init];
  self.containerStyle = filledStyle;
}

#pragma mark Stateful Color APIs

- (void)setFilledBackgroundColor:(nonnull UIColor *)filledBackgroundColor
                        forState:(UIControlState)state {
  MDCContainedInputViewState containedInputViewState =
      MDCContainedInputViewStateWithUIControlState(state);
  [self.filledStyle setFilledBackgroundColor:filledBackgroundColor
                                    forState:containedInputViewState];
  [self setNeedsLayout];
}

- (nonnull UIColor *)filledBackgroundColorForState:(UIControlState)state {
  MDCContainedInputViewState containedInputViewState =
      MDCContainedInputViewStateWithUIControlState(state);
  return [self.filledStyle underlineColorForState:containedInputViewState];
}

- (void)setUnderlineColor:(nonnull UIColor *)underlineColor forState:(UIControlState)state {
  MDCContainedInputViewState containedInputViewState =
      MDCContainedInputViewStateWithUIControlState(state);
  [self.filledStyle setUnderlineColor:underlineColor forState:containedInputViewState];
  [self setNeedsLayout];
}

- (nonnull UIColor *)underlineColorForState:(UIControlState)state {
  MDCContainedInputViewState containedInputViewState =
      MDCContainedInputViewStateWithUIControlState(state);
  return [self.filledStyle underlineColorForState:containedInputViewState];
}

- (MDCContainedInputViewStyleFilled *)filledStyle {
  MDCContainedInputViewStyleFilled *filledStyle = nil;
  if ([self.containerStyle isKindOfClass:[MDCContainedInputViewStyleFilled class]]) {
    filledStyle = (MDCContainedInputViewStyleFilled *)self.containerStyle;
  }
  return filledStyle;
}

@end
