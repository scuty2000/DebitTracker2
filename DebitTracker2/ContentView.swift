//
//  ContentView.swift
//  DebitTracker2
//
//  Created by Luca Scutigliani on 27/11/20.
//

import SwiftUI

struct ContentView: View {

    @State var debitors: [Debitor] = DebitTracker2App().readData()
    
    @State var addSheetPresented: Bool = false
    
    func updateData() {
        self.debitors = DebitTracker2App().readData()
    }
    
    var body: some View {
        
        NavigationView{
            VStack(alignment: .center){
                
                if(self.debitors.count == 0){
                    
                    ScrollView(showsIndicators: false){
                            VStack{
                                HStack{
                                    Spacer()
                                    VStack(alignment: .center){
                                        Text("Nobody has debts with you, enjoy!")
                                            .font(.title3)
                                            .fontWeight(.ultraLight)
                                    }
                                    .padding()
                                    Spacer()
                                }
                            }
                            .frame(height: 200, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.green).shadow(radius: 10).opacity(0.4))
                    }
                    .padding(.horizontal)
                    
                } else {
                
                    // Using a LazyVStack inside a ScrollView is pretty buggy, going to update this later.
                    ScrollView(showsIndicators: false){
                        LazyVStack(alignment: .center, spacing: 30){
                            ForEach(self.debitors) { debitor in
                                DebitorRow(debitor: debitor, root: self)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Debit Tracker")
            .navigationBarItems(trailing: Button("+"){
                self.addSheetPresented.toggle()
            }
            .buttonStyle(AddButtonStyle()))
            .sheet(isPresented: $addSheetPresented, content: { addView(root: self) })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AddButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(width: 30, height: 30, alignment: .center)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .background(RoundedRectangle(cornerRadius: 7).fill(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue))
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .shadow(radius: 2)
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .background(RoundedRectangle(cornerRadius: 15).fill(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue))
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

struct DeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.body)
            .frame(width: 60, height: 25, alignment: .center)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .background(RoundedRectangle(cornerRadius: 15).fill(configuration.isPressed ? Color.red.opacity(0.5) : Color.red))
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

struct DebitorRow: View {
    var debitor: Debitor
    var root: ContentView
    
    func calculateColor(colorString: String) -> Color {
        var splittedString = colorString.split(separator: " ")
        var color: Color = Color.blue.opacity(0.4)
        if (splittedString.count == 5){
            splittedString.remove(at: 0)
            color = Color.init(red: Double(splittedString[0])!, green: Double(splittedString[1])!, blue: Double(splittedString[2])!).opacity(Double(splittedString[3])!)
        } else {
            color = Color.init(red: 1.0, green: 1.0, blue: 1.0)
        }
            return color
    }

    var body: some View {
        VStack{
            VStack(alignment: .leading){
                HStack{
                    Text(debitor.name)
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                    Spacer()
                    Button("delete") {
                        DebitTracker2App().removeData(debitor: debitor)
                        root.updateData()
                    }
                    .buttonStyle(DeleteButtonStyle())
                }
                Text(debitor.surname)
                    .font(.system(size: 35))
                    .fontWeight(.heavy)
                HStack{
                    Spacer()
                    Text("\(debitor.debit).00 €")
                        .font(.system(size: 55))
                        .padding(.top, 20)
                }

            }
            .padding()
        }
        .frame(height: 200, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20)
                        .fill(calculateColor(colorString: debitor.color)).shadow(color: Color.gray, radius: 5))
    }
}

struct addView: View {
    
    @State var debitorName: String = ""
    @State var debitorSurname: String = ""
    @State var debitDescription: String = ""
    @State var debit: String = ""
    @State var color: Color = Color.init(red: 1.0, green: 1.0, blue: 1.0)
    
    var root: ContentView
    
    var body: some View {

        VStack(alignment: .center){
            Spacer()
            
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
            
            HStack{
                TextField("Name", text: $debitorName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Surname", text: $debitorSurname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack{
                TextField("Debit", text: $debit)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Description", text: $debitDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            .padding(.bottom, 20)
            ColorPicker("Colore della card", selection: $color)
                .padding(.bottom, 20)
            HStack{
                Spacer()
                Button("Add debit") {
                    print("[ColorPicker] \(self.color.description)")
                    if(debitorName != "" && debitorSurname != ""){
                        if let numericDebit = Int(debit) {
                            DebitTracker2App().writeNewData(debitor: Debitor.init(name: debitorName, surname: debitorSurname, debit: numericDebit, color: "\(self.color.description)"))
                            root.updateData()
                            self.debitorName = ""
                            self.debitorSurname = ""
                            self.debit = ""
                            root.addSheetPresented.toggle()
                        } else {
                            print("[UI] Debit field doesn't have a numerical content.")
                            self.debit = ""
                        }
                    } else {
                        print("[UI] Inputs aren't complete")
                    }
                }
                .buttonStyle(BlueButtonStyle())
                Spacer()
            }
            Spacer()
            Button("Close"){
                root.addSheetPresented.toggle()
            }
            .accentColor(Color.gray)
        }
        .padding(.horizontal)
    }
}
