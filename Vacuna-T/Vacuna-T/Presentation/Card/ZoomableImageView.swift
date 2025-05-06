//
//  ZoomableImageView.swift
//  Vacuna-T
//
//  Created by Aldo Hernandez on 05/05/25.
//

import SwiftUI

struct ZoomableImageView: View {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    @State private var gestureScale: CGFloat = 1.0
    @State private var gestureOffset: CGSize = .zero
    
    var imageName: String

    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 5.0
    private let doubleTapZoomScale: CGFloat = 3.0

    var body: some View {
        GeometryReader { geometry in
            let viewSize = geometry.size

            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale * gestureScale)
                .offset(x: offset.width + gestureOffset.width,
                        y: offset.height + gestureOffset.height)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                gestureScale = value
                            }
                            .onEnded { _ in
                                var newScale = scale * gestureScale
                                newScale = min(max(newScale, minScale), maxScale)

                                withAnimation(.spring()) {
                                    scale = newScale
                                    gestureScale = 1.0
                                    offset = clampOffset(offset, scale: scale, viewSize: viewSize)
                                    gestureOffset = .zero
                                }
                            },
                        DragGesture()
                            .onChanged { value in
                                gestureOffset = value.translation
                            }
                            .onEnded { _ in
                                let newOffset = CGSize(
                                    width: offset.width + gestureOffset.width,
                                    height: offset.height + gestureOffset.height
                                )
                                withAnimation(.spring()) {
                                    offset = clampOffset(newOffset, scale: scale, viewSize: viewSize)
                                    gestureOffset = .zero
                                }
                            }
                    )
                )
                .contentShape(Rectangle()) // Makes entire area tappable
                .onTapGesture(count: 2) { location in
                    withAnimation(.spring()) {
                        if scale > minScale {
                            // Reset
                            scale = minScale
                            offset = .zero
                        } else {
                            // Zoom in toward tap location
                            let tapPoint = CGPoint(x: location.x - viewSize.width / 2,
                                                   y: location.y - viewSize.height / 2)

                            let zoomFactor = doubleTapZoomScale / scale
                            let newOffset = CGSize(
                                width: offset.width - tapPoint.x * (zoomFactor - 1),
                                height: offset.height - tapPoint.y * (zoomFactor - 1)
                            )

                            scale = doubleTapZoomScale
                            offset = clampOffset(newOffset, scale: scale, viewSize: viewSize)
                        }

                        gestureScale = 1.0
                        gestureOffset = .zero
                    }
                }
        }
    }

    func clampOffset(_ offset: CGSize, scale: CGFloat, viewSize: CGSize) -> CGSize {
        let imageSize = CGSize(width: viewSize.width * scale, height: viewSize.height * scale)
        let maxX = max((imageSize.width - viewSize.width) / 2, 0)
        let maxY = max((imageSize.height - viewSize.height) / 2, 0)

        let clampedX = min(max(offset.width, -maxX), maxX)
        let clampedY = min(max(offset.height, -maxY), maxY)

        return CGSize(width: clampedX, height: clampedY)
    }
}

#Preview {
    ZoomableImageView(imageName: "cartilla-de-vacunacion-ninos")
}
