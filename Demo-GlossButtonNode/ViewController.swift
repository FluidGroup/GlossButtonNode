//
//  ViewController.swift
//  Demo-GlossButtonNode
//
//  Created by muukii on 2020/04/24.
//  Copyright © 2020 TextureCommunity. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import TextureSwiftSupport
import TextureBridging
import GlossButtonNode
import TypedTextAttributes

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nodeView = NodeView(node: BodyNode())
    
    view.addSubview(nodeView)
    
    nodeView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      nodeView.topAnchor.constraint(equalTo: view.topAnchor),
      nodeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      nodeView.rightAnchor.constraint(equalTo: view.rightAnchor),
      nodeView.leftAnchor.constraint(equalTo: view.leftAnchor),
    ])
    
  }

}

extension ViewController {
  
  private enum Descriptors {
    
    static let icon = UIImage(named: "rectangle")!
    static let gray = UIColor(red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
    
    static let items: [GlossButtonDescriptor] = [
      GlossButtonDescriptor(
        title: "Confirm".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(.white)
        },
        image: icon,
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .fill(
          .init(
            cornerRound: .radius(all: 16),
            backgroundColor: .gradient(
              colorAndLocations: [
                (0, #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1)),
                (1, #colorLiteral(red: 0.9841937423, green: 0.3711297512, blue: 0.2100374103, alpha: 1)),
              ],
              startPoint: .init(x: 0, y: 0),
              endPoint: .init(x: 1, y: 1)
            ),
            dropShadow: .none
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      ),
      
      GlossButtonDescriptor(
        title: "Confirm".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(.white)
        },
        image: icon,
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .fill(
          .init(
            cornerRound: .circle,
            backgroundColor: .gradient(
              colorAndLocations: [
                (0, #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1)),
                (1, #colorLiteral(red: 0.9841937423, green: 0.3711297512, blue: 0.2100374103, alpha: 1)),
              ],
              startPoint: .init(x: 0, y: 0),
              endPoint: .init(x: 1, y: 1)
            ),
            dropShadow: .none
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      ),

      GlossButtonDescriptor(
        title: "Confirm".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(.white)
        },
        image: icon,
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .fill(
          .init(
            cornerRound: .radius(topRight: 20, topLeft: 20, bottomRight: 10, bottomLeft: 10),
            backgroundColor: .gradient(
              colorAndLocations: [
                (0, #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1)),
                (1, #colorLiteral(red: 0.9841937423, green: 0.3711297512, blue: 0.2100374103, alpha: 1)),
              ],
              startPoint: .init(x: 0, y: 0),
              endPoint: .init(x: 1, y: 1)
            ),
            dropShadow: .none
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      ),
      
      GlossButtonDescriptor(
        title: "Confirm".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(.white)
        },
        image: icon,
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .fill(
          .init(
            cornerRound: .circle,
            backgroundColor: .gradient(
              colorAndLocations: [
                (0, #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1)),
                (1, #colorLiteral(red: 0.9841937423, green: 0.3711297512, blue: 0.2100374103, alpha: 1)),
              ],
              startPoint: .init(x: 0, y: 0),
              endPoint: .init(x: 1, y: 1)
            ),
            dropShadow: .init(color: #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1), offset: .init(width: 0, height: 2), radius: 20, opacity: 0.8 , isModern: true)
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      ),
      
      GlossButtonDescriptor(
        title: "Confirm".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(#colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1))
        },
        bodyStyle: .init(layout: .horizontal()),
        surfaceStyle: .stroke(
          .init(
            cornerRound: .radius(16),
            borderColor: #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1),
            borderWidth: 2,
            highlightAnimation: .basic
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      ),
      
   
      
      GlossButtonDescriptor(
        title: "Confirm".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(#colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1))
        },
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .stroke(
          .init(
            cornerRound: .circle,
            borderColor: #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1),
            borderWidth: 2,
            highlightAnimation: .basic
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      ),
      
      GlossButtonDescriptor(
        title: "Confirm".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(#colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1))
        },
        bodyStyle: .init(layout: .horizontal()),
        surfaceStyle: .bodyOnly,
        bodyOpacity: 1,
        insets: .init(top: 8, left: 8, bottom: 8, right: 8)
      )
    ]
    
  }
  
  private final class BodyNode: ASDisplayNode {
    
    private let scrollNode: ASDisplayNode
          
    override init() {
      
      let buttons: [GlossButtonNode] = Descriptors.items.map {
        let node = GlossButtonNode()
        node.setDescriptor($0, for: .normal)
        return node
      }
      
      self.scrollNode = VerticalScrollWrapperNode {
        Self.makeList(buttonNodes: buttons.map { Self.makeCell(buttonNode: $0) } + CollectionOfOne(Self.makeToggleCell()))
      }
      
      super.init()
      
      automaticallyManagesSubnodes = true
                
    }
    
    override func didLoad() {
      super.didLoad()        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      
      LayoutSpec {
        scrollNode
      }
    }
    
    private static func makeList(buttonNodes: [ASDisplayNode]) -> FunctionalDisplayNode {

      return FunctionalDisplayNode { _, _ in
        LayoutSpec {
          VStackLayout {
            buttonNodes
          }
        }
      }
    }
    
    private static func makeCell(buttonNode: GlossButtonNode) -> FunctionalDisplayNode {
                  
      return FunctionalDisplayNode { _, _ in
        LayoutSpec {
          HStackLayout(justifyContent: .center) {
            VStackLayout(justifyContent: .center) {
              buttonNode
            }
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 20)
        }
      }
    }

    private static func makeToggleCell() -> FunctionalDisplayNode {

      let button = GlossButtonNode()

      let base = GlossButtonDescriptor(
        title: nil,
        image: nil,
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .fill(
          .init(
            cornerRound: .circle,
            backgroundColor: .gradient(
              colorAndLocations: [
                (0, #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1)),
                (1, #colorLiteral(red: 0.9841937423, green: 0.3711297512, blue: 0.2100374103, alpha: 1)),
              ],
              startPoint: .init(x: 0, y: 0),
              endPoint: .init(x: 1, y: 1)
            ),
            dropShadow: .none
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      )

      let on = GlossButtonDescriptor(
        title: "A".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(#colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1))
        },
        image: nil,
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .stroke(
          .init(
            cornerRound: .radius(16),
            strokeColor: #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1),
            borderWidth: 2,
            highlightAnimation: .basic
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      )

      let off = GlossButtonDescriptor(
        title: "BBB".styled {
          $0.font(.boldSystemFont(ofSize: 18))
            .foregroundColor(.white)
        },
        image: nil,
        bodyStyle: .init(layout: .horizontal(imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 2))),
        surfaceStyle: .fill(
          .init(
            cornerRound: .circle,
            backgroundColor: .gradient(
              colorAndLocations: [
                (0, #colorLiteral(red: 0.4375238121, green: 0.04877754301, blue: 0.4053111374, alpha: 1)),
                (1, #colorLiteral(red: 0.9841937423, green: 0.3711297512, blue: 0.2100374103, alpha: 1)),
              ],
              startPoint: .init(x: 0, y: 0),
              endPoint: .init(x: 1, y: 1)
            ),
            dropShadow: .none
          )
        ),
        bodyOpacity: 1,
        insets: .init(top: 16, left: 16, bottom: 16, right: 16)
      )

      button.setDescriptor(off, for: .normal)

      var flag = false

      button.onTap = { [weak button] in

        flag.toggle()
        if flag {
          button?.setDescriptor(on, for: .normal, animated: true)
        } else {
          button?.setDescriptor(off, for: .normal, animated: true)
        }

      }

      return makeCell(buttonNode: button)
    }
    
  }
  
}
