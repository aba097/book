//
//  RegisterViewController.swift
//  Book
//
//  Created by 相場智也 on 2021/09/01.
//

import UIKit
import AVFoundation
import Foundation

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var TitleNameTextField: UITextField!
    
    @IBOutlet weak var WriterNameTextField: UITextField!
    
    @IBOutlet weak var PublisherNameTextField: UITextField!
  
    
    @IBOutlet weak var User0TextField: UITextField!
    @IBOutlet weak var User1TextField: UITextField!
    @IBOutlet weak var User2TextField: UITextField!
    @IBOutlet weak var User3TextField: UITextField!
    @IBOutlet weak var User4TextField: UITextField!
    @IBOutlet weak var User5TextField: UITextField!
    @IBOutlet weak var User6TextField: UITextField!
    @IBOutlet weak var User7TextField: UITextField!
    @IBOutlet weak var User8TextField: UITextField!
    @IBOutlet weak var User9TextField: UITextField!
    @IBOutlet weak var User10TextField: UITextField!
    @IBOutlet weak var User11TextField: UITextField!
    @IBOutlet weak var User12TextField: UITextField!
    @IBOutlet weak var User13TextField: UITextField!
    @IBOutlet weak var User14TextField: UITextField!
    @IBOutlet weak var User15TextField: UITextField!
    
    
    @IBOutlet weak var ImageView: UIImageView!
    
    
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var CheckButton: UIButton!
    
    @IBOutlet weak var UserView: UIView!
    
    @IBOutlet weak var TextView: UITextView!
    
    let userbuttontag = 20 //buttontag start num
    let usertextfieldtag = 40 //textfieldtag start num
    
    let usernum = 16 //ユーザ人数
    var users:[String] = [] //ユーザ名
    var borrowchecked = false //借りるボタン
    var userselected = 0 //選択したユーザ
    
    var imagepicker: UIImagePickerController! //フォトライブラリ操作
    
    
    @IBOutlet weak var CaptureView: UIView!
    
    private lazy var captureSession: AVCaptureSession = AVCaptureSession()
    private lazy var captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    private lazy var capturePreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return layer
    }()
        
    private var captureInput: AVCaptureInput? = nil
    private lazy var Output: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: .main)
        return output
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user file
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileUrl = dir.appendingPathComponent("user.txt")
        //not exist
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
            var users = ""
            for i in 0 ..< usernum {
                users += ("user" + String(i) + "\n")
            }
            do {
                try users.write(to: fileUrl, atomically: false, encoding: .utf8)
            } catch {
                print("Error: \(error)")
            }
        }
        
        TitleNameTextField.delegate = self
        WriterNameTextField.delegate = self
        PublisherNameTextField.delegate = self
        
        User0TextField.delegate = self
        User1TextField.delegate = self
        User2TextField.delegate = self
        User3TextField.delegate = self
        User4TextField.delegate = self
        User5TextField.delegate = self
        User6TextField.delegate = self
        User7TextField.delegate = self
        User8TextField.delegate = self
        User9TextField.delegate = self
        User10TextField.delegate = self
        User11TextField.delegate = self
        User12TextField.delegate = self
        User13TextField.delegate = self
        User14TextField.delegate = self
        User15TextField.delegate = self
        
        User0TextField.textAlignment = .center
        User1TextField.textAlignment = .center
        User2TextField.textAlignment = .center
        User3TextField.textAlignment = .center
        User4TextField.textAlignment = .center
        User5TextField.textAlignment = .center
        User6TextField.textAlignment = .center
        User7TextField.textAlignment = .center
        User8TextField.textAlignment = .center
        User9TextField.textAlignment = .center
        User10TextField.textAlignment = .center
        User11TextField.textAlignment = .center
        User12TextField.textAlignment = .center
        User13TextField.textAlignment = .center
        User14TextField.textAlignment = .center
        User15TextField.textAlignment = .center

        
        TextView.layer.cornerRadius = 5
        CheckButton.layer.cornerRadius = 5
        CheckButton.layer.borderColor = UIColor.black.cgColor
        CheckButton.layer.borderWidth = 1
        
        setupBarcodeCapture()

    }
    
    //リターンキーが押されたとき
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        
        //ユーザネーム変更の場合
        if usertextfieldtag <= textField.tag && textField.tag < usertextfieldtag + usernum {
            
            users[textField.tag - usertextfieldtag] = textField.text!
            
            //write to user file
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = dir.appendingPathComponent("user.txt")
            var tmp = ""
            for i in 0 ..< usernum {
                tmp += (users[i] + "\n")
            }
            do {
                try tmp.write(to: fileUrl, atomically: false, encoding: .utf8)
            } catch {
                print("Error: \(error)")
            }
        }
        
        // 次のTag番号を持っているテキストボックス&& uesrtextfieldtag未満であれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag){
            if nextTag < usertextfieldtag {
                nextTextField.becomeFirstResponder()
            }
        }
        
        //tileが入力されていたらボタンを有効にする
        if let textname = TitleNameTextField.text{
            if textname.count != 0{
                RegisterButton.isEnabled = true
            }else{
                RegisterButton.isEnabled = false
            }
        }
        
        return true
    }
    
    //入力中
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //tileが入力されていたらボタンを有効にする
        if let textname = TitleNameTextField.text{
            if textname.count != 0{
                RegisterButton.isEnabled = true
            }else{
                RegisterButton.isEnabled = false
            }
        }
        return true
    }
    
    //UITextField以外の部分を押下時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //キーボード閉じる
        self.view.endEditing(true)
        
        //tileが入力されていたらボタンを有効にする
        if let textname = TitleNameTextField.text{
            if textname.count != 0{
                RegisterButton.isEnabled = true
            }else{
                RegisterButton.isEnabled = false
            }
        }
    }
    
    
    //登録する
    @IBAction func RegisterAction(_ sender: Any) {
        //入力
        var title = ""
        var writer = ""
        var publisher = ""
        var id = 0
        
        if TitleNameTextField.text != nil && TitleNameTextField.text?.count != 0 {
            title = TitleNameTextField.text!
        }
        
        if WriterNameTextField.text != nil && WriterNameTextField.text?.count != 0{
            writer = WriterNameTextField.text!
        }
        
        if PublisherNameTextField != nil && PublisherNameTextField.text?.count != 0{
            publisher = PublisherNameTextField.text!
        }

        //file
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var originaltext = ""
        
        //admin
        var fileUrl = dir.appendingPathComponent("admin.txt")
        //not exist
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
       
    
        //read
        do {
            originaltext = try String(contentsOf: fileUrl)
            if originaltext == "" {
                id = 0
            }else {
                let tmp = originaltext.components(separatedBy: "\n").filter{!$0.isEmpty}
                id = Int(tmp[tmp.count - 1])! + 1
            }
        } catch {
            print("Error: \(error)")
        }
        
        //write 上書き
        do {
            originaltext = originaltext + "\n" + String(id)
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //title
        fileUrl = dir.appendingPathComponent("title.txt")
        //not exist
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        //read
        do {
            originaltext = try String(contentsOf: fileUrl)
        } catch {
            print("Error: \(error)")
        }
        
        //write 上書き
        do {
            originaltext = originaltext + "\n" + String(id) + " " + title
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //writer
        fileUrl = dir.appendingPathComponent("writer.txt")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        do {
            originaltext = try String(contentsOf: fileUrl)
        } catch {
            print("Error: \(error)")
        }
        
        do {
            originaltext = originaltext + "\n" + String(id) + " " + writer
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //publisher
        fileUrl = dir.appendingPathComponent("publisher.txt")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        do {
            originaltext = try String(contentsOf: fileUrl)
        } catch {
            print("Error: \(error)")
        }
        
        do {
            originaltext = originaltext + "\n" + String(id) + " " + publisher
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //borrowreturn
        fileUrl = dir.appendingPathComponent("borrowreturn.txt")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        do {
            originaltext = try String(contentsOf: fileUrl)
        } catch {
            print("Error: \(error)")
        }
        
        do {
            if borrowchecked {
                originaltext = originaltext + "\n" + String(id) + " 1 " + String(userselected)
            }else {
                originaltext = originaltext + "\n" + String(id) + " 0 "
            }
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //UIImage
        //画像がセットされていたら保存
        if ImageView.image != nil {
            fileUrl = dir.appendingPathComponent(String(id) + ".jpeg")
            //画像保存
            do {
                try ImageView.image?.jpegData(compressionQuality: 0.8)?.write(to: fileUrl)
            }catch{
                print("Error: \(error)")
            }
        }
        
        //TextView
        //コメントがなくても保存するようにする
        //コメントがあったら保存
        if TextView.text! != "" {
            fileUrl = dir.appendingPathComponent(String(id) + ".txt")
            do {
                try TextView.text!.write(to: fileUrl, atomically: false, encoding: .utf8)
            }catch {
                print("Error: \(error)")
            }
        }
    

        //alert
        let alert = UIAlertController(title: "登録完了", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func CheckAction(_ sender: UIButton) {
        borrowchecked = !borrowchecked
        
        if borrowchecked {
            CheckButton.setTitle("✔️", for: .normal)
            UserView.isHidden = false
            
            //初期値として、左上のユーザを選択していることにする
            userselected = 0
            
            //初期値として、左上のユーザを選択した状態にしておく
            for i in userbuttontag ..< userbuttontag + usernum {
           
                let button = UserView.viewWithTag(i) as! UIButton
                
                if i == userbuttontag {
                    button.isSelected = true
                    button.backgroundColor = .black
                }else{
                    button.isSelected = false
                    button.backgroundColor = .lightGray
                }
            }
            
            //user.textからユーザ名読み込み、textfieldに追加
            //user name read -> users
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = dir.appendingPathComponent("user.txt")
            do {
                let tmp = try String(contentsOf: fileUrl)
                users = tmp.components(separatedBy: "\n").filter{!$0.isEmpty}
            } catch {
                print("Error: \(error)")
            }
            
            //textfieldにユーザネーム追加
            for i in usertextfieldtag ..< usertextfieldtag + usernum {
           
                let textfield =  UserView.viewWithTag(i) as! UITextField
                textfield.text = users[i - usertextfieldtag]
            }
            
        }
        
        if !borrowchecked {
            CheckButton.setTitle("", for: .normal)
            UserView.isHidden = true
        }
    }
    
    
    @IBAction func UserAction(_ sender: UIButton) {
        
        //選択したユーザ
        userselected = sender.tag - userbuttontag
       
        //どれか一個は必ず選択するように
        if !sender.isSelected {
            //ひとつのみ選択可能にする
            for i in userbuttontag ..< userbuttontag + usernum {
           
                let button = UserView.viewWithTag(i) as! UIButton
               
                button.isSelected = false
                button.backgroundColor = .lightGray
            }
            
            sender.isSelected = true
            sender.backgroundColor = .black
        }
    }
    
    //画像アップロード時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        ImageView.image = info[.originalImage] as? UIImage
        //フォトライブラリと閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //フォトライブラリのキャンセルボタンをクリック時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //フォトライブラリ閉じる
        picker.dismiss(animated: true, completion: nil)

    }
    
    //写真アップロードボタン
    @IBAction func PhotoButtonAction(_ sender: UIButton) {
        
        imagepicker = UIImagePickerController()
        
        //アラート生成
        let alert: UIAlertController = UIAlertController(title: "選択してください", message:  "", preferredStyle:  UIAlertController.Style.alert)
        
        let cameraaction: UIAlertAction = UIAlertAction(title: "カメラを起動", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            
           
            self.imagepicker.sourceType = .camera
            self.imagepicker.delegate = self
            self.present(self.imagepicker, animated: true)
        })
        
        let libraryaction: UIAlertAction = UIAlertAction(title: "フォトライブラリを起動", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.imagepicker.sourceType = .photoLibrary
            self.imagepicker.delegate = self
            self.present(self.imagepicker, animated: true)
        })
        
        alert.addAction(cameraaction)
        alert.addAction(libraryaction)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        //alert表示
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //バーコード
    func setupBarcodeCapture() {
        do {
            captureInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureInput!)
            captureSession.addOutput(Output)
            Output.metadataObjectTypes = Output.availableMetadataObjectTypes
            capturePreviewLayer.frame = self.CaptureView?.bounds ?? CGRect.zero
            capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            capturePreviewLayer.connection?.videoOrientation = .landscapeRight
            CaptureView?.layer.addSublayer(capturePreviewLayer)
            //captureSession.startRunning()
        
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    //バーコード読み取り
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        self.captureSession.stopRunning()
        
        let objects = metadataObjects
        var detectionString: String? = nil
        let barcodeTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13]
        for metadataObject in objects {
            loop: for type in barcodeTypes {
                guard metadataObject.type == type else { continue }
                guard self.capturePreviewLayer.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                    detectionString = object.stringValue
                    break loop
                }
            }
    
            guard let value = detectionString else { continue }

            getBookData(isbn: value)
            
        }
        self.captureSession.startRunning()
    }

    //OpenDBAPIを使用して図書データ取得
    func getBookData(isbn: String) {
    
        let baseUrlString = "https://api.openbd.jp/v1/"
        let searchUrlString = "\(baseUrlString)get"
        let searchUrl = URL(string: searchUrlString)!
        guard var components = URLComponents(url: searchUrl, resolvingAgainstBaseURL: searchUrl.baseURL != nil) else {
            return
        }
        
        components.queryItems = [URLQueryItem(name: "isbn", value: isbn)]
        
        var request = URLRequest(url: components.url!)
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
 
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                return
            }
            
            do {
                let bookdata:[Isbn] = try JSONDecoder().decode([Isbn].self, from: data)
                DispatchQueue.main.sync {
                    self.TitleNameTextField.text = bookdata[0].summary.title
                    self.WriterNameTextField.text = bookdata[0].summary.author
                    self.PublisherNameTextField.text = bookdata[0].summary.publisher
                    self.TextView.text = bookdata[0].onix.CollateralDetail.TextContent[0].Text
                    if bookdata[0].summary.cover != "" {
                        let url = URL(string: bookdata[0].summary.cover)
                        do {
                            let data = try Data(contentsOf: url!)
                            self.ImageView.image = UIImage(data: data)!
                        } catch let err {
                            print("Error : \(err.localizedDescription)")
                        }
                    }else{
                        self.ImageView.image = nil
                    }
                    //登録ボタンを押せるように
                    self.RegisterButton.isEnabled = true
                }
            } catch let error {
                print("Error: \(error)")
            }
            
        }.resume()
    }

    @IBAction func BarcodeAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            CaptureView.isHidden = false
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        }else{
            CaptureView.isHidden = true
            if captureSession.isRunning {
                captureSession.stopRunning()
            }
        }
    }
    
}
