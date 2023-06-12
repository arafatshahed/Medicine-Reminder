//
//  HomeView.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("8:00 am")
                .font(.largeTitle)
            Rectangle()
                .frame(height: 100)
                .cornerRadius(10)
                .foregroundColor(Color("itemBG"))
                .overlay(content: {
                    HStack{
                        Image(systemName: "pills")
                            .font(.system(size: 30))
                            .padding(20)
                        Rectangle()
                            .frame(width: 3, height: 60)
                            .padding(.trailing)
                        VStack(alignment: .leading){
                            Text("Napa")
                                .font(.title)
                            Text("Take 1 Pill(s)")
                        }
                        Spacer()
                    }
                })
            Spacer()
        }
        .padding(10)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
