#!/bin/bash
# 
# Envoi dans une requete DNS un message vers l exterieur
# Permet de sortir d'une infra avec des FW 
# ou des mechants proxy
# Les autorites DNS externes ne sont generalement pas filtrees
#
# Usage: <$0> message
#

# Zone dont l'autorite *n*est *pas* un DNS mais le serveur de notif
# ex: dig +trace NS notif.mondomaine.org
# notif.mondomaine.org. 10800   IN  NS  supervision.mondomaine.org.
# supervision.mondomaine.org.       3600    IN  A   217.115.161.170
NS=notif.mondomaine.org

#TAG du message (serveur, client, appli....)
CLIENT=$HOSTNAME

MSG=$( echo "$@" | cut -b 1-40 | base64 -w 0   )
[ "$(</tmp/LastALERT)" == "$MSG" ] && exit ## Pas de repetition / flood 
echo $MSG > /tmp/LastALERT
CLIENT=$( echo "$CLIENT" | cut -b 1-40 |  base64 -w 0   )
# On envoie le message via une requete DNS incorporant le message a faire passer... 
echo ALERTE.$CLIENT.${MSG}.FINMSG.$(date +%s).$NS
ping -c 1 ALERTE.$CLIENT.${MSG}.FINMSG.$(date +%s).$NS
