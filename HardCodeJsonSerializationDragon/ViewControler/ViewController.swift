import UIKit

class ViewController: UIViewController {
    
    
    lazy var decodeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decode", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(self.decodeButtonPressed), for: .touchUpInside)
        
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }

   
    func createUI() {
        self.view.addSubview(self.decodeButton)
        
        self.decodeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.decodeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.decodeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        self.decodeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
  
    @objc
    func decodeButtonPressed() {
        print("Manual Button Pressed")
        let dragon = NetworkManager.shared.getDragonManually()
        self.presentDragonAlert(dragon: dragon)
        
    }
    
    func presentDragonAlert(dragon: Dragon?) {
        guard let dragon = dragon else { return }
        
        let dragonTypes = dragon.pokemon.compactMap {
            return $0.pokemonName.name
        }
        
        let dragonTypesString = dragonTypes.joined(separator: "\n")
        
        let alert = UIAlertController(title: "Dragon Types", message: "\(dragonTypesString)", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayAction)
        
        self.present(alert, animated: true)
    }
}

