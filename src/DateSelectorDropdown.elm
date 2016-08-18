module DateSelectorDropdown exposing (
  Model, init, value,
  Msg(SelectDate), update,
  view, viewWithButton
  )

import Date exposing (Date)
import Date.Extra as Date
import DateSelector
import Dropdown
import Html exposing (Html, div, input, text)
import Html.App as App
import Html.Attributes exposing (class, readonly)


-- Model

type alias Model =
  Dropdown.Model DateSelector.Model


init : Date -> Date -> Date -> Model
init min max selected =
  Dropdown.init <| DateSelector.init min max selected


value : Model -> Date
value model =
  DateSelector.value model.content


-- Update

type Msg
  = DropdownMsg (Dropdown.Msg DateSelector.Msg)
  | SelectDate Date


update : Msg -> Model -> Model
update msg model =
  case msg of
    DropdownMsg m ->
      Dropdown.update DateSelector.update m model

    SelectDate date ->
      Dropdown.update DateSelector.update (Dropdown.Content (DateSelector.SelectDate date)) model


-- View

view : Model -> Html Msg
view model =
  viewWithButton defaultViewButton model


viewWithButton : (Bool -> Date -> Html a) -> Model -> Html Msg
viewWithButton viewButton model =
  let
    --button : Bool -> DateSelector.Model -> Html a
    button isOpen dateSelector =
      viewButton isOpen <| DateSelector.value dateSelector
  in
    App.map DropdownMsg <| Dropdown.view button DateSelector.view model


defaultViewButton : Bool -> Date -> Html a
defaultViewButton isOpen date =
  input
    [ class "date-selector-input"
    , readonly True
    , Html.Attributes.value <| Date.toFormattedString "yyyy-MM-dd" date
    ]
    []
