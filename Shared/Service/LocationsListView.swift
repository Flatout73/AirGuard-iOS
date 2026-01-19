//
//  LocationsListView.swift
//  AirGuard (iOS)
//
//  Created by Leonid Liadveikin on 04.11.24.
//

import SwiftUI

struct LocationsListView: View {
    let locations: [ClusteredLocation]
    
    @StateObject
    var airFogStore = AirFogStore()
    
    @ObservedObject
    var blueoothData: BluetoothTempData
    @ObservedObject
    var tracker: BaseDevice
    
    @State
    var statusText: String?
    
    var body: some View {
        List {
            Section(header: Text("Service")) {
                let string = airFogStore.advDataService(tracker: tracker).hexEncodedString()
                if string.isEmpty {
                    Text("No data")
                } else {
                    Text(string)
                }
            }
            
            Section(header: Text("Locations")) {
                ForEach(locations, id: \.startDate) { location in
                    HStack {
                        Text(location.location.latitude.description + ", " + location.location.longitude.description)
                        
                        Spacer()
                        
                        Button(action: {
                            do {
                                try airFogStore.send(location: location, tracker: tracker, bluetoothData: blueoothData)
                                statusText = "AirFog sent"
                            } catch {
                                statusText = error.localizedDescription
                            }
                        }) {
                            Text("Send AirFog")
                        }
                    }
                }
            }
            
            if let statusText {
                Text(statusText)
            }
        }
        .navigationTitle("AirFog")
    }
}

//#Preview {
//    LocationsListView()
//}
