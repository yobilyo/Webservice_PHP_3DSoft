<?php
    class Modele {
        private $pdo;

        public function __construct() {
            $this->pdo = null;
            try {
                $this->pdo = new PDO("mysql:host=localhost;dbname=ce", "root", "");
            }
            catch (PDOException $exp) {
                echo "Echec de connexion à la base de données";
            }
        }

        public function verifConnexion($email, $password) {
            if ($this->pdo != null) {
                $requete = "select * from utilisateur where email =:email and password = :password ;";
                $donnees = array(":email"=>$email, ":password"=>$password);
                $select = $this->pdo->prepare($requete);
                $select->execute($donnees);
                $result = $select->fetch();

                if ($result['droits'] == "admin" || $result['droits'] == "salarie") {
                    // utilisateurSalarie
                    $requeteSalarie = "select * from utilisateur_salarie where email =:email and password = :password ;";
                    $donnees = array(":email"=>$email, ":password"=>$password);
                    $select = $this->pdo->prepare($requeteSalarie);
                    $select->execute($donnees);
                    return $select->fetch();
                } else{
                    // utilisateurSponsor
                    $requeteSponsor = "select * from utilisateur_sponsor where email =:email and password = :password ;";
                    $donnees = array(":email"=>$email, ":password"=>$password);
                    $select = $this->pdo->prepare($requeteSponsor);
                    $select->execute($donnees);
                    return $select->fetch();
                }
            }
        }

        public function listerActivites() {
            if ($this->pdo != null) {
                $requete = "select * from activite; ";
                $select = $this->pdo->prepare($requete);
                $select->execute();
                return $select->fetchAll();
            }
        }

        public function listerMesParticipations($email) {
            if ($this->pdo != null) {
                $requete = "select * from utilisateur_salarie_activite_participer where email = :email; ";
                $select = $this->pdo->prepare($requete);
                $donnees = array(":email"=>$email);
                $select->execute($donnees);
                return $select->fetchAll();
            }
        }

        public function participation($idutilisateur, $id_activite, $date_inscription) {
            if ($this->pdo != null) {
                $requete = "insert into participer values(:idutilisateur, :id_activite, :date_inscription);";
                $donnees = array(":idutilisateur"=>$idutilisateur, ":id_activite"=>$id_activite, ":date_inscription"=>$date_inscription);
                $select = $this->pdo->prepare($requete);
                $select->execute($donnees);
            }
        }

        public function modifierProfilSalarie($idutilisateur, $username, $password, $email, $droits, $nom, $prenom, $tel, $adresse, $quotient_fam, $service, $sexe) {
            if ($this->pdo != null) {
                $requeteUtilisateur = "update utilisateur set username = :username, password = :password, email = :email, droits = :droits where idutilisateur = :idutilisateur;";
                $donnees = array(
                    ":idutilisateur"=>$idutilisateur,
                    ":username"=>$username,
                    ":password"=>$password,
                    ":email"=>$email,
                    ":droits"=>$droits
                );
                $select = $this->pdo->prepare($requeteUtilisateur);
                $select->execute($donnees);

                $requeteSalarie = "update salarie set nom = :nom, prenom = :prenom, tel = :tel, adresse = :adresse, quotient_fam = :quotient_fam, service =:service, sexe = :sexe where idutilisateur = :idutilisateur;";
                $donnees = array(
                    ":idutilisateur"=>$idutilisateur,
                    ":nom"=>$nom,
                    ":prenom"=>$prenom,
                    ":tel"=>$tel,
                    ":adresse"=>$adresse,
                    ":quotient_fam"=>$quotient_fam,
                    ":service"=>$service,
                    ":sexe"=>$sexe
                );
                $select = $this->pdo->prepare($requeteSalarie);
                $select->execute($donnees);
            }
        }

        public function modifierProfilSponsor($idutilisateur, $username, $password, $email, $droits, $societe, $image_url, $budget, $tel, $lien) {
            if ($this->pdo != null) {
                $requeteUtilisateur = "update utilisateur set username = :username, password = :password, email = :email, droits = :droits where idutilisateur = :idutilisateur;";
                $donnees = array(
                    ":idutilisateur"=>$idutilisateur,
                    ":username"=>$username,
                    ":password"=>$password,
                    ":email"=>$email,
                    ":droits"=>$droits
                );
                $select = $this->pdo->prepare($requeteUtilisateur);
                $select->execute($donnees);

                $requeteSponsor = "update sponsor set societe = :societe, image_url = :image_url, budget = :budget, tel = :tel, lien = :lien where idutilisateur = :idutilisateur;";
                $donnees = array(
                    ":idutilisateur"=>$idutilisateur,
                    ":societe"=>$societe,
                    ":image_url"=>$image_url,
                    ":budget"=>$budget,
                    ":tel"=>$tel,
                    ":lien"=>$lien
                );

                $select = $this->pdo->prepare($requeteSponsor);
                $select->execute($donnees);
            }
        }
    }
?>