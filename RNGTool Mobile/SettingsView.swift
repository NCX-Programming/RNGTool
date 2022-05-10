//
//  SettingsView.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/14/21.
//

import SwiftUI
#if os(iOS)
import CoreHaptics
#elseif os(watchOS)
import WatchKit
#endif

struct SettingsView: View {
    @EnvironmentObject var settingsData: SettingsData
    #if os(iOS)
    @State private var engine: CHHapticEngine?
    #endif
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var showResetPrompt = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAdvSet = false
    
    var body: some View {
        Form {
            Section(header: Text("Number Settings"), footer: Text("The default maximum and minimum numbers when using Number Mode.")) {
                Text("Default Maximum Number")
                TextField(text: $maxNumberInput, prompt: Text("Required")) {
                    Text("Max Number")
                }
                Text("Default Minimum Number")
                TextField(text: $minNumberInput, prompt: Text("Required")) {
                    Text("Min Number")
                }
                .onAppear {
                    maxNumberInput = "\(settingsData.maxNumberDefault)"
                    minNumberInput = "\(settingsData.minNumberDefault)"
                }
                Button(action:{
                    #if os(iOS)
                    playHaptics(engine: engine, intensity: 0.8, sharpness: 0.5, count: 0.1)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.click)
                    #endif
                    showResetPrompt = true
                }) {
                    Text("Reset")
                }
                .alert(isPresented: $showResetPrompt){
                    Alert(
                        title: Text("Confirm Reset"),
                        message: Text("Are you sure you want to reset the minimum and maximum numbers to their defaults? This cannot be undone."),
                        primaryButton: .default(Text("Confirm")){
                            minNumberInput = ""
                            maxNumberInput = ""
                            resetNumSet()
                            showResetPrompt = false
                        },
                        secondaryButton: .cancel()
                    )
                }
                Button(action:{
                    #if os(iOS)
                    playHaptics(engine: engine, intensity: 0.8, sharpness: 0.5, count: 0.1)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.click)
                    #endif
                    if(maxNumberInput == "" || minNumberInput == ""){
                        showAlert = true
                        alertTitle = "Missing numbers!"
                        alertMessage = "You must specify a minimum and maximum number!"
                    }
                    else {
                        settingsData.maxNumberDefault = Int(maxNumberInput)!
                        settingsData.minNumberDefault = Int(minNumberInput)!
                        showAlert = true
                        alertTitle = "Numbers Saved"
                        alertMessage = "Your new maximum and minimum numbers have been saved."
                    }
                }) {
                    Text("Save")
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
            DiceSettings()
            CardSettings()
            #if !os(watchOS)
            MarbleSettings()
            #endif
            Section(header: Text("Other")) {
                Button(action:{
                    #if os(iOS)
                    playHaptics(engine: engine, intensity: 0.8, sharpness: 0.5, count: 0.1)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.click)
                    #endif
                    showAdvSet = true
                }) {
                    #if os(iOS)
                    Text("Show Advanced Settings")
                    #endif
                    #if os(watchOS)
                    Text("Advanced Settings")
                    #endif
                }
                NavigationLink(destination: About()) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.accentColor)
                    Text("About RNGTool")
                }
            }
        }
        #if os(iOS)
        .onAppear { prepareHaptics(engine: &engine) }
        #endif
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAdvSet, content: {
            AdvancedSettingsView()
            #if os(watchOS)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { self.showAdvSet = false }
                }
            })
            #endif
        })
    }
}

struct AdvancedSettingsView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                AdvancedSettings()
            }
            #if os(iOS)
            .navigationBarTitle("Advanced Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
            #endif
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(SettingsData())
    }
}
