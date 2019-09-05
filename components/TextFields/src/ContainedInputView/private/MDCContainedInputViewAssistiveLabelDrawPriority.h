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

/**
 Dictates the relative importance of the underline labels, and the order in which they are laid out.
 */
typedef NS_ENUM(NSUInteger, MDCContainedInputViewAssistiveLabelDrawPriority) {
  /**
   When the priority is @c .leading, the @c leadingAssistiveLabel will be laid out first within the
   horizontal space available for @b both underline labels. Any remaining space will then be given
   for the @c trailingAssistiveLabel.
   */
  MDCContainedInputViewAssistiveLabelDrawPriorityLeading,
  /**
   When the priority is @c .trailing, the @c trailingAssistiveLabel will be laid out first within
   the horizontal space available for @b both underline labels. Any remaining space will then be
   given for the @c leadingAssistiveLabel.
   */
  MDCContainedInputViewAssistiveLabelDrawPriorityTrailing,
  /**
   When the priority is @c .custom, the @c customAssistiveLabelDrawPriority property will be used to
   divide the space available for the two underline labels.
   */
  MDCContainedInputViewAssistiveLabelDrawPriorityCustom,
};
