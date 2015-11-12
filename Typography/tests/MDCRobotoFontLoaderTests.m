/*
 Copyright 2015-present Google Inc. All Rights Reserved.

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

#import <XCTest/XCTest.h>

#import "MDCFontResource.h"
#import "MDCRobotoFontLoader.h"
#import "Private/MDCTypography+Constants.h"

static const CGFloat kEpsilonAccuracy = 0.001f;

@interface MDCRobotoFontLoaderTests : XCTestCase
@end

@interface MDCRobotoFontLoader (Testing)
@property(nonatomic, strong) MDCFontResource *lightFontResource;
@property(nonatomic, strong) MDCFontResource *regularFontResource;
@property(nonatomic, strong) MDCFontResource *mediumFontResource;
@property(nonatomic, strong) MDCFontResource *boldFontResource;

@property(nonatomic, strong) MDCFontResource *lightItalicFontResource;
@property(nonatomic, strong) MDCFontResource *italicFontResource;
@property(nonatomic, strong) MDCFontResource *mediumItalicFontResource;
@property(nonatomic, strong) MDCFontResource *boldItalicFontResource;

@property(nonatomic, strong, null_resettable) NSBundle *baseBundle;

- (instancetype)initInternal;

@end

@implementation MDCRobotoFontLoaderTests

- (void)testRobotoRegularWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader regularFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCRegularFontName);
}

- (void)testRobotoMediumWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader mediumFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCMediumFontName);
}

- (void)testRobotoLightWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader lightFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCLightFontName);
}

- (void)testRobotoBoldWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader boldFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCBoldFontName);
}

- (void)testRobotoItalicWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader italicFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCRegularItalicFontName);
}

- (void)testRobotoMediumItalicWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader mediumItalicFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCMediumItalicFontName);
}

- (void)testRobotoLightItalicWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader lightItalicFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCLightItalicFontName);
}

- (void)testRobotoBoldItalicWithSize {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [MDCRobotoFontLoader sharedInstance];

  // When
  UIFont *font = [fontLoader boldItalicFontOfSize:size];

  // Then
  XCTAssertEqualWithAccuracy(font.pointSize, size, kEpsilonAccuracy);
  XCTAssertEqualObjects(font.fontName, MDCBoldItalicFontName);
}

- (void)testLightFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.lightFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader lightFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont systemFontOfSize:size]);
}

- (void)testFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.regularFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader regularFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont systemFontOfSize:size]);
}

- (void)testMediumFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.mediumFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader mediumFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont boldSystemFontOfSize:size]);
}

- (void)testBoldFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.boldFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader boldFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont boldSystemFontOfSize:size]);
}

- (void)testLightItalicFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.lightItalicFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader lightItalicFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont italicSystemFontOfSize:size]);
}

- (void)testItalicFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.italicFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader italicFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont italicSystemFontOfSize:size]);
}

- (void)testMediumItalicFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.mediumItalicFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader mediumItalicFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont italicSystemFontOfSize:size]);
}

- (void)testBoldItalicFallbackSystemFonts {
  // Given
  CGFloat size = arc4random_uniform(1000) / (arc4random_uniform(10) + 1);
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  fontLoader.boldItalicFontResource.fontName = @"something that doesn't exist";

  // When
  UIFont *font = [fontLoader boldItalicFontOfSize:size];

  // Then
  XCTAssertEqualObjects(font, [UIFont italicSystemFontOfSize:size]);
}

- (void)testSettingBaseBundleResetsResources {
  // Given
  NSBundle *testBundle = [NSBundle bundleForClass:[UIFont class]];
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];
  NSArray *existingFontResources = @[
    fontLoader.regularFontResource,
    fontLoader.lightFontResource,
    fontLoader.mediumFontResource,
    fontLoader.boldFontResource,
    fontLoader.italicFontResource,
    fontLoader.lightItalicFontResource,
    fontLoader.mediumItalicFontResource,
    fontLoader.boldItalicFontResource
  ];

  // When
  fontLoader.baseBundle = testBundle;
  NSArray *newFontResources = @[
    fontLoader.regularFontResource,
    fontLoader.lightFontResource,
    fontLoader.mediumFontResource,
    fontLoader.boldFontResource,
    fontLoader.italicFontResource,
    fontLoader.lightItalicFontResource,
    fontLoader.mediumItalicFontResource,
    fontLoader.boldItalicFontResource
  ];

  // Then
  for (NSUInteger index = 0; index < existingFontResources.count; ++index) {
    MDCFontResource *exisitngFontResource = existingFontResources[index];
    MDCFontResource *newFontResource = newFontResources[index];
    XCTAssertNotEqualObjects(exisitngFontResource, newFontResource);
    XCTAssertTrue([newFontResource.fontURL.path containsString:[testBundle bundlePath]]);
  }
}

- (void)testResetingBaseBundle {
  // Given
  MDCRobotoFontLoader *fontLoader = [[MDCRobotoFontLoader alloc] initInternal];

  // When
  fontLoader.baseBundle = nil;

  // Then
  XCTAssertNotNil(fontLoader.baseBundle);
}

@end
