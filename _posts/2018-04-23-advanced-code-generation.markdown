---
layout: post
title:  "Advanced code generation"
date:   2018-04-23 00:00:00 -0300
categories: swift
---

In the previous post, ["How to represent code invariants"](/swift/2018/04/09/how-to-represent-code-invariants.html), I described how code generation and meta-programming can help us represent code invariants. Although the proposed solution works there was a small bug. Let's take a look at the template I used to generate the extension for the type that conformed to `AutoRangeMappable` which added a computed property to list the value of all properties of type `SpreadSheetRange`.

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

As you can see, when defining the computed property `ranges`, the template iterates over all instance variables and performs a check to see wether the instance variable's type is `SpreadSheetRange`. If that check returns `true` it adds the instance variable to the returning array, otherwise the instance variable is ignored.

Did you spot the bug in the template? The problem is on how the `rangesCount` variable is defined. The template returns the total amount of instance variables, without taking into account that not all instance variables may be of type `SpreadSheetRange`.

The problem is that [Stencil templates](https://github.com/kylef/Stencil) don't have a way of executing "complex" Swift expressions. Taken from [Stencil's documentation](http://stencil.fuller.li/en/latest/templates.html#variables):

> Stencil will look up the variable inside the current variable context andevaluate it. When a variable contains a dot, it will try doing the following lookup:
>
> - Context lookup
> - Dictionary lookup
> - Array lookup (first, last, count, index)
> - Key value coding lookup
> - Type introspection
>

`type.instanceVariables.count` works because `type.instanceVariable` returns an array by doing a key value coding lookup (or type introspection, I'm not really sure which one) and then `.count` works because it's one of the supported array lookup operations. Ideally I'd like to do something like `type.instanceVariables.filter({ $0.type.name == "SpreadSheetRange" }).count` but that won't work because of how variable evaluation works in Stencil.

So what can you do in this scenarios? Well, thankfully Sourcery provides another templating language (which is not as documented as Stencil is) which is Swift template. This template is way more powerful because it let us execute any piece of Swift code we want. All you need to do to use a Swift template is change the extension of the file where you declared you template from `.stencil` to `.swifttemplate`. Also the syntax changes a little bit. Going back to the original problem of getting the amount of instance variables of type `SpreadSheetRange`, using Swift template we can define the following template:

{% raw %}
```
<% for type in types.all where type.implements["AutoRangeMappable"] != nil { %>
extension <%= type.name %> {

  static let rangesCount = <%= type.instanceVariables.filter({ $0.type?.name == "SpreadSheetRange" }).count %>

  var ranges: [SpreadSheetRange] {
    return [
    <% for instanceVariable in type.instanceVariables where instanceVariable.type?.name == "SpreadSheetRange" { -%>
      <%= instanceVariable.name %>,
    <% } %>
    ]
  }

}
<% } %>
```
{% endraw %}

As you can see the overall structure is pretty similar. Important things to note:

* Instead of {% raw %}`{% %}`{% endraw %} to execute control flow statements you need to use `<% %>`.
* Anything inside `<% %>` needs to be valid Swift syntax, otherwise you'll get a compiler error.
* Instead of {% raw %}`{{ }}`{% endraw %} to evaluate a variable you need to use `<%= %>` which will print the result of evaluating the given Swift expression.
* You loose some of the syntax sugar like `types.implementing.AutoRangeMappable` which in Swift template translates to `for type in types.all where type.implements["AutoRangeMappable"] != nil`. Here we are using Swift's `for-in` statement combined with a `where` clause to filter out elements that don't satisfy the given condition. Sourcery's Swift API to access all confirming types is provided via the `implements` property that returns a `[String: Type]` (check the documentation for Sourcery's Swift API [here](https://cdn.rawgit.com/krzysztofzablocki/Sourcery/master/docs/Classes/Type.html#/c:@M@SourceryRuntime@objc(cs)Type(py)implements)).
* For some reason when using `<% %>` or `<%= %>`the generated code will have extra new lines where the Swift statement or expression was executed. You can avoid extra new lines by using `-`, like `<% -%>` or `<%= -%>` but indentation is not properly done (maybe a bug with swift template).

We are now able to properly generate the `rangesCount` property by filtering out all instance variable which type is not `SpreadSheetRange` and then asking the `count` to the resulting array.

```
static let rangesCount = <%= type.instanceVariables.filter({ $0.type?.name == "SpreadSheetRange" }).count %>
```

The `ranges` computed property is generated in a similar way as in the Stencil template adapting the syntax to the Swift template one.

```
var ranges: [SpreadSheetRange] {
    return [
    <% for instanceVariable in type.instanceVariables where instanceVariable.type?.name == "SpreadSheetRange" { -%>
      <%= instanceVariable.name %>,
    <% } %>
    ]
  }
```

Overall Swift templates provide a more flexible experience at the expense of longer compile times and a harder debugging experience (Sourcery just prints raw compiler errors to the console).

In the next blog post we will learn how to make this template more generic in order to be able to reuse it to list other types of instance variables instead of just `SpreadSheetRange` variables.
