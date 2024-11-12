//
//  AirFogStore.swift
//  AirGuard (iOS)
//
//  Created by Leonid Liadveikin on 04.11.24.
//

import Foundation
import CoreBluetooth

class AirFogStore: ObservableObject {
    
    let airFogService: AirFogService
    
    init(airFogService: AirFogService = AirFogService()) {
        self.airFogService = airFogService
    }
    
    func send(location: ClusteredLocation, tracker: BaseDevice, bluetoothData: BluetoothTempData) {
        print(bluetoothData.advertisementData_background)
        var advData = Data()
        if bluetoothData.advertisementData_background[CBAdvertisementDataIsConnectable] as? Int == 1 {
            advData.append(contentsOf: [0x02, 0x01, 0x06])
        }
  
        advData.append(contentsOf: [0x03, 0x03])
        advData.append(contentsOf: tracker.getType.constants.hexOfferedService)
//        getServiceDataKeys(advertisementData: bluetoothData.advertisementData_background).forEach { key in
//            guard let hexKey = key.hexadecimal else {
//                return
//            }
//            
//            advData.append(contentsOf: [
//                UInt8(hexKey.count + 1),
//                0x03
//            ])
//            advData.append(hexKey)
//        }
                                            
        if let service = tracker.getType.constants.offeredService {
            let servData = bluetoothData.advertisementData_background[CBAdvertisementDataServiceDataKey]
            
            if let servData = servData as? [CBUUID : Data],
                let data = servData[CBUUID(string: service)] {

                advData.append(contentsOf: [UInt8(data.count + 1), 0x16])
                advData.append(contentsOf: tracker.getType.constants.hexOfferedService)
                advData.append(data)
            }
        }
        
        print(advData.hexEncodedString())
        Task {
            
            let airFog = AirFog(deviceId: bluetoothData.peripheral_background!.identifier, macAddress: nil,
                                location: AirLocation(latitude: location.location.latitude, longitude: location.location.longitude),
                                advertisementData: advData)
            
            try! await airFogService.postAirFog(airFog)
        }
    }
}
