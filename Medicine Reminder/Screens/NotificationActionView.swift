//
//  NotificationActionView.swift
//  Medicine Reminder
//
//  Created by BJIT on 31/7/23.
//

import SwiftUI


struct NotificationActionView : View {
    var bodyText : String
    var title: String
    @Binding var pushNavigationBinding: Bool
    @State var medicineNameList: [String] = []
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chevron.backward")
                    .font(.title3)
                Text("Back")
                    .font(.title3)
                Spacer()
            }
            .padding(.leading, 8)
            .onTapGesture {
                withAnimation(.default){
                    pushNavigationBinding = false
                }
            }
            .foregroundColor(Color("tealBlue"))
            HStack{
                Text("Your \(title)'s")
                    .font(.title)
                Spacer()
            }
            .padding(.horizontal)
            
            List{
                ForEach(medicineNameList, id: \.self){ medicineName in
                    HStack{
                        Text(medicineName)
                            .font(.title2)
                        Spacer()
                        HStack{
                            Button(action: {

                            }, label: {
                                Image(systemName: "checkmark.circle.fill")
                            })

                            Button(action: {

                            }, label: {
                                Image(systemName: "exclamationmark.circle.fill")
                            })
                            Button(action: {

                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                            })
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 28))
                    }
                    .listRowSeparator(.hidden)
                    .padding()
                    .background(Color("itemBG"))
                    .cornerRadius(15)
                }
            }
            
            .listStyle(.plain)
        }
        
        .onAppear(){
            let trimmedInput = bodyText.replacingOccurrences(of: "Take ", with: "")
            medicineNameList = trimmedInput.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        }
    }
    
}

struct NotificationActionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationActionView(bodyText: "Take Napa Extra, Ace, Antibiotic", title: "Afternoon Medicine", pushNavigationBinding: Binding.constant(true))
    }
}
