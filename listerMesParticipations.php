<?php
    require_once("modele.class.php");
    $unModele = new Modele();

    if (isset($_REQUEST['email'])) {
        $lesResultats = $unModele->listerMesParticipations($_REQUEST['email']);
        $tab = array();

        //http://localhost/Webservice_PHP_3DSoft/listerMesParticipations?email=melanie@cfa-insta.fr&password=45D4E

        foreach ($lesResultats as $unResultat) {
            //utilisateur
            $ligne['idutilisateur'] = $unResultat['idutilisateur'];
            $ligne['username'] = $unResultat['username'];
            $ligne['email'] = $unResultat['email'];
            //salarie
            $ligne['nom'] = $unResultat['nom'];
            $ligne['prenom'] = $unResultat['prenom'];
            //participer
            $ligne['date_inscription'] = $unResultat['date_inscription'];
            //activite dans la view sql
            $ligne['id_activite'] = $unResultat['id_activite'];
            $ligne['nom_activite'] = $unResultat['nom_activite'];
            $ligne['lieu'] = $unResultat['lieu'];
            $ligne['image_url'] = $unResultat['image_url'];
            $ligne['lien'] = $unResultat['lien'];
            // la ligne description casse le programme TODO
            /*$ligne['description'] = $unResultat['description'];*/
            //non nécessaire
            /*$ligne['date_debut'] = $unResultat['date_debut'];
            $ligne['date_fin'] = $unResultat['date_fin'];
            $ligne['prix'] = $unResultat['prix'];
            $ligne['nb_personnes'] = $unResultat['nb_personnes'];
            $ligne['id_tresorerie'] = $unResultat['id_tresorerie'];
            */

            $tab[] = $ligne;
        }

        echo "<div style='overflow-wrap:anywhere;'>".json_encode($tab)."</div>";
    }
?>