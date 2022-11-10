import Foundation


struct Dragon {
    let damageRelations: [DamageRelations]
    let gameIndices: [GameIndices]
    let generation: NameLink
    let id: Int
    let moveDamageClass: NameLink
    let moves: [NameLink]
    let name: String
    let pokemon:[Pokemon]
    
}

struct DamageRelations {
    let doubleDamageFrom: [NameLink]
    let doubleDamageTo: [NameLink]
    let halfDamageFrom: [NameLink]
    let halfDamageTo: [NameLink]
    let noDamageFrom: [NameLink]
    let noDamageTo: [NameLink]
    
}

struct GameIndices {
    let gameIndices: Int
    let generation: NameLink
}

struct NameLink {
    let name: String
    let url: String
}

struct Pokemon {
    let pokemonName: NameLink
    let slot: Int
}
