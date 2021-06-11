--create database CasaDiscografica1

create table Band(
	ID int identity(1,1),
	Nome varchar(50) not null,
	NumeroComponenti int not null,
	primary key(ID),
	unique(Nome)
)

create table Album(
	ID int identity(1,1),
	Titolo varchar(50) not null,
	AnnoUscita int not null,
	CasaDiscografica varchar(50) not null,
	Genere varchar(50) not null,
	SupportoDistribuzione varchar(50) not null,
	BandID int,
	primary key(ID),
	foreign key (BandID) references Band(ID),
	unique (Titolo, AnnoUscita, CasaDiscografica, Genere, SupportoDistribuzione),
	check(Genere IN ('Classico', 'Jazz', 'Pop', 'Rock', 'Metal')),
	check(SupportoDistribuzione IN ('CD', 'Vinile', 'Streaming'))
)

create table Brano(
	ID int identity(1,1),
	Titolo varchar(50) not null,
	Durata int,
	primary key(ID)
)

create table AlbumBrano(
	AlbumID int,
	BranoID int,
	foreign key (AlbumID) references Album(ID),
	foreign key (BranoID) references Brano(ID)
)

insert Band values('883', 2)
insert Album values ('Hanno ucciso l uomo ragno', 1992, 'Fri Records', 'Pop', 'CD',1),
('Nord sud ovest est', 1993, 'Fri Records', 'Pop', 'CD',1), ('Uno in più', 2001, 'Wea International', 'Pop', 'CD',1)
insert Brano values ('Hanno ucciso l uomo ragno', 252), ('Con un deca', 300), ('Sei un mito', 306), ('Rotta x casa di Dio', 296),
('Bella vera', 215)
insert AlbumBrano values (1,1),(1,2),(2,3),(2,4),(3,5)

insert Band values ('Maneskin', 4)
insert Album values ('Il ballo della Vita', 2018, 'Sony Music', 'Rock', 'Vinile', 2),
('Il ballo della Vita', 2018, 'Sony Music', 'Rock', 'CD', 2), ('Il ballo della Vita', 2018, 'Sony Music', 'Rock', 'Streaming', 2),
('Teatro d ira Vol.1', 2021, 'Sony Music', 'Rock', 'Streaming', 2), ('Teatro d ira Vol.1', 2021, 'Sony Music', 'Rock', 'Vinile', 2), 
('Teatro d ira Vol.1', 2021, 'Sony Music', 'Rock', 'CD', 2)
insert Brano values ('Morirò da re', 157), ('Torna a casa', 230), ('Zitti e buoni', 192)
insert AlbumBrano values (4,6), (4,7), (5,6), (5,7), (6,6), (6,7), (7,8), (8,8), (9,8)

--sì lo so, la canzone si chiama IMAGINE, non so perché ho cambiato il titolo: la tengo così, in memoria della mia dislessia
-- in alternativa si potrebbe usare l'UPDATE (come mostro nella parte teorica)
insert Band values ('Jhon Lennon', 1)
insert Album values ('Image', 1971, 'Apple', 'Rock', 'CD', 3)
insert Brano values ('Image', 234)
insert AlbumBrano values (10,9)

insert Band values ('Mario Rossi & Co', 5)
insert Album values ('Imagine a song named Image', 2021, 'Sony Music', 'Metal', 'Vinile', 4)
insert Brano values ('Jolly', 700)
insert Brano values ('Una canzone chiamata Image', 100)
insert AlbumBrano values (11,10) 
insert AlbumBrano values (11,11)

insert Band values ('The Giornalisti', 3)
insert Album values ('Vecchio', 2012, 'Boombica Records', 'Rock', 'Streaming', 5),
('Fuoricampo', 2014, 'Foolica Records', 'Pop', 'CD', 5)
insert Brano values ('Cinema', 125), ('Insonnia', 197)
insert AlbumBrano values (12, 12), (13,13)

---------- query----------------

--titoli album 883
select a.Titolo as 'Album 883'
from Album A
join Band B
on A.BandID=B.ID
where B.Nome='883'

--album casa discografica in anno specifico (es 2019)
select A.Titolo
from Album A
group by A.CasaDiscografica, A.AnnoUscita, A.Titolo
having A.AnnoUscita=2021

--tutte canzoni Maneskin prima 2019
select distinct Br.Titolo
from Brano Br
join AlbumBrano AB
on AB.BranoID=Br.ID
join Album A
on AB.AlbumID=A.ID
join Band B
on A.BandID=B.ID
where B.Nome='Maneskin' AND A.AnnoUscita<2019

--album con una canzone che ha 'Image' nel titolo
select A.Titolo as 'Titolo Album'
from Album A
join AlbumBrano AB
on AB.AlbumID=A.ID
join Brano B
on AB.BranoID=B.ID
where B.Titolo like '%image%'

--numero canzoni The Giornalisti
select COUNT(*) as 'Numero canzoni'
from Brano Br
join AlbumBrano AB
on AB.BranoID=Br.ID
join Album A
on AB.AlbumID=A.ID
join Band B
on A.BandID=B.ID
where B.Nome='The Giornalisti'

--contare per ogni album somma minuti dei brani (??)
select A.Titolo as 'Titolo Album', SUM(B.Durata) as 'Durata Totale'
from Brano B
join AlbumBrano AB
on AB.BranoID=B.ID
join Album A
on AB.AlbumID=A.ID
group by A.Titolo, B.Durata

--view dettaglio completo
create view [Dettaglio Completo] as(
select BA.Nome, BA.NumeroComponenti as '#Componenti', A.Titolo as 'Titolo Album', A.AnnoUscita, A.Genere, A.CasaDiscografica,
A.SupportoDistribuzione, B.Titolo 'Titolo Brano', B.Durata
from Brano B
join AlbumBrano AB
on AB.BranoID=B.ID
join Album A
on AB.AlbumID=A.ID
join Band BA
on A.BandID=BA.ID
)

select*from[Dettaglio Completo]

--per ogni genere quanti album
create function ufnQuantiAlbumPerGenere (@Genere varchar(50))
returns int
as
begin
	return (select count(*)
	from Album A
	where A.Genere=@Genere
	group by A.ID)
end

select *, dbo.ufnQuantiAlbumPerGenere(A.Genere) as 'Numero Album'
from Album A










