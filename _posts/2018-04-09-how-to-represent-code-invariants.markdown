---
layout: post
title:  "How to represent code invariants"
date:   2018-04-09 09:00:00 -0300
categories: swift
---

I wanted to write a bit about how we represent code invariants, specifically when those invariants cannot be easily expressed or enforced by the language, in this case the Swift programming language. When we talk about invariants [Wikipedia's definition](https://en.wikipedia.org/wiki/Invariant_(computer_science)) explains it quite well:

> In [computer science](https://en.wikipedia.org/wiki/Computer_science), an **invariant** is a condition that can be relied upon to be true during execution of a program, or during some portion of it. It is a [logical assertion](https://en.wikipedia.org/wiki/Logical_assertion) that is held to always be true during a certain phase of execution. For example, a [loop invariant](https://en.wikipedia.org/wiki/Loop_invariant) is a condition that is true at the beginning and end of every execution of a loop.

Basically something that we know it's always true and won't change. Otherwise somebody made a serious mistake and our program would probably crash. Now that we have defined some terminology lets jump right down to the code.

```swift
public struct RangeMapper {

    let title: SpreadSheetRange
    let description: SpreadSheetRange
    let attributes: SpreadSheetRange

    public init(title: SpreadSheetRange, description: SpreadSheetRange, attributes: SpreadSheetRange) {
        self.title = title
        self.description = description
        self.attributes = attributes
    }

    var ranges: [SpreadSheetRange] {
        return [title, description, attributes]
    }

}
```

`RangeMapper` is a type that represents a set of `SpreadSheetRange`s that have a particular semantic associated with it. A `SpreadSheetRange` is a simple type that basically wraps a `String` and when created it verifies that the given string follows certain rules. In particular it should be a valid cells range identifier expressed in the [A1 notation](https://developers.google.com/sheets/api/guides/concepts#a1_notation). This notation is the one you may use to refer to a range of cells in a Google spread sheet, e.g: `Sheet1!A1:D4`. The following is a possible implementation of that type without the initializer's implementation because it is a little bit cumbersome:

```swift
public enum SpreadSheetRange: CustomStringConvertible, Equatable {

    public enum CellRange: CustomStringConvertible, Equatable {

        case allCellsInRows(fromRow: UInt, toRow: UInt)
        case allCellsInColumn(columnName: String)
        case allCellsInColumnFromRow(columnName: String, fromRow: UInt)
        case range(from: String, to: String)

        public var description: String {
            switch self {
            case .allCellsInRows(let fromRow, let toRow):
                return "\(fromRow):\(toRow)"
            case .allCellsInColumn(let columnName):
                return "\(columnName):\(columnName)"
            case .allCellsInColumnFromRow(let columnName, let fromRow):
                return "\(columnName)\(fromRow):\(columnName)"
            case .range(let from, let to):
                return "\(from):\(to)"
            }
        }

        init?(from string: String) {
            // Somewhat long implementation that verifies all possible valid
            // A1 notation cases.
        }

    }

    case allCellsInSheet(sheetName: String)
    case cellRange(sheetName: String?, cellRange: CellRange)

    public var description: String {
        switch self {
        case .allCellsInSheet(let sheetName):
            return sheetName
        case .cellRange(let sheetName?, let cellRange):
            return "\(sheetName)!\(cellRange)"
        case .cellRange(.none, let cellRange):
            return cellRange.description
        }
    }

    public init?(from string: String) {
		// Implementation
    }

}
```

The reason I'm talking about spread sheets and cell ranges is because I'm writing a program that needs to extract data from several Google spread sheets and do some magic with it. In one of those spread sheets there is structured data and that data could be represented with a struct like the following one:

```swift
struct Ability {

    struct Attribute {

        let name: String
        let description: String
        let value: Int

    }

    let title: String
    let description: String
    let attributes: [Attribute]

}
```

This structured data is spread throw out several spread sheets so I need to fetch from all of this spread sheets the cell ranges that contain this structured data. The spread sheet API has a method called [batchGet](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets.values/batchGet) to fetch in one API call several cell ranges. It is important to note that a particular cell range could be translated to several `Ability` properties, meaning that there is not one to one relation between cell ranges and `Ability` properties.

That is why the `RangeMapper` type exists, to define the cell range for each `Ability`'s property. We can then define an array of `RangeMapper` that need to be fetched and translate that to a list of ranges to pass to the `batchGet` method.

```swift
let mappers: [RangeMapper] = //....
let cellRanges:[SpreadSheetRange] = mappers.flatMap { $0.ranges }
```

It is out of the scope of this blog post to explain how the fetching and parsing logic works but believe than inside the code that parses the response from `batchGet` in order to get `[Ability]` as a result I needed to reference the amount of `SpreadSheetRange`s needed to parse an `Ability` value.

This is the invariant that I know holds true as long as I need 3 ranges to extract the data needed to create an `Ability` value. I could add a comment explaining what's the reason behind the magic number 3. I could then extract it into a constant and forget about it but this is the sort of trap I've fallen down so many times before. What happens if the requirements change? Lets say that somebody decides to add new data and I need more ranges to extract it in order to successfully parse an `Ability` value, then I would need to update that magic number, which if extracted into a constant would only need to update it one place and if I have proper unit tests any issue should arise. The truth is that real world software development is a messy process  and some of this measures could fail or not be implemented at all. Also I do have an OCD with things that I know could be automated, so this gave an excuse to think about how to reflect invariants that cannot be easily expressed with the tools we have and can evolve naturally as other parts of the system changes.

### Option 1: Use a constant

The first options is the simplest one, which is adding the `rangesCount` static property. This has the disadvantage of remembering to keep in sync the `rangesCount` static property with the `ranges` computed property. We also need to remember to keep in sync the actual instance variables of type `SpreadSheetRange` with ranges array. Both issues could be mitigated by having unit tests.

```swift
public struct RangeMapper {

    static func let rangesCount = 3

    let title: SpreadSheetRange
    let description: SpreadSheetRange
    let attributes: SpreadSheetRange

    public init(title: SpreadSheetRange, description: SpreadSheetRange, attributes: SpreadSheetRange) {
        self.title = title
        self.description = description
        self.attributes = attributes
    }

    var ranges: [SpreadSheetRange] {
        return [title, description, attributes]
    }

}
```

### Option 2: Use key paths

The second option is to only have one place where the actual ranges are assembles, in this case in a static property called `ranges`. Because this is a static property we need to use `KeyPath`s if we want to have an array to which we can ask the amount of elements it has. In this case the only think we need to keep in sync is the list of key path with the instance variables of type `SpreadSheetRange`. I consider option 2 to be superior to option 1 because it reduces the amount of things to keep in sync without adding too much complexity.

```swift
public struct RangeMapper {

    static var ranges: [KeyPath<RangeMapper, SpreadSheetRange>] {
        return [
            \RangeMapper.title,
            \RangeMapper.description,
            \RangeMapper.attributes
        ]
    }

    let title: SpreadSheetRange
    let description: SpreadSheetRange
    let attributes: SpreadSheetRange

    public init(title: SpreadSheetRange, description: SpreadSheetRange, attributes: SpreadSheetRange) {
        self.title = title
        self.description = description
        self.attributes = attributes
    }

    var ranges: [SpreadSheetRange] {
        return RangeMapper.ranges.map { self[keyPath: $0] }
    }

}
```

### Option 3: Use Sourcery

The third option is to use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) to automatically generate all the code to avoid having to keep state in sync. I consider this to be the superior solution to all previous options at the expense of having to introduce a new tool as part of the build process.

For those who don't know what Sourcery is, basically allows you to generate code based on templates that can introspect your source code. In this case we are defining an extension for every type that conforms to `AutoRangeMappable`, a protocol we use to mark the types that we want to extend. For each of those types we define an extension that implements the solution in Option 1 by iterating over all instance variable of type `SpreadSheetRange`.

{% raw %}
```
{% for type in types.implementing.AutoRangeMappable %}

extension {{ type.name }} {

  static let rangesCount = {{ type.instanceVariables.count }}

  public var ranges: [SpreadSheetRange] {
    return [
      {% for variable in type.instanceVariables %}{% if variable.type.name == "SpreadSheetRange" %} {{ variable.name }}{% if not forloop.last %},{% endif %}{% endif %}
      {% endfor %}
    ]
  }

}
{% endfor %}
```
{% endraw %}

We only need to conform to `AutoRangeMappable`.

```swift
public struct RangeMapper: AutoRangeMappable {

    let title: SpreadSheetRange
    let description: SpreadSheetRange
    let attributes: SpreadSheetRange

    public init(title: SpreadSheetRange, description: SpreadSheetRange, attributes: SpreadSheetRange) {
        self.title = title
        self.description = description
        self.attributes = attributes
    }

}
```

Then Sourcery will generate the following extension based on the previous template.

```swift
extension RangeMapper {

    static let rangesCount = 3

    var ranges: [SpreadSheetRange] {
        return [
            title,
            description,
            attributes
        ]
    }

}
```

If we want to add or remove an instance variable from `RangeMapper` all we have to do is run Sourcery and our extension will be automatically updated. You can add Sourcery as a build script and forget about it!



### To sum up

The idea of this blog post is to show a particular case where there are invariants that cannot be easily enforced by the language without having some sort of manual sync process and show possible solutions. I'd love to know other cases where you faced a similar situation and see how you resolved it.
