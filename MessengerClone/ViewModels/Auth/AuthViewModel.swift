import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var otpNavigationTrigger: UUID?

    @Published var currentUser: User?
    @Published var userExists: Bool? = nil   // nil = checking Firestore
    
    @Published var appUser: AppUser?

    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthListener()
        print("AuthViewModel: Initialized")
    }

    private func setupAuthListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }

            print("Auth state changed:", user?.uid ?? "nil")
            self.currentUser = user

            // Reset state
            self.userExists = nil

            // If logged in -> check Firestore
            if let phone = user?.phoneNumber {
                Task {
                    await self.checkPhoneExists(phone)
                }
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        currentUser = nil
        userExists = nil
        print("Signed out")
    }

    deinit {
        if let handle = authListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func sendOTP(phoneNumber: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await AuthService.shared.sendOTP(to: phoneNumber)
            otpNavigationTrigger = UUID()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func verifyOTP(_ otp: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await AuthService.shared.verifyOTP(otp)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func checkPhoneExists(_ phoneNumber: String) async {
        let normalizedPhone = FirestoreService.shared.normalizePhone(phoneNumber)

        do {
            let doc = try await FirestoreService.shared.db
                .collection("users")
                .document(normalizedPhone)
                .getDocument()

            userExists = doc.exists
            appUser = try await FirestoreService.shared.fetchUserData(phoneNumber: phoneNumber)
            print("Firestore userExists =", doc.exists)
        } catch {
            print("Firestore check failed:", error)
            userExists = false
        }
    }
    
    
}
