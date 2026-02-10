import FirebaseAuth
import Foundation

final class AuthService {

    static let shared = AuthService()
    private init() {}

    private let verificationIDKey = "firebase_verification_id"

    func sendOTP(to phoneNumber: String) async throws {
        print("Sending OTP to \(phoneNumber)")

        // Simulator testing
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true

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

                    print("verificationID saved")
                    continuation.resume()
                }
        }
    )}


    func verifyOTP(_ otp: String) async throws {

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
    }
}
