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
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    #elseif os(watchOS)
    @State private var kbReturnType = 0
    @State private var keyboardNumber = 0
    @State private var showNumKeyboard = false
    #endif
    @State private var showResetPrompt = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAdvSet = false
    
    var body: some View {
        Form {
            Section(header: Text("Number Settings"), footer: Text("The default maximum and minimum numbers when using Number Mode.")) {
                #if os(iOS)
                Text("Default Maximum Number")
                TextField(text: $maxNumberInput, prompt: Text("Required")) {
                    Text("Max Number")
                }
                .onChange(of: maxNumberInput) { maxNumberInput in
                    settingsData.maxNumberDefault = Int(maxNumberInput) ?? 100
                }
                Text("Default Minimum Number")
                TextField(text: $minNumberInput, prompt: Text("Required")) {
                    Text("Min Number")
                }
                .onChange(of: minNumberInput) { minNumberInput in
                    settingsData.minNumberDefault = Int(minNumberInput) ?? 0
                }
                .onAppear {
                    maxNumberInput = "\(settingsData.maxNumberDefault)"
                    minNumberInput = "\(settingsData.minNumberDefault)"
                }
                #elseif os(watchOS)
                Button(action: {
                    kbReturnType = 1
                    keyboardNumber = settingsData.maxNumberDefault
                    showNumKeyboard = true
                }) {
                    Text("Max: \(settingsData.maxNumberDefault)")
                }
                Button(action: {
                    kbReturnType = 2
                    keyboardNumber = settingsData.minNumberDefault
                    showNumKeyboard = true
                }) {
                    Text("Min: \(settingsData.minNumberDefault)")
                }
                .sheet(isPresented: $showNumKeyboard) {
                    NumKeyboard(targetNumber: $keyboardNumber)
                    .toolbar(content: {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { self.showNumKeyboard = false }
                        }
                    })
                    .toolbar(content: {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                if(kbReturnType == 1) {
                                    settingsData.maxNumberDefault = keyboardNumber
                                }
                                else if(kbReturnType == 2) {
                                    settingsData.minNumberDefault = keyboardNumber
                                }
                                self.showNumKeyboard = false
                            }
                        }
                    })
                }
                #endif
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
                            #if os(iOS)
                            maxNumberInput = "100"
                            minNumberInput = "0"
                            #elseif os(watchOS)
                            settingsData.maxNumberDefault = 100
                            settingsData.minNumberDefault = 0
                            #endif
                            showResetPrompt = false
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            DiceSettings()
            CardSettings()
            MarbleSettings()
            InterfaceSettings()
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
