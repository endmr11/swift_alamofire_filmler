//
//  ViewController.swift
//  udemy_alamofire_fimler
//
//  Created by Eren Demir on 18.05.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var kategorilerTableView: UITableView!
    var kategorilerListe = [Kategoriler]()
    override func viewDidLoad() {
        super.viewDidLoad()
        kategorilerTableView.delegate = self
        kategorilerTableView.dataSource = self
        tumKategoriler()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilm" {
            print("toFilm")
            if let index = sender as? Int{
                let gidilecekVC = segue.destination as! FilmViewController
                gidilecekVC.kategori = kategorilerListe[index]
            }
        }
    }
    
    func tumKategoriler() {

        Alamofire.request("http://kasimadalan.pe.hu/filmler/tum_kategoriler.php", method:.get).responseJSON(completionHandler: {
            respnse in
            
            if let data = respnse.data {
                do {
                    let cevap = try JSONDecoder().decode(KategoriCevap.self, from: data)
                    if let kategoriListesi = cevap.kategoriler {
                        self.kategorilerListe = kategoriListesi
                    }
                    DispatchQueue.main.async {
                        self.kategorilerTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
        
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gelenKategori = kategorilerListe[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "kategoriHucre", for: indexPath) as! KategoriTableViewCell
        cell.kategoriAdLabel.text = gelenKategori.kategori_ad
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.performSegue(withIdentifier: "toFilm", sender: indexPath.row)
    }
}
