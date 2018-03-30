---
layout: post
title:  "Tips for better refactoring in Swift"
date:   2017-05-31 03:00:00 -0300
categories: swift
redirect_from:
  - /tips-for-better-refactoring-in-swift-4a43c08961cd
---

One of the things I like the most about the Swift programming language is its type system. I think it has a good balance between *"main stream / industrial"* languages and more academic ones. Which makes it really approachable for new developers but also gives the more advanced ones a nice set of tools to be more productive.

What I also like is something that could be called *“typed-driven development”* (if such thing exists). Which basically boils down to define your types and function signatures and then trying to make every piece fit together until the compiler is happy. I found that by doing this, it makes implementing the actual logic quite straight forward.

Also having a type system and static checks come in really handy when you have to refactor code. The compiler becomes your first line of defense by pointing out all places that need you attention. Pieces that no longer fit together and need to be fixed.

Unfortunately not everything is as good as it could be. The Swift programming language is still very young and under heavy development. The compiler is not as mature as other compilers from languages that are ten or twenty years old. Nowadays it’s rare to see a compiler crash but not so long ago compiler crashes were a real issue that could throw away all productivity benefits Apple’s new language said it had.

Currently the mayor pain point regarding the compiler is diagnosis. Once you reach a fair amount of non-trivial code, very strange error messages will appear when you make a syntax error. Specially if you use lots of generics and type inference.

After a while of getting mad at the compiler and spending hours to understand what is the actual cause of the error (which usually requires trying to isolate the issue by reproducing the problem with the least amount of code possible), you learn how to read this cryptic and misleading error messages and know where to look at. You get a sort of intuition. Which is really hard to transfer to other team members.

### My last refactoring adventure

Yesterday I found myself in a similar situation while I was refactoring some code in [Portal](http://github.com/guidomb/Portal). I wanted to delete a class which implemented a certain protocol and I also wanted to change the method signatures in such protocol.

My first attempt was to delete the class, change the method signatures and make some class in the library implement the modified protocol. The idea was that the compiler would tell me all the places that stopped working and needed my attention. Which worked for the most part until I reached to a point of not being able to fix some errors pointed by the compiler.

The errors made no sense at all. Probably some bug in the compiler or a bad diagnosis. But after spending hours trying to fix it, I gave up. I discarded all my changes, shutdown my laptop and went home.

Today I decided to tackle the problem with a different approach. The first thing I did was to copy-paste the protocol I wanted to modify and made a second version of it called `ApplicationRenderer2`. Then I updated the method signatures. Everything compiled. I was just adding a new type.

Then I made a class in the library implement this new protocol. This required a little bit of work because some of the logic that was in the class that I intended to delete needed to be copy-pasted into this class. After half an hour the project compiled again.

Next step was replacing every dependency on `ApplicationRenderer` to `ApplicationRenderer2`. Which yielded lots of compiler error that where pretty simple to fix.

Finally I deleted the aforementioned class, hit build and checked that everything worked as expected. The last step was deleting `ApplicationRenderer` and renaming `ApplicationRenderer2` to ApplicationRenderer. The whole process took two hours.

### Conclusion

Thanks to only making *additive* changes and then only adding a *destructive* change at the end of the refactoring process made me accomplish my refactoring task much more effectively. This is a strategy I intend to use more in my future refactoring endeavors. At least until Swift gets better diagnosis. Give it a try and let me know what you think.

> If you are curious about the actual change that I made you can check commit [757a2a6f4be997c50f5155e3b63bc894abfc3ec4](https://github.com/guidomb/Portal/commit/757a2a6f4be997c50f5155e3b63bc894abfc3ec4)
