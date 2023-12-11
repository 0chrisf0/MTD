(**This file contains functions that draw and update the menubar.*)

open Raylib
open Bears

val hover_display : bear option ref
(**This value represents the bear that is currently hovered over, if any.*)

val select_display : bear option ref
(**Select display represents the menu
   type of a placed bear that is selected.*)

val check_valid_placement : Vector2.t -> Rectangle.t list -> bool
(** Checks for valid placement of bear, contingent on position and cash.
   If a player no longer wants to place a bear, they can move the selected
   choice back to the menu to discard their choice.

   The radius of the circle in check_collision_circle_rec will determine how much
   the bears can overhang on path.*)

val check_button_press : Vector2.t -> Rectangle.t list -> bool
(**Checks if a GUI button was pressed, in which case we should not necessarily
   deselect the selected bear.*)

val nevermind : Vector2.t -> Rectangle.t -> bool
(**Checks if the user has clicked the menu. This allows them to put a bear they
    have picked up back into the menu.*)

val place_bear : unit -> unit
(**Handles picking up and placing bears.*)

val update_bear_selections : bool -> Vector2.t -> bear list -> unit
(**Checks if the current mouse position corresponds to a bear in the given list.
  placed_bear represents whether or not he passed in list is a lsit of placed 
  bears or menu bears.
  Parameters: [placed_bears] [position] [bear_list]*)

val check_click : unit -> unit
(**Check_click is called in Game.update_game() to update whether or not a bear
    has been selected. If a user clicked a button, we do not deselect their 
    current selection.*)

val check_hover : unit -> unit
(**Updates the hover_display to be the current bear hovered over. Could be a menu
   bear OR a placed bear.*)

val lives_box : float -> float -> Rectangle.t
(**Draws the lives rectange.*)

val cash : float -> float -> Rectangle.t
(**Draws the cash rectangle.*)

val draw_heart : float -> float -> unit
(**Draws the heart lives.*)

val lives_and_cash_count : float -> float -> unit
(**Draws the num of lives and cash.*)

val draw_menu : Rectangle.t -> unit
(**Draws the menubar rectangle and bear icons.*)

val draw_range : bear option -> unit
(**Draws the range of the selected bear: grey if it is in a valid location,
      red otherwise.
  Precondition: bear is not a None option.*)

val mem_option : 'a option -> 'a list -> bool
(**Takes in an option and a list and tests of the contents of that option are in
    the list*)

val draw_hover_highlight : unit -> unit
(**Draws the range of the bear if it is hovered over or currently selected.*)

val draw_info_background : Bears.bear_types -> unit
(**Draws the rectangle for the selection GUI.*)

val cost_of_beartype : bear_types -> int
(** Get the cost of each bear type *)

val bear_info_text : bear_types -> float -> float -> float -> float -> unit
(** Gets the description of each bear *)

val draw_info_title :
  bear_types -> bool -> float -> float -> float -> float -> unit
(**Draws the title for the selection GUI based on the bear type.*)

val display_hover_info : bear option -> unit
(**Draws the information about a menu bear that is hovered over, if any. This
    should simply drawn ontop of the current selection, if a bear is selected.*)

val draw_sell_button : bear -> float -> float -> float -> float -> unit
(**Draw the sell button in the selection GUI, the sell rate is 0.70 of the original
    cost.*)

val draw_range_upgrade_button : bear -> float -> float -> float -> float -> unit
(** Upgrade range button *)

val draw_damage_upgrade_button :
  bear -> float -> float -> float -> float -> unit
(** Upgrade damage button *)

val draw_speed_upgrade_button : bear -> float -> float -> float -> float -> unit
(** Upgrade attack speed button *)

val display_selection : bear option -> unit
(**Displays the selection GUI for placed bears, if a bear is selected.*)

val display_bear_info : bear option -> bear option -> unit
(**check_click takes care of updating what should currently be displayed.
   Important: Always draw the select_display before the hover_display.*)
