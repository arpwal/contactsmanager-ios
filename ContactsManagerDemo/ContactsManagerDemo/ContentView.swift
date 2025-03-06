//
//  ContentView.swift
//  ContactsManagerDemo
//
//  Created by Arpit Agarwal on 3/5/25.
//

import ContactsManager
import SwiftUI
import RealmSwift

struct ContentView: View {
    @State private var contacts: [Contact] = []
    @State private var isAuthorized: Bool = false
    @State private var showingAuthAlert: Bool = false
    
    var body: some View {
        NavigationView {
            Group {
                if isAuthorized {
                    ContactListView(contacts: contacts)
                } else {
                    ContactAccessView(requestAccess: requestAccess)
                }
            }
            .navigationTitle("Contacts")
            .onAppear {
                checkAuthorizationStatus()
            }
            .contactAccessAlert(isPresented: $showingAuthAlert)
        }
    }
    
    private func checkAuthorizationStatus() {
        let status = ContactService.shared.contactAuthStatus()
        isAuthorized = status == .authorized
        if isAuthorized {
            loadContacts()
        }
    }
    
    private func requestAccess() {
        requestContactAccess { granted in
            isAuthorized = granted
            if granted {
                loadContacts()
            } else {
                showingAuthAlert = true
            }
        }
    }
    
    private func loadContacts() {
        if let results = ContactService.shared.contactResults() {
            contacts = Array(results)
        }
    }
}

// MARK: - Supporting Views
private struct ContactListView: View {
    let contacts: [Contact]
    
    var body: some View {
        List {
            ForEach(contacts) { contact in
                ContactRow(contact: contact)
            }
        }
    }
}

private struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.displayName ?? "No Name")
                .font(.headline)
            if let firstPhone = contact.phoneNumbers.first,
               let phoneNumber = firstPhone.value {
                Text(phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ContactAccessView: View {
    let requestAccess: () -> Void
    
    var body: some View {
        VStack {
            Text("Contact Access Required")
                .font(.title)
                .padding()
            
            Text("This app needs access to your contacts to display them.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Grant Access") {
                requestAccess()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
}
