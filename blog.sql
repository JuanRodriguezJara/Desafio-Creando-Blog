--! Creamos la base de datos.
CREATE DATABASE blog;

--! Cambiamos a la base de datos creada.
\c blog;

--! Creamos la tabla "usuario".
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255)
);

--! Creamos la tabla "post"
CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    usuario_id INT,
    titulo VARCHAR(100),
    fecha DATE,
    FOREIGN KEY (usuario_id) REFERENCES usuario (id)   
);

--! Creamos la tabla "comentario"
CREATE TABLE comentario (
    id SERIAL PRIMARY KEY,
    post_id INT,
    usuario_id INT,
    texto VARCHAR(255),
    fecha DATE,
    FOREIGN KEY (post_id) REFERENCES post (id),
    FOREIGN KEY (usuario_id) REFERENCES usuario (id)
);

--Insertando usuarios.
INSERT INTO usuario (email)
VALUES ( 'usuario01@hotmail.com'), ('usuario02@hotmail.com'), ('usuario03@hotmail.com'), ('usuario04@hotmail.com'),
('usuario05@hotmail.com'), ('usuario06@hotmail.com'), ('usuario07@hotmail.com'), ('usuario08@hotmail.com'), ('usuario09@hotmail.com');

--Insertando post.
INSERT INTO post (usuario_id, titulo, fecha)
VALUES ('1', 'Post 1: Esto es malo', '2020-06-29'), ('5', 'Post 2: Esto es malo', '2020-06-20'), ('1', 'Post 3: Esto es excelente', '2020-05-30'), ('9', 'Post 4: Esto es bueno', '2020-05-09'), ('7', 'Post 5: Esto es malo', '2020-07-10'), ('5', 'Post 6: Esto es excelente', '2020-07-18'), ('8', 'Post 7: Esto es excelente', '2020-07-07'),  ('5', 'Post 8: Esto es excelente', '2020-05-14'),  ('2', 'Post 9: Esto es bueno', '2020-05-08'),  ('6', 'Post 10: Esto es bueno', '2020-06-02'),  ('4', 'Post 11: Esto es bueno', '2020-05-05'),
('9', 'Post 12: Esto es malo', '2020-07-23'), ('5', 'Post 13: Esto es excelente', '2020-05-30'), ('8', 'Post 14: Esto es excelente', '2020-05-01'), ('7', 'Post 15: Esto es malo', '2020-06-17');

--Insertando comentarios.
INSERT INTO comentario  (post_id, usuario_id, texto, fecha)
VALUES ('6', '3', 'Este es el comentario 1', '2020-07-08'), ('2', '4', 'Este es el comentario 2', '2020-06-07'), ('4', '6', 'Este es el comentario 3', '2020-06-16'), ('13', '2', 'Este es el comentario 4', '2020-06-15'), ('6', '6', 'Este es el comentario 5', '2020-05-14'), ('3', '3', 'Este es el comentario 6', '2020-07-08'), ('1', '6', 'Este es el comentario 7', '2020-05-22'), ('7', '6', 'Este es el comentario 8', '2020-07-09'), ( '13', '8', 'Este es el comentario 9', '2020-06-30'), ('6', '8', 'Este es el comentario 10', '2020-06-19'), ('1', '5', 'Este es el comentario 11', '2020-05-09'), ('15', '8', 'Este es el comentario 12', '2020-06-17'), ('9', '1', 'Este es el comentario 13', '2020-05-01'), ('5', '2', 'Este es el comentario 14', '2020-05-31'), ('3', '4', 'Este es el comentario 15', '2020-06-28');

-- Seleccionar el correo, id y título de todos los post publicados por el usuario 5.
SELECT
u.email,
p.id,
p.titulo
FROM usuario u
LEFT JOIN post p ON p.usuario_id = u.id
WHERE u.id = 5;

-- Listar el correo, id y el detalle de todos los comentarios que no hayan sido realizados por el usuario con email usuario06@hotmail.com.
SELECT
u.email,
c.id,
c.texto
FROM usuario u
LEFT JOIN comentario c ON c.usuario_id = u.id
WHERE u.email <>'usuario06@hotmail.com'
ORDER BY u.email;

--  Listar los usuarios que no han publicado ningún post.
SELECT u.email
FROM usuario u
LEFT JOIN post p ON u.id = p.usuario_id
WHERE p.usuario_id IS NULL;

-- O tambien lo podemos obtener de la siguiente forma
SELECT email FROM usuario WHERE id NOT IN (SELECT usuario_id FROM post WHERE usuario.id = post.usuario_id);

-- Listar todos los post con sus comentarios (incluyendo aquellos que no poseen comentarios).
SELECT 
p.*,
c.texto,
c.fecha
FROM post p
LEFT JOIN comentario c ON p.id = c.post_id;

-- Listar todos los usuarios que hayan publicado un post en Junio.
SELECT email FROM usuario WHERE EXISTS (SELECT usuario_id FROM post WHERE usuario.id = post.usuario_id AND post.fecha BETWEEN '2020-06-01' AND '2020-06-30'); 

-- O tambien lo podemos obtener de la siguiente forma.
SELECT 
u.email 
FROM (SELECT usuario_id FROM post WHERE EXTRACT (month FROM fecha) = 06) AS m
JOIN usuario u ON m.usuario_id = u.id;
