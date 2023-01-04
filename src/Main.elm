module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)
import Html exposing (..)
import Html.Attributes exposing (..)


main : Program () Model Msg
main = 
    Browser.application 
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

type alias Model = 
    { key : Nav.Key
    , url : Url.Url
    }

type Msg 
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
       
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )  
init flags url key = 
    ( Model key url, Cmd.none )
    
update : Msg -> Model -> ( Model, Cmd Msg)    
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of 
                Browser.Internal url -> 
                    ( model, Nav.pushUrl model.key (Url.toString url) )
                
                Browser.External href ->
                    ( model, Nav.load href )
                    
        UrlChanged url -> 
            ( { model | url = url }
            , Cmd.none 
            )

subscriptions : Model -> Sub Msg 
subscriptions _ =
    Sub.none
    

view : Model -> Browser.Document Msg
view model = 
    { title = "title"
    , body =
        [ text "the current URL is: "
        , b [] [ text model.url.path ] 
        , ul []
            [ viewLink "/"
            , viewLink "/settings"
            , viewLink "/account"
            , viewLink "/another"
            , viewLink "/something"
            ]
        , (matchCaseBody model)
        ]
        
    }
    
matchCaseBody : Model ->  Html msg
matchCaseBody model =
    case model.url.path of
        "/" -> viewHome
        "/settings" -> viewSettings
        "/account" -> viewAccount
        _ -> view404
    
viewHome : Html msg    
viewHome  =
    div [] [ text "Home"]

viewSettings : Html msg    
viewSettings  =
    div [] [ text "Settings"]

viewAccount :  Html msg    
viewAccount  =
    div [] [ text "Account"]

view404 :  Html msg    
view404  =
    div [] [ text "404"]

viewLink : String -> Html msg
viewLink path = 
    li [] [ a [href path] [text path] ]

 
