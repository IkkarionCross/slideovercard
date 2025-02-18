//
//  SlideOverCard.swift
//  Spends
//
//  Created by victor amaro on 12/02/25.
//

import SwiftUI

public struct SlideOverCard<Content: View>: View {
    
    @GestureState private var dragState = DragState.inactive
    @State private var position: CardScreenPosition = CardScreenPosition.top
    
    private var content: () -> Content
    
    public var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        return VStack {
            Handle()
            self.content()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
        .background(Color.white)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: self.position.offset(forTranslation: dragState.translation))
        .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: self.dragState.isDragging)
        .gesture(drag)
        
    }
    
    public init(position: CardScreenPosition, content: @escaping () -> Content) {
        self.position = position
        self.content = content
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTop = position.screenPosition() + drag.translation.height
        let positionAbove: CardScreenPosition
        let positionBelow: CardScreenPosition
        let closestPosition: CardScreenPosition
   
        if cardTop <= CardScreenPosition.middle.screenPosition() {
            positionAbove = .top
            positionBelow = .middle
        } else {
            positionAbove = .middle
            positionBelow = .bottom
        }
        
        if (cardTop - positionAbove.screenPosition()) < (positionBelow.screenPosition() - cardTop) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
        
    }
    
}

fileprivate enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self{
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

public enum CardScreenPosition: CGFloat {
    case top = 0.1
    case middle = 0.5
    case bottom = 0.8
    
    func offset(forTranslation translation: CGSize) -> CGFloat {
        return screenPosition() + translation.height
    }
    
    func screenPosition() -> CGFloat {
        return self.rawValue * UIScreen.main.bounds.height
    }
}
