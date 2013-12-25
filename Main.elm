import Keyboard
import Window

type GameState = {finished : Bool}

defaultGame: GameState
defaultGame = {finished = False}

update : Bool -> GameState -> GameState
update input state = case state.finished of

                       True -> state

                       False -> {state | finished <- True}

gameState : Signal GameState
gameState = foldp update defaultGame Keyboard.enter

renderState : GameState -> Element
renderState {finished} = case finished of

                      False -> plainText "Press enter to end game"

                      True -> plainText "GOODBYE"


display : (Int, Int) -> Element -> Element
display (h, w) el = container h w middle el

main = lift2 display Window.dimensions <| lift renderState gameState



