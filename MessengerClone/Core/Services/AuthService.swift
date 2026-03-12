import FirebaseAuth
import Foundation
import FirebaseFirestore

final class AuthService {

    static let shared = AuthService()
    private init() {}

    private let verificationIDKey = "firebase_verification_id"

    func sendOTP(to phoneNumber: String) async throws {

        #if targetEnvironment(simulator)
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        #endif
        
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Void, Error>) in
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in

                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let verificationID else {
                        continuation.resume(
                            throwing: NSError(
                                domain: "AuthService",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Missing verificationID"]
                            )
                        )
                        return
                    }

                    UserDefaults.standard.set(verificationID, forKey: self.verificationIDKey)

                    continuation.resume()
                }
        }
    )}


    func verifyOTP(_ otp: String) async throws {
        
        print("verifyOTP() called")

        guard let verificationID = UserDefaults.standard.string(forKey: verificationIDKey) else {
            throw NSError(
                domain: "AuthService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "OTP expired. Please resend."]
            )
        }

        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID, verificationCode: otp)

        try await Auth.auth().signIn(with: credential)

        print("OTP verified → user signed in")

        UserDefaults.standard.removeObject(forKey: verificationIDKey)
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
    }
    

    
    func signInWithEmail(email: String, password: String) async throws {
        let auth = Auth.auth()
        
        // Triple-clear phone state
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        try? auth.signOut()
        
        // EXPLICIT EmailAuthProvider credential - bypasses corruption
        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        let result = try await auth.signIn(with: emailCredential)
    }
    

    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResult {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func sendPasswordReset(withEmail email: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                   
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    func checkIfEmailExists(email: String) async throws -> Bool {
        

        let snapshot = try await Firestore.firestore()
            .collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments()

        return !snapshot.documents.isEmpty

    }    
}
