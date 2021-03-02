<?php
    require_once("modele.class.php");
    $unModele = new Modele();

    //print_r($_REQUEST);
    if (isset($_REQUEST['email']) && isset($_REQUEST['password'])) {
        $unResultat = $unModele->verifConnexion($_REQUEST['email'], $_REQUEST['password']);
        //print_r($unResultat);

        $ligne = array();
        
        if ($unResultat['droits'] == "salarie" || $unResultat['droits'] == "admin") {
            // utilisateurSalarie
            // http://localhost/Webservice_PHP_3DSoft/verifConnexion.php?email=a@gmail.com&password=
            // http://localhost/Webservice_PHP_3DSoft/verifConnexion.php?email=sa@gmail.com&password=
            $ligne['idutilisateur'] = $unResultat['idutilisateur'];
            $ligne['username'] = $unResultat['username'];
            $ligne['password'] = $unResultat['password'];
            $ligne['email'] = $unResultat['email'];
            $ligne['droits'] = $unResultat['droits'];
            //
            $ligne['nom'] = $unResultat['nom'];
            $ligne['prenom'] = $unResultat['prenom'];
            $ligne['sexe'] = $unResultat['sexe'];
            $ligne['tel'] = $unResultat['tel'];
            $ligne['adresse'] = $unResultat['adresse'];
            $ligne['quotient_fam'] = $unResultat['quotient_fam'];
            $ligne['service'] = $unResultat['service'];

        } else {
            // utilisateurSponsor
            // http://localhost/Webservice_PHP_3DSoft/verifConnexion.php?email=sp@gmail.com&password=
            $ligne['idutilisateur'] = $unResultat['idutilisateur'];
            $ligne['username'] = $unResultat['username'];
            $ligne['password'] = $unResultat['password'];
            $ligne['email'] = $unResultat['email'];
            $ligne['droits'] = $unResultat['droits'];
            //
            $ligne['societe'] = $unResultat['societe'];
            $ligne['image_url'] = $unResultat['image_url'];
            $ligne['budget'] = $unResultat['budget'];
            $ligne['tel'] = $unResultat['tel'];
            $ligne['lien'] = $unResultat['lien'];
        }

        $tab[] = $ligne;

        //https://developer.mozilla.org/fr/docs/Web/CSS/overflow-wrap
        echo "<div style='overflow-wrap:anywhere;'>".json_encode($tab)."</div>";
    } else {
        print("[]");
    }
?>