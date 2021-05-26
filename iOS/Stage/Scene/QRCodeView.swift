//
//  QRCodeView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/27.
//

import SwiftUI

struct QRCodeView: View {
    @State private var presentPhotoLibrary = false
    @State private var selectedImage: UIImage = UIImage()
    var body: some View {
        VStack {
            Image(uiImage: selectedImage)
                .resizable().scaledToFit()
        }.sheet(isPresented: $presentPhotoLibrary) {
            SwiftUIPhotoPicker(
                sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
        Button {
            presentPhotoLibrary = true
        } label: {
            Text("選取QRCode圖片").foregroundColor(flameScarlet(1.0))
        }
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView()
    }
}
