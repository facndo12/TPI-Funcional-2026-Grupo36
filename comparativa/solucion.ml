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