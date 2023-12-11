(** This file specifies the properties and behaviors of balloons. There
   are several different colors of balloons, each with their own velocities
   and associated values. *)

open Raylib
open Bears

type balloon_colors =
  | None
  | Red
  | Blue
  | Green
  | Orange
  | Purple
  | Yellow
  | Lead

val value_of_balloon : balloon_colors -> int
(**Maps a balloon to an integer value. *)

val balloon_of_value : int -> balloon_colors
(**Maps an integer value to a ballon color*)

type balloon = {
  mutable color : balloon_colors;
  mutable velocity : Raylib.Vector2.t;
  mutable position : Raylib.Vector2.t;
  mutable img : Raylib.Texture2D.t;
  mutable current_turn : int;
  mutable remove : bool;
  mutable freeze_duration : int;
}

val balloon_of_string : string -> balloon
(**Maps a string to a new balloon.*)

val pops : Vector2.t list ref
(**The positions of pops that occurred this frame.*)

val hitbox_width : float ref
(**The calculated hitbox width, for use by functions in this module and others.*)

val hitbox_height : float ref
(**The calculated hitbox height, for use by functions in this module and others.*)

val setup_hitbox : float -> unit
(**Sets up the size of the balloon hitbox given the path_width (which depends
       on the screen size).*)

val get_hitbox : balloon -> Rectangle.t
(**Gets the rectangle representing the hitbox of a given balloon. *)

val draw_balloon : float -> balloon -> unit
(**Draws a given balloon given the path_width.*)

val draw_pop : Vector2.t -> unit
(** Draws pop image at the given position when called *)

val draw_pops : Vector2.t list -> unit
(**Draws all the pops that should be drawn in the current frame.*)

val draw_balloons : float -> balloon list -> unit
(** Draws all the balloons in a balloon list. *)

val determine_image : balloon_colors -> Texture2D.t
(**Determines the image for a balloon given its color.*)

val determine_velocity : balloon_colors -> float
(** Determines the velocity for a balloon given its color. *)

val change_velocity : balloon -> balloon_colors -> Raylib.Vector2.t
(** Changes the velocity of a balloon while preserving its direction. *)

val make_balloon : balloon_colors -> balloon
(**Creates a balloon given the color. *)

val lower_lives : balloon_colors -> unit
(**Lowers player lives when a balloon crosses the finish line based on the
      value of that balloon. *)

val check_balloon_exit : balloon -> bool
(**Checks if a balloon has reached the finish line. *)

val set_balloon_color : balloon -> balloon_colors -> unit
(**Sets the balloon's color to be a given color, also updating the necessary
       fields.*)

val update_balloon_status : bear -> balloon -> unit
(**Updates a balloons color, etc. after a collision with a projectile.
       If bear is a zombie, slows down the balloon*)

val hit_update : bear -> balloon -> unit
(** Modifies the given balloon to be the correct layer color based on the damage
      of the bear. If lead ballon hit and not able to pop lead, do not modify balloon.*)

val remove_balloons : balloon list -> balloon list
(** Removes a balloon if it has crossed the finish line and reduces a player's
      lives by calling lower_lives. *)
