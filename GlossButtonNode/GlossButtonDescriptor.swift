//
// Copyright (c) 2020 Hiroshi Kimura(Muukii) <muuki.app@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation
import UIKit
import CoreGraphics

public struct GlossButtonDescriptor {
    
  public var image: UIImage?
  public var title: NSAttributedString?
  
  public var boundPadding: UIEdgeInsets = .zero
  // Body padding
  public var insets: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)

  public var truncateStyle: GlossButtonTruncateStyle
  public var bodyStyle: GlossButtonBodyStyle
  public var surfaceStyle: GlossButtonSurfaceStyle

  public var indicatorViewStyle: UIActivityIndicatorView.Style
  public var bodyOpacity: CGFloat
  
  public init(
    title: NSAttributedString? = nil,
    image: UIImage? = nil,
    truncateStyle: GlossButtonTruncateStyle = .init(),
    bodyStyle: GlossButtonBodyStyle,
    surfaceStyle: GlossButtonSurfaceStyle,
    bodyOpacity: CGFloat = 1,
    insets: UIEdgeInsets? = nil,
    indicatorViewStyle: UIActivityIndicatorView.Style = .white
  ) {
    
    self.title = title
    self.image = image
    self.bodyOpacity = bodyOpacity
    if let insets = insets {
      self.insets = insets
    }
    self.truncateStyle = truncateStyle
    self.surfaceStyle = surfaceStyle
    self.bodyStyle = bodyStyle
    self.indicatorViewStyle = indicatorViewStyle
  }
  
}

// MARK: - Modifying Method Chain
extension GlossButtonDescriptor {
  
  public func title(_ title: NSAttributedString?) -> GlossButtonDescriptor {
    var m = self
    m.title = title
    return m
  }
  
  public func image(_ image: UIImage?) -> GlossButtonDescriptor {
    var m = self
    m.image = image
    return m
  }
  
  public func insets(_ insets: UIEdgeInsets) -> GlossButtonDescriptor {
    var m = self
    m.insets = insets
    return m
  }
  
  public func boundPadding(_ boundPadding: UIEdgeInsets) -> GlossButtonDescriptor {
    var m = self
    m.boundPadding = boundPadding
    return m
  }
  
  public func bodyOpacity(_ opacity: CGFloat) -> GlossButtonDescriptor {
    var m = self
    m.bodyOpacity = bodyOpacity
    return m
  }
  
  public func surfaceStyle(_ sufaceStyle: GlossButtonSurfaceStyle) -> Self {
    var m = self
    m.surfaceStyle = sufaceStyle
    return m
  }
  
}

public enum GlossButtonColor {
  case fill(UIColor)
  case gradient(colorAndLocations: [(CGFloat, UIColor)], startPoint: CGPoint, endPoint: CGPoint)
}

public enum GlossButtonCornerRound {
  case circle
  case radius(CGFloat)
}

public enum FilledGlossButtonCornerRound {
  case circle
  case radius(topRight: CGFloat, topLeft: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat)
  
  public static func radius(all: CGFloat) -> Self {
    return .radius(topRight: all, topLeft: all, bottomRight: all, bottomLeft: all)
  }
  
  public static func radius(left: CGFloat, right: CGFloat) -> Self {
    return .radius(topRight: right, topLeft: left, bottomRight: right, bottomLeft: left)
  }
}

public struct GlossButtonTruncateStyle {
  public let truncateMode: NSLineBreakMode
  public let pointSizeScaleFactors: [CGFloat]?
  
  public init(
    truncateMode: NSLineBreakMode = .byWordWrapping,
    pointSizeScaleFactors: [CGFloat]? = nil
  ) {
    self.truncateMode = truncateMode
    self.pointSizeScaleFactors = pointSizeScaleFactors
  }
}

public enum GlossButtonSurfaceStyle {
  
  /// workaround
  public static var translucentHighlight: GlossButtonSurfaceStyle {
    return .stroke(.init(cornerRound: nil, strokeColor: .clear, borderWidth: 0))
  }
  
  @available(*, deprecated)
  public static var highlightOnly: GlossButtonSurfaceStyle {
    return .stroke(.init(cornerRound: nil, strokeColor: .clear, borderWidth: 0))
  }
  
  /// Fills specified Style
  case fill(GlossButtonFilledStyle)
  
  /// Strokes outline with specifide style
  case stroke(GlossButtonStrokedStyle)
  
  /// It should have better name.
  case highlight(GlossButtonHighlightSurfaceStyle)
  
  case blur(GlossButtonBlurryStyle)
 
}
