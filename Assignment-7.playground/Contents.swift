//Lecture 9 - Extensions, Protocols, Generics

//სუპერ გმირების შერკინება

//1. შევქმნათ Class-ი SuperEnemy with properties: String name, Int hitPoints (ანუ სიცოცხლის რაოდენობა). სურვილისამებრ დაამატებ properties რომელიც მას აღწერს.

class SuperEnemy {
    let name: String
    var hitPoints: Int
    
    init(name: String, hitPoints: Int) {
        self.name = name
        self.hitPoints = hitPoints
    }
}

//2. შევქმნათ Superhero Protocol-ი.შემდეგი get only properties: String name, String alias, Bool isEvil და დიქშენარი (dictionary) superPowers [String: Int], სადაც String-ი არის სახელი და Int არის დაზიანება (damage). Method attack, რომელიც მიიღებს target SuperEnemy-ის და დააბრუნებს (return) Int-ს ანუ დარჩენილ სიცოცხლე. Method performSuperPower, რომელიც მიიღებს SuperEnemy-ის და დააბრუნებს (return) Int-ს, აქაც დარჩენილ სიცოცხლე.

protocol Superhero {
    var name: String { get }
    var alias: String { get }
    var isEvil: Bool { get }
    var superPowers: [String: Int] { get } // Superpower = key: damage = value
    
    mutating func performSuperPower(targetIs: SuperEnemy) -> Int
    
    func attack(target: SuperEnemy, remainingHitPoints: Int) -> Int
}

//3. Superhero-ს extension-ი გავაკეთოთ სადაც შევქმნით method-ს რომელიც დაგვი-print-ავს ინფორმაციას სუპერ გმირზე და მის დარჩენილ superPower-ებზე.

extension Superhero {
    func info() {
        if !superPowers.isEmpty {
            print("\(name) has these following super powers: \(superPowers.keys.joined(separator: ", ")) left.")
        } else {
            print("\(name) has no super powers left.")
        }
    }
}

//4. შევქმნათ რამოდენიმე სუპერგმირი Struct-ი რომელიც ჩვენს Superhero protocol-ს დააიმპლემენტირებს მაგ: struct SpiderMan: Superhero და ავღწეროთ protocol-ში არსებული ცვლადები და მეთოდები. attack მეთოდში -> 20-იდან 40-ამდე დავაგენერიროთ Int-ის რიცხვი და ეს დაგენერებული damage დავაკლოთ SuperEnemy-ს სიცოცხლეს და დარჩენილი სიცოცხლე დავაბრუნოთ( return). performSuperPower-ს შემთხვევაში -> დიქშენერიდან ერთ superPower-ს ვიღებთ და ვაკლებთ enemy-ს (სიცოცხლეს ვაკლებთ). ვშლით ამ დიქშენერიდან გამოყენებულ superPower-ს. გამოყენებული superPower-ი უნდა იყოს დარანდომებული. დარჩენილ enemy-ს სიცოცხლეს ვაბრუნებთ (return).

struct SunkMan: Superhero {
    
    var name: String
    var alias: String
    var isEvil: Bool
    var superPowers: [String: Int]
    
    init(name: String, alias: String, isEvil: Bool, superPowers: [String: Int]) {
        self.name = name
        self.alias = alias
        self.isEvil = isEvil
        self.superPowers = superPowers
    }
    
    mutating func performSuperPower(targetIs: SuperEnemy) -> Int {
        var remainingHitPoints = targetIs.hitPoints
        for (name, damage) in superPowers {
            if remainingHitPoints <= 0 {
                break
            }
            remainingHitPoints -= damage
            info()
            superPowers.removeValue(forKey: name)
        }
        //checking if super powers are completely used up. if so - calling 'attack' func
        if superPowers.isEmpty {
            remainingHitPoints = attack(target: targetIs, remainingHitPoints: remainingHitPoints)
        }
        return max(remainingHitPoints, 0) //comparing 0 to 'remainingHitPoints'. returns the max value to ensure that the returned value is not negative
    }
    
    func attack(target: SuperEnemy, remainingHitPoints: Int) -> Int {
        let damage = Int.random(in: 20...40)
        var finaltPoints = remainingHitPoints - damage
        return max(finaltPoints, 0)
    }
}

struct LoveBomb: Superhero {
    
    var name: String
    var alias: String
    var isEvil: Bool
    var superPowers: [String: Int]
    
    init(name: String, alias: String, isEvil: Bool, superPowers: [String: Int]) {
        self.name = name
        self.alias = alias
        self.isEvil = isEvil
        self.superPowers = superPowers
    }
    
    mutating func performSuperPower(targetIs: SuperEnemy) -> Int {
        var remainingHitPoints = targetIs.hitPoints
        for (name, damage) in superPowers {
            remainingHitPoints -= damage
            info()
            superPowers.removeValue(forKey: name)
        }
        //checking if super powers are completely used up. if so - calling 'attack' func
        if superPowers.isEmpty {
            remainingHitPoints = attack(target: targetIs, remainingHitPoints: remainingHitPoints)
        }
        return max(remainingHitPoints, 0) //comparing 0 to 'remainingHitPoints'. returns the max value to ensure that the returned value is not negative
    }
    
    func attack(target: SuperEnemy, remainingHitPoints: Int) -> Int {
        let damage = Int.random(in: 20...40)
        var finaltPoints = remainingHitPoints - damage
        return max(finaltPoints, 0)
    }
}

//5. შევქმნათ class SuperherSquad, რომელიც ჯენერიკ Superhero-s მიიღებს. მაგ: class SuperheroSquad<T: Superhero>. შევქმნათ array სუპერგმირების var superheroes: [T]. შევქმნათ init-ი. შევქმნათ method რომელიც ჩამოგვითვლის სქვადში არსებულ სუპერგმირებს.

class SuperheroSquad {
    var superheroesArray: [Superhero]
    
    init(superheroesArray: [Superhero]) {
        self.superheroesArray = superheroesArray
    }
    
    func superheroesList() {
        for hero in superheroesArray {
            print(hero.name)
        }
    }
}


//6.ამ ყველაფრის მერე მოვაწყოთ ერთი ბრძოლა. შევქმნათ method simulateShowdown. ეს method იღებს სუპერგმირების სქვადს და იღებს SuperEnemy-ს. სანამ ჩვენი super enemy არ მოკვდება, ან კიდევ სანამ ჩვენ სუპერგმირებს არ დაუმთავრდებათ სუპერ შესაძლებლობები გავმართოთ ბრძოლა. ჩვენმა სუპერ გმირებმა რანდომად შეასრულონ superPowers, ყოველი შესრულებული superPowers-ი იშლება ამ გმირის ლისტიდან. თუ გმირს დაუმთავრდა superPowers, მას აქვს ბოლო 1 ჩვეულებრივი attack-ის განხორციელება (ამ attack განხორიციელება მხოლოდ ერთხელ შეუძლია როცა superPowers უმთავრდება).

let sunkMan = SunkMan(
    name: "Skunk-Man",
    alias: "Sunk",
    isEvil: false,
    superPowers: [
        "emits toxic airs": 30,
        "belches loudly": 10,
        "exhales fire": 40]
)
let loveBomb = LoveBomb(
    name: "Love Bomb",
    alias: "Heartbreaker",
    isEvil: true,
    superPowers: [
        "breaks hearts with a touch": 20,
        "manipulates for personal gain": 15,
        "drains happiness makes depressed": 15]
)
let lazyBeast = SuperEnemy(name: "Lazy Beast", hitPoints: 200) 


var mySquad = SuperheroSquad(superheroesArray: [])
mySquad.superheroesArray.append(sunkMan)
mySquad.superheroesArray.append(loveBomb)

func simulateShowdown(hero: SuperheroSquad, enemy: SuperEnemy) {
    print("SuperEnemy's starting hit points: \(enemy.hitPoints)")
    for var hero in hero.superheroesArray {
        var remainingHitPoints = hero.performSuperPower(targetIs: enemy)
        enemy.hitPoints = remainingHitPoints
        hero.info()
        print("SuperEnemy's left hit points: \(enemy.hitPoints)")
        
        if enemy.hitPoints <= 0 {
            break // Stop the battle if SuperEnemy's hit points reach zero or below
        }
    }
    
    if enemy.hitPoints <= 0 {
        print("Superhero Wins!")
    } else {
        print("Enemy Wins!")
    }
}

simulateShowdown(hero: mySquad, enemy: lazyBeast) // both as superhero as well as enemy can win (I've checked)
