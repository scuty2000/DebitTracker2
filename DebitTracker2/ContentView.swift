//
//  ContentView.swift
//  DebitTracker2
//
//  Created by Luca Scutigliani on 27/11/20.
//

import SwiftUI

struct Debitor: Identifiable {
    var id = UUID()
    var name: String
    var surname: String
    var debit : Int
}

struct ContentView: View {
    
    @State var newDebitor: Bool = true
    @State var debitorName: String = ""
    @State var debitorSurname: String = ""
    @State var debitDescription: String = ""
    @State var debit: Int = 0
    @State var debitors: [Debitor] = []
    
    func updateData() {
        self.debitors = DebitTracker2App().readData()
    }
    
    var body: some View {
        
        VStack(alignment: .center){
                
            HStack{
                Text("Debit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("tracker")
                    .font(.largeTitle)
                    .fontWeight(.light)
            }
            .padding(.top, 20)
            
            Text("Debits are important.")
                .font(.title3)
                .fontWeight(.ultraLight)
            
            if(self.debitors.count == 0){
                
                Text("Nobody has debts with you, enjoy!")
                    .font(.title3)
                    .frame(height: 150, alignment: .center)
                
            } else {
            
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 30){
                        Spacer(minLength: 5)
                        ForEach(self.debitors) { debitor in
                            VStack{
                                VStack(alignment: .leading){
                                    Text(debitor.name)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    Text(debitor.surname)
                                        .font(.title)
                                        .fontWeight(.heavy)
                                    HStack{
                                        Spacer()
                                        Text("\(debitor.debit).00 €")
                                            .font(.title3)
                                            .padding(.top, 10)
                                    }

                                }
                                .padding()
                            }
                            .frame(width: 220, height: 150, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.accentColor).shadow(radius: 3).opacity(0.4))
                        }
                        Spacer(minLength: 5)
                    }
                }
                .frame(height: 150, alignment: .center)
            
            }
            
            HStack{
                Text("Modify")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("debit(or)")
                    .font(.largeTitle)
                    .fontWeight(.light)
            }
            
            Text("New or existing.")
                .font(.title3)
                .fontWeight(.ultraLight)
            
            Toggle("New debitor", isOn: $newDebitor)
                .padding(.horizontal)
            
            if (!newDebitor){
                Text("C0m1ng s00n!")
            } else {
                VStack(alignment: .leading){
                    HStack{
                        TextField("Name", text: $debitorName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Surname", text: $debitorSurname)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack{
                        TextField("Debit", value: $debit, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Description", text: $debitDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.bottom, 10)
                    HStack{
                        Spacer()
                        Button("Add debit") {
                            if(debitorName != "" && debitorSurname != "" && debit != 0){
                                DebitTracker2App().writeNewData(name: debitorName, surname: debitorSurname, debit: debit)
                                self.updateData()
                            }
                        }
                        .frame(width: 150.0, height: 30.0)
                        .foregroundColor(.black)
                        .font(.title3)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.accentColor).opacity(0.4))
                        Spacer().shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
