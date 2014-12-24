//
//  CentralManager.swift
//  NexturnController
//
//  Created by Y.K on 2014/12/24.
//  Copyright (c) 2014年 Yokoyama Kengo. All rights reserved.
//

import Foundation
import CoreBluetooth

class CentralManager: CBCentralManager, CBCentralManagerDelegate {
    private var nexturnObject = NexturnObject()
    
    override init(delegate: CBCentralManagerDelegate!, queue: dispatch_queue_t!, options: [NSObject : AnyObject]!) {
        super.init(delegate: delegate, queue: queue, options: options)
        self.delegate = self
    }
    
    // MARK: - CBCentralManager Delegate Method
    // CBCentralManagerのステータス更新後に呼ばれる
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch central.state {
        case .PoweredOn:
            let options = ["CBCentralManagerScanOptionAllowDuplicatesKey" : true]
            scanForPeripheralsWithServices(nil, options: options)
        default:
            break
        }
    }
    
    // ペリフェラル発見時に呼ばれる
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        switch peripheral.name {
        case nexturnObject.kNexturnName:
            peripheral.delegate = nexturnObject
            nexturnObject.peripheral = peripheral
            connectPeripheral(nexturnObject.peripheral, options: nil)
        default:
            break
        }
    }
    
    // ペリフェラルと接続後に呼ばれる
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        switch peripheral.name {
        case nexturnObject.kNexturnName:
            let UUID = CBUUID(string: nexturnObject.kNexturnLEDServiceUUID)
            nexturnObject.peripheral?.discoverServices([UUID])
            stopScan()
        default:
            break
        }
    }
    
    // MARK: - Call from IBAction
    // 押されたボタンに対応したデータを渡す
    func ledButtonTapped(tag: NSInteger) {
        nexturnObject.ledButtonTapped(tag)
    }
}