#!bash

DIRNAME=$(dirname "$0")

# get the dp1-dump tar file from tue RUCIO storage system
PATH_TO_BUTLER_DUMP=${PATH_TO_BUTLER_DUMP:-${DIRNAME}/dp1-dump-DM-51372.tar}

BUTLER_TAGS=""
for CONTAINER in $(cat ${DIRNAME}/container_list.txt); do
    BUTLER_TAGS="${BUTLER_TAGS} -t ${CONTAINER}"
done

# setup the LSST software environment
setup lsst_distrib 

# bring down the latest scripts from lsst data wrangling site to
# automate butler ingesting
git clone https://github.com/lsst-dm/dp1-data-wrangling.git
cd dp1-data-wrangling

[ -f ${PATH_TO_BUTLER_DUMP} ] &&  tar -xf ${PATH_TO_BUTLER_DUMP} || exit -1

# file-paths are set to rsp as we strip the 'dp1' off the file path in
# RUCIO an add it to the SI uri component.  see the butler.yaml value
# of datasotre.root in the cadc-butler project
python import_preliminary_dp1.py --file-paths rsp \
       --db-connection-string "postgresql://$PGUSER:$PGPASSWORD@${PGHOST}:${PGPORT}/${PGDB}" \
       --db-schema ${PGSCHEMA} \
       ${BUTLER_TAGS}


