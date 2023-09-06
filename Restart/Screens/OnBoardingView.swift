//
//  OnBoardingView.swift
//  Restart
//
//  Created by Nindya Alita Rosalia on 13/08/23.
//

import SwiftUI

struct OnBoardingView: View {
    
    // MARK: PROPERTIES
    
    @AppStorage ("onboarding") var isOnBoardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80 //
    @State private var buttonOffset:CGFloat = 0 // represent the asset valuein the horizontal direction
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero // CGSize = (width: 0, height: 0)
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTittle: String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    // MARK: BODIY
    
    var body: some View {
        ZStack {
            
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack (spacing: 20){
                
                //MARK: HEADER
                
                Spacer()
                
                VStack (spacing: 0){
                    Text(textTittle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTittle)
                    
                    Text("""
                        It's not how much we give but
                        how much love we put into giving.
                    """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                }//: HEADER
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
                
                //MARK: CENTER
                ZStack{
                    
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1) // -1 because we would like to ove the ring in the opposite direction than dragging
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2 , y: 0) //accelerate the movement
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))//make image rotate
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    if abs(imageOffset.width) <= 150{ // make image not go outside the screen (left-right limitation)
                                        imageOffset = gesture.translation //total movement from start gesture of the drag gesture to the current event of the drag gesture
                                        
                                        withAnimation(.linear(duration: 0.25)){
                                            indicatorOpacity = 0
                                            textTittle = "Give."
                                        }
                                    }
  
                                }
                                .onEnded{ _ in
                                    imageOffset = .zero //restore the initial value of the x and y coordinates of the image view
                                    
                                    withAnimation(.linear(duration: 0.25)){
                                        indicatorOpacity = 1
                                        textTittle = "Share."
                                    }
                                }
                        )//: GESTURE
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                }//: CENTER
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity),
                    alignment: .bottom
                        
                )
                
                Spacer()
                
                //MARK: FOOTER
                
                ZStack{
                    //PART OF CUSTOM BUTTON
                    
                    //1. BACKGROUND (STATIC)
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    
                    //2. CALL-TO-ACTION (STATIC)
                    
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    
                    
                    //3. CAPSULE (DYNAMIC WIDTH)
                    
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80) // make the red capsule width increased 80 if red button dragging
                        Spacer()
                    }
                    
                    //4. CIRCLE (DRAGGABLE)
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(Color.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset) // automatic view upadte --> we can see the button movement in the horizontal direction
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 { // gesture.translation.width > 0 : first dragging initiate from left to right direction
                                        //  buttonOffset <= buttonWidth - 80 : prevent user from moving red button outside
                                        buttonOffset = gesture.translation.width // added new value of the offset property about how much we move our finger on the screen in the horizontal direction.
                                    }
                                    
                                    
                                }
                                .onEnded{ _ in
                                    withAnimation(Animation.easeOut(duration: 0.4)){ // told program to run animation next time when change from onboarding to home view
                                        if buttonOffset > buttonWidth / 2{
                                            hapticFeedback.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            isOnBoardingViewActive = false
                                            //this if statement mean, if we dragging the red button more than a half of button width so, the red button will go to end of button width
                                        }else{
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0 // told program that we want to the red button in position zero when we stop dragging
                                            //this else statement mean, if we draging the red button less than a hal of button width so the red button will go to start of button width
                                        }
                                    }
                                    
                                }
                        )//: GESTURE
                        
                        Spacer()
                    }//: HSTACK
                    
                }//: FOOTER
                .frame(width: buttonWidth,height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y : isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
            }//: VSTACK
        }//: ZSTACK
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark)//tell our program that we want to use black mode
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
