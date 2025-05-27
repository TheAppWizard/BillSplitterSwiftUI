//
//  ContentView.swift
//  BillSpliter
//
//  Created by Shreyas Vilaschandra Bhike on 25/05/25.
//

//  MARK: Instagram
//  TheAppWizard
//  MARK: theappwizard2408

import SwiftUI

struct ContentView: View {
    var body: some View {
        BillSplitterMain()
    }
}

#Preview {
    ContentView()
}





















// MARK: - Models
struct Friend: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let avatar: String
    var isSelected: Bool = false
}

struct Bill: Identifiable {
    let id = UUID()
    let restaurant: String
    let amount: Double
    let splitCount: Int
    let isPaid: Bool
    let color: Color
}

struct BillSplit: Identifiable {
    let id = UUID()
    let friend: Friend
    let amount: Double
    let percentage: Double
}

// MARK: - Main App View
struct BillSplitterMain: View {
    @State private var currentView: ViewType = .home
    @State private var selectedBill: Bill?
    @State private var totalBillAmount: Double = 20.15
    @State private var selectedFriends: [Friend] = []
    
    enum ViewType {
        case home, splitBill, detailSplit
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch currentView {
                case .home:
                    HomeView(
                        currentView: $currentView,
                        selectedBill: $selectedBill,
                        totalBillAmount: $totalBillAmount
                    )
                case .splitBill:
                    SplitBillView(
                        currentView: $currentView,
                        totalBillAmount: $totalBillAmount,
                        selectedFriends: $selectedFriends
                    )
                case .detailSplit:
                    DetailSplitView(
                        currentView: $currentView,
                        totalBillAmount: totalBillAmount,
                        selectedFriends: selectedFriends
                    )
                }
            }
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    @Binding var currentView: BillSplitterMain.ViewType
    @Binding var selectedBill: Bill?
    @Binding var totalBillAmount: Double
    
    private let bills = [
        Bill(restaurant: "McDonalds", amount: 10.00, splitCount: 2, isPaid: false, color: .black),
        Bill(restaurant: "KFC", amount: 23.50, splitCount: 3, isPaid: true, color: .green.opacity(0.3)),
        Bill(restaurant: "Dominos", amount: 23.50, splitCount: 3, isPaid: true, color: .green.opacity(0.3))
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Hello Shreyas")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    Text("Good Morning, Don't\nForget To Have Breakfast!")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                
                // Balance Card
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Balance")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Total Balance")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("$40,000.00")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "qrcode")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Text("Deposit")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.black)
                                .cornerRadius(25)
                        }
                        
                        Button(action: {}) {
                            Text("Withdraw")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(25)
                        }
                    }
                }
                .padding(20)
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Billing Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Billing")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Tab Bar
                    HStack(spacing: 30) {
                        Text("Near By")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Recent")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("History")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Bills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(bills) { bill in
                                BillCard(bill: bill) {
                                    selectedBill = bill
                                    totalBillAmount = bill.amount
                                    currentView = .splitBill
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Add Split Billing Button
                    Button(action: {
                        currentView = .splitBill
                    }) {
                        Text("Add Split Billing")
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.purple.opacity(0.3))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color(.systemGray6))
    }
}

// MARK: - Bill Card
struct BillCard: View {
    let bill: Bill
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(bill.restaurant)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(bill.color == .black ? .white : .black)
                    
                    Spacer()
                    
                    if bill.color == .black {
                        Image(systemName: "message")
                            .foregroundColor(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Bill • Split To \(bill.splitCount)")
                        .font(.caption)
                        .foregroundColor(bill.color == .black ? .white.opacity(0.7) : .gray)
                    
                    Text("$\(bill.amount, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(bill.color == .black ? .white : .black)
                }
                
                if bill.isPaid {
                    Text("Paid")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                } else {
                    Button(action: {}) {
                        Text("Pay")
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(16)
            .frame(width: 160, height: 180)
            .background(bill.color)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Split Bill View
struct SplitBillView: View {
    @Binding var currentView: BillSplitterMain.ViewType
    @Binding var totalBillAmount: Double
    @Binding var selectedFriends: [Friend]
    
    @State private var friends = [
        Friend(name: "Sara Patil", avatar: "avatar1"),
        Friend(name: "Preet Singh", avatar: "avatar3"),
        Friend(name: "Tina Thakur", avatar: "avatar2"),
        Friend(name: "Mayank Mehta", avatar: "avatar4")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button(action: {
                    currentView = .home
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Split The Bill")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Invisible spacer for centering
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .opacity(0)
            }
            .padding(.horizontal)
            
            // Bill Amount Card
            VStack(spacing: 16) {
                HStack {
                    Text("My Balance")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("$40,000.00")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .padding(16)
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(12)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Total Bill")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("$\(totalBillAmount, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Split With")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        HStack(spacing: 12) {
                                                   ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                                                       Button(action: {
                                                           withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                                                               friends[index].isSelected.toggle()
                                                           }
                                                           updateSelectedFriends()
                                                       }) {
                                                           ZStack {
                                                               Circle()
                                                                   .fill(friend.isSelected ? Color.black.opacity(1) : Color.clear)
                                                                   .frame(width: 60, height: 60)
                                                                   .scaleEffect(friend.isSelected ? 1.1 : 1.0)
                                                               
                                                               if friend.isSelected {
                                                                   Image(systemName: "checkmark")
                                                                       .foregroundColor(.white)
                                                                       .fontWeight(.bold)
                                                                       .scaleEffect(1.2)
                                                                       .transition(.scale.combined(with: .opacity))
                                                               } else {
                                                                   Image(friend.avatar)
                                                                       .resizable()
                                                                       .frame(width:60,height:60)
                                                                       .foregroundColor(.white)
                                                                       .font(.title2)
                                                                       .transition(.scale.combined(with: .opacity))
                                                               }
                                                           }
                                                           .animation(.spring(response: 0.4, dampingFraction: 0.8), value: friend.isSelected)
                                                       }
                                                   }
                            
                            Button(action: {}) {
                                Circle()
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .foregroundColor(.gray)
                                    )
                            }
                        }
                    }
                    
                    Button(action: {
                        currentView = .detailSplit
                    }) {
                        Text("Split Now")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .cornerRadius(25)
                    }
                    .disabled(selectedFriends.isEmpty)
                }
                .padding(20)
                .background(Color.purple.opacity(0.3))
                .cornerRadius(16)
            }
            .padding(.horizontal)
            
            // Nearby Friends
            VStack(alignment: .leading, spacing: 16) {
                Text("Nearby Friend")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                HStack(spacing: 25) {
                    ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                        VStack(spacing: 8) {
                            ZStack {
//                                Circle()
////                                    .fill(getCircleColor(for: index))
//                                    .frame(width: 60, height: 60)
                                
                                Image(friend.avatar)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                                    .font(.title2)
                                
                                // Add button
                                Button(action: {
                                    friends[index].isSelected = true
                                    updateSelectedFriends()
                                }) {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Image(systemName: "plus")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        )
                                }
                                .offset(x: 20, y: 20)
                            }
                            
                            Text(friend.name)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color(.systemGray6))
    }
    
    private func getCircleColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .purple, .orange, .pink]
        return colors[index % colors.count]
    }
    
    private func updateSelectedFriends() {
        selectedFriends = friends.filter { $0.isSelected }
    }
}

// MARK: - Detail Split View
struct DetailSplitView: View {
    @Binding var currentView: BillSplitterMain.ViewType
    let totalBillAmount: Double
    let selectedFriends: [Friend]
    
    private var billSplits: [BillSplit] {
        guard !selectedFriends.isEmpty else { return [] }
        
        let amountPerPerson = totalBillAmount / Double(selectedFriends.count + 1) // +1 for user
        let percentage = 100.0 / Double(selectedFriends.count + 1)
        
        var splits: [BillSplit] = []
        
        // Add user's split
        let userFriend = Friend(name: "Shreyas Bhike", avatar: "avatar5")
        splits.append(BillSplit(friend: userFriend, amount: amountPerPerson, percentage: percentage))
        
        // Add selected friends' splits
        for friend in selectedFriends {
            splits.append(BillSplit(friend: friend, amount: amountPerPerson, percentage: percentage))
        }
        
        return splits
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button(action: {
                    currentView = .splitBill
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Split The Bill")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Invisible spacer for centering
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .opacity(0)
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    HStack(spacing: 12) {
                        VStack(spacing: 8) {
                            Text("My Balance")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("$40,000.00")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(12)
                        
                        VStack(spacing: 8) {
                            Text("Total Bill")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("$\(totalBillAmount, specifier: "%.2f")")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.purple.opacity(0.3))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Split With Section
                    VStack(spacing: 16) {
                        Text("Split With")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 12) {
                            ForEach(Array(selectedFriends.enumerated()), id: \.element.id) { index, friend in
                                Circle()
//                                    .fill(getCircleColor(for: index))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(friend.avatar)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    )
                            }
                        }
                        
                        Button(action: {
                            // Handle split now action
                        }) {
                            Text("Split Now")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(25)
                        }
                    }
                    .padding(20)
                    .background(Color.purple.opacity(0.3))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Nearby Friends (same as before)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Nearby Friend")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            ForEach(Array(selectedFriends.enumerated()), id: \.element.id) { index, friend in
                                VStack(spacing: 8) {
                                    Image(friend.avatar)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                        .font(.title2)
                                    
                                    Text(friend.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    // Detail Split Bill
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Detail Split Bill")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Total Bill")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("$\(totalBillAmount, specifier: "%.2f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            ForEach(Array(billSplits.enumerated()), id: \.element.id) { index, split in
                                HStack(spacing: 12) {
                                    Circle()
//                                        .fill(getCircleColor(for: index))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(split.friend.avatar)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.white)
                                                .font(.title3)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(split.friend.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text("\(Int(split.percentage))%")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("$\(split.amount, specifier: "%.2f")")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color(.systemGray6))
    }
    
    private func getCircleColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .purple, .orange, .pink, .green, .red]
        return colors[index % colors.count]
    }
}

