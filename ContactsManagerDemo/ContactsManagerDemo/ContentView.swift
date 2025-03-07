//
//  ContentView.swift
//  ContactsManagerDemo
//
//  Created by Arpit Agarwal on 3/5/25.
//

import Contacts
import ContactsManager
import SwiftUI
import Combine

struct ContentView: View {
    @State private var contacts: [Contact] = []
    @State private var authorizationStatus: CNAuthorizationStatus = .notDetermined
    @State private var showingAuthAlert: Bool = false
    @State private var searchText: String = ""
    @State private var selectedContact: Contact? = nil
    @State private var cancellable: Set<AnyCancellable> = []
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        }
        if let results = ContactService.shared.contactResults(searchQuery: searchText) {
            return Array(results)
        }
        return []
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch authorizationStatus {
                case .notDetermined:
                    ContactAccessView(requestAccess: requestAccess)
                case .denied, .restricted:
                    ContactDeniedView()
                case .authorized, .limited:
                    List {
                        ForEach(filteredContacts) { contact in
                            ContactRow(contact: contact)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedContact = contact
                                }
                        }
                    }
                    .listStyle(.plain)
                @unknown default:
                    Text("Unknown authorization status")
                }
            }
            .navigationTitle("Rolodex")
            .searchable(text: $searchText, prompt: "Search by name, email, or phone")
            .onAppear {
                checkAuthorizationStatus()
                setupContactsSubscription()
            }
            .sheet(item: $selectedContact) { contact in
                ContactDetailView(contact: contact)
            }
            .contactAccessAlert(isPresented: $showingAuthAlert)
        }
    }
    
    private func checkAuthorizationStatus() {
        authorizationStatus = ContactService.shared.contactAuthStatus()
        if authorizationStatus == .authorized {
            loadContacts()
        }
    }
    
    private func requestAccess() {
        requestContactAccess { granted in
            authorizationStatus = granted ? .authorized : .denied
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
    
    private func setupContactsSubscription() {
        // Clear existing subscriptions
        cancellable.removeAll()
        
        // Subscribe to contact updates
        ContactService.shared.contactsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("Received contact update notification")
                loadContacts()
            }
            .store(in: &cancellable)
    }
}

// MARK: - Supporting Views
private struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            Group {
                if contact.imageDataAvailable,
                   let thumbnailData = contact.thumbnailImageData,
                   let uiImage = UIImage(data: thumbnailData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(.gray.opacity(0.8))
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .background(
                Circle()
                    .fill(Color(.systemBackground))
            )
            .overlay(
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 0.5)
            )
            
            // Contact Info
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.displayName ?? "No Name")
                    .font(.headline)
                
                Group {
                    if let firstPhone = contact.phoneNumbers.first,
                       let phoneNumber = firstPhone.value {
                        Text(phoneNumber)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else if let firstEmail = contact.emailAddresses.first,
                             let email = firstEmail.value {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else if let firstAddress = contact.addresses.first {
                        Text(firstAddress.display())
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

private struct ContactDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingDebugInfo = false
    let contact: Contact
    
    var body: some View {
        NavigationView {
            List {
                ContactProfileSection(contact: contact)
                
                if !contact.phoneNumbers.isEmpty {
                    ContactPhoneSection(phoneNumbers: contact.phoneNumbers)
                }
                
                if !contact.emailAddresses.isEmpty {
                    ContactEmailSection(emailAddresses: contact.emailAddresses)
                }
                
                if !contact.addresses.isEmpty {
                    ContactAddressSection(addresses: contact.addresses)
                }
                
                if !contact.socialProfiles.isEmpty {
                    ContactSocialSection(socialProfiles: contact.socialProfiles)
                }
                
                if !contact.organizations.isEmpty {
                    ContactOrganizationSection(organizations: contact.organizations)
                }
                
                if !contact.interests.isEmpty {
                    ContactInterestsSection(interests: contact.interests)
                }
                
                if let notes = contact.notes, !notes.isEmpty {
                    ContactNotesSection(notes: notes)
                }
                
                if let birthday = contact.birthday {
                    ContactBirthdaySection(birthday: birthday)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Debug") {
                        showingDebugInfo = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingDebugInfo) {
                NavigationView {
                    ScrollView {
                        Text(contact.debugDescription)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                    }
                    .navigationTitle("Debug Info")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingDebugInfo = false
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Contact Detail Sections
private struct ContactProfileSection: View {
    let contact: Contact
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                // Profile Image
                Group {
                    if contact.imageDataAvailable,
                       let imageData = contact.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundStyle(.gray)
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                
                VStack(spacing: 8) {
                    Text(contact.displayName ?? "No Name")
                        .font(.title2)
                        .bold()
                    
                    if let nickname = contact.nickname {
                        Text(nickname)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    if let organization = contact.organizationName {
                        Text(organization)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    if let jobTitle = contact.jobTitle {
                        Text(jobTitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
}

private struct ContactPhoneSection: View {
    let phoneNumbers: [ContactLabelledValue]
    
    var body: some View {
        if !phoneNumbers.isEmpty {
            Section("Phone Numbers") {
                ForEach(phoneNumbers, id: \.labelId) { phone in
                    LabeledRow(
                        icon: "phone.fill",
                        title: phone.value ?? "",
                        subtitle: formatLabel(phone.type)
                    )
                }
            }
        }
    }
}

private struct ContactEmailSection: View {
    let emailAddresses: [ContactLabelledValue]
    
    var body: some View {
        if !emailAddresses.isEmpty {
            Section("Email Addresses") {
                ForEach(emailAddresses, id: \.labelId) { email in
                    LabeledRow(
                        icon: "envelope.fill",
                        title: email.value ?? "",
                        subtitle: formatLabel(email.type)
                    )
                }
            }
        }
    }
}

private struct ContactAddressSection: View {
    let addresses: [ContactAddress]
    
    var body: some View {
        if !addresses.isEmpty {
            Section("Addresses") {
                ForEach(addresses, id: \.addressId) { address in
                    LabeledRow(
                        icon: "location.fill",
                        title: address.display(),
                        subtitle: formatLabel(address.type)
                    )
                }
            }
        }
    }
}

private struct ContactSocialSection: View {
    let socialProfiles: [ContactSocial]
    
    var body: some View {
        if !socialProfiles.isEmpty {
            Section("Social Profiles") {
                ForEach(socialProfiles, id: \.socialId) { social in
                    if let username = social.username {
                        LabeledRow(
                            icon: "link",
                            title: username,
                            subtitle: social.service?.capitalized ?? "Other"
                        )
                    }
                }
            }
        }
    }
}

private struct ContactNotesSection: View {
    let notes: String?
    
    var body: some View {
        if let notes = notes, !notes.isEmpty {
            Section("Notes") {
                Text(notes)
                    .font(.body)
                    .padding(.vertical, 8)
            }
        }
    }
}

private struct ContactBirthdaySection: View {
    let birthday: Date?
    
    var body: some View {
        if let birthday = birthday {
            Section("Birthday") {
                LabeledRow(
                    icon: "gift.fill",
                    title: birthday.formatted(date: .long, time: .omitted),
                    subtitle: nil
                )
            }
        }
    }
}

// Update ContactOrganizationSection to use ContactOrganization type
private struct ContactOrganizationSection: View {
    let organizations: [ContactOrganization]
    
    var body: some View {
        Section("Organizations") {
//          ForEach(organizations, id: \.organizationId) { org in
//                LabeledRow(
//                    icon: "building.2.fill",
//                    title: org.name ?? "",
//                    subtitle: org.jobTitle
//                )
//            }
        }
    }
}

private struct ContactInterestsSection: View {
    let interests: [String]
    
    var body: some View {
        Section("Interests") {
            ForEach(interests, id: \.self) { interest in
                LabeledRow(
                    icon: "heart.fill",
                    title: interest,
                    subtitle: nil
                )
            }
        }
    }
}

// MARK: - Helper Functions
private func formatLabel(_ label: String?) -> String {
    label?
        .replacingOccurrences(of: "_$!<", with: "")
        .replacingOccurrences(of: ">!$_", with: "")
        .capitalized ?? "Other"
}

private struct LabeledRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
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

private struct ContactDeniedView: View {
    var body: some View {
        VStack {
            Text("Contact Access Denied")
                .font(.title)
                .padding()
            
            Text("Please enable contact access in Settings to use this app.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
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

