/*
 Copyright 2016-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "CollectionsEditingExample.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 5;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsEditingExample {
  NSMutableArray *_content;
}

+ (NSArray *)catalogBreadcrumbs {
  return @[ @"Collections", @"Cell Editing Example" ];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Add button to toggle edit mode.
  [self updatedRightBarButtonItem:NO];

  // Register cell class.
  [self.collectionView registerClass:[MDCCollectionViewTextCell class]
          forCellWithReuseIdentifier:kReusableIdentifierItem];

  // Populate content.
  _content = [NSMutableArray array];
  for (NSInteger i = 0; i < kSectionCount; i++) {
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger j = 0; j < kSectionItemCount; j++) {
      NSString *itemString = [NSString stringWithFormat:@"Section-%zd Item-%zd", i, j];
      [items addObject:itemString];
    }
    [_content addObject:items];
  }

  // Customize collection view settings.
  self.styler.cellStyle = MDCCollectionViewCellStyleCard;
}

- (void)updatedRightBarButtonItem:(BOOL)isEditing {
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:isEditing ? @"Cancel" : @"Edit"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(toggleEditMode:)];
}

- (void)toggleEditMode:(id)sender {
  BOOL isEditing = self.editor.isEditing;
  [self updatedRightBarButtonItem:!isEditing];
  [self.editor setEditing:!isEditing animated:YES];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return [_content count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_content[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MDCCollectionViewTextCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                                forIndexPath:indexPath];
  cell.textLabel.text = _content[indexPath.section][indexPath.item];
  return cell;
}

#pragma mark - <MDCCollectionViewEditingDelegate>

- (BOOL)collectionViewAllowsEditing:(UICollectionView *)collectionView {
  return YES;
}

- (BOOL)collectionViewAllowsReordering:(UICollectionView *)collectionView {
  return YES;
}

- (BOOL)collectionViewAllowsSwipeToDismissItem:(UICollectionView *)collectionView {
  return self.editor.isEditing;
}

- (void)collectionView:(UICollectionView *)collectionView
    willDeleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
  // First sort reverse order then remove. This is done because when we delete an index path the
  // higher rows shift down, altering the index paths of those that we would like to delete in the
  // next iteration of this loop.
  NSArray *sortedArray = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
  for (NSIndexPath *indexPath in [sortedArray reverseObjectEnumerator]) {
    [_content[indexPath.section] removeObjectAtIndex:indexPath.item];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
    willMoveItemAtIndexPath:(NSIndexPath *)indexPath
                toIndexPath:(NSIndexPath *)newIndexPath {
  if (indexPath.section == newIndexPath.section) {
    // Exchange data within same section.
    [_content[indexPath.section] exchangeObjectAtIndex:indexPath.item
                                     withObjectAtIndex:newIndexPath.item];
  } else {
    // Since moving to different section, first remove data from index path and insert
    // at new index path.
    id movedObject = [_content[indexPath.section] objectAtIndex:indexPath.item];
    [_content[indexPath.section] removeObjectAtIndex:indexPath.item];
    [_content[newIndexPath.section] insertObject:movedObject atIndex:newIndexPath.item];
  }
}

@end
