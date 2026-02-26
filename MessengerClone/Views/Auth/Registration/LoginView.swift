//
//  LoginView.swift
//  MessengerClone
//
//  Created by rentamac on 2/7/26.
//
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

    @State private var phoneNumber = ""
    @State private var countryCode = "+91"
    @State private var sheetForAuth = false
    @State private var animate = false

    var body: some View {
        ZStack {
            
            // MARK: Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue,
//                    Color.purple,
//                    Color.pink
                    Color.purple,
                    Color.indigo
                ]),
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)

            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 250)
                .blur(radius: 80)
                .offset(x: -120, y: -200)

            Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: 300)
                .blur(radius: 100)
                .offset(x: 150, y: 250)
            
            VStack(spacing: 32) {
                
                Spacer()
                
                // MARK: Header Section
                VStack(spacing: 18) {
                                        
                    Image(.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .scaleEffect(animate ? 1 : 0.7)
                        .opacity(animate ? 1 : 0)
                    
                    Text("Messenger")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 2)
                    
                    Text("Connect with your friends instantly")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                VStack(spacing: 22) {
                    
                    PrimaryButtons(
                        title: "Sign In with Email",
                        icon: "envelope.fill",
                        isLoading: authViewModel.isLoading
                    ) {
                        router.navigate(to: .emailEntryView)
                    }
                    
                    PrimaryButtons(
                        title: "Sign In with Phone",
                        icon: "phone.fill",
                        isLoading: authViewModel.isLoading
                    ) {
                        router.navigate(to: .phoneLogin)
                    }
                    
                    Button {
                        sheetForAuth.toggle()
                        print("SheetForAuth: \(sheetForAuth)")
                    } label: {
                        Text("Create New Account")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(18)
                            .shadow(color: .blue.opacity(0.25), radius: 8)
                    }
                }
                .padding(28)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .shadow(radius: 20)
                .padding(.horizontal)
                .offset(y: animate ? 0 : 50)
                .opacity(animate ? 1 : 0)
                
                Spacer()
                
                Text("Secure • Fast • Reliable")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 30)
            }
            .padding()
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animate = true
                }
            }
            .sheet(isPresented: $sheetForAuth) {
                SignUpOptionsSheet(sheetForAuth: $sheetForAuth)
                    .environmentObject(router)
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(30)
            }
        }
    }
}
