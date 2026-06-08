create or replace function treureEspais(text VARCHAR2) return VARCHAR2 
is
resultat VARCHAR2(2000);
begin
    if text is NULL THEN
        return '';
    end if;    

    resultat := replace(text, ' ', '');
    return resultat;
end;
/

create or replace function kgToLliures(kg float) return integer
is lbs float;
begin
lbs := kg * 2.2046;
   return lbs;
end;
/


create or replace function lliuresToKg(lbs integer) return float
is kg float;
begin
kg := round(lbs / 2.2046, 1);
   return kg;
end;
/


create or replace function esAlcadaValida(alcada VARCHAR2) 
return INTEGER
is 
 peus varchar2(2000);
 polzades varchar2(2000);
 c char(1);
 guions integer := 0;
 pos_guio INTEGER := 0;
 i integer;
 alcada_net VARCHAR2(2000);
begin

alcada_net := treureEspais(alcada);

if length(alcada_net) < 3 or length(alcada_net) > 4 then
        return 0;
    end if;

    for i in 1..length(alcada_net) loop
      c := substr(alcada_net, i, 1);

      if c = '-' then
        guions := guions + 1;
        pos_guio := i;
      elsif c < '0' or c > '9' then
        return 0;
      end if;
    end loop;

    if guions != 1 or pos_guio != 2 then
        return 0;
    end if;

    peus := substr(alcada_net, 1, 1);
    polzades := substr(alcada_net, 3);

    if peus is null or peus = '' then
        return 0;
    end if; 

    if polzades is null or polzades = '' then
        return 0;
    end if; 

    if to_number(polzades) > 11 THEN
        return 0;
        end if;

    return 1;
end;
/

create or replace function posicioToString(posicio varchar2)
return varchar2
is
    net varchar2(2000);
    resultat varchar2(2000) := '';
    part varchar2(50);
    pos number;
begin
    if posicio is null then
        return null;
    end if;

    net := treureEspais(upper(posicio));

    while net is not null loop
        pos := instr(net, '-');

        if pos = 0 then
            part := net;
            net := null;
        else
            part := substr(net, 1, pos - 1);
            net := substr(net, pos + 1);
        end if;

        if part = 'G' then
            part := 'Base';
        elsif part = 'F' then
            part := 'Alero';
        elsif part = 'C' then
            part := 'Pívot';
        end if;

        if resultat is null or resultat = '' then
            resultat := part;
        else
            resultat := resultat || '-' || part;
        end if;

    end loop;

    return resultat;
end;
/