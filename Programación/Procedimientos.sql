Create or replace procedure BuscaJugador (jugador varchar2)
is
cursor pokemons IS
    
    select j.codigo as codigo, 
           j.nombre as nombreJugador,
           j.nombre_equipo as equipo,
           e.ciudad as ciudad
    from jugador j 
    join equipo e on (j.nombre_equipo = e.nombre)
    where lower(j.nombre) like '%' || lower(jugador) || '%';
    i integer:= 0;
begin
    
    dbms_output.put_line('Codi   ' || 'Nom    ' || 'Equip   ' || '  Ciutat');
    DBMS_OUTPUT.put_line('*******************************************************');
    for x in pokemons LOOP
       i := i + 1;
        dbms_output.put_line(x.codigo || '    ' || x.nombreJugador || '    ' || x.equipo || '    ' || x.ciudad);
    end loop;
    dbms_output.put_line('Total jugadors mostrats: ' || i);
end;
/    


create or replace procedure JugadorsCiutat(ciudad VARCHAR2)
is
cursor jugadores IS
    select j.nombre as nombreJugador,
           j.nombre_equipo as equipo,
           e.ciudad 
    from jugador j
    join equipo e on (j.nombre_equipo = e.nombre)
    where e.ciudad = ciudad
    order by j.nombre_equipo asc, j.nombre asc;
begin
    dbms_output.put_line('Nom' || '                  ' || 'Equip');
    dbms_output.put_line('****************************');
    for x in jugadores LOOP
        dbms_output.put_line(x.nombreJugador || '        ' || x.equipo);
    end loop;
end;
/

create or replace PROCEDURE NouJugador(nom jugador.nombre%type, 
                                       procedencia jugador.procedencia%type,
                                       alcada jugador.altura%type,
                                       pes jugador.peso%type,
                                       posicio jugador.posicion%type,
                                       equip jugador.nombre_equipo%type  
                                        )
IS

  codi jugador.codigo%type;

  error_check EXCEPTION;
  PRAGMA exception_init(error_check, -2290);

  error_equip EXCEPTION;
  PRAGMA exception_init(error_equip, -2291);

BEGIN

    IF nom IS NULL OR equip IS NULL THEN
        dbms_output.put_line('Error: El nom i l''equip no poden estar buits.');
        RETURN;
    END IF;
    
    select max(codigo)+1 into codi from jugador;

   if esAlcadaValida(alcada) = 0 then
     dbms_output.put_line('Alcada incorrecte');
        return;
    end if;

    insert into jugador values (codi, nom, procedencia, alcada, pes, posicio, equip);
    dbms_output.put_line('S''ha donat d''alta correctament al jugador ' || nom || ' i se li ha assignat el codi ' || codi);
EXCEPTION
WHEN error_check THEN
        IF pes <= 130 OR pes > 400 THEN
            dbms_output.put_line('Error: El pes ' || pes || ' és incorrecte. Ha d''estar entre 130 i 400.');
        ELSIF posicio NOT IN ('C', 'F', 'G', 'C-F', 'C-G', 'F-C', 'F-G', 'G-C','G-F') THEN
            dbms_output.put_line('Error: La posició (' || posicio || ') és incorrecte.');
        END IF;
WHEN error_equip THEN
        dbms_output.put_line('Error: L''equip ' || equip || ' no existeix');
WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.put_line('Error de tipus de dades.');
end;
/

create or replace PROCEDURE NouJugadorEuropeu(nom jugador.nombre%type, 
                                       procedencia jugador.procedencia%type,
                                       alcadaCm number,
                                       pesKg float,
                                       posicio jugador.posicion%type,
                                       equip jugador.nombre_equipo%type  
                                        )
IS

  codi jugador.codigo%type;
  lbs integer;
  polzades VARCHAR2(2000);

  error_check EXCEPTION;
  PRAGMA exception_init(error_check, -2290);

  error_equip EXCEPTION;
  PRAGMA exception_init(error_equip, -2291);

BEGIN

    IF nom IS NULL OR equip IS NULL THEN
        dbms_output.put_line('Error: El nom i l''equip no poden estar buits.');
        RETURN;
    END IF;

    lbs := kgToLliures(pesKg);
    select max(codigo)+1 into codi from jugador;
    polzades := cmToPeus(alcadaCm);

    insert into jugador values (codi, nom, procedencia, polzades, lbs, posicio, equip);
    dbms_output.put_line('S''ha donat d''alta correctament al jugador ' || nom || ' i se li ha assignat el codi ' || codi);
EXCEPTION
WHEN error_check THEN
        IF lbs <= 130 OR lbs > 400 THEN
            dbms_output.put_line('Error: El pes ' || lbs || ' és incorrecte. Ha d''estar entre 130 i 400.');
        ELSIF posicio NOT IN ('C', 'F', 'G', 'C-F', 'C-G', 'F-C', 'F-G', 'G-C','G-F') THEN
            dbms_output.put_line('Error: La posició (' || posicio || ') és incorrecte.');
        END IF;
WHEN error_equip THEN
        dbms_output.put_line('Error: L''equip ' || equip || ' no existeix');
WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.put_line('Error de tipus de dades.');        
end;
/

create or replace procedure BaixaJugador(id integer)
is
codi jugador.codigo%type;
nom jugador.nombre%type;
procedencia jugador.procedencia%type;
alcada jugador.altura%type;
pes jugador.peso%type;
posicio jugador.posicion%type;
equip jugador.nombre_equipo%type; 
begin
    select codigo, nombre, procedencia, altura, peso, posicion, nombre_equipo 
    into codi, nom, procedencia, alcada, pes, posicio, equip
    from jugador
    where codigo = id;

    delete from jugador
    where codigo = id;
    dbms_output.put_line('S''ha donat de baixa correctament al jugador: ' || 
                         codi || ', ' || nom || ', ' || posicio || ', ' || equip);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('No hi ha cap jugador amb aquest número');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.put_line('Hi ha massa resultats. Concreta més la cerca');    
end;
/

create or replace procedure ConsultarJugador(id integer)
is
codi jugador.codigo%type;
nom jugador.nombre%type;
procedencia jugador.procedencia%type;
alcada jugador.altura%type;
alcadaEuropeu number;
pes jugador.peso%type;
pesEuropeu float;
posicio jugador.posicion%type;
posicioLlarg VARCHAR2(2000);
equip jugador.nombre_equipo%type; 
ciutat equipo.ciudad%type;
conferencia equipo.conferencia%type;
divisio equipo.division%type;

begin
    select j.codigo, j.nombre, j.procedencia, j.altura, j.peso, j.posicion, j.nombre_equipo, e.ciudad, e.conferencia, e.division 
    into codi, nom, procedencia, alcada, pes, posicio, equip, ciutat, conferencia, divisio
    from jugador j
    join equipo e on (j.nombre_equipo = e.nombre)
    where j.codigo = id;

    pesEuropeu := lliuresToKg(pes);
    alcadaEuropeu := peusToCm(alcada);
    posicioLlarg := posicioToString(posicio);

    DBMS_OUTPUT.put_line('*******************************************************');
    DBMS_OUTPUT.put_line('Dades de jugador');
    DBMS_OUTPUT.put_line('*******************************************************');
    DBMS_OUTPUT.put_line('CODI: ' || codi);  
    DBMS_OUTPUT.put_line('NOM: ' || nom);
    DBMS_OUTPUT.put_line('EQUIP: ' || equip || ' (' || ciutat || ')');
    DBMS_OUTPUT.put_line('CONFERÈNCIA: ' || conferencia || '   DIVISIÓ: ' || divisio);
    DBMS_OUTPUT.put_line('POSICIÓ: ' || posicioLlarg);
    DBMS_OUTPUT.put_line('ALÇADA (peus): ' || alcada || '    ALÇADA (cm): ' || alcadaEuropeu);
    DBMS_OUTPUT.put_line('PES (lliures): ' || pes || '    PES (Kg): ' || pesEuropeu);
    DBMS_OUTPUT.put_line('PROCEDÈNCIA: ' || procedencia);

exception
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('No hi ha cap jugador amb aquest número');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.put_line('Hi ha massa resultats. Concreta més la cerca'); 
end;
/