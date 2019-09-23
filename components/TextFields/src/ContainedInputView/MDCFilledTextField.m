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

#import "MDCFilledTextField.h"

#import <Foundation/Foundation.h>

#import "private/MDCBaseTextField+ContainedInputView.h"
#import "private/MDCContainedInputView.h"
#import "private/MDCContainedInputViewStyleFilled.h"

@interface MDCFilledTextField ()
@end

@implementation MDCFilledTextField

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonMDCFilledTextFieldInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonMDCFilledTextFieldInit];
  }
  return self;
}

- (void)commonMDCFilledTextFieldInit {
  self.containerStyle = [[MDCContainedInputViewStyleFilled alloc] init];
  self.borderStyle = UITextBorderStyleNone;
}

#pragma mark Stateful Color APIs

- (void)setFilledBackgroundColor:(nonnull UIColor *)filledBackgroundColor
                        forState:(MDCTextControlState)state {
  [self.filledStyle setFilledBackgroundColor:filledBackgroundColor
                                    forState:state];
  [self setNeedsLayout];
}

- (nonnull UIColor *)filledBackgroundColorForState:(MDCTextControlState)state {
  return [self.filledStyle underlineColorForState:state];
}

- (void)setUnderlineColor:(nonnull UIColor *)underlineColor forState:(MDCTextControlState)state {
  [self.filledStyle setUnderlineColor:underlineColor forState:state];
  [self setNeedsLayout];
}

- (nonnull UIColor *)underlineColorForState:(MDCTextControlState)state {
  return [self.filledStyle underlineColorForState:state];
}

- (MDCContainedInputViewStyleFilled *)filledStyle {
  MDCContainedInputViewStyleFilled *filledStyle = nil;
  if ([self.containerStyle isKindOfClass:[MDCContainedInputViewStyleFilled class]]) {
    filledStyle = (MDCContainedInputViewStyleFilled *)self.containerStyle;
  }
  return filledStyle;
}

@end
