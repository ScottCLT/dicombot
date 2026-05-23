#!/bin/bash
# The following 4 variables (commented out) are set via "docker run --env"
#CALLING="DICOMBOT"
#CALLED="DCM4CHEE"
#IPADDRESS="10.0.3.214"
#SERVERPORT="104"

FNAME="dicombot-$RANDOM"
LNAME="dicombot-$RANDOM"
PATID=$RANDOM
STUDYUID="1.2.276.0.$RANDOM.$RANDOM.$RANDOM.$RANDOM.$RANDOM.$RANDOM.$RANDOM.$RANDOM.$RANDOM.$RANDOM"
echo -e "\r\n\r\n***ATTENTION***\r\nIf dicombot is not working, please note that it has been updated with new environment variables as of 26.04.2026 in order to make it more versatile. Please review the updated documentation at https://dicombot.mallonee.org \r\n"
if [ -z "$DICOMFILES" ]; then
    echo "Using default DICOM Files ($DICOMFILES)"
    FILES="/var/dcm/files/"
else
    echo "Using mounted volume for DICOM files"
    FILES="/var/dcm/mount/"
fi

echo "STUDY: $STUDYUID"
echo "Renumerating SOPInstanceUID, SeriesInstanceUID, StudyInstanceUID, and assigning dummy name and ID of all files in $FILES*"

dcmodify -v -ma "(0020,000d)=$STUDYUID" -gse -gin -nb -ma "(0010,0020)=$PATID" -ma "(0010,0010)=$LNAME^$FNAME" $FILES*.DCM

echo "Storing all files in $FILES"
storescu -v -aet $AETITLE -aec $STORAGEAE +sd -xs $STORAGEIP $STORAGEPORT $FILES*.DCM

findscu -v -S -aet $AETITLE -aec $RETRIEVEAE -k QueryRetrieveLevel=STUDY -k PatientID=$PATID -k StudyInstanceUID="" $RETRIEVEIP $RETRIEVEPORT

mkdir "${FILES}retrieve"

gdcmscanner -t 0020,000E -d $FILES -p | grep -Po '\[\K[^]]*' | while read -r SERIESUID ; do
    echo "Retrieving Series: $SERIESUID"
    getscu -v -S -aet $AETITLE $RETRIEVEIP $RETRIEVEPORT -aec $RETRIEVEAE +B -od "${FILES}retrieve/" -k QueryRetrieveLevel=SERIES -k StudyInstanceUID=$STUDYUID -k SeriesInstanceUID="$SERIESUID" 
done

#sleep infinity
