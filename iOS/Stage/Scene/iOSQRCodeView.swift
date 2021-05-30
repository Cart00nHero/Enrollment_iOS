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
    @State private var qrMessage = localized("wait_for_qrcode")
    @State private var copyText: String = "Copy"
    var body: some View {
        VStack {
            Image(uiImage: selectedImage)
                .resizable().scaledToFit()
            Divider()
            chooseView()
        }.navigationBarHidden(true)
        .onAppear() {
            scenario.beSubscribeRedux { newState in
            }
            if SingletonStorage.shared.currentRole == "Visitor" {
                scenario.beSubscribeQRCode { image in
                    selectedImage = image
                    qrMessage = "\(localized("scanning"))..."
                    scenario.beScanQrCode(image: selectedImage) { qrMsgs in
                        qrMessage =
                            qrMsgs.first ?? localized("\(localized("empty_qrcode_message"))!!!")
                    }
                }
            }
        }
        .sheet(isPresented: $presentPhotoLibrary) {
            SwiftUIPhotoPicker(
                sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
        .onDisappear() {
            scenario.beUnSubscribe()
        }
    }
    private func chooseView() -> AnyView {
        let role = SingletonStorage.shared.currentRole
        if role == "Visitor" {
            return AnyView(
                HStack {
                    Spacer().frame(width: autoUISize(10.0))
                    Text(qrMessage).foregroundColor(golden(1.0))
                    Spacer()
                    Button {
                        if qrMessage != localized("wait_for_qrcode") {
                            UIPasteboard.general.string = qrMessage
                            copyText = "Copied"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                // Code you want to be delayed
                                copyText = "Copy"
                            }
                        }
                    } label: {
                        Text(copyText)
                            .foregroundColor(flameScarlet(1.0))
                            .font(.system(size: autoFont(value: 16.0)))
                    }
                    Spacer().frame(width: autoUISize(10.0))
                }
            )
        }
        return AnyView(
            Button {
                presentPhotoLibrary = true
            } label: {
                Text(localized("select_qrcode_image"))
                    .foregroundColor(flameScarlet(1.0))
            }
        )
        
    }
}

struct iOSQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        iOSQRCodeView()
    }
}
