-- tabla caciones
CREATE TABLE caciones(
    id NUMBER PRIMARY KEY,
    titulo VARCHAR(50),
    reproducciones NUMBER,
    valoracion NUMBER,
    duracion NUMBER,
    id_artista NUMBER NOT NULL,
    FOREIGN KEY (id_artista) REFERENCES artistas(id_artista)
);

-- tabla artistas
CREATE TABLE artistas(
    id_artista NUMBER PRIMARY KEY,
    nombre VARCHAR(50)
);

INSERT INTO canciones VALUES (1,'El condor herido',100,5,6,1);
INSERT INTO canciones VALUES (2,'Una aventura',110,5,6,2);
INSERT INTO canciones VALUES (3,'Soy tan feliz',200,5,6,3);
INSERT INTO canciones VALUES (4,'El niagara en bicicleta',150,5,6,6);
INSERT INTO canciones VALUES (5,'torero',210,5,6,5);
INSERT INTO canciones VALUES (6,'Uno se cura',300,5,6,4);
INSERT INTO canciones VALUES (7,'Leidy laura',150,5,6,4);
INSERT INTO canciones VALUES (8,'sin sentimiento',400,5,6,2);
INSERT INTO canciones VALUES (9,'Eres',240,5,6,2);
INSERT INTO canciones VALUES (10,'La reina',110,5,6,1);
INSERT INTO canciones VALUES (11,'La bilirrubina',500,5,6,6);
INSERT INTO canciones VALUES (12,'Aguzate',105,5,6,3);
INSERT INTO canciones VALUES (13,'vas a llorar',100,5,6,5);
INSERT INTO canciones VALUES (14,'Buenaventura y caney',180,5,6,2);
INSERT INTO canciones VALUES (15,'Visa para un sueño',450,5,6,6);
INSERT INTO canciones VALUES (16,'Como yo',50,5,3,6);
INSERT INTO canciones VALUES (17,'Soldado',50,5,10,6);
INSERT INTO canciones VALUES (18,'Manguito Biche',50,5,0.1,1);

-- eliminar todas las canciones 
delete from canciones;

-- consultar todas las canciones
SELECT * FROM canciones;

-- consulta canciones con duración superior a 5 minutos
select c.* from canciones c where c.duracion > 5;

-- consulta duración total de todas las caciones.
select sum(duracion) from canciones; 

-- consulta numero de canciones en BD.
select count(id) from canciones;

-- consulta la canción más larga
select c.* from canciones c where c.duracion = (select max(duracion) from canciones);

-- consultar caciones especifica de un artista
select c.titulo, a.nombre from canciones c, artistas a 
where c.id_artista = a.id_artista and a.id_artista = 6; 

-- consulta titulo y nombre de las caciones y artistas
select c.titulo, a.nombre from canciones c, artistas a 
where c.id_artista = a.id_artista; 

INSERT INTO artistas VALUES (1,'Diomedez Dias');
INSERT INTO artistas VALUES (2,'Grupo niche');
INSERT INTO artistas VALUES (3,'Richey rey and Boobby Cruz');
INSERT INTO artistas VALUES (4,'Raulin Rosendo');
INSERT INTO artistas VALUES (5,'Guayacan');
INSERT INTO artistas VALUES (6,'Juan luis guerra');

-- consultar artistas
select * from artistas;

-- función calcular promerio de las canciones
create or replace function cal_duracion_promedio
return number
is
duracion_promedio number;
begin
    select avg(duracion) into duracion_promedio from canciones;
    
    return duracion_promedio;
end;
/

SET SERVEROUTPUT ON;
declare
duracion_promedio number := 0;
begin
    duracion_promedio := cal_duracion_promedio();
    DBMS_OUTPUT.PUT_LINE('Promedio duración -> '||duracion_promedio);
end;
/

-- procedimiento para calcular si es larga o corta una canción
create or replace PROCEDURE cal_cancion_tamaño
is
begin
    for cancion in (select * from canciones) loop
        if cancion.duracion > 7 then
            DBMS_OUTPUT.PUT_LINE('LARGA');
        else    
            DBMS_OUTPUT.PUT_LINE('CORTA');
        end if;
    end loop;
    
end cal_cancion_tamaño;
/

SET SERVEROUTPUT ON;
begin
    cal_cancion_tamaño;
end;
/
-- prodecimiento para consultar canciones mas reproducidas por un artista
create or replace PROCEDURE mas_reproducida(idArtista in number, nombreCancion out varchar)
is
nombreCancion varchar(30):= '';
begin
    select c.titulo into nombreCancion from canciones c 
    where c.reproducciones = (select max(cc.reproducciones) from canciones cc where cc.id_artista = c.id_artista) and c.id_artista = idArtista;
end mas_reproducida;
/


-- trigger para canciones menores a un minuto
create or replace trigger evitar_canciones
before insert on canciones
for each row
begin
    if :new.duracion < 1 then
        RAISE_APPLICATION_ERROR(-20001,'Canción no debe ser menor a un minuto');
    end if ;
end;
/

/*
ACID
atomicidad, consistencia, aislamiento, durabilidad
propiedades para garantizar que las transacciones se realicen de manera confiable.
1. la transacción debe ser un todo o nada.
2. los datos que se introduzcan en la BD deben ser del mismo tipo de las columnas.
3. cada transacción al ejecutarse debe ser independiente.
4. si la transacción es completada se debe conservar aunque después ocurran fallos en la BD.
*/

/*
Diferencias entre un LIKE o un IN
con el operador like el resultado de la busqueda debe cumplir con con ciertos caracteres 
ejemplo: select * from canciones where titulo like '%la%';.

con el oprador IN la busqueda sera solo por los parametros que esten dentro del IN.
ejemplo: select * from canciones where reproducciones IN (100,150);
*/

