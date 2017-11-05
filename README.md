# Runtime

Runtime is a Swift library to give you more runtime abilities, including getting type metadata, setting properties via reflection, and type construction for native swift objects.

## TypeInfo
`TypeInfo` exposes metadata about native Swift structs, protocols, classes, tuples and enums. It captures the properties, generic types, inheritance levels, and more.
### Example
Lets say you have a Person struct:
```swift
struct Person {
  let firstName: String
  let lastName: String
  let age: Int
}
```
To get the `TypeInfo` of `Person`, all that you have to do is:
```swift
let info = try typeInfo(of: Person.self)
```

## PropertyInfo
Within the `TypeInfo` object, it contains a list of `PropertyInfo` which represents all properties for the type. `PropertyInfo` exposes the name and type of the property. It also allows the getting and setting of a value on an object.
### Example
Using the same `Person` object as before first we get the `TypeInfo`
```swift
let info = try typeInfo(of: Person.self)
var steve = Person(firstName: "Steve", lastName: "Jobs", age: 56)
```
To get a value:
```swift
let property = try info.property(named: "firstName")
let firstName = try property.get(from: steve)
```
To set a value:
```swift
let property = try info.property(named: "firstName")
try property.set(value: "New_Name", on: &steve)
```
Getting and setting the values works completely typeless. So your objects and values can be casted as an `Any` or any other protcol of your choosing and it will still work. 

## Factory
Runtime also supports building an object from it's `Type`. Both structs and classes are supported and classes are still managed by ARC.
To build a `Person` object:
```swift
let person = try build(type: Person.self)
```

## Installation
Runtime is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:
```ruby
pod 'Runtime'
```

## Contributions
Contributions are welcome and encouraged!

## License
Runtime is available under the MIT license. See the LICENSE file for more info.
