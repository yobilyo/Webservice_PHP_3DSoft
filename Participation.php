<?php
    require_once("modele.class.php");
    $unModele = new Modele();

    //http://localhost/Webservice_PHP_3DSoft/Participation.php?idutilisateur=11&id_activite=2&date_inscription=2021-02-22

    if (isset($_REQUEST['idutilisateur']) && isset($_REQUEST['id_activite']) && isset($_REQUEST['date_inscription'])) {

        $unModele->participation($_REQUEST['idutilisateur'],$_REQUEST['id_activite'], $_REQUEST['date_inscription']);
        print('["message": "true"]');
    } else {
        print('["message": "false"]');
    }
?>