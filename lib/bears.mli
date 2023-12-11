(**This file contains all the functions responsible for modifying and creating bears. 
    This includes menu bears and the actual bears in game.*)

open Raylib

type bear_types = Dart | Hockey | Polar | Sniper | Dragon

type bear = {
  bear_type : bear_types;
  mutable range : float;
  mutable cost : int;
  mutable upgrades : int;
  mutable position : Raylib.Vector2.t;
  mutable texture : Raylib.Texture2D.t;
  image_width : float;
  image_height : float;
  is_placed : bool;
  mutable attack_speed : int;
  mutable counter : int;
  mutable projectile_speed : float;
  mutable sold : bool;
  mutable damage : int;
  mutable facing : float;
  mutable pops_lead : bool;
  mutable freeze_duration : int;
  mutable isFiring : bool;
}

val bear_collection : bear list ref
val bear_radius : float
val menu_bear_radius : float

val get_x : bear -> float
(**Gets the x position of the given bear.*)

val get_y : bear -> float
(**Gets the y position of the given bear.*)

val fire_rect_length : float
val fire_rect_width : float
val selected_bear : bear option ref

val menu_bears : bear list ref
(**The bears displayed on the menu.*)

val determine_image : bool -> bear_types -> Texture2D.t
(**Determines the image for a bear given its type and whether its a menu bear.*)

val string_of_beartype : bear_types -> string
(**Given a bear type, gives the string representation.*)

val extract_bear_properties : bear_types -> Yojson.Basic.t
(**Extract the json dictionary containing the properties for the given bear type.*)

val make_bear : bool -> bear_types -> Vector2.t -> bear
(**Creates a bear given whether the bear is a menu bear the type of a bear, and its position.*)

val generate_menu_bears : float -> float -> bear list
(**A list containing all the different bears to be displayed on the menu.*)

val determine_bear_clicked : Vector2.t -> bear list -> bear option
(** Returns the bear clicked, if any.*)

val determine_bear_hovered : Vector2.t -> bear list -> bear option
(** Returns the bear being hovered over, if any.*)

val draw_menu_bear : bear -> unit
(**Draws a bear on the menu.*)

val dest_rect_custom : bear -> float -> float -> Rectangle.t
(** Helps with resizing of images to make sure all bears are similar size*)

val origin_vect_custom : bear -> Vector2.t
(** Helps with placement of images to ensure its centered, the factor must be
   1/2 of factor for dest_rect!*)

val draw_bear : bear -> unit
(** draw_bear function *)

val draw_bears : bear list -> unit
(**Draws the placed bears in the game*)

val draw_menu_bears : bear list -> unit
(**Draws all the menu bears in a given list.*)

val draw_selected_bear : bear option -> unit
(**Draws the bear the user is currently dragging across the screen.*)

val check_circle_collision : Vector2.t -> Vector2.t -> float -> bool
(**Checks for a collision between two circles.*)

val update_selected_bear : bear option -> Vector2.t -> unit
(**Updates the position of the currently selected bear based on where the user
    has dragged it.*)

val check_collision_bears : bear option -> bear list -> bool
(**Checks if a given bear is colliding with any of the bears in a given list.*)

val remove_bears : bear list -> bear list
(**Returns a list with the sold bears removed.*)

val update_bear_firing_rate : bear list -> unit
(** Updates the firing rates of bears according to the speed multiplier*)
