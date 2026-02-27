//
//  FirestoreService.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.
//


import FirebaseFirestore
import FirebaseAuth

final class FirestoreService {
    static let shared = FirestoreService()
    private init() {}
    
    let db = Firestore.firestore()
    
    func normalizePhone(_ phone: String) -> String {
        let normalized = phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        return normalized
    }
    
    func saveUserProfile(
        firstName: String,
        lastName: String?,
        about: String?,
        phoneNumber: String,
        isNewUser: Bool = false
    ) async throws {
        let normalizedPhone = normalizePhone(phoneNumber)
        let userRef = db.collection("users").document(normalizedPhone)
        
        print("Firestore: Phone document \(normalizedPhone)")
        
        let snapshot = try await userRef.getDocument()
        
        if snapshot.exists && !isNewUser {
            print("Existing user - No update needed...")
//            try await userRef.updateData([
//                "lastLogin": Timestamp(),
//                "phoneNumber": normalizedPhone
//            ])
        } else {
            print("New user registration")
            let uid = Auth.auth().currentUser?.uid
            
            let userData: [String: Any] = [
                "uid": uid,
                "phoneNumber": normalizedPhone,
                "firstName": firstName,
                "lastName": lastName ?? "",
                "about": about ?? "",
                "createdAt": Timestamp(),
                "profileURL": nil as String?
            ]
            try await userRef.setData(userData, merge: true)
            print("Profile created: users/\(normalizedPhone)")
        }
    }

    func fetchUserData(phoneNumber: String) async throws -> AppUser {
        let normalizedPhone = normalizePhone(phoneNumber)
        let userRef = db.collection("users").document(normalizedPhone)

        let snapshot = try await userRef.getDocument()

        guard snapshot.exists else {
            throw NSError(
                domain: "FirestoreError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "User not found"]
            )
        }

        guard let data = snapshot.data() else {
            throw NSError(
                domain: "FirestoreError",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "No user data found"]
            )
        }

        let user = self.decodeUser(from: data)

        return user!
    }
    
    // MARK: - Save user via email registration
    func createUserIfNotExists(
        phoneNumber: String,
        uid: String,
        firstName: String,
        lastName: String,
        about: String,
        email: String? = nil) async throws {

            let normalizedPhone = normalizePhone(phoneNumber)

            let docRef = db.collection("users").document(normalizedPhone)

            let snapshot = try await docRef.getDocument()

            if snapshot.exists {
                print("User already exists.")
                return
            }

            var data: [String: Any] = [
                "uid": uid,
                "firstName": firstName,
                "lastName": lastName,
                "about": about,
                "phoneNumber": normalizedPhone,
                "profileURL": NSNull(),
                "createdAt": Timestamp()
            ]

            if let email = email {
                data["email"] = email
            }

            try await docRef.setData(data)

            print("New user created with phoneNumber as document ID.")
    }
    
    
    func decodeUser(from data: [String: Any]?) -> AppUser? {
        guard let data = data else { return nil }
        
        return AppUser(
            id: "",
            uid: data["uid"] as? String ?? "",
            firstName: data["firstName"] as? String ?? "",
            lastName: data["lastName"] as? String ?? "",
            phoneNumber: data["phoneNumber"] as? String ?? "",
            about: data["about"] as? String ?? "",
            profileURL: data["profileURL"] as? String,
            createdAt: data["createdAt"] as? Timestamp ?? Timestamp(),
            email: data["email"] as? String
        )
    }
}
