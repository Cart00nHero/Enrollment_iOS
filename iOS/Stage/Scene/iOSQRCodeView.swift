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
    @State private var toggleSwitchOn = false
    var body: some View {
        VStack {
            Toggle(isOn: $toggleSwitchOn) {
                Text("")
            }.onChange(of: toggleSwitchOn) { isOn in
                if isOn {
                    print("送")
                } else {
                    print("停")
                }
            }
            Image(uiImage: selectedImage)
                .resizable().scaledToFit()
            Divider()
            Button {
                presentPhotoLibrary = true
            } label: {
                Text("選取QRCode圖片")
                    .foregroundColor(flameScarlet(1.0))
            }
        }.onAppear() {
            scenario.beCollectParcel()
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
