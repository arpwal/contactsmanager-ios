//
//  ContentView.swift
//  ContactsManagerDemo
//
//  Created by Arpit Agarwal on 3/5/25.
//

import ContactsManager
import SwiftUI

struct ContentView: View {
  @State private var items = ["Apple", "Banana", "Orange", "Mango", "Grapes"]
  @State private var selectedIndex: String = ""
  @State private var result: String = ""

  var body: some View {
    VStack(spacing: 20) {
      Text("Array Safe Subscript Demo")
        .font(.title)
        .padding()

      // Display the array items
      VStack(alignment: .leading) {
        Text("Available Items:")
          .font(.headline)
        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
          Text("\(index): \(item)")
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(10)

      // Input field for index
      HStack {
        Text("Enter index:")
        TextField("Index", text: $selectedIndex)
          .keyboardType(.numberPad)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 100)
      }
      .padding()

      // Button to test the safe subscript
      Button("Get Item") {
        if let index = Int(selectedIndex) {
          if let item = items[safe: index] {
            result = "Found: \(item)"
          } else {
            result = "Index out of bounds!"
          }
        } else {
          result = "Please enter a valid number"
        }
      }
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)

      // Display result
      Text(result)
        .padding()
        .foregroundColor(result.contains("out of bounds") ? .red : .green)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
