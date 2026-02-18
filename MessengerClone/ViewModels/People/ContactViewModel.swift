//
//  NewContactViewModel.swift
//  MessengerClone
//
//  Created by rentamac on 05/02/2026.
//

import Contacts
import Combine
import FirebaseFirestore
import CoreData

class ContactsViewModel: ObservableObject {
    @Published var contacts: [RegisteredContact] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedContactIDs: Set<NSManagedObjectID> = []
    @Published var isSelectionMode: Bool = false
    @Published var msgFromViewModel: String = ""
    let chatService: ChatService = ChatService()
    
//    private var newContact: RegisteredContact? = nil

    private let store = CNContactStore()
    
    private let persistence = PersistenceController.shared

        init() {
            Task {
                await requestAndSyncContacts()
            }
        }

        
        func requestAndSyncContacts() async {
            isLoading = true

            let status = CNContactStore.authorizationStatus(for: .contacts)

            switch status {
            case .authorized:
                await syncContacts()

            default:
                let granted = try? await store.requestAccess(for: .contacts)
                if granted == true {
                    await syncContacts()
                } else {
                    await MainActor.run {
                        self.msgFromViewModel = "Please allow access to contacts in settings."
                        self.isLoading = false
                    }
                }
            }
            isLoading = false
        }

        
        private func syncContacts() async {
            do {
                let deviceNumbers = try fetchDistinctPhoneNumbers()
                let normalizedNumbers = deviceNumbers.map { normalizePhone($0) }

                let existingContacts = persistence.fetchContactsDetails()
                let existingNumbersSet = Set(existingContacts.compactMap { $0.idPhNo })

                for number in normalizedNumbers where !existingNumbersSet.contains(number) {
                    do {
                        let user = try await FirestoreService.shared.fetchUserData(phoneNumber: number)
                        PersistenceController.shared.createRegCon(appUser: user, isReg: true)
                    } catch {
                        let dummyUser = AppUser(
                            id: "",
                            uid: "",
                            firstName: number,
                            lastName: "",
                            phoneNumber: number,
                            about: "",
                            profileURL: "",
                            createdAt: Timestamp()
                        )
                        PersistenceController.shared.createRegCon(appUser: dummyUser, isReg: false)
                    }
                }

                
                let updatedContacts = persistence.fetchContactsDetails()

                await MainActor.run {
                    self.contacts = updatedContacts
                    self.isLoading = false
                }

            } catch {
                await MainActor.run {
                    self.msgFromViewModel = "Failed to sync contacts"
                    self.isLoading = false
                }
            }
        }


        // MARK: - Fetch Device Numbers
        private func fetchDistinctPhoneNumbers() throws -> [String] {
            let keys: [CNKeyDescriptor] = [
                CNContactPhoneNumbersKey as CNKeyDescriptor
            ]

            let request = CNContactFetchRequest(keysToFetch: keys)

            var numbers: Set<String> = []

            try store.enumerateContacts(with: request) { contact, _ in
                for phone in contact.phoneNumbers {
                    numbers.insert(phone.value.stringValue)
                }
            }

            return Array(numbers)
        }
    
    
    var filteredRegContacts: [RegisteredContact] {
        
        if searchText.isEmpty {
            return contacts
        }

        let term = searchText.lowercased()

        let digitsOnlyTerm = term.filter { $0.isNumber }

        return contacts.filter { contact in
            let name = contact.firstName! + contact.lastName!
            let nameMatch = name.lowercased().contains(term)

            let phoneMatch: Bool = {
                guard let phone = contact.idPhNo else { return false }

                let digitsOnlyNumber = phone.filter { $0.isNumber }

                return !digitsOnlyTerm.isEmpty &&
                       digitsOnlyNumber.contains(digitsOnlyTerm)
            }()


            return nameMatch || phoneMatch
        }
    }
    
    func filteredContacts(type: Int = 0) -> [RegisteredContact] {
        
        var baseContacts: [RegisteredContact]
        
        switch type {
        case 0:
            baseContacts = contacts.filter { $0.isReg }
        case 1:
            baseContacts = contacts.filter { !$0.isReg }
        default:
            baseContacts = contacts
        }
        
        if searchText.isEmpty {
            return baseContacts
        }
        
        let term = searchText.lowercased()
        let digitsOnlyTerm = term.filter { $0.isNumber }
        
        return baseContacts.filter { contact in
            let name = (contact.firstName ?? "") + (contact.lastName ?? "")
            let nameMatch = name.lowercased().contains(term)
            
            let phoneMatch: Bool = {
                guard let phone = contact.idPhNo else { return false }
                let digitsOnlyNumber = phone.filter { $0.isNumber }
                
                return !digitsOnlyTerm.isEmpty &&
                       digitsOnlyNumber.contains(digitsOnlyTerm)
            }()
            
            return nameMatch || phoneMatch
        }
    }

    
    func normalizePhone(_ phone: String) -> String {
        var digits = phone.filter { $0.isNumber }
        
        
        if digits.hasPrefix("0") {
            digits.removeFirst()
        }
        digits = "+91" + digits
        return digits
    }
    
    
    
    func sendInviteSMS(phone: String) {
        let message = "Hey! Join me on MessengerClone. It is still under Dev"
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "sms:\(phone)&body=\(encodedMessage)") {
            UIApplication.shared.open(url)
        }
    }

    @MainActor
    func createChat(
        currentUserID: String,
        contact: RegisteredContact
    ) async throws -> Chat {
        
        let otherUserID = contact.databaseId
        
        let chats = try await chatService.fetchChatsForUser(userID: currentUserID)
        
        if let existingChat = chats.first(where: {
            !$0.isGroup &&
            $0.participants.count == 2 &&
            $0.participants.contains(otherUserID!)
        }) {
            return existingChat
        }
        
        let newChatID = try await chatService.createChat(
            participants: [currentUserID, otherUserID!],
            isGroup: false
        )
        
        guard let newChat = try await chatService.fetchChat(by: newChatID) else {
            throw NSError(domain: "Chat creation failed", code: 0)
        }
        
        return newChat
    }


}
