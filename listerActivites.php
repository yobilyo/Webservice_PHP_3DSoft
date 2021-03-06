<?php
    require_once("modele.class.php");
    $unModele = new Modele();

    $lesResultats = $unModele->listerActivites();
    //print_r($lesResultats);
    
    //http://localhost/Webservice_PHP_3DSoft/listerActivites.php

    $tab = array();

    foreach ($lesResultats as $unResultat) {
        $ligne['id_activite'] = $unResultat['id_activite'];
        $ligne['nom'] = $unResultat['nom'];
        $ligne['lieu'] = $unResultat['lieu'];
        $ligne['image_url'] = $unResultat['image_url'];
        $ligne['lien'] = $unResultat['lien'];
        $ligne['budget'] = $unResultat['budget'];
        // la ligne description doit être convertie en utf8 sinon elle casse le programme:
        //https://www.php.net/manual/en/function.utf8-encode.php
        $ligne['description'] = utf8_encode($unResultat['description']);
        $ligne['date_debut'] = $unResultat['date_debut'];
        $ligne['date_fin'] = $unResultat['date_fin'];
        $ligne['prix'] = $unResultat['prix'];
        $ligne['nb_personnes'] = $unResultat['nb_personnes'];
        $ligne['id_tresorerie'] = $unResultat['id_tresorerie'];

        $tab[] = $ligne;

        echo "<div style='overflow-wrap:anywhere;'>".json_encode($tab)."</div>";
    }

?>