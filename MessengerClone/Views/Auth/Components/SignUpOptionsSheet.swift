//
//  SignUpOptionsSheet.swift
//  MessengerClone
//
//  Created by rentamac on 2/26/26.
//

import SwiftUI

struct SignUpOptionsSheet: View {
    
    @EnvironmentObject var router: AppRouter
    @Binding var sheetForAuth: Bool
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color.blue.opacity(0.05)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray.opacity(0.3))
                    .padding(.top, 8)
                
                Text("Choose Sign Up Method")
                    .font(.headline)
                    .fontWeight(.bold)
                
                // MARK: Phone Option
                Button {
                    sheetForAuth = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        router.navigate(to: .registration)
                    }
                } label: {
                    HStack {
                        Image(systemName: "phone.fill")
                            .font(.title3)
                        Text("Sign Up with Phone")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(radius: 5)
                }
                
                // MARK: Email Option
                Button {
                    sheetForAuth = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        router.navigate(to: .emailRegistrationView)
                    }
                } label: {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .font(.title3)
                        Text("Sign Up with Email")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.pink, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(radius: 5)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animate = true
            }
        }
    }
}
