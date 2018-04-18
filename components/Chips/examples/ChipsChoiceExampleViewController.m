/*
 Copyright 2017-present the Material Components for iOS authors. All Rights Reserved.

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

#import "ChipsExamplesSupplemental.h"

#import "MaterialChips.h"
#import "MDCChipViewColorThemer.h"

@implementation ChipsChoiceExampleViewController {
  MDCSemanticColorScheme *_colorScheme;
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor whiteColor];

  _colorScheme = [[MDCSemanticColorScheme alloc] init];

  CGSize estimatedItemSize = CGSizeMake(60, 33);
  CGRect collectionStartingRect = CGRectMake(0, 0, 100, estimatedItemSize.height);

  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  layout.minimumInteritemSpacing = 10.0f;
  layout.estimatedItemSize = estimatedItemSize;

  _collectionView = [[UICollectionView alloc] initWithFrame:collectionStartingRect
                                       collectionViewLayout:layout];
  _collectionView.dataSource = self;
  _collectionView.delegate = self;
  _collectionView.backgroundColor = [UIColor whiteColor];
  _collectionView.delaysContentTouches = NO;
  _collectionView.clipsToBounds = NO;
  [_collectionView registerClass:[MDCChipCollectionViewCell class]
          forCellWithReuseIdentifier:@"Cell"];

  [self.view addSubview:_collectionView];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  // increased the height so bottom slider doesn't overlap with chips
  _collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MDCChipCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.chipView.titleLabel.text = self.titles[indexPath.row];
  // Every other chip is stroked
  if (indexPath.row % 2) {
    [cell.chipView setBorderWidth:0 forState:UIControlStateNormal];
    [MDCChipViewColorThemer applySemanticColorScheme:_colorScheme toChipView:cell.chipView];
  } else {
    [cell.chipView setBorderWidth:1 forState:UIControlStateNormal];
    [MDCChipViewColorThemer applySemanticColorScheme:_colorScheme
                                   toStrokedChipView:cell.chipView];
  }
  return cell;
}

- (NSArray *)titles {
  if (!_titles) {
    _titles = @[
      @"The Bronx",
      @"Brooklyn",
      @"Manhattan",
      @"Queens",
      @"Staten Island",
    ];
  }
  return _titles;
}

@end
