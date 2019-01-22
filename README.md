# epicea

Epicea is a tool for Pharo that records **code changes** enriched with **IDE events**. 

Epicea extends and could replace the traditional **.changes** logging mechanism, where the recorded code changes are incomplete and are not properly reified and thus it can be difficult to recover lost code after an image crash.

Epicea has a small subproject, named **Ombu**, which provides simple persistence. By default, Ombu uses [STON](http://smalltalkhub.com/#!/~SvenVanCaekenberghe/STON) to write the events when they are announced in the system. STON is part of Pharo 5.0.

:warning:
OUTDATED: The latest version this project is located inside [Pharo repository](https://github.com/pharo-project/pharo).
:warning:


## Install it

Note this project is already part of Pharo 6 and 7. However, if you need to install it in some situation, the script to do it is:

```Smalltalk
		Metacello new 
			repository: 'github://tinchodias/epicea/src';
			baseline: 'Epicea';
			load.
```

## Use it

- Enable recording at `System Settings > Epicea`.
- To browse the recorded logs, click on `World menu > Tools > Code Changes`
- To browse any **.ombu** file with a log, you can simply drag&drop it from your file browser (e.g. Finder in Mac) into the image.

## More info

**Publications**

- 2015: [Ph.D. thesis, chapter 3](http://rmod.inria.fr/archives/phd/PhD-2015-Dias.pdf)
- 2013: [short paper](http://rmod.lille.inria.fr/archives/papers/Dias13a-IWST13-Epicea.pdf)

**Brief history**

This project started as a fork (or a continuation) of Ezequiel's [NewChangeSystem](http://smalltalkhub.com/#!/~EzequielLamonica/NewChangeSystem). It got inspiration as well in Göran's [DeltaStreams](http://wiki.squeak.org/squeak/6001).
