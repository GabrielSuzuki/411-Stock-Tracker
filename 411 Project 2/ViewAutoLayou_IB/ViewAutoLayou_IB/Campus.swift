
enum Gender : String {
    case female = "female"  // raw value
    case male = "male"
}

class Person {
    // Stored properties
    var firstName : String
    var middleName : String?
    var lastName : String
    var gender : Gender
    var age : String!

    // Computed properties
    // getter option
    var fullName : String {
        get {
            if let m = middleName {
               return "\(firstName) \(m) \(lastName)"
            } else {
               return "\(firstName) \(lastName)"
            }
        }
    }
    
    // Closure option
    lazy var fullName1 : String = { ()->String in
        if let m = middleName {
           return "\(firstName) \(m) \(lastName)"
        } else {
           return "\(firstName) \(lastName)"
        }
    }()
    
    // Designated Initializer
    init?(fn : String, ln : String, g : Gender ) {
        if (fn.isEmpty || ln.isEmpty) {
            return nil
        }
        firstName = fn
        lastName = ln
        gender = g
    }
    
    // Convenience Initializer
    convenience init?(p : Person) {
        self.init(fn: p.firstName, ln: p.lastName, g: p.gender)
    }
    
    //
    convenience init?(ln : String, g : Gender) {
        self.init(fn: "", ln: ln, g : g)
    }
    
    func getLabel() -> String {
        var label : String
        var title : String
        //
        switch gender {
            case .male: title = "Mr."
            case .female: title = "Ms."
        }
        label = "\(title) \(fullName)"
        return label
    }
    
}

class Campusmember : Person {
    var cwid : Int!
    
    // Designated Initializer
    //init?(id : Int, fn : String, ln : String) {
    //    cwid = id
    //    super.init(fn: fn, ln: ln)
    //}
    
    convenience init?(obj : Person) {
        self.init(fn: obj.firstName, ln: obj.lastName, g : obj.gender)
    }
    
    func setCWID(_ id: Int) -> Campusmember {
        cwid = id
        return self
    }
    
    override func getLabel() -> String {
        let label = "\(super.getLabel()) \(cwid!)"
        return label
    }
}

class Student : Campusmember {
    var yearGrad : Int!
    var major : Department!
    
    func major(m : String) {
        if let d = CSUF.departments[m] {
            major = d
            if d.students != nil {
                d.students?.append(self)
            } else {
                d.students = [Student]()
                d.students?.append(self)
            }
        }
    }
}

// Singleton Object pattern
class CSUF {
    static var departments : [String : Department] = {
        var dList = [String : Department]()
        dList["Computer Science"] = Department("Computer Science")
        dList["Mathematics"] = Department("Mathematics")
        return dList
    }()
}

class Department {
    var name : String
    var students : [Student]?
    
    init(_ n : String) {
        name = n
    }
}
