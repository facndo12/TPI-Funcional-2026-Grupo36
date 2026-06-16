(* =======================================================
   FUNCION: transicion_v2

   NATURALEZA: Pura
   (No produce efectos secundarios. Para las mismas
   entradas siempre devuelve la misma salida.)

   ESTRATEGIA: Pattern Matching
   (Utiliza match ... with para evaluar los distintos
   estados y destinos posibles del semáforo.)

   IMPACTO: No destructiva
   (No modifica estructuras existentes, solamente
   construye y devuelve una nueva tupla con el estado
   y la acción correspondiente.)

   ======================================================= *)
type estado =
  | EnRojo
  | EnVerde
  | EnAmarillo
  | IntermitenteRojoVerde
  | IntermitenteVerdeAmarillo
  | IntermitenteAmarilloRojo

type destino =
  | Rojo
  | Verde
  | Amarillo
  | AIntermitenteRojoVerde
  | AIntermitenteVerdeAmarillo
  | AIntermitenteAmarilloRojo

let transicion_v2 color_actual cambiar_a =
  match (color_actual, cambiar_a) with
  | (EnRojo, AIntermitenteRojoVerde) ->
      (EnRojo, "cambiar-a-intermitente-rojo-verde")

  | (IntermitenteRojoVerde, Verde) ->
      (IntermitenteRojoVerde, "cambiar-a-verde")

  | (EnVerde, AIntermitenteVerdeAmarillo) ->
      (EnVerde, "cambiar-a-intermitente-verde-amarillo")

  | (IntermitenteVerdeAmarillo, Amarillo) ->
      (IntermitenteVerdeAmarillo, "cambiar-a-amarillo")

  | (EnAmarillo, AIntermitenteAmarilloRojo) ->
      (EnAmarillo, "cambiar-a-intermitente-amarillo-rojo")

  | (IntermitenteAmarilloRojo, Rojo) ->
      (IntermitenteAmarilloRojo, "cambiar-a-rojo")

  | _ ->
      (color_actual, "accion-por-defecto")

let () =
  let (_, accion1) =
    transicion_v2 IntermitenteRojoVerde  Verde
  in
  print_endline accion1
;;


(* ========================================================================== *)
(* FUNCIÓN: Timer                                                             *)
(* NATURALEZA: Pura                                                           *)
(* ESTRATEGIA: Expresiones condicionales y mapeo matematico                   *)
(* IMPACTO: No destructiva                                                    *)
(* ========================================================================== *)

type estado_semaforo = 
  | EnRojo 
  | IntermitenteRojoVerde 
  | EnVerde 
  | IntermitenteVerdeAmarillo 
  | EnAmarillo 
  | IntermitenteAmarilloRojo

let timer 
    (tiempoUnix : int) 
    (rojo : int) 
    (inter_rojo_verde : int) 
    (verde : int) 
    (inter_verde_amarillo : int) 
    (amarillo : int) 
    (inter_amarillo_rojo : int) : estado_semaforo =

  let segundo = 
    tiempoUnix mod (rojo + inter_rojo_verde + verde + inter_verde_amarillo + amarillo + inter_amarillo_rojo) 
  in

  if segundo < rojo then
    EnRojo
  else if segundo < (rojo + inter_rojo_verde) then
    IntermitenteRojoVerde
  else if segundo < (rojo + inter_rojo_verde + verde) then
    EnVerde
  else if segundo < (rojo + inter_rojo_verde + verde + inter_verde_amarillo) then
    IntermitenteVerdeAmarillo
  else if segundo < (rojo + inter_rojo_verde + verde + inter_verde_amarillo + amarillo) then
    EnAmarillo
  else
    IntermitenteAmarilloRojo

(*Caso de prueba:*)
let () =
  
  let resultado = timer 92 90 3 120 3 6 3 in

  print_endline (
    match resultado with
    | EnRojo -> "Resultado: EN ROJO"
    | IntermitenteRojoVerde -> "Resultado: INTERMITENTE ROJO -> VERDE"
    | EnVerde -> "Resultado: EN VERDE"
    | IntermitenteVerdeAmarillo -> "Resultado: INTERMITENTE VERDE -> AMARILLO"
    | EnAmarillo -> "Resultado: EN AMARILLO"
    | IntermitenteAmarilloRojo -> "Resultado: INTERMITENTE AMARILLO -> ROJO"
  )
