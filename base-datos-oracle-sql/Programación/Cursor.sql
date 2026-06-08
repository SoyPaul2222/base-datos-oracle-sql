create or replace procedure ConsultarJugadorAmpliat(id integer)
is
    cursor mi_pokemon is
        select j.codigo as codigo, j.nombre as nombreJugador, j.procedencia as procedencia, 
               j.altura as altura, j.peso as peso, j.posicion as posicion, j.nombre_equipo as nombreEquipo, 
               e.ciudad as ciudad, e.conferencia as conferencia, e.division as division, 
               es.temporada as temporada, es.puntos_por_partido as puntos,
               es.rebotes_por_partido as rebotes, es.asistencias_por_partido as asistencias
        from jugador j
        join equipo e on (j.nombre_equipo = e.nombre)
        join estadisticas es on (j.codigo = es.codigo)
        where j.codigo = id;
        primer_registre boolean := true;
begin
    for x in mi_pokemon loop
          if primer_registre then    
              DBMS_OUTPUT.put_line('*******************************************************');
              DBMS_OUTPUT.put_line('Dades de jugador');
              DBMS_OUTPUT.put_line('*******************************************************');
              DBMS_OUTPUT.put_line('CODI: ' || x.codigo);  
              DBMS_OUTPUT.put_line('NOM: ' || x.nombreJugador);
              DBMS_OUTPUT.put_line('EQUIP: ' || x.nombreEquipo || ' (' || x.ciudad || ')');
              DBMS_OUTPUT.put_line('CONFERÈNCIA: ' || x.conferencia || '   DIVISIÓ: ' || x.division);
              DBMS_OUTPUT.put_line('POSICIÓ: ' || posicioToString(x.posicion));
              DBMS_OUTPUT.put_line('ALÇADA (peus): ' || x.altura || '    ALÇADA (cm): ' || peusToCm(x.altura));
              DBMS_OUTPUT.put_line('PES (lliures): ' || x.peso || '    PES (Kg): ' || lliuresToKg(x.peso));
              DBMS_OUTPUT.put_line('PROCEDÈNCIA: ' || x.procedencia);
              DBMS_OUTPUT.put_line('');
              DBMS_OUTPUT.put_line('ESTADISTIQUES');
              DBMS_OUTPUT.put_line('--------------------------------------------------------');
              DBMS_OUTPUT.put_line('Temporada' || '     ' || 'Punts' || '     ' || 'Rebots' || '     ' || 'Assistències');
            primer_registre := false;
         end if;
              DBMS_OUTPUT.put_line(REPLACE(x.temporada, '/', '-') || '         ' || x.puntos ||'       ' || x.rebotes ||'     ' || x.asistencias);
  
    end loop;
end;
/