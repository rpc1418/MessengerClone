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
    @Published var readReceipts: Bool = true
    @Published var appUser: AppUser?

    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthListener()
        print("AuthViewModel: Initialized")
    }

    private func setupAuthListener() {
//        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            guard let self else { return }
//
//            print("Auth state changed:", user?.uid ?? "nil")
//            self.currentUser = user
//
//            // Reset state
//            self.userExists = nil
//
//            // If logged in -> check Firestore
//            if let phone = user?.phoneNumber {
//                Task {
//                    await self.checkPhoneExists(phone)
//                }
//            }
//        }
        
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            
            print("Auth state changed:", user?.uid ?? "nil")
            self.currentUser = user
            
            self.userExists = nil
            
            Task {
                // Phone or Email - Load user profile
                if let uid = user?.uid {
                    await self.loadUserProfile(uid: uid)
                }
            }
        }
    }
    
    private func loadUserProfile(uid: String) async {
        do {
            // Try phone lookup first for existing users
            if let phone = currentUser?.phoneNumber {
                userExists = try? await FirestoreService.shared.db
                    .collection("users")
                    .document(FirestoreService.shared.normalizePhone(phone))
                    .getDocument().exists
                appUser = try? await FirestoreService.shared.fetchUserData(phoneNumber: phone)
            }
            
            // Fallback: Uid lookup for email users
            if appUser == nil {
                let uidQuery = try await FirestoreService.shared.db
                    .collection("users")
                    .whereField("uid", isEqualTo: uid)
                    .limit(to: 1)
                    .getDocuments()
                
                if let doc = uidQuery.documents.first {
                    appUser = try? FirestoreService.shared.decodeUser(from: doc.data())
                    userExists = true
                }
            }
        } catch {
            print("Profile load failed:", error)
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
    
    func loginWithEmail(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            UserDefaults.standard.removeObject(forKey: "firebase_verification_id")
            UserDefaults.standard.synchronize()
            
            // Clear any auth state explicitly
            try? Auth.auth().signOut()
            Auth.auth().useAppLanguage()
            
            // Disable phone testing for email flow
            Auth.auth().settings?.isAppVerificationDisabledForTesting = false
            
            try? Auth.auth().signOut()
            try await AuthService.shared.signInWithEmail(email: email, password: password)
            
            // On success, Auth listener will automatically update my currentUser
            
        } catch let error as NSError {
            
            print("FULL ERROR DEBUG:")
                print("Domain: \(error.domain)")
                print("Code: \(error.code)")
                print("Description: \(error.localizedDescription)")
                print("UserInfo: \(error.userInfo)")
            
            switch AuthErrorCode(rawValue: error.code) {
                
            case .userNotFound:
                errorMessage = "No account found with this email."
                
            case .wrongPassword:
                errorMessage = "Incorrect password."
                
            case .invalidEmail:
                errorMessage = "Invalid email format."
                
            default:
                errorMessage = error.localizedDescription
                print("The other error is: ", error.localizedDescription)
            }
            
            print("Auth error:", errorMessage)
        }
    }
    

    func registerWithEmail(
        email: String,
        password: String,
        phoneNumber: String,
        firstName: String,
        lastName: String,
        about: String
    ) async {
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            // Create Firebase Auth user
            let result = try await AuthService.shared.signUpWithEmail(
                email: email,
                password: password
            )
            
            let uid = result.user.uid
            
            // Save to Firestore
            try await FirestoreService.shared.createUserIfNotExists(
                phoneNumber: phoneNumber,
                uid: uid,
                firstName: firstName,
                lastName: lastName,
                about: about,
                email: email
            )
            
            print("Email registration successful.")
            
        } catch let error as NSError {
            
            switch AuthErrorCode(rawValue: error.code) {
                
            case .invalidEmail:
                errorMessage = "Invalid email format."
                
            case .emailAlreadyInUse:
                errorMessage = "Email already registered."
                
            case .weakPassword:
                errorMessage = "Password too weak (min 6 characters)."
                
            default:
                errorMessage = error.localizedDescription
            }
            
            print("Registration error:", error.localizedDescription)
        }
    }
    
    func sendPasswordReset(email: String) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            try await AuthService.shared.sendPasswordReset(withEmail: email)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
