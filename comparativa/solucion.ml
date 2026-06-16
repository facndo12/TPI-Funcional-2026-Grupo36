(* =======================================================
   FUNCION: transicion

   NATURALEZA: Pura
   (No produce efectos secundarios. Para las mismas
   entradas siempre devuelve la misma salida.)

   ESTRATEGIA: Pattern Matching
   (Utiliza match ... with para evaluar los distintos
   estados y destinos posibles.)

   IMPACTO: No destructiva
   (No modifica estructuras existentes, solamente
   devuelve una nueva tupla con el estado y la acción.)

   ======================================================= *)

type estado =
  | EnRojo
  | EnVerde
  | EnAmarillo

type destino =
  | Rojo
  | Verde
  | Amarillo

let transicion color_actual cambiar_a =
  match (color_actual, cambiar_a) with

  | (EnRojo, Verde) ->
      (EnRojo, "EnRojo, cambiar-a-verde")

  | (EnVerde, Amarillo) ->
      (EnVerde, "EnVerde, cambiar-a-amarillo")

  | (EnAmarillo, Rojo) ->
      (EnAmarillo, "EnAmarillo, cambiar-a-rojo")

  | _ ->
      (color_actual, "accion-por-defecto")

let () =
  print_endline "Pruebas de transicion";


(* ========================================================================== *)
(* FUNCIÓN: timer_basico                                                      *)
(* NATURALEZA: Pura (Dado un timestamp, siempre retorna el mismo color)       *)
(* ESTRATEGIA: Expresiones Condicionales mapeo Matemático                   *)
(* IMPACTO: No destructiva                                                    *)
(* ========================================================================== *)

type estado_basico = 
  | EnRojo 
  | EnVerde 
  | EnAmarillo

let timer_basico (tiempo_unix : int) : estado_basico =
  
  let rojo = 90 in
  let amarillo = 6 in
  let verde = 120 in
  
  let segundo = tiempo_unix mod (rojo + amarillo + verde) in


  if segundo < rojo then
    EnRojo
  else if segundo < (rojo + verde) then
    EnVerde
  else
    EnAmarillo

(* Caso de prueba *)
let () =

  let resultado = timer_basico 100 in

  print_endline (
    match resultado with
    | EnRojo -> "Resultado Básico: EN ROJO"
    | EnVerde -> "Resultado Básico: EN VERDE"
    | EnAmarillo -> "Resultado Básico: EN AMARILLO"
  )
  )
