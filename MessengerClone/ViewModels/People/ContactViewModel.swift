//
//  NewContactViewModel.swift
//  MessengerClone
//
//  Created by rentamac on 05/02/2026.
//

import Contacts
import Combine

class ContactsViewModel: ObservableObject {
    @Published var contacts: [PhoneContact] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedContactIDs: Set<UUID> = []
    @Published var isSelectionMode: Bool = false
    @Published var msgFromViewModel: String = ""

    private let store = CNContactStore()

    func requestAndFetchContacts() {
        isLoading = true
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized:
            fetchContacts()

        default:
            store.requestAccess(for: .contacts) { granted, _ in
                if granted {
                    Task{
                         self.fetchContacts()
                        
                    }
                } else {
                    self.isLoading = false
                    self.msgFromViewModel=" Please allow the app to access your contacts in settings."
                    print("no access")
                }
            }

//        default:
//            self.isLoading = false
//            self.msgFromViewModel=""
//            print("Contacts access denied or restricted")
        }
    }

    private func fetchContacts() {
        isLoading = true
        print("in fetch")
        msgFromViewModel = ""
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        let request = CNContactFetchRequest(keysToFetch: keys)
        var results: [PhoneContact] = []

        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let name = "\(contact.givenName) \(contact.familyName)"
                let phones = contact.phoneNumbers.map {
                    $0.value.stringValue
                }

                results.append(
                    PhoneContact(name: name, phoneNumbers: phones)
                )
            }

            DispatchQueue.main.async {
                self.contacts = results
            }
        } catch {
            print("Failed to fetch contacts:", error)
            msgFromViewModel = ""
        }
        isLoading = false
        msgFromViewModel = ""
    }
    
    func loadDummyContacts()-> [PhoneContact]{
            let dummy = [
                PhoneContact(name: "Alice Johnson", phoneNumbers: ["+1 555-123-4567"]),
                PhoneContact(name: "Bob Smith", phoneNumbers: ["+1 555-987-6543", "+1 555-000-1111"]),
                PhoneContact(name: "Charlie Brown", phoneNumbers: ["+44 20 7946 0958"]),
                PhoneContact(name: "David Lee", phoneNumbers: ["+91 98765 43210"]),
                PhoneContact(name: "Eva Green", phoneNumbers: ["+1 555-222-3333"])
            ]
            return  dummy
        }
    
    
    var filteredContacts: [PhoneContact] {
        
        if searchText.isEmpty {
            return contacts
        }

        let term = searchText.lowercased()

        let digitsOnlyTerm = term.filter { $0.isNumber }

        return contacts.filter { contact in
            let nameMatch = contact.name.lowercased().contains(term)

            let phoneMatch = contact.phoneNumbers.contains { number in
                let digitsOnlyNumber = number.filter { $0.isNumber }
                return !digitsOnlyTerm.isEmpty &&
                       digitsOnlyNumber.contains(digitsOnlyTerm)
            }

            return nameMatch || phoneMatch
        }
    }

}
