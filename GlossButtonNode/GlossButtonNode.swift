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

import AsyncDisplayKit
import TextureSwiftSupport

/// Button component ASDisplayNode based
///
/// - TODO:
///   - Improve shape of structure that describing style.
public final class GlossButtonNode : ASControlNode {
    
  public struct ControlState: OptionSet {
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
    
    public var rawValue: Int
    
    public typealias RawValue = Int
    
    public static let normal = ControlState(rawValue: 1 << 0)
    public static let disabled = ControlState(rawValue: 1 << 1)
    public static let selected = ControlState(rawValue: 1 << 2)
  }
    
  // MARK: - Properties
  
  public var onTap: () -> Void = { }
  
  public override var supportsLayerBacking: Bool {
    return false
  }
  
  private let bodyNode = _GlossButtonBodyNode()

  private let lock = NSRecursiveLock()
  
  public var isProcessing: Bool {
    get {
      return _isProcessing
    }
    set {
      
      ASPerformBlockOnMainThread {
        
        self.prepareLoadingIndicatorIfNeeded()
      
        self._isProcessing = newValue
        
        self.indicator.style = self.currentDescriptor?.indicatorViewStyle ?? .white
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
          
          if newValue {
            
            self.bodyNode.alpha = 0
            self.bodyNode.transform = CATransform3DMakeScale(0.9, 0.9, 1)
            self.indicator.startAnimating()
            
            self.indicatorNode.transform = CATransform3DMakeScale(0.8, 0.8, 1)
            self.indicatorNode.transform = CATransform3DIdentity
            self.indicatorNode.alpha = 1
            
          } else {
            
            self.bodyNode.alpha = 1
            self.bodyNode.transform = CATransform3DIdentity
            self.indicator.stopAnimating()
            
            self.indicatorNode.transform = CATransform3DMakeScale(0.8, 0.8, 1)
            self.indicatorNode.alpha = 0
          }
        }, completion: { _ in
        })
      }
      
    }
  }
  
  private var _isProcessing: Bool = false
  
  public override var isSelected: Bool {
    didSet {
      if oldValue != isSelected {
        _synchronized_updateThatFitsState()
      }
    }
  }
  
  public override var isEnabled: Bool {
    didSet {
      if oldValue != isEnabled {
        isUserInteractionEnabled = isEnabled
        _synchronized_updateThatFitsState()
      }
    }
  }
  
  public override var isHighlighted: Bool {
    didSet {
      guard oldValue != isHighlighted else { return }
      bodyNode.isHighlighted = isHighlighted
      filledSurfaceNode?.isHighlighted = isHighlighted
      strokedSurfaceNode?.isHighlighted = isHighlighted
      highlightSurfaceNode?.isHighlighted = isHighlighted
    }
  }
  
  private lazy var indicatorNode: ASDisplayNode = ASDisplayNode { () -> UIView in
    return UIActivityIndicatorView(style: .white)
  }
  
  private var indicator: UIActivityIndicatorView {
    return indicatorNode.view as! UIActivityIndicatorView
  }
    
  private var descriptorStorage: [ControlState.RawValue : GlossButtonDescriptor] = [:]
  private var currentDescriptor: GlossButtonDescriptor?
  
  private var filledSurfaceNode: _GlossButtonFilledSurfaceNode?
  private var strokedSurfaceNode: _GlossButtonStrokedSurfaceNode?
  private var highlightSurfaceNode: _GlossButtonHighlightSurfaceNode?
  private var blurrySurfaceNode: _GlossButtonBlurrySurfaceNode?
  
  private var needsLayoutLoadingIndicator: Bool = false

  private var hapticsDescriptor: HapticsDescriptor? = nil
  
  // MARK: - Initializers
  
  public override init() {
    super.init()
    
    automaticallyManagesSubnodes = true

    addTarget(self, action: #selector(_onTouchUpInside), forControlEvents: .touchUpInside)
    addTarget(self, action: #selector(_onTouchDown), forControlEvents: .touchDown)
  }
  
  @available(*, unavailable)
  public init(layerBlock: @escaping ASDisplayNodeLayerBlock, didLoad: ASDisplayNodeLayerBlock? = nil) {
    fatalError()
  }
  
  @available(*, unavailable)
  public init(viewBlock: @escaping ASDisplayNodeViewBlock, didLoad: ASDisplayNodeLayerBlock? = nil) {
    fatalError()
  }
      
  // MARK: - Functions
  
  public func setDescriptor(
    _ descriptor: GlossButtonDescriptor,
    for state: ControlState,
    animated: Bool = false
  ) {

    descriptorStorage[state.rawValue] = descriptor
    if animated {

      let animator = UIViewPropertyAnimator.init(duration: 0.6, dampingRatio: 1) {
        self._synchronized_updateThatFitsState()
      }

      animator.startAnimation()
    } else {
      _synchronized_updateThatFitsState()
    }

  }

  public func setHaptics(
    _ hapticsDescriptor: HapticsDescriptor?
  ) {
    self.hapticsDescriptor = hapticsDescriptor
  }

  public override func didLoad() {
    super.didLoad()
    
    indicatorNode.backgroundColor = .clear
    indicatorNode.alpha = 0
    accessibilityIdentifier = "org.TextureCommunity.GlossButtonNode"
    accessibilityTraits = [.button]

  }

  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    guard let targetDescriptor = currentDescriptor else {
      return ASWrapperLayoutSpec(layoutElements: [])
    }
    
    var indicator: ASDisplayNode?
    if needsLayoutLoadingIndicator {
      indicator = indicatorNode
    }
            
    return ASInsetLayoutSpec(
      insets: targetDescriptor.boundPadding,
      child: ASBackgroundLayoutSpec(
        child: ASWrapperLayoutSpec(layoutElements: [
          ASInsetLayoutSpec(insets: targetDescriptor.insets, child: bodyNode),
          ].compactMap { $0 } as [ASLayoutElement]
        ),
        background: ASWrapperLayoutSpec(layoutElements: [
          filledSurfaceNode,
          strokedSurfaceNode,
          highlightSurfaceNode,
          blurrySurfaceNode,
          indicator.flatMap {
            ASCenterLayoutSpec(horizontalPosition: .center, verticalPosition: .center, sizingOption: .minimumSize, child: $0)
          },
          ].compactMap { $0 } as [ASLayoutElement]
        )
      )
    )
         
  }
  
  private func _synchronized_updateThatFitsState() {

    lock.lock()
    defer {
      lock.unlock()
    }

    let findDescriptor: (ControlState) -> GlossButtonDescriptor? = { state in
      self.descriptorStorage.first {
        ControlState(rawValue: $0.key) == state
        }?.value
    }
    
    let normalDescriptor = findDescriptor([.normal])
    
    let targetDescriptor: GlossButtonDescriptor? = {
      switch (isSelected, isEnabled) {
      case (true, true):
        return findDescriptor([.selected]) ?? normalDescriptor
      case (true, false):
        return findDescriptor([.selected, .disabled]) ?? findDescriptor([.disabled]) ?? normalDescriptor
      case (false, false):
        return findDescriptor([.disabled]) ?? {
          var d = normalDescriptor
          d?.bodyOpacity = 0.7
          return d
          }()
      case (false, true):
        return normalDescriptor
      }
    }()
    
    guard let d = targetDescriptor else {
      return
    }
    
    currentDescriptor = d
    
    switch d.surfaceStyle {
    case .fill(let style):
      
      let node = self.filledSurfaceNode ?? .init()
      node.setStyle(style)
      
      self.filledSurfaceNode = node
      self.strokedSurfaceNode = nil
      self.highlightSurfaceNode = nil
      self.blurrySurfaceNode = nil
      
    case .stroke(let style):
      
      let node = self.strokedSurfaceNode ?? .init()
      node.setStyle(style)
      
      self.filledSurfaceNode = nil
      self.strokedSurfaceNode = node
      self.highlightSurfaceNode = nil
      self.blurrySurfaceNode = nil
      
    case .highlight(let style):
      
      let node = self.highlightSurfaceNode ?? .init()
      node.setStyle(style)
      
      self.filledSurfaceNode = nil
      self.strokedSurfaceNode = nil
      self.highlightSurfaceNode = node
      self.blurrySurfaceNode = nil
      
    case .blur(let style):
      
      let node = self.blurrySurfaceNode ?? .init()
      node.setStyle(style)
      
      self.filledSurfaceNode = nil
      self.strokedSurfaceNode = nil
      self.highlightSurfaceNode = nil
      self.blurrySurfaceNode = node
      
    }
    
    bodyNode.setImage(d.image)
    bodyNode.setTitle(d.title)
    bodyNode.setTruncateStyle(d.truncateStyle)
    bodyNode.setBodyStyle(d.bodyStyle)
    
    alpha = d.bodyOpacity
    
    setNeedsLayout()
    setNeedsDisplay()

    let rootNode = supernode ?? self
    rootNode.layoutIfNeeded()

  }
  
  private func prepareLoadingIndicatorIfNeeded() {
    guard needsLayoutLoadingIndicator == false else { return }
    
    needsLayoutLoadingIndicator = true
    setNeedsLayout()
    layoutIfNeeded()
  }

  @objc private func _onTouchDown() {
    guard isProcessing == false else { return }
    hapticsDescriptor?.send(event: .onTouchDownInside)
  }

  @objc private func _onTouchUpInside() {
    guard isProcessing == false else { return }
    hapticsDescriptor?.send(event: .onTouchUpInside)
    onTap()
  }

}


protocol _GlossButtonSurfaceNodeType: ASDisplayNode {
      
  var isHighlighted: Bool { get set }
}
