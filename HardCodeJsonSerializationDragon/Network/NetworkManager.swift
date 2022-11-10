import Foundation


// 3 Requirements to make a perfect singleton
// 1. Final class
// 2. static shared property
// 3. private initializer

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
}

// MARK: Manual Decoding
extension NetworkManager {
    
    func getDragonManually() -> Dragon? {
        guard let path = Bundle.main.path(forResource: "SampleJSONDragon", ofType: "json") else{
            return nil
        }
        
        let url = URL(filePath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let jsonObj = try JSONSerialization.jsonObject(with: data)
            guard let baseDict = jsonObj as? [String: Any] else { return nil }
            return self.parseDragonManually(base: baseDict)
        } catch {
            
            return nil
        }
        
        
    }
    
    
    private func parseDragonManually(base: [String: Any]) -> Dragon? {
        
        // Damage Relations
        
        guard let dmgRelationsArr = base["damage_relations"] as? [String: Any] else { return nil }
        var returnDamage: [DamageRelations] = []
        var doubleDamageFrom: [NameLink] = []
        
        guard let damageDict = dmgRelationsArr["double_damage_from"] as? [[String: Any]] else {
            return nil}
        damageDict.forEach { elem in
            
            guard let dblDamageFrom = self.parseNameLink(nameLink: elem) else { return }
            doubleDamageFrom.append(dblDamageFrom)
            

        }
        
        var doubleDamageto: [NameLink] = []
        guard let dblDamageTo = dmgRelationsArr["double_damage_to"] as? [[String: Any]] else { return nil }
        dblDamageTo.forEach { elem in
            
            guard let dblDamageTo = self.parseNameLink(nameLink: elem) else { return }
            doubleDamageto.append(dblDamageTo)
        }
        
        var halfDamageFrom: [NameLink] = []
        guard let hlfDamageFrom = dmgRelationsArr["half_damage_from"] as? [[String:Any]] else { return nil}
        hlfDamageFrom.forEach { elem in
            
            guard let hlfDamageFrom = self.parseNameLink(nameLink: elem) else { return }
            halfDamageFrom.append(hlfDamageFrom)
        }
        
        var halfDamageTo: [NameLink] = []
        guard let hlfDamageTo = dmgRelationsArr["half_damage_to"] as? [[String: Any]] else { return nil}
        hlfDamageTo.forEach { elem in
            
            guard let hlfDamageTo = self.parseNameLink(nameLink: elem) else { return }
            halfDamageTo.append(hlfDamageTo)
        }
        
        var noDamageFrom: [NameLink] = []
        guard let nonDamageFrom = dmgRelationsArr["no_damage_from"] as? [[String:Any]] else { return nil}
        nonDamageFrom.forEach { elem in
            
            guard let nonDamageFrom = self.parseNameLink(nameLink: elem) else { return }
            noDamageFrom.append(nonDamageFrom)
        }
        
        var noDamageTo: [NameLink] = []
        guard let nonDamageTo = dmgRelationsArr["no_damage_to"] as? [[String: Any]] else { return nil}
        nonDamageTo.forEach { elem in
            
            guard let nonDamageTo = self.parseNameLink(nameLink: elem) else { return }
            noDamageTo.append(nonDamageTo)
        }
        let dmgRel = DamageRelations(doubleDamageFrom: doubleDamageFrom, doubleDamageTo: doubleDamageto, halfDamageFrom: halfDamageFrom, halfDamageTo: halfDamageTo, noDamageFrom: noDamageFrom, noDamageTo: noDamageTo)
        
        returnDamage.append(dmgRel)

        
        // Game Indices
        
        guard let gameIndicesArr = base["game_indices"] as? [[String: Any]] else { return nil }
        var returnGameIndices: [GameIndices] = []
        gameIndicesArr.forEach{_ in
            guard let gameIndice = base["game_index"] as? Int else { return }
            guard let generation = base["generation"] as? [String: Any] else { return }
            guard let returnGeneration = self.parseNameLink(nameLink: generation) else { return }
            let gameIndices = GameIndices(gameIndices: gameIndice, generation: returnGeneration)
            returnGameIndices.append(gameIndices)
            print(returnGameIndices)
        }
        
        // Generation
        
        guard let generationArr = base["generation"] as? [String: Any] else { return nil }
        guard let Gen = self.parseNameLink(nameLink: generationArr) else { return  nil}
        
        
        
        // id
        
        guard let id = base["id"] as? Int else { return nil }
        
        //Move Damage Class
        
        guard let movesDamageClassArr = base["move_damage_class"] as? [String: Any] else { return nil }
            guard let movesDamageClass = self.parseNameLink(nameLink: movesDamageClassArr) else { return nil }
        
        //Moves
        
        guard let movesArr = base["moves"] as? [[String: Any]] else { return nil }
        var returnMoves: [NameLink] = []
        movesArr.forEach{
            guard let moves = self.parseNameLink(nameLink: $0) else { return }
            returnMoves.append(moves)
        }
        
        //Name
        
        guard let pokeName = base["name"] as? String else { return nil }

        // Pokemon
        
        var returnPok: [Pokemon] = []
        
        guard let pokemonArr = base["pokemon"] as? [[String: Any]] else { return nil }
        pokemonArr.forEach{elem in
            
            guard let filterPoke = elem["pokemon"] as? [String: Any] else {return }
            guard let returnPoke = self.parseNameLink(nameLink: filterPoke) else { return }
            guard let slotNumber = elem["slot"] as? Int else { return }
            
            let returnPokemon = Pokemon(pokemonName: returnPoke, slot: slotNumber)
            returnPok.append(returnPokemon)
        }
        
        
        return Dragon(damageRelations: returnDamage, gameIndices: returnGameIndices, generation: Gen, id: id, moveDamageClass: movesDamageClass, moves: returnMoves, name: pokeName, pokemon: returnPok)

    }
    private func parseNameLink(nameLink: [String: Any]) -> NameLink? {
        guard let name = nameLink["name"] as? String else { return nil }
        guard let url = nameLink["url"] as? String else { return nil }
        return NameLink(name: name, url: url)
    }
}
