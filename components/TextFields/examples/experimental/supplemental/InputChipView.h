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

#import "MaterialContainerScheme.h"

#import "MDCContainedInputView.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputChipView : UIControl <MDCContainedInputView>
@property(strong, nonatomic, readonly) UITextField *textField;

@property(nonatomic, assign) BOOL chipsWrap;

@property(nonatomic, assign) CGFloat chipRowHeight;
@property(nonatomic, assign) CGFloat chipRowSpacing;

- (void)addChip:(UIView *)chip;

@property(nonatomic, assign) BOOL canFloatingLabelFloat;
//TODO: This needs to be replaced with an InputChipView specific label behavior property

@end

NS_ASSUME_NONNULL_END
