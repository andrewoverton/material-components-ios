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

#import "MDCContainedInputAssistiveLabelView.h"
#import "MDCContainedInputClearButton.h"
#import "MDCContainedInputView.h"

@protocol MDCContainedInputViewStyler;

NS_ASSUME_NONNULL_BEGIN

@interface MDCBaseTextFieldLayout : NSObject

@property(nonatomic, assign) BOOL leftViewHidden;
@property(nonatomic, assign) BOOL rightViewHidden;
@property(nonatomic, assign) BOOL clearButtonHidden;

@property(nonatomic, assign) CGRect labelFrameFloating;
@property(nonatomic, assign) CGRect labelFrameNormal;
@property(nonatomic, assign) CGRect placeholderLabelFrameNormal;
@property(nonatomic, assign) CGRect textRect;
@property(nonatomic, assign) CGRect textRectFloatingLabel;
@property(nonatomic, assign) CGRect clearButtonFrame;
@property(nonatomic, assign) CGRect clearButtonFrameFloatingLabel;
@property(nonatomic, assign) CGRect leftViewFrame;
@property(nonatomic, assign) CGRect rightViewFrame;
@property(nonatomic, assign) CGRect underlineLabelViewFrame;
@property(nonatomic, strong) MDCContainedInputAssistiveLabelViewLayout *underlineLabelViewLayout;

@property(nonatomic, readonly) CGFloat calculatedHeight;
@property(nonatomic, assign) CGFloat topRowBottomRowDividerY;

- (instancetype)initWithTextFieldSize:(CGSize)textFieldSize
                      containerStyler:(id<MDCContainedInputViewStyler>)containerStyler
                  positioningDelegate:(id<NewPositioningDelegate>)positioningDelegate
                                 text:(NSString *)text
                          placeholder:(NSString *)placeholder
                                 font:(UIFont *)font
                         floatingFont:(UIFont *)floatingFont
                                label:(UILabel *)label
                        canLabelFloat:(BOOL)canLabelFloat
                             leftView:(UIView *)leftView
                         leftViewMode:(UITextFieldViewMode)leftViewMode
                            rightView:(UIView *)rightView
                        rightViewMode:(UITextFieldViewMode)rightViewMode
                          clearButton:(MDCContainedInputClearButton *)clearButton
                      clearButtonMode:(UITextFieldViewMode)clearButtonMode
                   leftAssistiveLabel:(UILabel *)leftAssistiveLabel
                  rightAssistiveLabel:(UILabel *)rightAssistiveLabel
           underlineLabelDrawPriority:
               (MDCContainedInputViewAssistiveLabelDrawPriority)underlineLabelDrawPriority
     customAssistiveLabelDrawPriority:(CGFloat)customAssistiveLabelDrawPriority
             preferredContainerHeight:(CGFloat)preferredContainerHeight
                                isRTL:(BOOL)isRTL
                            isEditing:(BOOL)isEditing;

@end

NS_ASSUME_NONNULL_END
