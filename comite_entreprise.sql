#------------------------------------------------------------
#        Script MySQL.
#------------------------------------------------------------

drop database if exists ce;
create database ce;
use ce;

#------------------------------------------------------------
# Table: tresorerie
#------------------------------------------------------------

CREATE TABLE tresorerie(
        id_tresorerie Int  Auto_increment  NOT NULL ,
        fonds         Float,
		PRIMARY KEY (id_tresorerie)
);

#------------------------------------------------------------
# Table: activite
#------------------------------------------------------------

CREATE TABLE activite(
        id_activite   Int  Auto_increment  NOT NULL ,
        nom           Varchar (50),
        lieu          Varchar (50),
		image_url	  Varchar (200),
		lien	  	  Varchar (200),
        budget        Float,
        description   Varchar (400),
        date_debut    Date,
        date_fin      Date,
        prix          Float,
		nb_personnes  Int(5),
        id_tresorerie Int NOT NULL,
		PRIMARY KEY (id_activite),
		FOREIGN KEY (id_tresorerie) REFERENCES tresorerie(id_tresorerie)
);
#------------------------------------------------------------
# Table: utilisateur
#------------------------------------------------------------

CREATE TABLE utilisateur(
        idutilisateur Int  Auto_increment  NOT NULL ,
        username      Varchar (30),
        password      Varchar (30),
        email         Varchar (80),
		droits        Enum("salarie", "admin", "sponsor") NOT NULL,
		PRIMARY KEY (idutilisateur)
);
#------------------------------------------------------------
# Table: salarie
#------------------------------------------------------------

CREATE TABLE salarie(
        idutilisateur Int NOT NULL ,
        nom           Varchar (40),
        prenom        Varchar (40),
        tel           Varchar (15),
        adresse       Varchar (100),
        quotient_fam  Enum ("1","2","3","4","5"),
        service       Enum ("comptabilite","developpeur","commercial","ressources_humaines"),
        sexe          Enum ("homme","femme"),
		FOREIGN KEY (idutilisateur) REFERENCES utilisateur(idutilisateur)
);
#------------------------------------------------------------
# Table: sponsor
#------------------------------------------------------------

CREATE TABLE sponsor(
        idutilisateur Int NOT NULL ,
        societe       Varchar (100),
		image_url	  Varchar (200),
        budget        Float,
        tel           Varchar (15),
		lien	    Varchar (200),

		FOREIGN KEY (idutilisateur) REFERENCES utilisateur(idutilisateur)
		
);
#------------------------------------------------------------
# Table: commentaire
#------------------------------------------------------------

CREATE TABLE commentaire(
        id_commentaire Int  Auto_increment  NOT NULL ,
        datecomment    Date,
        contenu        Text,
        id_activite    Int NOT NULL ,
        idutilisateur  Int NOT NULL,
		PRIMARY KEY (id_commentaire),
		FOREIGN KEY (id_activite) REFERENCES activite(id_activite),
		FOREIGN KEY (idutilisateur) REFERENCES salarie(idutilisateur)
);
#------------------------------------------------------------
# Table: contact
#------------------------------------------------------------

CREATE TABLE contact(
        id_contact    Int  Auto_increment  NOT NULL ,
        objet         Varchar (50),
        contenu       Varchar (700),
        date          Date,
        idutilisateur Int NOT NULL,
		PRIMARY KEY (id_contact),
		FOREIGN KEY (idutilisateur) REFERENCES utilisateur(idutilisateur)
);
#------------------------------------------------------------
# Table: participer
#------------------------------------------------------------

CREATE TABLE participer(
        idutilisateur    Int NOT NULL ,
        id_activite      Int NOT NULL ,
        date_inscription Date,
		PRIMARY KEY (idutilisateur,id_activite),
		FOREIGN KEY (idutilisateur) REFERENCES salarie(idutilisateur),
		FOREIGN KEY (id_activite) REFERENCES activite(id_activite)
);




#------------------------------------------------------------
# Table: don
#------------------------------------------------------------

CREATE TABLE don(
		iddon Int  Auto_increment  NOT NULL ,
		datedon DATE,
		montant float,
		appreciation varchar(200),
		idutilisateur int not null,
		id_tresorerie int not null,
		PRIMARY KEY (iddon),
		FOREIGN KEY (idutilisateur) REFERENCES utilisateur(idutilisateur),
		FOREIGN KEY (id_tresorerie) REFERENCES tresorerie(id_tresorerie)
);



#------------------------------------------------------------
# View : utilisateur_sponsor
#------------------------------------------------------------

create view utilisateur_sponsor as (
	select 
		u.idutilisateur,
		u.username, 
		u.email,
		u.password,
		u.droits, 
		s.societe, 
		s.image_url,
		s.budget, 
		s.tel,
		s.lien
		
	from utilisateur u, sponsor s where u.idutilisateur = s.idutilisateur 
);


#------------------------------------------------------------
# View : utilisateur_salarie
#------------------------------------------------------------

create view utilisateur_salarie as (
	select  
		u.idutilisateur,
		u.username, 
		u.email,
		u.password,
		u.droits, 
		sa.nom, 
		sa.prenom,
		sa.sexe,
		sa.tel, 
		sa.adresse, 
		sa.quotient_fam, 
		sa.service
	from utilisateur u, salarie sa
	where u.idutilisateur = sa.idutilisateur
);


#------------------------------------------------------------
# View : utilisateur_salarie_activite
#------------------------------------------------------------

create view utilisateur_salarie_activite as (

	select 	
		u.idutilisateur,
		u.username, 
		u.email,
		u.password,
		u.droits, 
		sa.nom, 
		sa.prenom,
		sa.sexe,
		sa.tel, 
		sa.adresse, 
		sa.quotient_fam, 
		sa.service,
		a.nom as "nom_activite", 
		a.lieu, 
		a.image_url,
		a.lien,
		a.nb_personnes, 
		a.description, 
		sum(a.prix) as "prix_total", 
		p.date_inscription
	
	from  utilisateur u, salarie sa, participer p, activite a, tresorerie t
	where u.idutilisateur = sa.idutilisateur 
	and sa.idutilisateur = p.idutilisateur  
	and p.id_activite = a.id_activite  
);

#------------------------------------------------------------
# View : utilisateur_salarie_activite_commentaire
#------------------------------------------------------------

create view utilisateur_salarie_activite_commentaire as (

	select 	
		u.idutilisateur,
		u.username, 
		u.email,
		u.password,
		u.droits, 
		sa.nom, 
		sa.prenom, 
		sa.tel, 
		sa.adresse, 
		sa.service, 
		a.id_activite,
		a.nom as "nom_activite",
		a.lieu,
		a.image_url,
		a.lien,
		c.id_commentaire,
		c.contenu,
		c.datecomment
	
	
	from  utilisateur u, salarie sa, activite a, tresorerie t, commentaire c
	where u.idutilisateur = sa.idutilisateur 
	and c.idutilisateur = sa.idutilisateur
	and c.id_activite = a.id_activite 
);

#------------------------------------------------------------
# View : utilisateur_sponsor_don
#------------------------------------------------------------
create view utilisateur_sponsor_don as (
    select 
		u.idutilisateur,
		d.iddon,
        u.username , 
        u.email, 
		s.societe, 
		s.image_url,
		s.budget, 
		s.tel,
		s.lien,
		d.datedon,
        d.montant,
        d.appreciation,
		d.id_tresorerie

    from utilisateur u, sponsor s, don d
    where u.idutilisateur = s.idutilisateur 
	AND s.idutilisateur = d.idutilisateur
);


#------------------------------------------------------------
# View : utilisateur_contact
#------------------------------------------------------------


create view utilisateur_contact as (
	SELECT
		c.id_contact,
		c.objet,
		c.contenu,
		c.date,
		u.username,
		u.idutilisateur
	
	from contact c, utilisateur u
	where c.idutilisateur = u.idutilisateur
);

#------------------------------------------------------------
# View : utilisateur_administrateur 
#------------------------------------------------------------


create view utilisateur_administrateur as (
	SELECT
		*
	from utilisateur
	where utilisateur.droits="admin"
);

#------------------------------------------------------------
# View : utilisateur_salarie_activite_participer
#------------------------------------------------------------


create view utilisateur_salarie_activite_participer as (

	select 	
		u.idutilisateur,
		a.id_activite,
		u.username, 
		u.email,
		sa.nom, 
		sa.prenom, 
		sa.tel, 
		sa.adresse, 
		sa.service, 
		a.nom as "nom_activite",
		p.date_inscription,
		a.lieu,
		a.image_url,
		a.lien,
		a.description
		
	
	from  utilisateur u, salarie sa, participer p, activite a, tresorerie t
	where u.idutilisateur = sa.idutilisateur 
	and sa.idutilisateur = p.idutilisateur  
	and p.id_activite = a.id_activite
);


#------------------------------------------------------------
# Trigger : ajout_don_tresorerie
#------------------------------------------------------------


DROP trigger IF EXISTS ajout_don_tresorerie;
DELIMITER $
CREATE TRIGGER ajout_don_tresorerie
AFTER INSERT ON don
FOR EACH ROW
BEGIN
	UPDATE tresorerie SET fonds = fonds + new.montant
	WHERE new.id_tresorerie = id_tresorerie;
END $
DELIMITER ;

#------------------------------------------------------------
# Trigger : modifie_don_tresorerie
#------------------------------------------------------------

DROP trigger IF EXISTS modifie_don_tresorerie;
DELIMITER $
CREATE TRIGGER modifie_don_tresorerie
AFTER UPDATE ON don
FOR EACH ROW
BEGIN
	UPDATE tresorerie SET fonds = fonds - old.montant + new.montant
	WHERE new.id_tresorerie = id_tresorerie;
END $
DELIMITER ;

#------------------------------------------------------------
# Trigger : supprime_don_tresorerie
#------------------------------------------------------------

DROP trigger IF EXISTS supprime_don_tresorerie;
DELIMITER $
CREATE TRIGGER supprime_don_tresorerie
AFTER DELETE ON don
FOR EACH ROW
BEGIN
	UPDATE tresorerie SET fonds = fonds - old.montant
	WHERE old.id_tresorerie = id_tresorerie;
END $
DELIMITER ;

#------------------------------------------------------------
# Trigger : ajout_participation_activite 
#Le nombre de personne inscrit va être actualisé à chaque insertion d une participation
#------------------------------------------------------------

DROP TRIGGER IF EXISTS ajout_participation_activite;
DELIMITER $
CREATE TRIGGER ajout_participation_activite
AFTER INSERT ON participer
FOR EACH ROW
BEGIN
	UPDATE activite SET nb_personnes = nb_personnes + 1
	WHERE new.id_activite = id_activite;
END $
DELIMITER ;

#------------------------------------------------------------
# Trigger : modifie_participation_activite
#Le nombre de personne inscrit va être actualisé à chaque suppression d une participation
#------------------------------------------------------------

DROP TRIGGER IF EXISTS supprime_participation_activite;
DELIMITER $
CREATE TRIGGER supprime_participation_activite
AFTER DELETE ON participer
FOR EACH ROW
BEGIN
	UPDATE activite SET nb_personnes = nb_personnes - 1
	WHERE old.id_activite = id_activite;
END $
DELIMITER ;

#------------------------------------------------------------
# Trigger : ajout_activite_tresorerie
#------------------------------------------------------------


DROP trigger IF EXISTS ajout_activite_tresorerie;
DELIMITER $
CREATE TRIGGER ajout_activite_tresorerie
AFTER INSERT ON activite
FOR EACH ROW
BEGIN
    UPDATE tresorerie SET fonds = fonds - new.budget
    WHERE new.id_tresorerie = id_tresorerie;
END $
DELIMITER ;

#------------------------------------------------------------
# Trigger : modifie_activite_tresorerie
#------------------------------------------------------------

DROP trigger IF EXISTS modifie_activite_tresorerie;
DELIMITER $
CREATE TRIGGER modifie_activite_tresorerie
AFTER UPDATE ON activite
FOR EACH ROW
BEGIN
    UPDATE tresorerie SET fonds = fonds + old.budget - new.budget
    WHERE new.id_tresorerie = id_tresorerie;
END $
DELIMITER ;

#------------------------------------------------------------
# Trigger : supprime_activite_tresorerie
#------------------------------------------------------------

DROP trigger IF EXISTS supprime_activite_tresorerie;
DELIMITER $
CREATE TRIGGER supprime_activite_tresorerie
AFTER DELETE ON activite
FOR EACH ROW
BEGIN
    UPDATE tresorerie SET fonds = fonds + old.budget
    WHERE old.id_tresorerie = id_tresorerie;
END $
DELIMITER ;

#On insère ces valeurs après le trigger pour que ce soit pris en compte

# au début la trésorerie est haute afin de pouvoir créer de nombreuses activités en sql
insert into tresorerie values (NULL, 50000);

insert into activite values (1, "Parc Asterix", "Plailly", "lib/images/activites/parc_asterix.jpg","https://www.parcasterix.fr/", 1150, "Venez découvrir un Noël au Parc Astérix !", "2020-11-28", "2021-05-15", 25, 0, 1),
	(2, "Disneyland Paris", "Marne-La-Vallee", "lib/images/activites/disneyland.jpg", "https://www.disneylandparis.com/fr-fr/", 730, "Noel chez Disney", "2020-11-28", "2021-08-10", 35, 0, 1),
	(3, "Voyage a NYC", "Etats Unis", "lib/images/activites/voyage-new-york.jpg","https://www.leclercvoyages.com/product/?pid=253098&c.desti=US.EST#rubric=search&dispo=25-03-2021-5-3-PAR&dpci=&p=m_c.desti%3DUS.NYC", 7000, "Detendez vous en optant pour un voyage exceptionnel", "2020-12-08", "2021-03-14", 950, 0, 1),
	(4, "Soins massages", "Paris", "lib/images/activites/massage.jpg","https://www.massage-concept.fr/", 900, "Prenez soin de vous avec ce massage tout compris", "2020-12-14", "2021-05-10", 32, 0, 1);

insert into utilisateur values (1, "melcfaduv", "45D4E", "melanie@cfa-insta.fr", "salarie"), 
	(2, "julcfabarr", "885DE", "julien@cfa-insta.fr", "salarie"), 
	(3, "gercfadepa", "8555ed", "gerard@cfa-insta.fr", "admin"),
	(4, "fracfahami", "445d4d", "franck@cfa-insta.fr", "admin"),
	(5, "damcfadeni", "23daeez", "damiens@cfa-insta.fr", "salarie"),
	(6, "cedrairfra", "c85d4ee", "cedric@airfrance.fr", "sponsor"),
	(7, "jesslysdor", "jess744", "jessica@lysdor.com", "sponsor"),
	(8, "michticmas", "m847cihe", "michele@ticketmaster.fr", "sponsor"),
	(9, "jerevoypri", "j885ee", "jeremie@voyage-prive.com", "sponsor"),
	(10, "sponsortest", "", "sp@gmail.com", "sponsor"),
	(11, "admintest", "", "a@gmail.com", "admin"),
	(12, "salarietest", "", "sa@gmail.com", "salarie");
	#(13, "sponsortest2", "", "sp@gmail.com", "sponsor");

insert into salarie values (1, "DUVIL", "Melanie", "0633928562", "paris", 2, "developpeur", "femme"), 
							(2, "BARRETO", "Julien", "0645749655", "toulouse", 1, "commercial", "homme"),
							(3, "DEPARD", "Gerard", "0658856244", "bordeaux", 4, "comptabilite", "homme"),
							(4, "HAMIAUX", "Franck", "0755896254", "caen", 3, "ressources_humaines", "homme"),
							(5, "DENIS", "Damiens", "0646220322", "boissy-saint-leger", 1, "commercial", "homme"),
							(11, "TESTNOMADMIN", "Testprenomadmin", "0755896254", "caen", 3, "ressources_humaines", "homme"),
							(12, "TESTNOMSALARIE", "Testprenomsalarie", "0755896254", "caen", 3, "ressources_humaines", "homme");

insert into participer values (1, 1, "2020-10-05"),
								(2, 2, "2020-08-20"),
								(3, 3, "2020-10-12"),
								(4, 4, "2020-04-17"),
								(1, 2, "2020-10-05");

insert into commentaire values (NULL, "2020-11-29", "Nous y retournerons très prochainement, c'était super !", 1, 1),
	(NULL, "2020-11-29", "Assez satisfait, prix intéressant", 2, 2),
	(NULL, "2020-11-30", "Un voyage inoubliable !", 3, 3),
	(NULL, "2020-12-02", "Mauvaise masseuse, prix bien trop élevé.", 4, 4);

insert into sponsor values (6, "Air France", "lib/images/sponsors/airfrance.png", 8000, "0184452566", "https://wwws.airfrance.fr/"),
							(7, "Lys D'Or", "lib/images/sponsors/lys-d-or.png", 5000, "0925526358", "https://www.lysdor.com/"),
							(8, "Ticketmaster", "lib/images/sponsors/ticket_master.png", 9500, "0180300322", "https://www.ticketmaster.fr/"),
							(9, "Voyage Privé", "lib/images/sponsors/voyage_prive.png", 10000, "0144857852", "https://www.voyage-prive.com/"),
							(10, "Fnac Spectacles", "lib/images/sponsors/fnac.png", 9500, "0180300322", "https://www.fnacspectacles.com/");
							#(13, "Fnac ", "https://blog.hubspot.com/hubfs/image8-2.jpg", 9500, "0180300322", "https://www.fnacspectacles.com/");

insert into contact values (NULL, "Reservation", "Bonjour, je vous contacte suite à l'annonce concernant le voyage a New-York. Les chambres disposent-elle d'une SDB handicapée ? Merci", "2020-11-29",4),
						(NULL, "Probleme technique", "Bonjour, je ne parviens pas à accedez à mon espace CE", "2020-11-30", 4);

INSERT INTO don VALUES (NULL,"2020-11-15", 300, "Avec plaisir", 7,1),
						(NULL,"2020-12-10", 450, "Pour vous aider", 6,1),
						(NULL,"2020-12-10", 180, "Etant riche, je me permet de vous donnez cette somme", 8,1);

# verification :
select * from utilisateur_salarie;
select * from utilisateur_sponsor;
select * from utilisateur_salarie_activite;
select * from utilisateur_salarie_activite_commentaire;
select * from utilisateur_sponsor_don;
select * from utilisateur_contact;
select * from utilisateur_administrateur;
select * from utilisateur_salarie_activite_participer;
select * from utilisateur;
select * from participer;
select * from activite;
select * from commentaire;
select * from don;
select * from tresorerie;
select * from contact;

