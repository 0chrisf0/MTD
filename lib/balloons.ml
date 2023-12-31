open Raylib
open Bears
open Constants

type balloon_colors =
  | None
  | Red
  | Blue
  | Green
  | Orange
  | Purple
  | Yellow
  | Lead

(* Maps a balloon to an integer value. *)
let value_of_balloon = function
  | None -> 0
  | Red -> 1
  | Blue -> 2
  | Green -> 3
  | Yellow -> 4
  | Orange -> 5
  | Purple -> 6
  | Lead -> 7

let balloon_of_value = function
  | 1 -> Red
  | 2 -> Blue
  | 3 -> Green
  | 4 -> Yellow
  | 5 -> Orange
  | 6 -> Purple
  | 7 -> Lead
  | _ -> None

type balloon = {
  mutable color : balloon_colors;
  mutable velocity : Raylib.Vector2.t;
  mutable position : Raylib.Vector2.t;
  mutable img : Raylib.Texture2D.t;
  mutable current_turn : int;
  mutable remove : bool;
  mutable freeze_duration : int;
}

let pops : Vector2.t list ref = ref []
let hitbox_width = ref 0.0
let hitbox_height = ref 0.0

let setup_hitbox path_width =
  hitbox_width := path_width /. 1.5;
  hitbox_height := path_width /. 1.5

(* This should be dependent on the size of the balloon image. Needs fine tuning. *)
let get_hitbox (balloon : balloon) =
  Rectangle.create
    (Vector2.x balloon.position -. (!hitbox_width /. 2.))
    (Vector2.y balloon.position -. (!hitbox_height /. 2.))
    !hitbox_width !hitbox_height

let draw_balloon path_width (balloon : balloon) =
  let x = Vector2.x balloon.position in
  let y = Vector2.y balloon.position in
  draw_texture_pro balloon.img
    (Rectangle.create 0. 0. 385. 500.)
    (Rectangle.create x y (path_width /. 0.9) path_width)
    (Vector2.create (path_width /. 1.8) (path_width /. 2.))
    0.
    (Color.create 255 255 255 255)

(* Draws pop image at the given position when called *)
let draw_pop position =
  draw_texture_pro (Option.get !pop_img)
    (Rectangle.create 0. 0. 146. 120.)
    (Rectangle.create (Vector2.x position) (Vector2.y position) 80. 80.)
    (Vector2.create 40. 40.) 0.
    (Color.create 255 255 255 255)

(* Draws balloons in a balloon list. *)
let rec draw_balloons path_width (balloon_list : balloon list) =
  match balloon_list with
  | [] -> ()
  | h :: t ->
      draw_balloon path_width h;
      draw_balloons path_width t

(**Draws all the pops that should be drawn in the current frame.*)
let rec draw_pops pop_list =
  match pop_list with
  | [] -> ()
  | position :: t ->
      draw_pop position;
      draw_pops t

let determine_image balloon_type =
  match balloon_type with
  | None -> failwith "impossible?"
  | Red -> Option.get !red_balloon_img
  | Blue -> Option.get !blue_balloon_img
  | Green -> Option.get !green_balloon_img
  | Yellow -> Option.get !yellow_balloon_img
  | Orange -> Option.get !orange_balloon_img
  | Purple -> Option.get !purple_balloon_img
  | Lead -> Option.get !lead_balloon_img

(** Determines the velocity associated with a color of a balloon. *)
let determine_velocity = function
  | Red -> 2.0 *. float_of_int !Constants.speed_mult
  | Blue -> 3.0 *. float_of_int !Constants.speed_mult
  | Green -> 4. *. float_of_int !Constants.speed_mult
  | Yellow -> 4.5 *. float_of_int !Constants.speed_mult
  | Orange -> 4.5 *. float_of_int !Constants.speed_mult
  | Purple -> 5.5 *. float_of_int !Constants.speed_mult
  | Lead -> 3.0 *. float_of_int !Constants.speed_mult
  | _ -> 0.0

(* Changes the velocity of a balloon while preserving its direction. *)
let change_velocity balloon new_color =
  let velocity = balloon.velocity in
  if Vector2.x velocity = 0.0 then
    if Vector2.y velocity >= 0.0 then
      Vector2.create 0.0 (determine_velocity new_color)
    else Vector2.create 0.0 (-1.0 *. determine_velocity new_color)
  else if Vector2.x velocity >= 0.0 then
    Vector2.create (1.0 *. determine_velocity new_color) 0.0
  else Vector2.create (-1.0 *. determine_velocity new_color) 0.0

(* Creates a balloon given the color. *)
let make_balloon color =
  let position =
    Raylib.Vector2.create (-30.0) (3. *. floor (!screen_height /. 28.5))
  in
  let x = Vector2.x position in
  let y = Vector2.y position in
  {
    color;
    velocity = Raylib.Vector2.create (determine_velocity color) 0.0;
    position = Vector2.create x y;
    img = determine_image color;
    current_turn = 0;
    remove = false;
    freeze_duration = 0;
  }

let balloon_of_string = function
  | "Red" -> make_balloon Red
  | "Blue" -> make_balloon Blue
  | "Green" -> make_balloon Green
  | "Orange" -> make_balloon Orange
  | "Purple" -> make_balloon Purple
  | "Yellow" -> make_balloon Yellow
  | "Lead" -> make_balloon Lead
  | _ -> failwith "Balloon color does not exist"

(***Lowers player lives when a balloon crosses the finish line based on the
   value of that balloon. *)
let lower_lives balloon = Constants.(lives := !lives - value_of_balloon balloon)

(*Checks if a balloon has reached the finish line. *)
let check_balloon_exit (balloon : balloon) =
  let y = Vector2.y balloon.position in
  if y < Constants.end_line then (
    lower_lives balloon.color;
    true)
  else false

let set_balloon_color balloon new_color =
  balloon.color <- new_color;
  balloon.img <- determine_image new_color;
  balloon.velocity <- change_velocity balloon new_color

(**Updates a balloons color, etc. after a collision with a projectile.
    If bear is a zombie, slows down the balloon*)
let update_balloon_status bear balloon =
  if (balloon.color = Lead && bear.pops_lead) || not (balloon.color = Lead) then
    let new_value = value_of_balloon balloon.color - bear.damage in
    match balloon_of_value new_value with
    (*If none, the balloon should be removed.*)
    | None ->
        balloon.remove <- true;
        Constants.cash := !Constants.cash + value_of_balloon balloon.color;
        pops := balloon.position :: !pops
    | color ->
        set_balloon_color balloon color;
        Constants.cash := !Constants.cash + new_value;
        pops := balloon.position :: !pops

(** Modifies the given balloon to be the correct layer color based on the damage
   of the bear. If lead ballon hit and not able to pop lead, do not modify balloon.*)
let hit_update (bear : bear) (balloon : balloon) =
  if balloon.remove then () else update_balloon_status bear balloon

(* Removes a balloon if it has crossed the finish line and reduces a player's
   lives by calling lower_lives. *)
let rec remove_balloons (balloon_lst : balloon list) =
  match balloon_lst with
  | [] -> []
  | balloon :: t ->
      if check_balloon_exit balloon || balloon.remove then remove_balloons t
      else balloon :: remove_balloons t
