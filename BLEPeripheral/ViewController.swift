//
//  ViewController.swift
//  FlxTransmit
//
//  Created by GENKIFUJIMOTO on 2022/10/04.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,CBPeripheralManagerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var inputTextFIeld: UITextField!
    @IBOutlet weak var transmitBtn: UIButton!
    
    var serviceUUID : CBUUID!
    var characteristicUUID : CBUUID!
    
    var service : CBMutableService!
    var manager : CBPeripheralManager!
    var characteristic : CBMutableCharacteristic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UUID
        self.serviceUUID = CBUUID(string: "01000001-9da6-39a1-ab4d-172b698fe6c2")
        //サービス登録
        self.service = CBMutableService(type: self.serviceUUID, primary: true)
        //マネジャー登録
        self.manager = CBPeripheralManager(delegate : self,queue : nil,options: nil)
        
        //テキストフィールドデリゲートの設定
        self.inputTextFIeld.delegate = self
        
        //キーボードタイプ数字
        inputTextFIeld.keyboardType = UIKeyboardType.numberPad
        
        //ボタン有効
        transmitBtn.isEnabled = true
    }

    //Bloothool設定状態確認
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOn {
            print("状態ON")
        }
    }
    
    
    //=======================
    //MARK: ボタンアクション
    //=======================
    
    //Bloothoolで文字を送信
    @IBAction func transmitText(_ sender: Any) {
        
        //ボタン非有効
        transmitBtn.isEnabled.toggle()
        
        //入力した値
        let inputText = inputTextFIeld.text!
        print("入力した値====\(inputText)")
        
        //入力した値を送信
        self.manager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [self.service.uuid],
                                       CBAdvertisementDataLocalNameKey: inputText])
        //1秒後停止
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.stopAdvertising()
            //ボタン有効
            self.transmitBtn.isEnabled.toggle()
        }
    }
    
    //=======================
    //MARK: キーボード
    //=======================
    //キーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    //キーボード閉じる
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //キーボード閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputTextFIeld.endEditing(true)
    }

}

