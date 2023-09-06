//
//  ContentView.swift
//  Restart
//
//  Created by Nindya Alita Rosalia on 13/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage ("onboarding") var isOnBoardingViewActive: Bool = false
     
    var body: some View {
        ZStack{
            if isOnBoardingViewActive{
                OnBoardingView()
            }else{
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
