//
//  manageViewController.swift
//  Book
//
//  Created by 相場智也 on 2021/09/01.
//
//  本を管理する画面のContoroller

import UIKit

class manageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate  {

    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var PickerView: UIPickerView!
    
    @IBOutlet weak var UserView: UIView!
    
    
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
    
    fileprivate let refreshcontrol = UIRefreshControl()
    
    let searchcategorypickerlist = ["全て", "タイトル", "著者", "出版社", "コメント"]
    let sortcategorypickerlist = ["タイトル", "著者", "出版社"]
    let sortpickerlist = ["昇順", "降順"]
    var searchcategorypickertarget = 0
    var sortcategorypickertarget = 0
    var sortpickertarget = 0
    
    //表示するデータ
    var currentids:[Int] = []
    
    var ids:[Int] = [] //id list
    var titles:[String] = [] //title list
    var writers:[String] = [] //writer list
    var publishers:[String] = [] //publisher list 
    var borrowreturns:[Int] = [] //borrowreturn list -1:return usernum:borrow
    var images:[String] = [] //image list "":notexist url:exist
    var comments:[String] = [] //comment list
    
    //貸し借り状態を変える用
    var cells:[CollectionViewCell] = []
    var cellselected = 0 //選択したcell
    
    
    
    let userbuttontag = 1020 //buttontag start num
    let usertextfieldtag = 1040 //textfieldtag start num
    
    let usernum = 16 //ユーザ人数
    var users:[String] = [] //ユーザ名
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        PickerView.delegate = self
        PickerView.dataSource = self
        
        SearchBar.delegate = self
        
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
        
        //collectionview layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        CollectionView.collectionViewLayout = layout
        
        CollectionView.refreshControl = refreshcontrol
        refreshcontrol.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
        //data load
        reload()
    }
    
    //下すクロールすると更新する
    @objc func refresh(){
        reload()
        
        CollectionView.refreshControl?.endRefreshing()
        
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return searchcategorypickerlist.count
        case 1:
            return sortcategorypickerlist.count
        case 2:
            return sortpickerlist.count
        default:
            return 0
        }
        
    }
    
    // UIPickerViewの表示するもの
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var str = ""
        switch component {
        case 0:
            str = searchcategorypickerlist[row]
        case 1:
            str = sortcategorypickerlist[row]
        case 2:
            str = sortpickerlist[row]
        default:
            str = "error"
        }
        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            searchcategorypickertarget = row
        case 1:
            sortcategorypickertarget = row
        case 2:
            sortpickertarget = row
        default:
            break
        }
    }
    
    //表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentids.count // 表示するセルの数
    }
        
    //セルの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell else{
            fatalError("Dequeue failed: AnimalTableViewCell.")
        }
      
        //image
        if images[currentids[indexPath.row]] != "" {
            cell.ImageView.image = UIImage(contentsOfFile: images[currentids[indexPath.row]])
        }else{
            cell.ImageView.image = nil
        }
        
        //title
        cell.TitleTextView.text = titles[currentids[indexPath.row]]
        cell.TitleTextView.backgroundColor = .white
        cell.TitleTextView.textColor = .black
        //writer
        cell.WriterTextView.text = writers[currentids[indexPath.row]]
        cell.WriterTextView.backgroundColor = .white
        cell.WriterTextView.textColor = .black
    
        //publisher
        cell.PublisherTextView.text = publishers[currentids[indexPath.row]]
        cell.PublisherTextView.backgroundColor = .white
        cell.PublisherTextView.textColor = .black
        
        //comment
        cell.CommentTextView.text = comments[currentids[indexPath.row]]
        
        //借りる返すボタン
        if borrowreturns[currentids[indexPath.row]] != -1 {
            cell.BorrowerLabel.text = users[borrowreturns[currentids[indexPath.row]]]
            cell.BorrowerLabel.isHidden = false
            cell.BorrowReturnButton.setTitle("返す", for: .normal)
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 5
        }else{
            cell.BorrowerLabel.text = ""
            cell.BorrowerLabel.isHidden = true
            cell.BorrowReturnButton.setTitle("借りる", for: .normal)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 5
        }
        
        cell.BorrowReturnButton.tag = currentids[indexPath.row]
        cell.tag = currentids[indexPath.row]
        
    
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.delegate = self
        cell.addGestureRecognizer(longPressGesture)
        
        cell.CommentTextView.layer.borderColor = UIColor.black.cgColor
        cell.CommentTextView.layer.borderWidth = 1
        cell.CommentTextView.backgroundColor = .white
        cell.CommentTextView.textColor = .black
        
        cell.backgroundColor = .white  // セルの色
        cell.layer.cornerRadius = 5
        
        cells.append(cell)
        
        return cell
    }
    
    // Long Press イベント edit delete
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
      
        //長押し時
        if sender.state == .began {
          
            //アラート生成
            let alert: UIAlertController = UIAlertController(title: "選択してください", message:  "", preferredStyle:  UIAlertController.Style.alert)
            
            //編集選択
            let editaction: UIAlertAction = UIAlertAction(title: "編集", style: .default, handler:{
                
                (action: UIAlertAction!) -> Void in
                
                let idx = sender.view!.tag as Int
                
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EditView") as! EditViewController
                
                nextVC.target = idx
                nextVC.ids = self.ids
                nextVC.titles = self.titles
                nextVC.writers = self.writers
                nextVC.publishers = self.publishers
                nextVC.images = self.images
                nextVC.comments = self.comments
                
                self.present(nextVC, animated: true, completion: nil)
                            
            })
            
            //削除選択
            let deleteaction: UIAlertAction = UIAlertAction(title: "削除", style: .default, handler:{
                
                (action: UIAlertAction!) -> Void in
            
                
                let configalert: UIAlertController = UIAlertController(title: "本当に削除してもいいですか", message:  "", preferredStyle:  UIAlertController.Style.alert)
                
                let yesaction: UIAlertAction = UIAlertAction(title: "Yes", style: .default, handler:{
                    
                    (action: UIAlertAction!) -> Void in
                    
                    //削除
                    self.deleteAction(idx: sender.view!.tag as Int)
                    
                })
                
                configalert.addAction(yesaction)
                configalert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                    
                self.present(configalert, animated: true, completion: nil)
                
            })
        
            
            alert.addAction(editaction)
            alert.addAction(deleteaction)
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
            
        }
    
        
    }
    
    
    //layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    //uisearchbar 複数検索対応できたら
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        
        reload()
    
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

        return true
    }
    
    //UITextField以外の部分を押下時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //キーボード閉じる
        self.view.endEditing(true)
        
        if !UserView.isHidden {
            UserView.isHidden = true
        }
    }
    
    //ファイルからデータ入力
    func fileload(){
        //file
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        //admin
        var fileUrl = dir.appendingPathComponent("admin.txt")
        //not exist
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        //read
        ids = []
        do {
            let text = try String(contentsOf: fileUrl)
            let arr = text.components(separatedBy: "\n").filter{!$0.isEmpty}
            for tmp in arr {
                ids.append(Int(tmp)!)
            }
        } catch {
            print("Error: \(error)")
        }
        
        //title
        fileUrl = dir.appendingPathComponent("title.txt")
        //not exist
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        if ids.count != 0 {
            
            titles = []
            for _ in 0 ..< ids[ids.count - 1] + 1 { //adminが1からのため
                titles.append("")
            }
            
            do {
                let text = try String(contentsOf: fileUrl)
                let arr = text.components(separatedBy: "\n").filter{!$0.isEmpty}

                for tmp in arr {
                    let split = tmp.components(separatedBy: " ")
                    let idx = Int(split[0])!
                    var value = ""
                    for i in 1 ..< split.count - 1{
                        value += (split[i] + " ")
                    }
                    value += (split[split.count - 1])
                    
                    titles[idx] = value
                }
            } catch {
                print("Error: \(error)")
            }
            
        
            //writer
            fileUrl = dir.appendingPathComponent("writer.txt")
            //not exist
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
            }
            
            writers = []
            for _ in 0 ..< ids[ids.count - 1] + 1 { //adminが1からのため
                writers.append("")
            }
            
            do {
                let text = try String(contentsOf: fileUrl)
                let arr = text.components(separatedBy: "\n").filter{!$0.isEmpty}

                for tmp in arr {
                    let split = tmp.components(separatedBy: " ")
                    let idx = Int(split[0])!
                    var value = ""
                    for i in 1 ..< split.count - 1{
                        value += (split[i] + " ")
                    }
                    value += (split[split.count - 1])
                    
                    writers[idx] = value
                }
            } catch {
                print("Error: \(error)")
            }
            
            //publisher
            fileUrl = dir.appendingPathComponent("publisher.txt")
            //not exist
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
            }
            
            publishers = []
            for _ in 0 ..< ids[ids.count - 1] + 1 { //adminが1からのため
                publishers.append("")
            }
            
            do {
                let text = try String(contentsOf: fileUrl)
                let arr = text.components(separatedBy: "\n").filter{!$0.isEmpty}

                for tmp in arr {
                    let split = tmp.components(separatedBy: " ")
                    let idx = Int(split[0])!
                    var value = ""
                    for i in 1 ..< split.count - 1{
                        value += (split[i] + " ")
                    }
                    value += (split[split.count - 1])
                    
                    publishers[idx] = value
                }
            } catch {
                print("Error: \(error)")
            }
            
            //borrowreturn
            fileUrl = dir.appendingPathComponent("borrowreturn.txt")
            //not exist
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
            }
            
            borrowreturns = []
            for _ in 0 ..< ids[ids.count - 1] + 1 { //adminが1からのため
                borrowreturns.append(0)
            }
            
            do {
                let text = try String(contentsOf: fileUrl)
                let arr = text.components(separatedBy: "\n").filter{!$0.isEmpty}

                for tmp in arr {
                    let split = tmp.components(separatedBy: " ")
                    let idx = Int(split[0])!
                    let flg = Int(split[1])!
                    if flg == 1 {
                        borrowreturns[idx] = Int(split[2])!

                    }else{
                        borrowreturns[idx] = -1
                    }
                }
            }catch {
                print("Error: \(error)")
            }
            
            //user file
            fileUrl = dir.appendingPathComponent("user.txt")
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
            
            do {
                let tmp = try String(contentsOf: fileUrl)
                users = tmp.components(separatedBy: "\n").filter{!$0.isEmpty}
            } catch {
                print("Error: \(error)")
            }
            
            
            //Image
            images = []
            for _ in 0 ..< ids[ids.count - 1] + 1 { //adminが1からのため
                images.append("")
            }
            
            for i in 0 ..< ids.count {
                fileUrl = dir.appendingPathComponent(String(ids[i]) + ".jpeg")
                if UIImage(contentsOfFile: fileUrl.path) != nil {
                    images[ids[i]] = fileUrl.path
                }
            }
            
            //Comment
            comments = []
            for _ in 0 ..< ids[ids.count - 1] + 1 {
                comments.append("")
            }
            
            for i in 0 ..< ids.count {
                fileUrl = dir.appendingPathComponent(String(ids[i]) + ".txt")
                do {
                    comments[ids[i]] = try String(contentsOf: fileUrl)
                }catch {
                }
            }
            
        }
        
    }
    
    func display(){
        
        currentids = []
        
        if ids.count != 0 {
            //検索入力ない
            if SearchBar.text == nil || SearchBar.text! == "" {
                currentids = ids
            }else{
                if searchcategorypickertarget == 0{
                    var idx = Array(repeating: false, count: ids[ids.count - 1] + 1)
                    for i in 0 ..< titles.count {
                        if titles[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                    }
                    
                    for i in 0 ..< titles.count {
                        if writers[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                        
                        
                    }
                    
                    for i in 0 ..< publishers.count {
                        if publishers[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                    }
                    
                    for i in 0 ..< comments.count {
                        if comments[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                    }
                    
                    for i in 0 ..< idx.count{
                        if idx[i] {
                            currentids.append(i)
                        }
                    }
                }
                //title
                if searchcategorypickertarget == 1{
                    var idx = Array(repeating: false, count: ids[ids.count - 1] + 1)
                    for i in 0 ..< titles.count {
                        if titles[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                    }
                    for i in 0 ..< idx.count{
                        if idx[i] {
                            currentids.append(i)
                        }
                    }
                }
                
                //writer
                if searchcategorypickertarget == 2{
                    var idx = Array(repeating: false, count: ids[ids.count - 1] + 1)
                    for i in 0 ..< titles.count {
                        if writers[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                    }
                    for i in 0 ..< idx.count{
                        if idx[i] {
                            currentids.append(i)
                        }
                    }
                }
                
                //publisher
                if searchcategorypickertarget == 3{
                    var idx = Array(repeating: false, count: ids[ids.count - 1] + 1)
                    for i in 0 ..< publishers.count {
                        if publishers[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                    }
                    for i in 0 ..< idx.count{
                        if idx[i] {
                            currentids.append(i)
                        }
                    }
                }
                
                //comment
                if searchcategorypickertarget == 4{
                    var idx = Array(repeating: false, count: ids[ids.count - 1] + 1)
                    for i in 0 ..< comments.count {
                        if comments[i].lowercased().contains(SearchBar.text!.lowercased()) {
                            idx[i] = true
                        }
                    }
                    for i in 0 ..< idx.count{
                        if idx[i] {
                            currentids.append(i)
                        }
                    }
                }
                
                
            }
            
            //sort element
            var tmp:[String]
            
            switch (sortcategorypickertarget, sortpickertarget) {
            case (0, 0):
                tmp = titles.sorted{ $0.localizedStandardCompare($1) == .orderedAscending}
            case (0, 1):
                tmp = titles.sorted{ $0.localizedStandardCompare($1) == .orderedDescending}
            case (1, 0):
                tmp = writers.sorted{ $0.localizedStandardCompare($1) == .orderedAscending}
            case (1, 1):
                tmp = writers.sorted{ $0.localizedStandardCompare($1) == .orderedDescending}
            case (2, 0):
                tmp = publishers.sorted{ $0.localizedStandardCompare($1) == .orderedAscending}
            case (2, 1):
                tmp = publishers.sorted{ $0.localizedStandardCompare($1) == .orderedDescending}
            default :
                print("error")
                tmp = titles.sorted{ $0.localizedStandardCompare($1) == .orderedAscending}
            }
            
            var tmpids:[Int] = []
            
            //sort index
            switch (sortcategorypickertarget) {
            case (0):
                //title
                for i in 0 ..< tmp.count {
                    for j in 0 ..< titles.count {
                        if tmp[i] == titles[j] && tmpids.firstIndex(of: j) == nil && currentids.firstIndex(of: j) != nil {
                            tmpids.append(j)
                        }
                    }
                }
            case (1):
                //writer
                for i in 0 ..< tmp.count {
                    for j in 0 ..< writers.count{
                        if tmp[i] == writers[j] && tmpids.firstIndex(of: j) == nil && currentids.firstIndex(of: j) != nil {
                            tmpids.append(j)
                        }
                    }
                }
                
            case (2):
                //publisher
                for i in 0 ..< tmp.count {
                    for j in 0 ..< publishers.count {
                        if tmp[i] == publishers[j] && tmpids.firstIndex(of: j) == nil && currentids.firstIndex(of: j) != nil {
                            tmpids.append(j)
                        }
                    }
                }
        
            default :
                print("error")
            }
            
            currentids = tmpids
           
            cells = []
            CollectionView.reloadData()
        }
    }
    
    
    
    
    
    @IBAction func BorrowReturnAction(_ sender: UIButton) {
        
        let buttontitle = sender.currentTitle!
        
        if buttontitle as String == "返す" {
            
            //borrowreturnsを変更する
            borrowreturns[sender.tag] = -1
            
            //file
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //borrowreturn
            let fileUrl = dir.appendingPathComponent("borrowreturn.txt")
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
            }
        
            var tmp = ""
        
            
            //write borrowreturn
            for i in 0 ..< ids[ids.count - 1] + 1 {
                
                if ids.firstIndex(of: i) == nil {continue}
                
                if borrowreturns[i] == -1 {
                    tmp += ("\n" + String(i) + " 0 ")
                }else {
                    tmp += ("\n" + String(i) + " 1 " + String(borrowreturns[i]))
                }
            }
            
            do {
                try tmp.write(to: fileUrl, atomically: false, encoding: .utf8)
            } catch {
                print("Error: \(error)")
            }
            
            for i in 0 ..< cells.count {
                if cells[i].tag == sender.tag {
                    cells[i].BorrowerLabel.text = ""
                    cells[i].BorrowerLabel.isHidden = true
                    cells[i].BorrowReturnButton.setTitle("借りる", for: .normal)
                    cells[i].layer.borderColor = UIColor.lightGray.cgColor
                    cells[i].layer.borderWidth = 5
                    break
                }
            }
            
            //alert
            let alert = UIAlertController(title: "返しました", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        if buttontitle as String == "借りる" {
            
            cellselected = sender.tag
            //usertableを表示する
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
            
            UserView.isHidden = false
            
            
        }
        
    }
    
    @IBAction func UserAction(_ sender: UIButton) {
        
        //借りるボタンを押し、ユーザを選択した
        borrowreturns[cellselected] = sender.tag - userbuttontag
        
        
        //file
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //borrowreturn
        let fileUrl = dir.appendingPathComponent("borrowreturn.txt")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
    
        var tmp = ""
        
        //write borrowreturn
        for i in 0 ..< ids[ids.count - 1] + 1 {
            
            if ids.firstIndex(of: i) == nil {continue}
            
            if borrowreturns[i] == -1 {
                tmp += ("\n" + String(i) + " 0 ")
            }else {
                tmp += ("\n" + String(i) + " 1 " + String(borrowreturns[i]))
            }
            
        }
        
        
        do {
            try tmp.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }

        for i in 0 ..< cells.count {
            if cells[i].tag == cellselected {
                cells[i].BorrowerLabel.text = users[sender.tag - userbuttontag]
                cells[i].BorrowerLabel.isHidden = false
                cells[i].BorrowReturnButton.setTitle("返す", for: .normal)
                cells[i].layer.borderColor = UIColor.black.cgColor
                cells[i].layer.borderWidth = 5
                break
            }
        }
        
        //usertableを非表示に
        UserView.isHidden = true
        
        //alert
        let alert = UIAlertController(title: "借りました", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func reload() {
        fileload()
        display()
    }
    
    //削除を選択したとき
    func deleteAction(idx: Int){
        
        //file
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var fileUrl = dir.appendingPathComponent("admin.txt")
        
        var originaltext = ""
        
        //write admin
        for i in 0 ..< ids.count {
            if ids[i] != idx {
                originaltext += ("\n" + String(ids[i]))
            }
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
            if i == idx {continue}
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
            if i == idx {continue}
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
            if i == idx {continue}
            originaltext += ("\n" + String(i) + " " + publishers[i])
        }
        
        do {
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        
        //write borrowreturns
        fileUrl = dir.appendingPathComponent("borrowreturn.txt")
        originaltext = ""
        
        for i in 0 ..< borrowreturns.count {
            if ids.firstIndex(of: i) == nil {continue}
            if i == idx {continue}
            if borrowreturns[i] == -1 {
                originaltext += ("\n" + String(i) + " 0 ")
            }else {
                originaltext += ("\n" + String(i) + " 1 " + String(borrowreturns[i]))
            }
        }
    
        do {
            try originaltext.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        //images
        fileUrl = dir.appendingPathComponent(String(idx) + ".jpeg")
        if UIImage(contentsOfFile: fileUrl.path) != nil {
            do {
                try FileManager.default.removeItem(at: fileUrl)
            }catch{
                print("Error: \(error)")
            }
        }
        
        reload()
        
    }

}
