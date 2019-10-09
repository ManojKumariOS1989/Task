//
//  ViewController.swift
//  Collection_View
//
//  Created by Practice on 04/10/19.
//  Copyright © 2019 Practice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var viewStyleButton: UIBarButtonItem!
    
    @IBOutlet var tablelist:UITableView!
    @IBOutlet var checkcollection:UICollectionView!
    @IBOutlet var popupcollection:UICollectionView!
    @IBOutlet var popupView:UIView!
    var sizeVal = 0
    
    //MARK: Data Types
    let imageCache = NSCache<NSString, UIImage>()
    var arrCount:Int!
    var dataArray:[DataModel] = []
    var arrResult = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tablelist.isHidden = true
        self.checkcollection.isHidden = false
        tablelist.estimatedRowHeight = 1000
        tablelist.rowHeight = UITableView.automaticDimension
        sizeVal = Int(self.checkcollection.frame.size.width/2.2)
        getNewsResult()
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "LOG OUT", message: "ARE YOU SURE WANT TO LOGOUT?", preferredStyle: .alert)
       
        alertVC.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
            
        }))
        alertVC.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { (action) in
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.popupView.removeFromSuperview()
    }
    
    @IBAction func stepperButtonTapped(_ sender: UIStepper) {
       
        
       
        sender.maximumValue = Double(self.checkcollection.frame.size.width)
        sender.minimumValue = Double(self.checkcollection.frame.size.width/2.2)
        sizeVal = Int(sender.value)
        DispatchQueue.main.async {
            self.tablelist.reloadData()
            self.checkcollection.reloadData()
        }
        
        
    }
    @IBAction func viewStyleButtonTapped(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            sender.image = UIImage(named: "list")
            self.tablelist.isHidden = false
            self.checkcollection.isHidden = true
            sender.tag = 1
        }else{
            sender.tag = 0
            sender.image = UIImage(named: "grid")
            self.tablelist.isHidden = true
            self.checkcollection.isHidden = false
        }
        sizeVal = Int(self.checkcollection.frame.size.width/2.2)
    }

    private func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getNewsResult() {
        
        let urlName = API.NEWS_URL + "&from=2019-10-06&sortBy=publishedAt&apiKey=d244163c8fad4561a07ce46b72f04b70"
        _ = URLSession.shared.dataTask(with: URL(string: urlName)!) { (data, respones, error) in
            do {
                if data != nil{
                    let responesss = try JSONSerialization.jsonObject(with:data!, options: .allowFragments) as! NSDictionary
                    let status = responesss["status"] as! String
                    if (status != "error") {
                        let mainDict = responesss as NSDictionary
                        print(mainDict)
                        self.arrResult = mainDict.value(forKey: "articles") as! NSArray
                        self.dataArray = DataModel.getResponseWithData(results: self.arrResult as! [Any])
                        DispatchQueue.main.async {
                            self.tablelist.reloadData()
                            self.checkcollection.reloadData()
                            self.popupcollection.delegate = self
                            self.popupcollection.dataSource = self
                            self.popupcollection.reloadData()
                        }
                    }
              }
            }catch{
            }
            }.resume()
    }
    
    
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.popupcollection == collectionView {
            let popupcell = popupcollection?.dequeueReusableCell(withReuseIdentifier: "POPUPCollectionViewCell", for: indexPath) as! POPUPCollectionViewCell
            let dataModel = dataArray[indexPath.row]
            popupcell.titlelabl!.text = dataModel.title
            popupcell.datelabl!.text = dataModel.date
            if let imageurl = dataModel.image {
                let url = URL(string: imageurl)!
                ImageLoader.image(for: url) { image in
                    popupcell.imagev.image = image
                }
            }
            
            return popupcell
        }else{
            let cell = checkcollection?.dequeueReusableCell(withReuseIdentifier: "collectionview", for: indexPath) as! checkCollectionViewCell
            let dataModel = dataArray[indexPath.row]
            cell.titlelabl!.text = dataModel.title
            cell.datelabl!.text = dataModel.date
            if let imageurl = dataModel.image {
                let url = URL(string: imageurl)!
                ImageLoader.image(for: url) { image in
                    cell.imagev.image = image
                }
            }
            
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if self.popupcollection == collectionView {
           return CGSize(width: (collectionView.bounds.size.width-10), height:collectionView.bounds.size.height)
        }else{
          return CGSize(width: CGFloat(sizeVal), height: CGFloat(sizeVal))
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.popupcollection == collectionView {

        }else{
            self.popupView.frame = UIScreen.main.bounds
            UIApplication.shared.keyWindow?.addSubview(self.popupView)
            self.popupcollection.delegate = self
            self.popupcollection.dataSource = self
            self.popupcollection.reloadData()
            self.popupcollection.scrollToItem(at:indexPath, at: .right, animated: false)

            
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(sizeVal+30)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(sizeVal+30)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "NewsListCell") as! NewsListCell
        if dataArray.count > indexPath.row {
            let dataModel = dataArray[indexPath.row]
            cell.titleLbl.text = dataModel.title
            cell.dateLbl.text = dataModel.date
            cell.newsImage.image = UIImage.init(named: "Default_Image")
            if let imageurl = dataModel.image {
                let url = URL(string: imageurl)!
                ImageLoader.image(for: url) { image in
                    cell.newsImage.image = image
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "list images"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popupView.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self.popupView)
        self.popupcollection.reloadData()
        self.popupcollection.scrollToItem(at:indexPath, at: .right, animated: false)
    }
}
