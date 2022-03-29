//
//  ContentView.swift
//  SwipeAnimation
//
//  Created by robevans on 3/29/22.
//

import SwiftUI

struct ContentView: View {
    @State var showAlert = false
    @State var showListDividers = false
    @State var navigationBarTitle = ""

    var body: some View {
        NavigationView {
            ZStack {
                //                BackgroundView()
                //                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    VStack {
                        List(0 ..< 5){ reminder in
                            CardRowView(geo: geo, showAlert: $showAlert)
                                .frame(height: 150)
                                .padding(.vertical)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(showListDividers ? .visible : .hidden)
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Title"),
                                          message: Text("SubText"),
                                          primaryButton: .destructive(Text("Delete")){
                                        print("Delete")
                                    },
                                          secondaryButton: .cancel()
                                    )
                                }

                        }
                    }
                    .listStyle(.plain)
                }
                .refreshable {
                    print("refresh")
                }
            }
            .navigationBarTitle(navigationBarTitle.isEmpty ? "Swipe Animation" : navigationBarTitle)
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Main card view
struct CardRowView: View {
    @State var offset = CGSize.zero
    @State var rotate = 00.0
    @State var animationShakeAmount = 5.0 // higher the number the more of an angle of the card
    @State var swipeScale = 0.8 // default is 0.8 to scale inward
    @State var animateReminder = false
    @State var animateShake1 = false
    @State var animateShake2 = false

    let geo: GeometryProxy
    @Binding var showAlert: Bool

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color("StatusCard"))
                .padding(.horizontal)
                .shadow(radius: 2)
                .overlay(
                    VStack {
                        HStack {
                            Image("rocket_green")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                            Text("Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium")
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal)
                        HStack {
                            Text("Subtext")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("2/22/2022")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                    }
                )
                .offset(x: offset.width)
                .scaleEffect(animateReminder ? swipeScale : 1.0)
                .rotationEffect(.degrees(animateShake1 ? animationShakeAmount : 0))
                .rotationEffect(.degrees(animateShake2 ? -animationShakeAmount : 0))
                .rotation3DEffect(.degrees(rotate / 2), axis: (x: 1, y: 0, z: 0))
                .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            withAnimation {
                                offset = gesture.translation
                                while rotate < 90.0 {
                                    rotate += 10.0
                                }
                            }
                        } else if gesture.translation.width > 0 {
                            withAnimation {
                                offset = gesture.translation
                                while rotate < 90.0 {
                                    rotate += 0.06
                                }
                            }
                        }
                    }.onEnded{ value in
                        print(value.translation.width)
                        if value.translation.width > 150 {
                            print(value.translation.width)
                            withAnimation(.spring()) {
                                offset = .zero
                                rotate = 1.0
                                playHaptic(style: "medium")
                                showAlert = true
                                animateReminder = true
                                animateShake1 = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    withAnimation {
                                        animateShake1 = false
                                        animateShake2 = true
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation {
                                        animateShake2 = false
                                        animateReminder = false
                                    }
                                }
                            }
                        } else if value.translation.width < 50 {
                            print(value.translation.width)
                            withAnimation(.spring()) {
                                offset = .zero
                                rotate = 1.0
                                playHaptic(style: "medium")
                                showAlert = true
                                animateReminder = true
                                animateShake2 = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    withAnimation {
                                        animateShake2 = false
                                        animateShake1 = true
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation {
                                        animateShake1 = false
                                        animateReminder = false
                                    }
                                }
                            }
                        }  else {
                            withAnimation(.spring()) {
                                offset = .zero
                                rotate = 1.0
                            }
                        }
                    })
        }
    }
}
