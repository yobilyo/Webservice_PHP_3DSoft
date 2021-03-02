<?php
    require_once("modele.class.php");
    $unModele = new Modele();

    if (isset($_REQUEST['droits'])) {
        //print_r($_REQUEST);
        if ($_REQUEST['droits'] == "admin" || $_REQUEST['droits'] == "salarie") {
            //utilisateurSalarie

            //http://localhost/Webservice_PHP_3DSoft/ModifierProfil.php?idutilisateur=1&username=melania007&password=&abcd&email=melanie@cfa-insta.fr&droits=admin&nom=testnom&prenom=testprenom&tel=testtel&adresse=testadresse&quotient_fam=1&service=developpeur&sexe=femme

            if (isset($_REQUEST['idutilisateur']) && isset($_REQUEST['username']) && isset($_REQUEST['password']) && isset($_REQUEST['email']) && isset($_REQUEST['droits']) && isset($_REQUEST['nom']) && isset($_REQUEST['prenom']) && isset($_REQUEST['tel']) && isset($_REQUEST['adresse']) && isset($_REQUEST['quotient_fam']) && isset($_REQUEST['service']) && isset($_REQUEST['sexe'])) {

                $unModele->modifierProfilSalarie($_REQUEST['idutilisateur'], $_REQUEST['username'], $_REQUEST['password'], $_REQUEST['email'], $_REQUEST['droits'], $_REQUEST['nom'], $_REQUEST['prenom'], $_REQUEST['tel'], $_REQUEST['adresse'], $_REQUEST['quotient_fam'], $_REQUEST['service'], $_REQUEST['sexe']);
                print('["message": "true"]');
            } else {
                print('["message": "false"]');
            }

        } else {
            //utilisateurSponsor

            //http://localhost/Webservice_PHP_3DSoft/ModifierProfil.php?idutilisateur=6&username=cedric007&password=&efgh&email=cedric@cfa-insta.fr&droits=sponsor&societe=testsociete&image_url=testimage_url&budget=testbudget&tel=testtel&lien=testlien

            if (isset($_REQUEST['idutilisateur']) && isset($_REQUEST['password']) && isset($_REQUEST['email']) && isset($_REQUEST['droits']) && isset($_REQUEST['societe']) && isset($_REQUEST['image_url']) && isset($_REQUEST['budget']) && isset($_REQUEST['tel']) && isset($_REQUEST['lien'])) {

                $unModele->modifierProfilSponsor($_REQUEST['idutilisateur'], $_REQUEST['username'], $_REQUEST['password'], $_REQUEST['email'], $_REQUEST['droits'], $_REQUEST['societe'], $_REQUEST['image_url'], $_REQUEST['budget'], $_REQUEST['tel'], $_REQUEST['lien']);
                print('["message": "true"]');
            } else {
                print('["message": "false"]');
            }

        }
    }

?>