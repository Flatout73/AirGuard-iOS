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
    
    var body: some View {
        List {
            ForEach(locations, id: \.startDate) { location in
                HStack {
                    Text(location.location.latitude.description + ", " + location.location.longitude.description)
                    
                    Button(action: {
                        airFogStore.send(location: location, tracker: tracker, bluetoothData: blueoothData)
                    }) {
                        Text("Send AirFog")
                    }
                }
            }
        }
    }
}

//#Preview {
//    LocationsListView()
//}
