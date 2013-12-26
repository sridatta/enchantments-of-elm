# The Enchantments of Elm: Part 1

![Some other roguelike](http://i.imgur.com/CsLg22Z.png "Totally not
Enchantments of Elm")

Inspired by [purely functional retro
games](http://prog21.dadgum.com/23.html)
and Steve Losh's [The Caves of Clojure
series](http://stevelosh.com/blog/2012/07/caves-of-clojure-01/),
I've decided to write a roguelike game in a variant of Haskell called
[Elm](http://elm-lang.org/). I call the game "The Enchantments of Elm",
keeping with Steve's alliterative naming.

According to the language's website, Elm is a functional language that
compiles to HTML, CSS, and JavaScript. It is designed for functional
reactive programming, which is based on the idea of auto-updating values
(similar to two-way data binding in Angular.js). To me, this seems like
an ideal language to write a browser-based game.

I plan to develop this roguelike over time and blog about it. 
This series is best if you're familiar with functional programming
concepts such as high-order functions and combinators.
This first iteration of the game isn't that exciting. 
It waits for the player to hit Enter and then ends the game.

Let's get started. First some necessary imports that we will use later.

```haskell
import Keyboard
import Window
```

## State Manipulation

Our game will need a state object to store player stats, inventory and
such.
Like in other languages with immutable data structures, the state will
be manipulated by functions that accept the current state and return a
new state. 

For now, we only keep track of whether the game has ended yet. 
Elm has a data structure called a record, which is similar to a
dictionary. We'll
define a `GameState` type to be a record with one field.

```haskell
type GameState = {finished : Bool}
```

We'll make a function to return the default state of the game.
Naturally, the `finished` property will start out as false.

```haskell
defaultGame: GameState
defaultGame = {finished = False}
```

It's time to write that `update` function to transform the state.
This function will get called on user input, namely when the player
presses Enter. It ignores the `input` for now since it just tells us
that the key has been pressed.

```haskell
update : Bool -> GameState -> GameState
update input state = case state.finished of
                       True -> state
                       False -> {state | finished <- True}
```

## Signals and FRP

Now we get to the fun part of Elm. While game programming in most
languages
would involve a main loop, Elm doesn't have loops at all. Updates are
triggered
by `Signal`s, which represent "reactive" values.

The one we care about for now is the built-in signal `Keyboard.enter`. 
It gets triggered when the Enter key is pressed.

Instead of writing handlers or callbacks, we will write a function
called `gameState` that "collects" keyboard Signal events and turns them
into game state Signals.

```haskell
gameState : Signal GameState
gameState = foldp update defaultGame Keyboard.enter
```


`foldp` is a folding function over a Signal (which I think are
applicative functors...) Every time `Keyboard.enter` is triggered,
`foldp` will call
`update`, which turns a signal input and current state into a new state.
In this way, user interactions 
can trigger changes to our game's state.  We pass `defaultGame` as the
starting value.  

## Rendering

All this state manipulation is useless if it doesn't output anything to
the screen. So we'll define a function called `renderState` that does
just that. It displays a different message depending on whether or not
the game has finished.


```haskell
renderState : GameState -> Element
renderState {finished} = case finished of
                      False -> plainText "Press enter to end game"
                      True -> plainText "GOODBYE"
```

The [Elm standard library](http://docs.elm-lang.org/) has many text and
image processing functions. 
As this game becomes a real roguelike, that functionality will be useful
to render menues, map tiles, and character sprites.
For now, we are just going to use the plaintext features.

Finally our `main` function ties everything together. It takes the
rendered `gameState` and passes it to `display`, which just puts it on
the center of the screen.

Earlier I said that `gameState` is itself a signal. Whenever the
`gameState`
signal triggers, `main` will re-render and display it.

Note that we lift `renderState` and `display` in order to apply them to
Signals.

```haskell
display : (Int, Int) -> Element -> Element
display (h, w) el = container h w middle el

main = lift2 display Window.dimensions <| lift renderState gameState
```

Let us enjoy the fruits of our labor. Click here or enjoy this very
visually impressive screen capture.

Or visit the [live demo](http://sridattalabs.com/part1.elm.html).
