/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNSVGPath.h"

#ifdef RN_FABRIC_ENABLED
#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "RNSVGFabricConversions.h"
#endif // RN_FABRIC_ENABLED

@implementation RNSVGPath {
  CGPathRef _path;
}

#ifdef RN_FABRIC_ENABLED
using namespace facebook::react;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNSVGPathProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RNSVGPathComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = *std::static_pointer_cast<const RNSVGPathProps>(props);
  self.d = [[RNSVGPathParser alloc] initWithPathString:RCTNSStringFromString(newProps.d)];

  setCommonRenderableProps(newProps, self);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  if (_path) {
    CGPathRelease(_path);
  }
  _path = nil;
  _d = nil;
}
#endif // RN_FABRIC_ENABLED

- (void)setD:(RNSVGPathParser *)d
{
  if (d == _d) {
    return;
  }

  [self invalidate];
  _d = d;
  CGPathRelease(_path);
  _path = CGPathRetain([d getPath]);
}

- (CGPathRef)getPath:(CGContextRef)context
{
  return _path;
}

- (void)dealloc
{
  CGPathRelease(_path);
}

@end

#ifdef RN_FABRIC_ENABLED
Class<RCTComponentViewProtocol> RNSVGPathCls(void)
{
  return RNSVGPath.class;
}
#endif // RN_FABRIC_ENABLED
