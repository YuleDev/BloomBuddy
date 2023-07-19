import Foundation
import SwiftUI

struct VineBorder: View {
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
                    .padding(.leading)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
                    .padding(.trailing)
            }
        }
    }
}
