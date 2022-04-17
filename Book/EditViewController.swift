//
//  EditViewController.swift
//  Book
//
//  Created by 相場智也 on 2021/09/08.
//

import UIKit
import AVFoundation
import Foundation

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var TitleNameTextField: UITextField!
    
    @IBOutlet weak var WriterNameTextField: UITextField!
    
    @IBOutlet weak var PublisherNameTextField: UITextField!
  
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var RefreshButton: UIButton!
    
    @IBOutlet weak var CommentTextView: UITextView!
    
    var target:Int = 0 //edit cell target
    
    var ids:[Int] = [] //id list
    var titles:[String] = [] //title list
    var writers:[String] = [] //writer list
    var publishers:[String] = [] //publisher list
    var images:[String] = [] //image list
    var comments:[String] = [] //comment list
    
    var imagepicker: UIImagePickerController!
    
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
        

        TitleNameTextField.text = titles[target]
        
        WriterNameTextField.text = writers[target]

        PublisherNameTextField.text = publishers[target]
        
        if images[target] != "" {
            ImageView.image = UIImage(contentsOfFile: images[target])
        }
        
        CommentTextView.text = comments[target]
        
        TitleNameTextField.delegate = self
        WriterNameTextField.delegate = self
        PublisherNameTextField.delegate = self
        
        //textView枠線
        CommentTextView.layer.cornerRadius = 5
 
        setupBarcodeCapture()
    }
    
    //リターンキーが押されたとき
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        
        // 次のTag番号を持っているテキストボックス&& uesrtextfieldtag未満であれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag){
            nextTextField.becomeFirstResponder()
        }
        
        //tileが入力されていたらボタンを有効にする
        if let textname = TitleNameTextField.text{
            if textname.count != 0{
                RefreshButton.isEnabled = true
            }else{
                RefreshButton.isEnabled = false
            }
        }
        
        return true
    }
    
    //入力中
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //tileが入力されていたらボタンを有効にする
        if let textname = TitleNameTextField.text{
            if textname.count != 0{
                RefreshButton.isEnabled = true
            }else{
                RefreshButton.isEnabled = false
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
                RefreshButton.isEnabled = true
            }else{
                RefreshButton.isEnabled = false
            }
        }
        
    }
    
    //画像選択時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //imageViewに選択した画像をセット
        ImageView.image = info[.originalImage] as? UIImage
        
        //フォトライブラリと閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //フォトライブラリのキャンセルボタンをクリック時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //フォトライブラリ閉じる
        picker.dismiss(animated: true, completion: nil)

    }
    
        
    
    @IBAction func RefreshAction(_ sender: UIButton) {
        
        //入力
    
        if TitleNameTextField.text != nil && TitleNameTextField.text?.count != 0 {
            titles[target] = TitleNameTextField.text!
        }
        
        if WriterNameTextField.text != nil && WriterNameTextField.text?.count != 0{
            writers[target] = WriterNameTextField.text!
        }
        
        if PublisherNameTextField != nil && PublisherNameTextField.text?.count != 0{
            publishers[target] = PublisherNameTextField.text!
        }
        
        
        //file
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        //admin
        var fileUrl = dir.appendingPathComponent("admin.txt")
        
        var originaltext = ""
        
        //write admin
        for i in 0 ..< ids.count {
            originaltext += ("\n" + String(ids[i]))
        }
        
        do {
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //write title
        fileUrl = dir.appendingPathComponent("title.txt")
        originaltext = ""
        
        for i in 0 ..< titles.count {
            if ids.firstIndex(of: i) == nil {continue}
            originaltext += ("\n" + String(i) + " " + titles[i])
        }
        
        do {
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        
        //write writer
        fileUrl = dir.appendingPathComponent("writer.txt")
        originaltext = ""
        for i in 0 ..< writers.count {
            if ids.firstIndex(of: i) == nil {continue}
            originaltext += ("\n" + String(i) + " " + writers[i])
        }
        
        do {
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //write publisher
        fileUrl = dir.appendingPathComponent("publisher.txt")
        originaltext = ""
        
        for i in 0 ..< publishers.count {
            if ids.firstIndex(of: i) == nil {continue}
            originaltext += ("\n" + String(i) + " " + publishers[i])
        }
        
        do {
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //imgae
        //元々存在していたら削除
        fileUrl = dir.appendingPathComponent(String(target) + ".jpeg")
        if UIImage(contentsOfFile: fileUrl.path) != nil {
            do {
                try FileManager.default.removeItem(at: fileUrl)
            }catch{
                print("Error: \(error)")
            }
        }
        
        //画像がセットされていたら保存
        if ImageView.image != nil {
            do {
                try ImageView.image?.jpegData(compressionQuality: 0.8)?.write(to: fileUrl)
            }catch{
                print("Error: \(error)")
            }
        }
        
        //alert
        let alert = UIAlertController(title: "更新完了", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    
        self.dismiss(animated: true, completion: nil)
        
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
            captureSession.startRunning()
        
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
            print(value)
        
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
                print(bookdata[0].summary.title)
                print(bookdata[0].summary.publisher)
                print(bookdata[0].summary.author)
                DispatchQueue.main.sync {
                    self.TitleNameTextField.text = bookdata[0].summary.title
                    self.WriterNameTextField.text = bookdata[0].summary.author
                    self.PublisherNameTextField.text = bookdata[0].summary.publisher
                    self.CommentTextView.text = bookdata[0].onix.CollateralDetail.TextContent[0].Text

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
