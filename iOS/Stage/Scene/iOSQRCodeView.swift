//
//  iOSQRCodeView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/27.
//

import SwiftUI

fileprivate let scenario: QRCodeScenario = QRCodeScenario()
struct iOSQRCodeView: View {
    @State private var presentPhotoLibrary = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var toggleTitle = ""
    @State private var isVisitor = true
    var body: some View {
        VStack {
            Image(uiImage: selectedImage)
                .resizable().scaledToFit()
            Divider()
            Button {
                presentPhotoLibrary = true
            } label: {
                Text("選取QRCode圖片")
                    .foregroundColor(flameScarlet(1.0))
            }
        }.navigationBarHidden(true)
        .onAppear() {
        }
        .sheet(isPresented: $presentPhotoLibrary) {
            SwiftUIPhotoPicker(
                sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
    }
}

struct iOSQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        iOSQRCodeView()
    }
}
