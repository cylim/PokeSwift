//
//  CatViewController.swift
//  testProject
//
//  Created by Chee Yeong Lim on 7/28/20.
//  Copyright © 2020 Chee Yeong Lim. All rights reserved.
//

import UIKit
import Alamofire

struct AFPokemons: Decodable {
    let results: [AFPokemon]
}

struct AFPokemon: Decodable {
    var url: String?
}

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let sprites : Sprite?
}

struct Sprite: Decodable {
    let front_default : String?
}

struct Constants {
    struct Loader {
        static let loaded = "Here are your cats!"
        static let loading = "Please wait a moment!"
    }
    struct API {
        static let baseURL = "https://pokeapi.co/api/v2/pokemon"
    }
}


class CatViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let queue = DispatchQueue.main
    let group = DispatchGroup()
    var name: String = "Guest"
    var pokemons: [Pokemon] = []
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.isHidden = true
        name = UserDefaults.standard.string(forKey: "name") ?? "Guest"
        welcomeLabel.text  = "Hi \(name)!\n\(Constants.Loader.loading)"
        
        fetchPokemons()
    }
    
    func fetchPokemons() {
        let url = "\(Constants.API.baseURL)?limit=5&offset=\(offset)"
        AF.request(url).validate().responseDecodable(of: AFPokemons.self) {
            response in
            switch response.result {
                case let .success(data):
                    for item in data.results {
                        self.group.enter()
                        self.fetchPokemonDetail(item)
                    }
                    
                    self.group.notify(queue: self.queue) {
                        self.activityIndicator.stopAnimating()
                        self.scrollView.isHidden = false
                        self.welcomeLabel.text = "Hi \(self.name )!\n\(Constants.Loader.loaded)"
                        self.updateUI()
                    }
                    
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    func fetchPokemonDetail(_ pokemon: AFPokemon)  {
        guard let url = pokemon.url else {
            group.leave()
            return
        }
        queue.async {
            AF.request(url).validate().responseDecodable(of: Pokemon.self) { (response) in
                switch response.result {
                case let .success(data):
                    self.pokemons.append(Pokemon(name: data.name, id: data.id, sprites: data.sprites))
                    self.group.leave()
                case let .failure(error):
                    print(error)
                    self.group.leave()
                }
            }
        }
        
    }

    func updateUI() {
        let height = CGFloat(160)
        for (index, pokemon) in pokemons.enumerated()  {
            if let url = pokemon.sprites?.front_default {
                do {
                    let float = CGFloat(index)
                    
                    let imageView = UIImageView.init(frame: CGRect(x: 0 , y: height * (float), width: self.scrollView.frame.size.width, height: height))
                    let image = try UIImage(data: Data.init(contentsOf: URL(string: url)!))
                    imageView.contentMode = .center
                    imageView.image = image
                    self.scrollView.addSubview(imageView)
                } catch {
                    print(error)
                }
            }
        }
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: height * CGFloat(pokemons.count))
    }
    
}
