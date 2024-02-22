#!/bin/ksh

# 20240221 drger; Added new myaudiconnect_nodataconnect.jar files
# 20221212 drger: Update NWS configuration
# 20220320 drger; DLink USB Ethernet adapter settings

# Script startup env from copie_scr.sh
showScreen ${SDLIB}/lansetup-0.png
touch ${SDPATH}/.started
xlogfile=${SDPATH}/run-$(getTime).log
exec > ${xlogfile} 2>&1
echo "[INFO] Start: $(date); Timestamp: $(getTime); MU version: $MUVER"
echo; echo "[INFO] Installing fair-mode on $SWTRAIN ..."

SOURCE=/mnt/efs-system/scripts/Connectivity

echo; echo "[ACTI] Copying data for LAN."
mes=/mnt/efs-system
mount -uw $mes

# Backup GSM related files:
if [ -f /etc/browser/common.cfg ]
then
  echo; echo "[ACTI] Saving /etc/browser/common.cfg"
  cp -v /etc/browser/common.cfg ${SDVAR}/etc-browser-common.cfg-GSM
  mv -v /etc/browser/common.cfg /etc/browser/common.cfg-GSM
fi

if [ -f /lsd/poiproducer.properties ]
then
  echo; echo "[ACTI] Saving /lsd/poiproducer.properties"
  cp -v /lsd/poiproducer.properties ${SDVAR}/lsd-poiproducer.properties-GSM
  mv -v /lsd/poiproducer.properties /lsd/poiproducer.properties-GSM
fi

if [ -f /lsd/MMI3G_MyAudi.properties ]
then
  echo; echo "[ACTI] Saving /lsd/MMI3G_MyAudi.properties"
  cp -v /lsd/MMI3G_MyAudi.properties ${SDVAR}/lsd-MMI3G_MyAudi.properties-GSM
  mv -v /lsd/MMI3G_MyAudi.properties /lsd/MMI3G_MyAudi.properties-GSM
fi

if [ -f /etc/ppp/pf.conf ]
then
  echo; echo "[ACTI] Saving /etc/ppp/pf.conf"
  cp -v /etc/ppp/pf.conf ${SDVAR}/etc-ppp-pf.conf-GSM
  mv -v /etc/ppp/pf.conf /etc/ppp/pf.conf-GSM
fi

# Backup network configuration
nwsbin=/mnt/efs-system/pss/nws/usr/bin
if [ -f ${nwsbin}/dhcp-down ]
then
  echo; echo "[ACTI] Saving dhcp-down"
  mv -v ${nwsbin}/dhcp-down ${nwsbin}/dhcp-down-GSM
fi

if [ -f ${nwsbin}/dhcp-up ]
then
  echo; echo "[ACTI] Saving dhcp-up"
  mv -v ${nwsbin}/dhcp-up ${nwsbin}/dhcp-up-GSM
fi

if [ -f ${nwsbin}/dnsrdr1.conf ]
then
  echo; echo "[ACTI] Saving dnsrdr1.conf"
  mv -v ${nwsbin}/dndrdr1.conf ${nwsbin}/dndrdr1.conf-GSM
fi

if [ -f ${nwsbin}/dnsrdr2.conf ]
then
  echo; echo "[ACTI] Saving dnsrdr2.conf"
  mv -v ${nwsbin}/dndrdr2.conf ${nwsbin}/dndrdr2.conf-GSM
fi

if [ -f ${nwsbin}/nws.cfg ]
then
  echo; echo "[ACTI] Saving nws.cfg"
  mv -v ${nwsbin}/nws.cfg ${nwsbin}/nws.cfg-GSM
fi

echo; echo "[INFO] MMI3GP LAN setup..."
echo "[ACTI] Install resolv.conf-LAN"
cp -v ${SDVAR}/resolv.conf-LAN ${mes}/scripts/Connectivity/
cp -v ${SDVAR}/resolv.conf-LAN ${mes}/etc/resolv.conf

echo; echo "[ACTI] Patch MyAudi."
if [ -n "$(echo $SWTRAIN | grep '_US_')" ]
then
  macndcjar="${SDVAR}/myaudiconnect_nodataconnect-US.jar"
else
  macndcjar="${SDVAR}/myaudiconnect_nodataconnect-EU.jar"
fi
cp -v $macndcjar /lsd/myaudiconnect_nodataconnect.jar

echo; echo "[ACTI] Create usedhcp flag."
touch /HBpersistence/usedhcp

echo; echo "[ACTI] Create DLinkReplacesPPP flag."
touch /HBpersistence/DLinkReplacesPPP

echo; echo "[ACTI] Copy common.cfg."
cp -v ${SOURCE}/common.cfg /etc/browser/common.cfg

echo; echo "[ACTI] Copy poiproducer.properties"
cp -v ${SOURCE}/poiproducer.properties /lsd/poiproducer.properties

echo; echo "[ACTI] Copy pf.conf"
cp -v ${SOURCE}/pf.conf /etc/ppp/pf.conf

echo; echo "[ACTI] Copy dhcp-down"
cp -v ${SDVAR}/dhcp-down-LAN ${nwsbin}/dhcp-down-LAN
cp -v ${SDVAR}/dhcp-down-LAN ${nwsbin}/dhcp-down

echo; echo "[ACTI] Copy dhcp-up"
cp -v ${SDVAR}/dhcp-up-LAN ${nwsbin}/dhcp-up-LAN
cp -v ${SDVAR}/dhcp-up-LAN ${nwsbin}/dhcp-up

echo; echo "[ACTI] Copy dnsrdr1.conf"
cp -v ${SDVAR}/dnsrdr1.conf-LAN ${nwsbin}/dnsrdr1.conf-LAN
cp -v ${SDVAR}/dnsrdr1.conf-LAN ${nwsbin}/dnsrdr1.conf

echo; echo "[ACTI] Copy dnsrdr2.conf"
cp -v ${SDVAR}/dnsrdr2.conf-LAN ${nwsbin}/dnsrdr2.conf-LAN
cp -v ${SDVAR}/dnsrdr2.conf-LAN ${nwsbin}/dnsrdr2.conf

echo; echo "[ACTI] Copy nws.cfg"
cp -v ${SDVAR}/nws.cfg-LAN ${nwsbin}/nws.cfg-LAN
cp -v ${SDVAR}/nws.cfg-LAN ${nwsbin}/nws.cfg

# Script cleanup:
echo "[INFO] End: $(date); Timestamp: $(getTime)"
showScreen ${SDLIB}/lansetup-1.png
rm -f ${SDPATH}/.started
exit 0
